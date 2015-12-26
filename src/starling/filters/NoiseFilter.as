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
     * Produces a noise/film grain effect on Starling display objects.
     * @author Devon O.
     */
    public class NoiseFilter extends BaseFilter
    {
        
        private var noiseVars:Vector.<Number> = new <Number>[1, 1, 1, 0];
        private var randVars:Vector.<Number> = new <Number>[12.9898, 78.233, 43758.5453, Math.PI];

        private var _seedX:Number;
        private var _seedY:Number;
        private var _amount:Number;
 
        /**
         * Create a new Noise Filter
         * @param amount    Amount of noise (between 0 and 2.0 is good)
         */
        public function NoiseFilter(amount:Number=.25)
        {
            _amount = amount;
            _seedX = Math.random();
            _seedY = Math.random();
        }
        
        /** Set AGAL*/
        protected override function setAgal():void
        {
            FRAGMENT_SHADER =
            <![CDATA[
                tex ft0, v0, fs0<2d, clamp, linear, mipnone>
                
                mov ft1.xy, v0.xy
                add ft1.xy, ft1.xy, fc0.xy
                mov ft6.xy, fc1.xy
                
                // 'improved' "canonical one-liner" noise function
                //@see http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/
                dp3 ft1.x, ft1.xy, ft6.xy
                div ft1.x, ft1.x, fc1.w
                frc ft1.x, ft1.x
                mul ft1.x, ft1.x, fc1.w
                sin ft1.x, ft1.x
                mul ft1.x, ft1.x, fc1.z
                frc ft1.x, ft1.x
                
                // multiply by amount
                mul ft1.x, ft1.x, fc0.z
                
                sub ft0.xyz, ft0.xyz, ft1.xxx 
                mov oc, ft0
            ]]>;
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            noiseVars[0] = _seedX;
            noiseVars[1] = _seedY;
            noiseVars[2] = _amount;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, noiseVars, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, randVars,  1);
            
            super.activate(pass, context, texture);
        }
        
        /** Random seed in x dimension (between 0 and 1) */
        public function get seedX():Number { return _seedX; }
        public function set seedX(value:Number):void { _seedX = value; }
        
        /** Random seed in y dimension (between 0 and 1) */
        public function get seedY():Number { return _seedY; }
        public function set seedY(value:Number):void { _seedY = value; }
        
        /** Amount of noise (between 0 and 2 is best) */
        public function get amount():Number { return _amount; }
        public function set amount(value:Number):void { _amount = value; }
    }
}