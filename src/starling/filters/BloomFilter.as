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
     * Produces a Bloom/Glow effect with adjustable color properties.
     * @author Devon O.
     */
 
    public class BloomFilter extends BaseFilter
    {
        
        private var fc0:Vector.<Number> = new <Number>[0, 0, 0, 2.5];
        private var fc1:Vector.<Number> = new <Number>[-1.0, 0.0, 1.0, 9.0];
        private var _color:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        
        private var _red:Number;
        private var _green:Number;
        private var _blue:Number
        
        private var _blur:Number;
        
        /**
         * Create a new BloomFilter
         * @param blur          amount of blur
         * @param red           red value
         * @param green         green value
         * @param blue          blue value
         * @param numPasses     number of passes this filter should apply (1 pass = 1 drawcall)
         */
        public function BloomFilter(blur:Number=2.5, red:Number=1, green:Number=1, blue:Number=1, numPasses:int=1)
        {
            _blur = blur;
            _red = red;
            _green = green;
            _blue = blue;
            
            this.numPasses = numPasses;
        }
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
            
            //original texture
            tex ft0, v0, fs0<2d, clamp, linear, mipnone>
            
            //output
            mov ft1, fc0.xxxx
            
            //size
            mov ft2.x, fc0.y
            mul ft2.x, ft2.x, fc0.w
            rcp ft2.x, ft2.x
            mov ft2.y, fc0.z
            mul ft2.y, ft2.y, fc0.w
            rcp ft2.y, ft2.y
            
            // START UNWRAPPED LOOP
            
            //1
            mov ft3.xy, fc1.xx
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //2
            mov ft3.xy, fc1.xy
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //3
            mov ft3.xy, fc1.xz
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //4
            mov ft3.xy, fc1.yx
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //5
            mov ft3.xy, fc1.yy
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //6
            mov ft3.xy, fc1.yz
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //7
            mov ft3.xy, fc1.zx
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //8
            mov ft3.xy, fc1.zy
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            //9
            mov ft3.xy, fc1.zz
            mul ft3.xy, ft3.xy, ft2.xy
            add ft3.xy, ft3.xy, v0.xy
            tex ft4, ft3.xy, fs0<2d, clamp, linear, mipnone>
            add ft1, ft1, ft4
            
            // END LOOP
            
            // average out
            div ft1, ft1, fc1.wwww
            add ft1, ft1, ft0
            
            // multiply by color
            mul oc, ft1, fc2 
            
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            fc0[1] = texture.width;
            fc0[2] = texture.height;
            fc0[3] = 1 / _blur;
            
            _color[0] = _red;
            _color[1] = _green;
            _color[2] = _blue;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc0,    1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fc1,    1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, _color, 1);
            
            super.activate(pass, context, texture);
        }
        
        /** Red value */
        public function get red():Number { return _red; }
        public function set red(value:Number):void { _red = value; }
        
        /** Green value */
        public function get green():Number { return _green; }
        public function set green(value:Number):void { _green = value; }
        
        /** Blue value */
        public function get blue():Number { return _blue; }
        public function set blue(value:Number):void { _blue = value; }
        
        /** Blur amount */
        public function get blur():Number { return _blur; }
        public function set blur(value:Number):void { _blur = value; }
        
    }
}