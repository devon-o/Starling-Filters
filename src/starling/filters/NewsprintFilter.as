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
	 * Creates newsprint (black and white halftone) like effect
	 * @author Devon O.
	 */

	public class NewsprintFilter extends FragmentFilter
	{
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
		tex ft0, v0, fs0<2d, clamp, nearest, nomip>
		mov ft1, fc0.w
		add ft1.x, ft0.x, ft0.y
		add ft1.x, ft1.x, ft0.z
		div ft1.x, ft1.x, fc1.w
		mul ft2, ft1.x, fc1.z 
		sub ft2, ft2, fc1.y 
		mov ft5, fc0.w 
		mov ft5.x, fc0.x
		sin ft5.x, ft5.x
		mov ft5.y, fc0.x 
		cos ft5.y, ft5.y
		mul ft6, v0, fc0.z
		sub ft6, ft6, fc0.w 
		mov ft7, fc0.w
		mul ft7.z, ft5.y, ft6.x
		mul ft7.w, ft5.x, ft6.y
		sub ft7.x, ft7.z, ft7.w
		mul ft7.x, ft7.x, fc0.y 
		mul ft7.z, ft5.x, ft6.x
		mul ft7.w, ft5.y, ft6.y 
		add ft7.y, ft7.z, ft7.w 
		mul ft7.y, ft7.y, fc0.y
		sin ft6.x, ft7.x
		sin ft6.y, ft7.y
		mul ft3, ft6.x, ft6.y
		mul ft3, ft3, fc1.x 
		add ft2, ft2, ft3
		mov ft2.w, ft0.w
		mov oc, ft2
	]]>
		
		private var mQuantifiers:Vector.<Number>	= new <Number>[1.0, 1.0, 1.0,  1.0];
		private var mConstants:Vector.<Number>		= new <Number>[4.0, 5.0, 10.0, 3.0];;
		private var mShaderProgram:Program3D;
		
		private var mSize:Number;
		private var mScale:Number;
		private var mAngle:Number;
        
		public function NewsprintFilter(size:Number = 120.0, scale:Number = 3.0, angleInRadians:Number = 0.0)
		{
			mSize	= size;
			mScale	= scale;
			mAngle	= angleInRadians;
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
            
			mQuantifiers[0] = mAngle;
			mQuantifiers[1] = mScale;
			mQuantifiers[2] = mSize;
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mQuantifiers, 1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mConstants,   1);
			context.setProgram(mShaderProgram);
		}
		
		public function get size():Number { return mSize; }
		public function set size(value:Number):void { mSize = value; }
		
		public function get angle():Number { return mAngle; }
		public function set angle(value:Number):void { mAngle = value; }
		
		public function get scale():Number { return mScale; }
		public function set scale(value:Number):void { mScale = value; }
	}
}