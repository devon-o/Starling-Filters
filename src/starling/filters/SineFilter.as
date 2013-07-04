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
	 * Creates a sine wave effect in horizontal or vertical direction. Use the ticker value to animate.
	 * @author Devon O.
	 */
	
    public class SineFilter extends FragmentFilter
    {
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
		mov ft0, v0
		sub ft1.x, v0.y, fc0.z
		mul ft1.x, ft1.x, fc0.w
		sin ft1.x, ft1.x
		mul ft1.x, ft1.x, fc0.y
		
		// horizontal
		mul ft1.y, ft1.x, fc1.x
		add ft0.x, ft0.x, ft1.y
		
		// vertical
		mul ft1.z, ft1.x, fc1.y
		add ft0.y, ft0.y, ft1.z

		tex oc, ft0, fs0<2d, wrap, linear, mipnone>
	]]>
		
        private var mQuantifiers:Vector.<Number> = new <Number>[1, 1, 1, 1];
		private var mBooleans:Vector.<Number> = new <Number>[1, 1, 1, 1];
		
        private var _amplitude:Number
		private var _amount:Number;
		private var _ticker:Number;
		private var _frequency:Number;
		private var _isHorizontal:Boolean = true;
		
        private var mShaderProgram:Program3D;
        
        public function SineFilter(amplitude:Number = 0.0, frequency:Number = 0.0, ticker:Number = 0.0)
        {
           this._amplitude = amplitude;
		   this._ticker = ticker;
		   this._frequency = frequency;
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
            mQuantifiers[1] = this._amplitude / texture.height;
			mQuantifiers[2] = this._ticker;
			mQuantifiers[3] = this._frequency ;
			
			mBooleans[0] = int(_isHorizontal);
			mBooleans[1] = int(!_isHorizontal);
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mQuantifiers, 1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mBooleans, 1);
            context.setProgram(mShaderProgram);
        }
        
        public function get amplitude():Number { return this._amplitude; }
        public function set amplitude(value:Number):void { this._amplitude = value; }
		
		public function get ticker():Number { return this._ticker; }
		public function set ticker(value:Number):void { this._ticker = value; }
		
		public function get frequency():Number { return this._frequency; }
        public function set frequency(value:Number):void { this._frequency = value; }
		
		public function get isHorizontal():Boolean { return this._isHorizontal; }
		public function set isHorizontal(value:Boolean):void { this._isHorizontal = value; }
    }
}
