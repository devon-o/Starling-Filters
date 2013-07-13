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
	 * Creates scanlines in filtered display object
	 * @author Devon O.
	 */
	
    public class ScanlineFilter extends FragmentFilter
    {
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
	
		// scanline color
		div ft0.x, v0.y, fc0.x
		frc ft0.x, ft0.x
		sub ft0.x, ft0.x, fc0.w
		abs ft0.x, ft0.x
		
		// get texture
		tex ft1, v0, fs0<2d, clamp, linear, mipnone>
		
        // scanline effect
		sub ft2.xyz, fc0.www, ft1.xyz
		mul ft2.xyz, ft2.xyz, ft0.xxx
		add ft2.xyz, ft2.xyz, ft1.xyz
		mul ft1.xyz, ft1.xyz, ft2.xyz
		
		mov oc, ft1
		
	]]>
		
        private var mVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
		private var mShaderProgram:Program3D;
		
        private var mPixels:Number;
		
		/**
		 * 
		 * @param	pixels		pixel distance between scanlines
		 */
        public function ScanlineFilter(pixels:Number=2.0)
        {
			mPixels = pixels;
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
			mVars[0] = mPixels / texture.height
            
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mVars, 1);
			context.setProgram(mShaderProgram);
        }
        
        public function get pixels():Number { return mPixels; }
        public function set pixels(value:Number):void { mPixels = value; }
		
    }
}
