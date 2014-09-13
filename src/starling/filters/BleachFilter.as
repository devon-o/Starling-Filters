/**
 *	Copyright (c) 2014 Devon O. Wolfgang
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
     * Produces a "bleached out" effect
     * @author Devon O.
     */
    public class BleachFilter extends FragmentFilter
    {
        private static const FRAGMENT_SHADER:String =
        <![CDATA[
        
        tex ft0, v0, fs0<2d, clamp, linear, mipnone>
        dp4 ft1.x, ft0, fc0
        mov ft2.xyzw, ft1.xxxx
        
        // amount of mix
        sub ft1.x, ft1.x, fc3.x
        mul ft1.x, ft1.x, fc3.y
        sat ft1.x, ft1.x
        mov ft1.yzw, ft1.xxx
        
        mul ft3, ft0, fc1
        mul ft3, ft3, ft2
        
        sub ft4, fc2, ft0
        sub ft5, fc2, ft2
        mul ft4, ft4, ft5
        mul ft4, ft4, fc1
        sub ft4, fc2, ft4
        
        sub ft4, ft4, ft3
        mul ft4, ft4, ft1
        add ft4, ft4, ft3

        // mix(original, result, amount);
        sub ft4, ft4, ft0
        mul ft4, ft4, fc3.zzzz
        add oc, ft4, ft0
        
        ]]>
        
        private var fc0:Vector.<Number> = new <Number>[0.2125, 0.7154, 0.0721, 0.0];
        private var fc1:Vector.<Number> = new <Number>[2.0, 2.0, 2.0, 2.0];
        private var fc2:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        private var mVars:Vector.<Number> = new <Number>[.45, 10.0, 1, 0];
        
        private var mShaderProgram:Program3D;

        private var mAmount:Number;
 
        /**
         * Create a new Bleach Filter
         * @param amount    Amount of bleach to apply (between 0 and 2 is good)
         */
        public function BleachFilter(amount:Number=1)
        {
            mAmount = amount;
        }
        
        /** Dispose */
        public override function dispose():void
        {
            if (mShaderProgram) mShaderProgram.dispose();
            super.dispose();
        }
        
        /** Create Shader program */
        protected override function createPrograms():void
        {
            mShaderProgram = assembleAgal(FRAGMENT_SHADER);
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            mVars[2] = mAmount;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc0,    1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fc1,    1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, fc2,    1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, mVars,  1);
            
            context.setProgram(mShaderProgram);
        }
        
        /** Amount of bleach (between 0 and 2 is generally good) */
        public function get amount():Number { return mAmount; }
        public function set amount(value:Number):void { mAmount = value; }
    }
}