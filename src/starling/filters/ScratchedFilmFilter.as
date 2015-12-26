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
    import starling.textures.Texture;
    
    /**
     * Creates a sepia toned scratched film effect
     * @author Devon O.
     */
	
    public class ScratchedFilmFilter extends BaseFilter
    {
        [Embed(source="assets/filmnoise.jpg")]
        private static const NOISE:Class;
        
        private var vars1:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var vars2:Vector.<Number> = new <Number>[1, 0, 1, 2];
        
        private var sepiaRed:Vector.<Number> = new <Number>[.393, .769, .189, 2];
        private var sepiaGreen:Vector.<Number> = new <Number>[.349, .686, .168, 2];
        private var sepiaBlue:Vector.<Number> = new <Number>[.272, .534, .131, 2];
        
        private var filmNoise:Texture;
        
        private var time:Number = 0.0;
        
        private var _speed1:Number;
        private var _speed2:Number;
        private var _scratchIntensity:Number;
        private var _scratchWidth:Number;
        
        /**
         * Creates a new ScratchedFilmFilter
         * @param   speed1              speed at which scrathes appear/disappear
         * @param   speed2              speed of horizontal scratch movement
         * @param   scratchIntensity    number of scratches
         * @param   scratchWidth        width of scratches
         */
        public function ScratchedFilmFilter(speed1:Number=.005, speed2:Number=.01, scratchIntensity:Number=.33, scratchWidth:Number=.02)
        {
            this.filmNoise = Texture.fromBitmap(new NOISE(), false, false, 1, "bgra", true);
            
            this._speed1 = speed1;
            this._speed2 = speed2;
            this._scratchIntensity = scratchIntensity;
            this._scratchWidth = scratchWidth;
        }
        
        /** Dispose */
        public override function dispose():void
        {
            this.filmNoise.dispose();
            super.dispose();
        }
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
                mov ft0.x, fc0.x
                mul ft0.x, ft0.x, fc1.x
                mov ft0.y, fc0.y
                mul ft0.y, ft0.y, fc1.x
                
                // img	
                tex ft1, v0, fs0<2d, clamp, linear, mipnone>
                
                add ft2.x, v0.x, ft0.y
                mov ft2.y, ft0.x
                
                // scratch 
                tex ft3, ft2.xy, fs1<2d, wrap, linear, mipnone>
                
                sub ft4.x, ft3.x, fc0.z
                mul ft4.x, ft4.x, fc1.w
                div ft3.x, ft4.x, fc0.w
                sub ft4.x, fc1.z, ft3.x
                abs ft4.x, ft4.x
                sub ft3.x, fc1.z, ft4.x
                max ft3.x, fc1.y, ft3.x
                mov ft3.w, fc1.z
                add ft5, ft3.xxxw, ft1
                
                // sepia
                dp3 ft6.x, ft5.xyz, fc2.xyz
                dp3 ft6.y, ft5.xyz, fc3.xyz
                dp3 ft6.z, ft5.xyz, fc4.xyz
                mov ft6.w, ft5.w
                mov oc ft6
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        { 
            this.vars1[0] = this._speed1;
            this.vars1[1] = this._speed2;
            this.vars1[2] = this._scratchIntensity;
            this.vars1[3] = this._scratchWidth;
            
            this.vars2[0] = this.time ;
            
            context.setTextureAt(1, this.filmNoise.base);
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.vars1,         1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.vars2,         1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.sepiaRed,      1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, this.sepiaGreen,    1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, this.sepiaBlue,     1);
            
            super.activate(pass, context, texture);
            
            this.time += .05;
            if (this.time >= texture.width) this.time = 0.0;
        }
		
        /** Deactivate */
        override protected function deactivate(pass:int, context:Context3D, texture:Texture):void 
        {
            context.setTextureAt(1, null);
        }
		
        /** Speed 1 (0 - .1) */
        public function get speed1():Number { return _speed1; }
        public function set speed1(value:Number):void { _speed1 = value; }
        
        /** Speed 2 (0 - .02) */
        public function get speed2():Number { return _speed2; }
        public function set speed2(value:Number):void { _speed2 = value; }
        
        /** Scratch Intensity (0 - .4) */
        public function get scratchIntensity():Number { return _scratchIntensity; }
        public function set scratchIntensity(value:Number):void { _scratchIntensity = value; }
        
        /** Scratch Width (0 - .25) */
        public function get scratchWidth():Number { return _scratchWidth; }
        public function set scratchWidth(value:Number):void { _scratchWidth = value; }
    }
}