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
	 * Pixelates images (hex shaped 'pixels'). Only use with Context3DProfile.BASELINE (not compatible with constrained profile).
	 * @author Devon O.
	 */
	
    public class HexFilter extends FragmentFilter
    {
		
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
		mov ft0.x, fc0.z
		mul ft0.y, fc0.x, ft0.x
		div ft1.xy, v0.xy, ft0.xy
		add ft1.xy, ft1.xy, fc0.ww
		frc ft1.zz, ft1.xy
		sub ft1.xy, ft1.xy.zw, ft1.zz
		mul ft1.xy, ft1.xy, ft0.xy
		sub ft1.xy, ft1.xy, v0.xy
		mul ft2.x, ft1.x, ft1.x
		mul ft2.y, ft1.y, ft1.y
		add ft2.x, ft2.x, ft2.y
		mov ft3.zz, fc0.zz
		mul ft3.xy, ft3.zz, fc0.wy
		sub ft4.xy, v0.xy, ft3.xy
		div ft4.xy, ft4.xy, ft0.xy
		add ft4.xy, ft4.xy, fc0.ww
		frc ft4.zw, ft4.xy
		sub ft4.xy, ft4.xy, ft4.zw
		mul ft4.xy, ft4.xy, ft0.xy
		add ft4.xy, ft4.xy, ft3.xy
		sub ft4.xy, ft4.xy, v0.xy
        mul ft2.y, ft4.x, ft4.x
		mul ft2.z, ft4.y, ft4.y
		add ft2.y, ft2.y, ft2.z
		slt ft5.x, ft2.x, ft2.y
		mul ft6.xy, ft1.xy, ft5.xx
		sge ft5.y, ft2.x, ft2.y
		mul ft7.xy, ft4.xy, ft5.yy
		add ft6.xy, ft6.xy, ft7.xy
		add ft6.xy, ft6.xy, v0.xy
		tex oc, ft6.xy, fs0 <2d, clamp, linear, mipnone>
	]]>
		
        private var mShaderProgram:Program3D;
        private var mSize:int;
		private var data:Vector.<Number> = new <Number>[1.7320508076, 0.866025404, 1.0, .50];
		
		/**
		 * 
		 * @param	size	Size of hex block (minimum of 1)
		 */
        public function HexFilter(size:int=8)
        {
            this.mSize = size;
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
			
			// average out width and height of texture
			this.data[2] = Number(this.mSize / ((texture.height + texture.width) * .50));

			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.data, 1);
            context.setProgram(mShaderProgram);
        }
		
		public function set size(value:int):void { this.mSize = value; }
		public function get size():int { return this.mSize; }
    }
}