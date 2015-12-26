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
    import starling.textures.Texture;
	
    /**
     * Produces a Black and White "Ansel Adams" type effect
     * @author Devon O.
     */
    public class AnselFilter extends BaseFilter
    {
        private var fc0:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        private var fc1:Vector.<Number> = new <Number>[0.299, 0.587, 0.114, 0];
        private var fc2:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        private var fc3:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        
        private var _exposure:Number;
        private var _brightness:Number;
        private var _scale:Number;
        private var _bias:Number;
        private var _redCoeff:Number=1.0;
        private var _greenCoeff:Number=1.0;
        private var _blueCoeff:Number=1.0;
 
        /**
         * Create a new Ansel filter
         * @param exposure      Exposure
         * @param brightness    Brightness
         * @param scale         Scale
         * @param bias          Bias
         */
        public function AnselFilter(exposure:Number=1, brightness:Number=1, scale:Number=1, bias:Number=0)
        {
            _exposure = exposure;
            _brightness = brightness;
            _scale = scale;
            _bias = bias;
        }
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
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
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            fc0[0] = _exposure;
            fc0[1] = _brightness;
            
            fc2[0] = _redCoeff;
            fc2[1] = _greenCoeff;
            fc2[2] = _blueCoeff;
            
            fc3[0] = _scale;
            fc3[1] = _bias;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc0, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fc1, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, fc2, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, fc3, 1);
            
            super.activate(pass, context, texture);
        }
        
        /** Exposure */
        public function get exposure():Number { return _exposure; }
        public function set exposure(value:Number):void { _exposure = value; }
        
        /** Brightness */
        public function get brightness():Number { return _brightness; }
        public function set brightness(value:Number):void { _brightness = value; }
        
        /** Scale */
        public function get scale():Number { return _scale; }
        public function set scale(value:Number):void { _scale = value; }
        
        /** Bias */
        public function get bias():Number { return _bias; }
        public function set bias(value:Number):void { _bias = value; }
        
        /** Red Coefficient */
        public function get redCoeff():Number { return _redCoeff; }
        public function set redCoeff(value:Number):void { _redCoeff = value; }
        
        /** Green Coefficient */
        public function get greenCoeff():Number { return _greenCoeff; }
        public function set greenCoeff(value:Number):void { _greenCoeff = value; }
        
        /** Blue Coefficient */
        public function get blueCoeff():Number { return _blueCoeff; }
        public function set blueCoeff(value:Number):void { _blueCoeff = value; }
        
    }
}