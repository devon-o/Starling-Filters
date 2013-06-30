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
	 * Produces a spotlight or vignette like effect on Starling display objects.
	 * @author Devon O.
	 */
 
	public class Spotlight2Filter extends FragmentFilter
	{
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
        tex ft1, v0, fs0<2d, clamp, linear, mipnone>
		sub ft2.x, v0.x, fc0.x
		mul ft2.x, ft2.x, ft2.x
		div ft2.x, ft2.x, fc1.w
		sub ft2.y, v0.y, fc0.y
		mul ft2.y, ft2.y, ft2.y
		mul ft2.y, ft2.y, fc1.w
		add ft2.x, ft2.x, ft2.y
		sqt ft4.x, ft2.x
		mov ft3.x, fc1.x
		add ft3.x, ft3.x, fc0.w
		div ft3.x, fc0.z, ft3.x
		div ft4.x, ft4.x, ft3.x
		sub ft4.x, fc1.x, ft4.x
		add ft4.x, ft4.x, fc0.w
		min ft4.x, ft4.x, fc1.x
		mul ft6.xyz, ft1.xyz, ft4.xxx
		mul ft6.xyz, ft6.xyz, fc2
		mov ft6.w, ft1.w
		mov oc, ft6
	]]>
		
		private var mCenter:Vector.<Number> = new <Number>[1, 1, 1, 1];
		private var mVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
		private var mLightColor:Vector.<Number> = new <Number>[1, 1, 1, 0];
		private var mShaderProgram:Program3D;
 
		private var _x:Number;
		private var _y:Number;
		private var _radius:Number;
		private var _corona:Number;
		private var _red:Number=1.0;
		private var _green:Number=1.0;
		private var _blue:Number = 1.0;
		
		/**
		 * 
		 * @param	x		x position
		 * @param	y		y position
		 * @param	radius	radius of spotlight (0 - 1)
		 * @param	corona	"softness" of spotlight
		 */
		public function Spotlight2Filter(x:Number = 0.0, y:Number = 0.0, radius:Number = .25, corona:Number = 2 )
		{
			_x 		= x;
			_y 		= y;
			_radius	= radius;
			_corona	= corona;
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
			mCenter[0] = _x / texture.width;
			mCenter[1] = _y / texture.height;
			mCenter[2] = _radius;
			mCenter[3] = _corona;
			
			// texture ratio to produce rounded lights on rectangular textures
			mVars[3] = texture.height / texture.width;
			
			mLightColor[0] = _red;
			mLightColor[1] = _green;
			mLightColor[2] = _blue;
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mCenter, 1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mVars,   1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, mLightColor,   1);
			context.setProgram(mShaderProgram);
        }
 
		public function get x():Number { return _x; }
		public function set x(value:Number):void { _x = value; }
 
		public function get y():Number { return _y; }
		public function set y(value:Number):void { _y = value; }
 
		public function get corona():Number { return _corona; }
		public function set corona(value:Number):void { _corona = value; }
 
		public function get radius():Number { return _radius; }
		public function set radius(value:Number):void { _radius = value; }
 
		public function get red():Number { return _red; }
		public function set red(value:Number):void { _red = value; }
		
		public function get green():Number { return _green; }
		public function set green(value:Number):void { _green = value; }
		
		public function get blue():Number { return _blue; }
		public function set blue(value:Number):void { _blue = value; }
    }
}