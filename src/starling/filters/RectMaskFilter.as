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
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Program3D;
    import starling.textures.Texture;
    
	/**
	 * Creates a rectangular mask covering display object. Can be optionally inverted (to create a rectangular hole in display object).
	 * @author Devon O.
	 */
	
    public class RectMaskFilter extends FragmentFilter
    {
        private static const FRAGMENT_SHADER:String =
        <![CDATA[
            // create rectangle
            sge ft1.x, v0.x, fc0.x
            slt ft1.z, v0.x, fc0.z
            sge ft1.y, v0.y, fc0.y
            slt ft1.w, v0.y, fc0.w
            
            mul ft1.x, ft1.x, ft1.y
            mul ft1.x, ft1.x, ft1.z
            mul ft1.x, ft1.x, ft1.w
            
            // invert
            sub ft1.x, ft1.x, fc1.x
            abs ft1.x, ft1.x
            
            // grab texture
            tex ft0, v0, fs0<2d, wrap, linear, mipnone>
            
            // multiply by desired alpha
            mul oc, ft0.xyzw, ft1.xxxx
        ]]>
		
        private var mVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mBooleans:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mShaderProgram:Program3D;

        private var mX:Number
        private var mY:Number;
        private var mWidth:Number;
        private var mHeight:Number;
        private var mInvert:Boolean;
		
        /**
         * Create a new RectMaskFilter instance
         * @param x         x position of rectangle (upper left corner)
         * @param y         y position of rectangle (upper left corner)
         * @param width     width of rectangle
         * @param height    height of rectangle
         * @param invert    should rectangle be inverted
         */
        public function RectMaskFilter(x:Number=0, y:Number=0, width:Number=100, height:Number=100, invert:Boolean=false)
        {
            mX = x;
            mY = y;
            mWidth = width;
            mHeight = height;
            mInvert = invert;
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
            mVars[0] = mX / texture.width;
            mVars[1] = mY / texture.height;
            mVars[2] = (mX + mWidth) / texture.width;
            mVars[3] = (mY + mHeight) / texture.height;

            mBooleans[0] = int(mInvert);

            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mVars,      1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mBooleans,  1);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            context.setProgram(mShaderProgram);
        }
        
        override protected function deactivate(pass:int, context:Context3D, texture:Texture):void 
        {
            context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
        }
        
        public function get x():Number { return mX; }
        public function set x(value:Number):void { mX = value; }

        public function get y():Number { return mY; }
        public function set y(value:Number):void { mY = value; }

        public function get width():Number { return mWidth; }
        public function set width(value:Number):void { mWidth = value; }

        public function get height():Number { return mHeight; }
        public function set height(value:Number):void { mHeight = value; }

        public function get invert():Boolean { return mInvert; }
        public function set invert(value:Boolean):void { mInvert = value; }
    }
}
