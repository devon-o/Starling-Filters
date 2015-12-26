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
    import flash.geom.Point;
    import flash.utils.getTimer;
    import starling.textures.Texture;
    
    /**
     * Creates a bad VCR effect with static-y snow, offset red colors, and moving black bar(s)
     * @author Devon O.
     */
    public class VCRFilter extends BaseFilter
    {
        private var snowVars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var offsetVars:Vector.<Number> = new <Number>[0, 1, 0, 0];
        private var trackingVars:Vector.<Number> = new <Number>[1, 3, 1, 1];
        private var randVars:Vector.<Number> = new <Number>[12.9898, 4.1414, 43758.5453, 1];
        
        private var _snow:Number = .40;
        private var _tracking:Number = 4.0;
        private var _trackingBlur:Number = 1.25;
        private var _trackingAmount:Number = 6.0;
        private var redOffset:Point = new Point(.4, .4);
		
        /** Create a new VCR Filter */
        public function VCRFilter(){}
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
                // original texture
                tex ft0, v0, fs0<2d, clamp, linear, mipnone>
                
                // jack up red offset
                add ft1.xy, v0.xy, fc1.xy
                tex ft3, ft1.xy, fs0<2d, clamp, linear, mipnone>
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
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            snowVars[0] = Math.random();
            snowVars[1] = Math.random();
            snowVars[2] = this._snow;
            
            offsetVars[0] = -this.redOffset.x;
            offsetVars[1] = -this.redOffset.y;
            
            trackingVars[0] = getTimer() / 1000;
            trackingVars[1] = this._trackingAmount;
            trackingVars[2] = this._tracking;
            trackingVars[3] = this._trackingBlur;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, snowVars,       1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, offsetVars,     1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, trackingVars,   1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, randVars,       1);
            
            super.activate(pass, context, texture);
        }
		
        /** Amount of snow */
        public function get snow():Number { return this._snow; }
        public function set snow(value:Number):void { this._snow = value; }

        /** Speed of black bars */
        public function get tracking():Number { return this._tracking; }
        public function set tracking(value:Number):void { this._tracking = value; }

        /** Blur of black bars */
        public function get trackingBlur():Number { return this._trackingBlur; }
        public function set trackingBlur(value:Number):void { this._trackingBlur = value; }

        /** Size / Number of black bars (larger value = more smaller bars) */
        public function get trackingAmount():Number { return this._trackingAmount; }
        public function set trackingAmount(value:Number):void { this._trackingAmount = value; }

        /** Image red offset x */
        public function get redOffsetX():Number { return this.redOffset.x*100; }
        public function set redOffsetX(value:Number):void { this.redOffset.x = value/100; }

        /** Image red offset y */
        public function get redOffsetY():Number { return this.redOffset.y*100; }
        public function set redOffsetY(value:Number):void { this.redOffset.y = value/100; }
		
    }
}
