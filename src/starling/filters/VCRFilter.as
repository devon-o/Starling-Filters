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
	import flash.geom.Point;
	import flash.utils.getTimer;
	import starling.textures.Texture;
    
	/**
	 * Creates scanlines in filtered display object
	 * @author Devon O.
	 */
	
    public class VCRFilter extends FragmentFilter
    {
		private static const FRAGMENT_SHADER:String =
	<![CDATA[
        // original texture
        tex ft0, v0, fs0<2d, wrap, linear, mipnone>

        // jack up red offset
        add ft1.xy, v0.xy, fc1.xy
        tex ft3, ft1.xy, fs0<2d, wrap, linear, mipnone>
        mov ft0.x, ft3.x

        // Random snow
        mov ft1.xy, v0.xy
        add ft1.xy, ft1.xy, fc0.xy
        mov ft1.zw, fc1.zz
        mov ft6.xy, fc3.xy
        mov ft6.zw, fc1.zz
        dp3 ft1.x, ft1, ft6
        sin ft1.x, ft1.x
        mul ft1.x, ft1.x, fc3.z
        frc ft1.x, ft1.x
        mov ft2.xyz, ft1.xxx
        mov ft2.w, ft0.w
        // multiply snow by snow amount
        mul ft2.xyz, ft2.xyz, fc0.zzz

        // tracking (black bar(s))
        mov ft1.x, v0.y
        mov ft1.y, fc2.x
        mul ft1.y, ft1.y, fc2.z
        mul ft1.x, ft1.x, fc2.y
        add ft1.x, ft1.x, ft1.y
        sin ft1.x, ft1.x
        add ft1.x, ft1.x, fc2.w
        sat ft1.x, ft1.x

        // multiply black bar in
        mul ft0.xyz, ft0.xyz, ft1.xxx

        // add snow and original
        add oc, ft0, ft2
	]]>
		
        private var snowVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var offsetVars:Vector.<Number> = new <Number>[0, 1, 0, 0];
        private var trackingVars:Vector.<Number> = new <Number>[1, 3, 1, 1];
        private var randVars:Vector.<Number> = new <Number>[12.9898, 4.1414, 43758.5453, 1];

        private var mShaderProgram:Program3D;

        /** Amount of snow (0-1) */
        private var mSnow:Number = .40;

        /** Amount of blur on black bars */
        private var mTrackingBlur:Number = 1.25;

        /** Speed of black bars */
        private var mTracking:Number = 4.0;

        /** Size/Number of black bars */
        private var mTrackingAmount:Number = 6.0;

        /** Image red offset */
        private var mRedOffset:Point = new Point(.4, .4);
		
        public function VCRFilter()
        {}
        
		/** Clean up */
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
            snowVars[0] = Math.random();
            snowVars[1] = Math.random();
            snowVars[2] = mSnow;

            offsetVars[0] = -mRedOffset.x;
            offsetVars[1] = -mRedOffset.y;

            trackingVars[0] = getTimer() / 1000;
            trackingVars[1] = mTrackingAmount;
            trackingVars[2] = mTracking;
            trackingVars[3] = mTrackingBlur;

            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, snowVars,     1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, offsetVars,   1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, trackingVars, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, randVars,     1);

            context.setProgram(mShaderProgram);
        }
		
        /** Amount of snow */
        public function get snow():Number { return mSnow; }
        public function set snow(value:Number):void { mSnow = value; }

        /** Speed of black bars */
        public function get tracking():Number { return mTracking; }
        public function set tracking(value:Number):void { mTracking = value; }

        /** Blur of black bars */
        public function get trackingBlur():Number { return mTrackingBlur; }
        public function set trackingBlur(value:Number):void { mTrackingBlur = value; }

        /** Size / Number of black bars (larger value = more smaller bars) */
        public function get trackingAmount():Number { return mTrackingAmount; }
        public function set trackingAmount(value:Number):void { mTrackingAmount = value; }

        /** Image red offset x */
        public function get redOffsetX():Number { return mRedOffset.x; }
        public function set redOffsetX(value:Number):void { mRedOffset.x = value/100; }

        /** Image red offset y */
        public function get redOffsetY():Number { return mRedOffset.y; }
        public function set redOffsetY(value:Number):void { mRedOffset.y = value/100; }
		
    }
}
