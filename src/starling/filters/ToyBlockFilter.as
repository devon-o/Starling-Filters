/**
 *	Copyright (c) 2014 Devon O. Wolfgang
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */

package starling.filters
{
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Program3D;
    import flash.filters.DropShadowFilter;
    import starling.textures.Texture;
	
    /**
     * Creates a toy block (e.g. Lego) type effect
     * @author Devon O.
     */
    
    public class ToyBlockFilter extends FragmentFilter
    {
        private static const FRAGMENT_SHADER:String =
        <![CDATA[
            div ft0, v0, fc0
            frc ft1, ft0
            sub ft0, ft0, ft1
            mul ft0, ft0, fc0
            tex ft1, ft0, fs0<2d, clamp, linear, mipnone>
            tex ft2, v0, fs1<2d, clamp, linear, mipnone>
            mul oc, ft1, ft2
        ]]>

        private var mVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        
        private var brickTexture:Texture;
        
        private var mShaderProgram:Program3D;

        public function ToyBlockFilter(){}
        
        public override function dispose():void
        {
            if (mShaderProgram)
                mShaderProgram.dispose();
            if (brickTexture)
            {
                brickTexture.dispose();
                brickTexture = null;
            }
            super.dispose();
        }
        
        protected override function createPrograms():void
        {
            mShaderProgram = assembleAgal(FRAGMENT_SHADER);
        }
		
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {	
            if (!brickTexture)
                createBrickTexture(texture.width, texture.height);
                
            mVars[0] = 16.0 / texture.width;
            mVars[1] = 8.0 / texture.height;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mVars, 1);
            context.setTextureAt(1, this.brickTexture.base);
            context.setProgram(mShaderProgram);
        }
		
        override protected function deactivate(pass:int, context:Context3D, texture:Texture):void 
        {
            context.setTextureAt(1, null);
        }
        
        private function createBrickTexture(w:Number, h:Number):void
        {
            var dat:BitmapData = brickData(w, h);
            this.brickTexture = Texture.fromBitmapData(brickData(w, h), false);
            dat.dispose();
        }
        
        private function brickData(w:Number, h:Number):BitmapData
        {
            var col:uint = 0xCDCDCD;
            
            var s:Sprite = new Sprite();
            s.graphics.beginFill(col);
            s.graphics.drawRect(0, 0, 8, 8);
            s.graphics.endFill();
            
            var c:Shape = new Shape();
            c.graphics.beginFill(col);
            c.graphics.drawCircle(4, 4, 3);
            c.graphics.endFill();
            c.filters = [new DropShadowFilter(2, 45, 0, .65)];
            
            s.addChild(c);
            
            var dat:BitmapData = new BitmapData(8, 8, false, 0x0);
            dat.draw(s);
            
            s.removeChildren();
            s = new Sprite();
            s.graphics.beginBitmapFill(dat);
            s.graphics.drawRect(0, 0, 16, 8);
            s.graphics.endFill();
            
            s.graphics.lineStyle(1, 0x000000, 1);
            s.graphics.moveTo(0, 8);
            s.graphics.lineTo(16, 8);
            s.graphics.moveTo(16, 0);
            s.graphics.lineTo(16, 8);
            
            var fill:BitmapData = new BitmapData(16, 8, false, 0x0);
            fill.draw(s);
            
            s.graphics.clear();
            
            var brick:Shape = new Shape();
            brick.graphics.beginBitmapFill(fill);
            brick.graphics.drawRect(0, 0, w, h);
            brick.graphics.endFill();
            
            var bdata:BitmapData = new BitmapData(w, h, false, 0x0);
            bdata.draw(brick);
            
            brick.graphics.clear();
            dat.dispose();
            
            return bdata;
        }
    }
}