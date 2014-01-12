/**
 *	Copyright (c) 2012 Devon O. Wolfgang
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
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Program3D;
    import starling.textures.Texture;
	
    /**
     * The ChromakeyFilter will 'key out' a specified color (setting its alpha to 0)
     * @author Devon O.
     */
    
    public class ChromakeyFilter extends FragmentFilter
    {
		
        private static const FRAGMENT_SHADER:String =
        <![CDATA[
            tex ft0, v0, fs0<2d, repeat, linear, nomip>
            sub ft2.x, ft0.x, fc0.x	
            mul ft2.x, ft2.x, ft2.x	
            sub ft2.y, ft0.y, fc0.y
            mul ft2.y, ft2.y, ft2.y	
            sub ft2.z, ft0.z, fc0.z
            mul ft2.z, ft2.z, ft2.z	
            add ft2.w, ft2.x, ft2.y
            add ft2.w, ft2.w, ft2.z	
            sqt ft1.x, ft2.w
            sge ft0.w, ft1.x, fc0.w
            mov oc, ft0
        ]]>
        
        private var mShaderProgram:Program3D;
        private var mVars:Vector.<Number> = new <Number>[1, 1, 1, 1];

        private var mColor:ColorObject;
        private var mThreshold:Number;
        
        /**
         * @param	color		The color to remove
         * @param	threshold	The threshold test for the keyed color
         */
        public function ChromakeyFilter(color:uint=0x00FF00, threshold:Number=.25)
        {
            mColor = new ColorObject(color);
            mThreshold = threshold;
        }
        
        public override function dispose():void
        {
            if (mShaderProgram) mShaderProgram.dispose();
            super.dispose();
        }
        
        protected override function createPrograms():void
        {
            mShaderProgram = assembleAgal(FRAGMENT_SHADER);
        }
        
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            mVars[0] = mColor.r;
            mVars[1] = mColor.g;
            mVars[2] = mColor.b;
            mVars[3] = mThreshold;

            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mVars, 1);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            context.setProgram(mShaderProgram);
        }
		
        override protected function deactivate(pass:int, context:Context3D, texture:Texture):void 
        {
            context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
        }
		
        public function set color(value:uint):void { mColor.setColor(value); }
        public function get color():uint { return mColor.getColor(); }

        public function set threshold(value:Number):void { mThreshold = value; }
        public function get threshold():Number { return mThreshold; }
    }
}

class ColorObject
{
    public var r:Number;
    public var g:Number;
    public var b:Number;
	
    public function ColorObject(color:uint)
    {
        setColor(color);
    }
	
    public function setColor(color:uint):void
    {
        var red:uint    = color >> 16;
        var green:uint  = color >> 8 & 0xFF;
        var blue:uint   = color & 0xFF;

        r = red / 0xFF;
        g = green / 0xFF;
        b = blue / 0xFF;
    }
	
    public function getColor():uint
    {
        var red:uint = r * 0xFF;
        var green:uint = g * 0xFF;
        var blue:uint = b * 0xFF;
        return red << 16 | green << 8 | blue;
    }
}