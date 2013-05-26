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
	 * Creates a sine wave effect
	 * @author Devon O.
	 */
	
    public class SineFilter extends FragmentFilter
    {
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
		mov ft0, v0
		mul ft1.x, v0.y, fc0.x
		sin ft1.y, ft1.x
		mul ft1.y, ft1.y, fc0.y
		add ft0.x, ft0.x, ft1.y
		tex oc, ft0, fs0<2d, clamp, linear, mipnone>
	]]>
		
        private var mQuantifiers:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mAmount:Number;
		private var mFreq:int;
        private var mShaderProgram:Program3D;
        
		/**
		 * 
		 * @param	freq	frequency of wave
		 * @param	amount	size of wave
		 */
        public function SineFilter(freq:int = 0, amount:Number = 0.0)
        {
           mFreq = freq;
		   mAmount = amount;
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
            // already set by super class:
            //
            // vertex constants 0-3: mvpMatrix (3D)
            // vertex attribute 0:   vertex position (FLOAT_2)
            // vertex attribute 1:   texture coordinates (FLOAT_2)
            // texture 0:            input texture
            
			// thank you, Daniel Sperl! ( http://forum.starling-framework.org/topic/new-feature-filters/page/2 )
            mQuantifiers[0] = mFreq;
            mQuantifiers[1] = mAmount * RADIAN;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mQuantifiers, 1);
            context.setProgram(mShaderProgram);
        }
        
        public function get freq():int { return mFreq; }
        public function set freq(value:int):void { mFreq = value; }
		
		public function get amount():Number { return mAmount; }
        public function set amount(value:Number):void { mAmount = value; }
		
		private const RADIAN:Number = Math.PI / 180;
    }
}