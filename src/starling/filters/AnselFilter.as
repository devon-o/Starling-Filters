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
     * Produces a Black and White "Ansel Adams" type effect
     * @author Devon O.
     */
    public class AnselFilter extends FragmentFilter
    {
        private static const FRAGMENT_SHADER:String =
        <![CDATA[
        
        tex ft0, v0, fs0<2d, clamp, linear, mipnone>

        // exposure 
        exp ft1, ft0
        mul ft1, ft1, fc0.xxxx
        mul ft0, ft0, ft1

        // coefficients * luma
        mov ft1.xyz, fc2.xyz
        mul ft1.xyz, ft1.xyz, fc1.xyz
        mov ft1.w, fc1.w

        dp3 ft2.x, ft0, ft1
        mov ft2.yzw, ft2.xxx
        
        // out * brightness
        mul ft2.xyz, ft2.xyz, fc0.yyy
        
        // scale and bias (for maximum contrast)
        add ft2.xyz, ft2.xyz, fc3.yyy
        max ft2.xyz, ft2.xyz, fc1.www
        mul ft2.xyz, ft2.xyz, fc3.xxx
        
        mov ft2.w, ft0.w
        mov oc, ft2
        
        ]]>
        
        private var fc0:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        private var fc1:Vector.<Number> = new <Number>[0.299, 0.587, 0.114, 0];
        private var fc2:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        private var fc3:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        
        private var mShaderProgram:Program3D;

        private var mExposure:Number;
        private var mBrightness:Number;
        private var mScale:Number;
        private var mBias:Number;
        private var mRedCoeff:Number=1.0;
        private var mGreenCoeff:Number=1.0;
        private var mBlueCoeff:Number=1.0;
 
        /**
         * Create a new Ansel filter
         * @param exposure      Exposure
         * @param brightness    Brightness
         * @param scale         Scale
         * @param bias          Bias
         */
        public function AnselFilter(exposure:Number=1, brightness:Number=1, scale:Number=1, bias:Number=0)
        {
            mExposure = exposure;
            mBrightness = brightness;
            mScale = scale;
            mBias = bias;
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
            fc0[0] = mExposure;
            fc0[1] = mBrightness;
            
            fc2[0] = mRedCoeff;
            fc2[1] = mGreenCoeff;
            fc2[2] = mBlueCoeff;
            
            fc3[0] = mScale;
            fc3[1] = mBias;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc0, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fc1, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, fc2, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, fc3, 1);
            
            context.setProgram(mShaderProgram);
        }
        
        /** Exposure */
        public function get exposure():Number { return mExposure; }
        public function set exposure(value:Number):void { mExposure = value; }
        
        /** Brightness */
        public function get brightness():Number { return mBrightness; }
        public function set brightness(value:Number):void { mBrightness = value; }
        
        /** Scale */
        public function get scale():Number { return mScale; }
        public function set scale(value:Number):void { mScale = value; }
        
        /** Bias */
        public function get bias():Number { return mBias; }
        public function set bias(value:Number):void { mBias = value; }
        
        /** Red Coefficient */
        public function get redCoeff():Number { return mRedCoeff; }
        public function set redCoeff(value:Number):void { mRedCoeff = value; }
        
        /** Green Coefficient */
        public function get greenCoeff():Number { return mGreenCoeff; }
        public function set greenCoeff(value:Number):void { mGreenCoeff = value; }
        
        /** Blue Coefficient */
        public function get blueCoeff():Number { return mBlueCoeff; }
        public function set blueCoeff(value:Number):void { mBlueCoeff = value; }
        
    }
}