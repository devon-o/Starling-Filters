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
	 * Creates a tiled glass effect
	 * @author Devon O.
	 */
	
    public class GlassFilter extends FragmentFilter
    {
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
		mov ft0.xy, v0.xy
		mul ft1.x, ft0.x, fc0.y
		sin ft1.x, ft1.x		
		mul ft1.x, ft1.x, fc0.x
		mul ft1.y, ft0.y, fc0.y
		sin ft1.y, ft1.y		
		mul ft1.y, ft1.y, fc0.x
		add ft0.xy, ft0.xy, ft1.xy
		tex oc, ft0.xy, fs0<2d, clamp, linear, mipnone>
	]]>
		
        private var mQuantifiers:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mAmount:Number;
		private var mRipple:Number;
        private var mShaderProgram:Program3D;
        
		/**
		 * 
		 * @param	amount		Amount of effect (0 - 1)
		 * @param	ripple		Amount of ripple to apply
		 */
        public function GlassFilter(amount:Number = 0.0, ripple:Number = 0.0)
        {
           mAmount = amount;
		   mRipple = ripple;
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
			
            mQuantifiers[0] = mAmount / 100;
            mQuantifiers[1] = mRipple ;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mQuantifiers, 1);
            context.setProgram(mShaderProgram);
        }
        
        public function get ripple():Number { return mRipple; }
        public function set ripple(value:Number):void { mRipple = value; }
		
		public function get amount():Number { return mAmount; }
        public function set amount(value:Number):void { mAmount = value; }
    }
}