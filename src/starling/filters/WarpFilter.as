/**
 *	CopymRight (c) 2013 Devon O. Wolfgang
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the mRights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copymRight notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYmRight HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
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
	 * Warps a display object with bezier curves (4 anchor points on mLeft edge of image, 4 anchor points on mRight edge of image)
	 * @author Devon O.
	 */

	public class WarpFilter extends FragmentFilter
	{
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
		mov ft0.xy, v0.xy
		mov ft1.x, fc2.x
		sub ft1.x, ft1.x, ft0.y
		pow ft1.x, ft1.x, fc2.z
		mov ft1.y, fc2.x
		sub ft1.y, ft1.y, ft0.y
		pow ft1.y, ft1.y, fc2.y
		mul ft1.y, ft1.y, fc2.z
		mul ft1.y, ft1.y, ft0.y
		mov ft1.z, fc2.x
		sub ft1.z, ft1.z, ft0.y
		mul ft1.z, ft1.z, fc2.z
		mul ft1.z, ft1.z, ft0.y
		mul ft1.z, ft1.z, ft0.y
		pow ft1.w, ft0.y, fc2.z
		mul ft2.x, ft1.x, fc0.x
		mul ft2.y, ft1.y, fc0.y
		mul ft2.z, ft1.z, fc0.z
		mul ft2.w, ft1.w, fc0.w
		add ft2.x, ft2.x, ft2.y
		add ft2.x, ft2.x, ft2.z
		add ft2.x, ft2.x, ft2.w
		mul ft3.x, ft1.x, fc1.x
		mul ft3.y, ft1.y, fc1.y
		mul ft3.z, ft1.z, fc1.z
		mul ft3.w, ft1.w, fc1.w
		add ft3.x, ft3.x, ft3.y
		add ft3.x, ft3.x, ft3.z
		add ft3.x, ft3.x, ft3.w
		sub ft4.x, ft0.x, ft2.x
		sub ft4.y, ft3.x, ft2.x
		div ft4.x, ft4.x, ft4.y
		mov ft4.y, ft0.y
		tex ft5, ft4.xy, fs0<2d, clamp, linear, nomip>
		sge ft6.x, ft0.x, ft2.x
		slt ft6.y, ft0.x, ft3.x
		mov ft6.w, ft5.w
		mul ft5.w, ft6.x, ft6.y
		min ft5.w, ft5.w, ft6.w
		mov oc, ft5
	]]>
		
		
		private var mLeft:Vector.<Number>		= new <Number>[0.0, 0.0, 0.0, 0.0];
		private var mRight:Vector.<Number>		= new <Number>[1.0, 1.0, 1.0, 1.0];
		private var mVars:Vector.<Number>		= new <Number>[1.0, 2.0, 3.0, 0.0];
		
		private var mShaderProgram:Program3D;
		
		public function WarpFilter()
		{}
        
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
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mLeft,  1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mRight, 1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, mVars,  1);
			context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context.setProgram(mShaderProgram);
		}
		
		override protected function deactivate(pass:int, context:Context3D, texture:Texture):void 
		{
			context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
		}
		
		// mLeft
		public function get l1():Number { return mLeft[0]; }
		public function set l1(value:Number):void { mLeft[0] = value; }
		
		public function get l2():Number { return mLeft[1]; }
		public function set l2(value:Number):void { mLeft[1] = value; }
		
		public function get l3():Number { return mLeft[2]; }
		public function set l3(value:Number):void { mLeft[2] = value; }
		
		public function get l4():Number { return mLeft[3]; }
		public function set l4(value:Number):void { mLeft[3] = value; }
		
		// mRight
		public function get r1():Number { return mRight[0]; }
		public function set r1(value:Number):void { mRight[0] = value; }
		
		public function get r2():Number { return mRight[1]; }
		public function set r2(value:Number):void { mRight[1] = value; }
		
		public function get r3():Number { return mRight[2]; }
		public function set r3(value:Number):void { mRight[2] = value; }
		
		public function get r4():Number { return mRight[3]; }
		public function set r4(value:Number):void { mRight[3] = value; }
		
	}
}