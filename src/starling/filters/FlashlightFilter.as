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
	 * A pointed flash light / light cone effect.
	 * Only use with Context3DProfile.BASELINE (not compatible with constrained profile)
	 * @author Devon O.
	 */
	
	public class FlashlightFilter extends FragmentFilter
	{
        private static const FRAGMENT_SHADER:String =
        <![CDATA[
            // azimuth
            mov ft0.z, fc1.y
            sin ft0.z, ft0.z
            neg ft0.z, ft0.z
            
            // direction
            mov ft1.x, fc1.y
            cos ft1.x, ft1.x
            mov ft2.x, fc1.x
            cos ft2.y, ft2.x
            sin ft2.z, ft2.x
            mul ft0.x, ft1.x, ft2.y
            mul ft0.y, ft1.x, ft2.z
            nrm ft3.xyz, ft0.xyz
            
            // distance
            sub ft2.y, v0.x, fc0.x
            mul ft2.y, ft2.y, ft2.y
            sub ft2.z, v0.y, fc0.y
            mul ft2.z, ft2.z, ft2.z
            add ft2.y, ft2.y, ft2.z
            sqt ft2.x, ft2.y
            
            // shadow
            mul ft4.y, ft2.x, fc3.y
            mul ft4.z, fc3.z, ft2.x
            mul ft4.z, ft4.z, ft2.x
            add ft4.x, fc3.x, ft4.y
            add ft4.x, ft4.x, ft4.z
            rcp ft4.x, ft4.x
            
            // cones
            mov ft0.xy, v0.xy
            mov ft0.z, fc0.z
            mov ft1.xy, fc0.xy
            mov ft1.z, fc0.z
            sub ft0.xyz, ft0.xyz, ft1.xyz
            nrm ft2.xyz, ft0.xyz
            mov ft0.x, fc1.z
            cos ft0.x, ft0.x
            mov ft0.y, fc1.w
            cos ft0.y, ft0.y
            dp3 ft0.z, ft2.xyz, ft3.xyz
            
            // Smoothstep
            sub ft1.x, ft0.z, ft0.y
            sub ft1.y, ft0.x, ft0.y
            div ft1.x, ft1.x, ft1.y
            sat ft0.z, ft1.x
            mul ft1.x, fc4.x, ft0.z
            sub ft1.x, fc4.y, ft1.x
            mul ft0.z, ft0.z, ft1.x
            mul ft0.z, ft0.z, ft0.z
            
            // shadow
            mul ft0.xyz, ft0.zzz, ft4.xxx
            
            // lightcolor
            mul ft0.xyz, ft0.xyz, fc2.xyz
            
            // Sample
            tex ft6, v0.xy, fs0<2d, clamp, linear, mipnone>
            mul ft6.xyz, ft6.xyz, ft0.xyz
            mov oc, ft6
        ]]>
		
		
        private var mCenter:Vector.<Number> = new <Number>[1, 1, 0, 1];
        private var mVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mLightColor:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mAttenuation:Vector.<Number> = new <Number>[.50, 10, 100, 1];
        private var mSmoothStep:Vector.<Number> = new <Number>[2, 3, 1, 1];
        private var mShaderProgram:Program3D;

        private var mX:Number;
        private var mY:Number;
        private var mAngle:Number = 0.0;
        private var mOuterCone:Number = 10.0;
        private var mInnerCone:Number = 50.0;
        private var mAzimuth:Number = 0.0;
		
        /**
         * 
         * @param	x		x position
         * @param	y		y position
         * @param	angle	angle (direction) of effect
         */
        public function FlashlightFilter(x:Number=0.0, y:Number=0.0, angle:Number = 0.0)
        {
            mX = x;
            mY = y;
            mAngle = angle;
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
            var cx:Number = mX / texture.width;
            var cy:Number = mY / texture.height;

            mCenter[0] = cx;
            mCenter[1] = cy;

            mVars[0] = mAngle * RADIAN;		// angle
            mVars[1] = mAzimuth * RADIAN;	// azimuth
            mVars[2] = mOuterCone * RADIAN;	// outer cone angle
            mVars[3] = mInnerCone * RADIAN;	// inner cone angle

            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mCenter,		1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mVars,			1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, mLightColor,	1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, mAttenuation,	1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, mSmoothStep,	1);

            context.setProgram(mShaderProgram);
        }
		
        private static const RADIAN:Number = Math.PI / 180;

        public function get x():Number { return mX; }
        public function set x(value:Number):void { mX = value; }

        public function get y():Number { return mY; }
        public function set y(value:Number):void { mY = value; }
		
        public function get angle():Number { return mAngle; }
        public function set angle(value:Number):void { mAngle = value; }

        public function get innerCone():Number { return mInnerCone; }
        public function set innerCone(value:Number):void { mInnerCone = value; }

        public function get outerCone():Number { return mOuterCone; }
        public function set outerCone(value:Number):void { mOuterCone = value; }

        public function get attenuation1():Number { return mAttenuation[0]; }
        public function set attenuation1(value:Number):void { mAttenuation[0] = value; }

        public function get attenuation2():Number { return mAttenuation[1]; }
        public function set attenuation2(value:Number):void { mAttenuation[1] = value; }

        public function get attenuation3():Number { return mAttenuation[2]; }
        public function set attenuation3(value:Number):void { mAttenuation[2] = value; }

        public function get red():Number { return mLightColor[0]; }
        public function set red(value:Number):void { mLightColor[0] = value; }

        public function get green():Number { return mLightColor[1]; }
        public function set green(value:Number):void { mLightColor[1] = value; }

        public function get blue():Number { return mLightColor[2]; }
        public function set blue(value:Number):void { mLightColor[2] = value; }

        public function get azimuth():Number { return mAzimuth; }
        public function set azimuth(value:Number):void { mAzimuth = value; }
		
    }
}