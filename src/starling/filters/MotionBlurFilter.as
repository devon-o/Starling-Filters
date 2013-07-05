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
		 * 
		 * @param	angle	angle of blur in radians
		 * @param	amount	the amount of blur
		 * @param	steps	the level of the blur. A higher number produces a better result, but with worse performance. Can only be set once.
		 */
        public function MotionBlurFilter(angle:Number=0.0, amount:Number=1.0, steps:int=5)
        {
			mAngle	= angle;
			mAmount	= clamp(amount, 0.0, 20.0);
			mSteps	= int(clamp(steps, 1.0, 30.0));
        }
        
        public override function dispose():void
        {
            if (mShaderProgram) mShaderProgram.dispose();
            super.dispose();
        }
        
        protected override function createPrograms():void
        {
			var step:String = 
				"add ft1.x, ft1.x, fc0.w \n" +
				"mul ft2.xy, ft0.xy, ft1.x \n" +
				"add ft3.xy, v0.xy, ft2.xy \n" +
				"tex ft5, ft3.xy, fs0<2d, clamp, linear, nomip> \n" +
				"add ft4, ft4, ft5 \n";
			
            var fragmentProgramCode:String =
                "mov ft0.y, fc0.x \n" +
				"sin ft0.y, ft0.y \n" +
				"mov ft0.x, fc0.x \n" +
				"cos ft0.x, ft0.x \n" +
				"mul ft0.xy, ft0.xy, fc0.y \n" +
				"mov ft1.x, fc0.w \n" +
				"sub ft1.x, ft1.x, ft1.x \n" +
				"mul ft2.xy, ft0.xy, ft1.x \n" +
				"add ft3.xy, v0.xy, ft2.xy \n" +
				"tex ft4, ft3.xy, fs0<2d, clamp, linear, nomip> \n";
				
			var numSteps:int = mSteps - 1;
			for (var i:int = 0; i < numSteps; i++)
			{
				fragmentProgramCode += step;
			}
			
			fragmentProgramCode +=
				"div ft4, ft4, fc0.z \n" +
				"mov oc, ft4";
			
            
            mShaderProgram = assembleAgal(fragmentProgramCode);
        }
        
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
			var tSize:Number = (texture.width + texture.height) * .50;
            mVars[0] = mAngle;
            mVars[1] = mAmount;
			mVars[2] = mSteps;
            mVars[3] = 1 / tSize;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mVars, 1);
            context.setProgram(mShaderProgram);
        }
		
		private function clamp(target:Number, min:Number, max:Number):Number {
			if (target < min) target = min;
			if (target > max) target = max;
			return target;
		}
        
        public function get angle():Number { return mAngle; }
        public function set angle(value:Number):void { mAngle = value; }
		
		public function get amount():Number { return mAmount; }
        public function set amount(value:Number):void { mAmount = value; }
    }
}