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
     * Produces a light streak effect on images.
     * This filter deliberately uses 4 passes to produce a streak in 4 different compass points so may degrade performance.
     * Use with caution.
     * @author Devon O.
     */
 
    public class LightStreakFilter extends FragmentFilter
    {
        
        /** 0, unused, unused, unused */
        private var fc0:Vector.<Number> = new <Number>[0.0, 0.0, 0.0, 0.0];
        
        /** direction xy / texel size xy */
        private var fc1:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        
        /** samples, spread, attenuation, 1 */
        private var fc2:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        
        /** Number of samples */
        private var mSamples:int = 0;
        
        /** Attenuation */
        private var mAttenuation:Number = .60;
        
        /** Angle (in radians) */
        private var mAngle:Number = 0;
        
        /** Spread */
        private var mSpread:Number = .30;
        
        /** Boost */
        private var mBoost:Number = 1.0;
        
        /** AGAL program */
        private var mShaderProgram:Program3D;
        
        /**
         * Create a new LightStreak Filter
         * @param samples   number of samples/steps
         * @param passes    number of passes. Each pass will add a new streak with a 90 degree offset.
         */
        public function LightStreakFilter(samples:int=10, passes:int=4)
        {
            this.mSamples = samples;
            this.numPasses = passes;
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
            var frag:String = "";
            
            // output
            frag += "mov ft1.xyzw, fc0.xxxx  \n";
 
            frag += "mov ft0.z, fc2.x  \n";
            frag += "pow ft0.z, ft0.z, fc2.y  \n";
            
            // counter
            frag += "mov ft0.w, fc0.x  \n";
            
            for (var i:int = 0; i < mSamples; i++)
            {
                frag += "mul ft2.x, ft0.z, ft0.w  \n";
                frag += "pow ft2.x, fc2.z, ft2.x  \n";
 
                frag += "mul ft0.xy, fc1.xy, ft0.zz  \n";
                frag += "mul ft0.xy, ft0.xy, ft0.ww  \n";
                frag += "mul ft0.xy, ft0.xy, fc1.zw  \n";
                frag += "add ft0.xy, ft0.xy, v0.xy  \n";
 
                frag += "tex ft3, ft0.xy, fs0 <2d, clamp, linear, mipnone>  \n";
                
                frag += "sat ft2.x, ft2.x  \n";

                frag += "mul ft3.xyzw, ft3.xyzw, ft2.xxxx  \n";
                frag += "add ft1, ft1, ft3  \n";
                
                // increment counter
                frag += "add ft0.w, ft0.w, fc2.w  \n";
            }
            
            frag += "sat oc, ft1";
            
            mShaderProgram = assembleAgal(frag);
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            // samples, spread, attenuation
            fc2[0] = mSamples;
            fc2[1] = mSpread;
            fc2[2] = mAttenuation;
            
            // angle (90 degrees each pass)
            var ang:Number = mAngle + (1.57079633 * pass);
            fc1[0] = Math.cos(ang) * mBoost;
            fc1[1] = Math.sin(ang) * mBoost;
            
            // texel size
            fc1[2] = 1 / texture.width;
            fc1[3] = 1 / texture.height;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc0, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fc1, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, fc2, 1);
            
            context.setProgram(mShaderProgram);
        }
        
        /** Attenuation */
        public function set attenuation(value:Number):void { mAttenuation = value; }
        public function get attenuation():Number { return mAttenuation; }
        
        /** Angle (in radians) */
        public function set angle(value:Number):void { mAngle = value; }
        public function get angle():Number { return mAngle; }
        
        /** Spread */
        public function set spread(value:Number):void { mSpread = value; }
        public function get spread():Number { return mSpread; }
        
        /** Boost (similar to spread, but adjusting the 2 independently can produce better results) */
        public function set boost(value:Number):void { mBoost = value; }
        public function get boost():Number { return mBoost; }
    }
}