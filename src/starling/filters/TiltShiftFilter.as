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
     * Produces a subtle 'Tilt Shift' blur effect on Starling display objects.
     * @author Devon O.
     */
 
    public class TiltShiftFilter extends FragmentFilter
    {
        private static const FRAGMENT_SHADER:String =
        <![CDATA[
        
            mul ft0.x, v0.y, fc0.y
            mul ft0.x, ft0.x, fc1.y
            sub ft0.x, ft0.x, fc1.x
            pow ft0.x, ft0.x, fc1.y
            mul ft0.x, ft0.x, fc0.x
            
            mov ft1.xyzw, fc1.zzzx
            
            // START OF UNWRAPPED LOOP
            //1
            mov ft2.xy, fc1.ww

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w

            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            // save original alpha
            mov ft6.w, ft4.w
            add ft1, ft1, ft4

            //2
            mov ft2.xy, fc1.wz

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w

            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4

            //3
            mov ft2.xy, fc1.wx

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w
            
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //4
            mov ft2.xy, fc1.zw

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w
            
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4

            //5
            mov ft2.xy, fc1.zz

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w
            
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //6
            mov ft2.xy, fc1.zx

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w
            
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //7
            mov ft2.xy, fc1.xw

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w
            
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //8
            mov ft2.xy, fc1.xz

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w
            
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //9
            mov ft2.xy, fc1.xx

            mov ft3.xy, v0.xy
            mul ft3.z, ft2.x, ft0.x
            mul ft3.z, ft3.z, fc0.z
            add ft3.x, ft3.x, ft3.z
            
            mul ft3.w, ft2.y, ft0.x
            mul ft3.w, ft3.w, fc0.z
            add ft3.y, ft3.y, ft3.w
            
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            // END LOOP
            
            mov ft5.x, fc0.w
            mul ft5.x, ft5.x, ft5.x
            div ft1.xyz, ft1.xyz, ft5.xxx
            // restore orig alpha
            mov ft1.w, ft6.w
            mov oc, ft1
        
        ]]>
	
        private var fc0:Vector.<Number> = new <Number>[1.5, 1.1, .004, 3.0];
        private var fc1:Vector.<Number> = new <Number>[1.0, 2.0, 0.0, -1.0];
        
        private var mBlurAmount:Number = 1.5;
        private var mCenter:Number = 1.1;
        
        private var mShaderProgram:Program3D;
        
        /**
         * Create a new TiltShift Filter
         * @param blurAmount    amount of blur
         * @param center        center of blur (roughly in y position)
         * @param numPasses     number of passes this filter should apply (1 pass = 1 drawcall)
         */
        public function TiltShiftFilter(blurAmount:Number=1.5, center:Number=1.1, numPasses:int=1)
        {
            mBlurAmount = blurAmount;
            mCenter = center;
            
            this.numPasses = numPasses;
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
            fc0[0] = mBlurAmount;
            fc0[1] = mCenter;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc0, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fc1, 1);
            
            context.setProgram(mShaderProgram);
        }
        
        /** Amount of blur (keep low for subtle effect) */
        public function get amount():Number { return mBlurAmount; }
        public function set amount(value:Number):void { mBlurAmount = value; }
        
        /** Rough center in y plane */
        public function get center():Number { return mCenter; }
        public function set center(value:Number):void { mCenter = value; }
    }
}