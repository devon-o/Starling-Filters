/**
 *	Copyright (c) 2013 Devon O. Wolfgang
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
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Program3D;
    import starling.textures.Texture;
	
    /**
     * Motion Blur filter for Starling Framework.
     * Only use with Context3DProfile.BASELINE (not compatible with constrained profile).
     * @author Devon O.
     */
    
    public class MotionBlurFilter extends FragmentFilter
    {
        private var mVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mShaderProgram:Program3D;

        private var mSteps:int;
        private var mAmount:Number;
        private var mAngle:Number;
		
        /**
         * Creates a new MotionBlurFilter
         * @param	angle	angle of blur in radians
         * @param	amount	the amount of blur
         * @param	steps	the level of the blur. A higher number produces a better result, but with worse performance. Can only be set once.
         */
        public function MotionBlurFilter(angle:Number=0.0, amount:Number=1.0, steps:int=5)
        {
            mAngle  = angle;
            mAmount = clamp(amount, 0.0, 20.0);
            mSteps  = int(clamp(steps, 1.0, 30.0));

            marginX = marginY = mAmount * mSteps ;
        }
        
        public override function dispose():void
        {
            if (mShaderProgram) mShaderProgram.dispose();
            super.dispose();
        }
        
        protected override function createPrograms():void
        {
            var step:String = 
                "add ft0.xy, ft0.xy, fc0.xy \n"+
                "tex ft2, ft0.xy, fs0<2d, clamp, linear, nomip> \n" +
                "add ft1, ft1, ft2 \n"

            var fragmentProgramCode:String = 
                "mov ft0.xy, v0.xy \n" +
                "tex ft1, ft0.xy, fs0<2d, clamp, linear, nomip> \n"
                    
            var numSteps:int = mSteps - 1;
            for (var i:int = 0; i < numSteps; i++)
            {
                fragmentProgramCode += step;
            }

            fragmentProgramCode += "div oc, ft1, fc0.zzz" 

            mShaderProgram = assembleAgal(fragmentProgramCode);
        }
        
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            var tSize:Number = (texture.width + texture.height) * .50;
            mVars[0] = mAmount * Math.cos(mAngle) / tSize;
            mVars[1] = mAmount * Math.sin(mAngle) / tSize;
            mVars[2] = mSteps;

            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mVars, 1);
            context.setProgram(mShaderProgram);
        }
		
        private function clamp(target:Number, min:Number, max:Number):Number 
        {
            if (target < min) target = min;
            if (target > max) target = max;
            return target;
        }
        
        public function get angle():Number { return mAngle; }
        public function set angle(value:Number):void { mAngle = value; }

        public function get amount():Number { return mAmount; }
        public function set amount(value:Number):void 
        { 
            mAmount = clamp(value, 0, 20);
            marginX = marginY = mAmount * mSteps ;
        }
    }
}