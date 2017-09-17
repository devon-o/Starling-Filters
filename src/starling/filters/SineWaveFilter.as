/**
 *	Copyright (c) 2017 Devon O. Wolfgang & William Erndt
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
    import starling.effects.SineWaveEffect;
    import starling.rendering.FilterEffect;
    import starling.utils.Padding;
    
	/**
     * Creates a sine wave image effect
     * @author Devon O.
     */
    public class SineWaveFilter extends FragmentFilter
    {
        private static const MIN_PADDING:int=25;
        
        private var _amplitude:Number
        private var _ticker:Number;
        private var _frequency:Number;
        private var _isHorizontal:Boolean=true;
        
        /**
         * Create a new SineWaveFilter
         * @param amplitude     Amplitude of sine wave (for best result, pass the largest expected amount)
         * @param frequency     Frequency of sine wave
         * @param ticker        Time ticker (use for animation)
         */
        public function SineWaveFilter(amplitude:Number=0.0, frequency:Number=0.0, ticker:Number=0.0) 
        {
            this._amplitude = amplitude;
            this._frequency = frequency;
            this._ticker = ticker;
            // Provide enough padding to fit amplitude comfortably
            this.padding.setToUniform(amplitude*2);
        }
        
        /** Amplitude of Sine Wave */
        public function get amplitude():Number { return this._amplitude; }
        public function set amplitude(value:Number):void 
        {
            this._amplitude = value;
            FilterUtil.applyEffectProperty("_amplitude", this._amplitude, this.effect, setRequiresRedraw);
        }
        
        /** Frequency of Sine Wave */
        public function get frequency():Number { return this._frequency; }
        public function set frequency(value:Number):void 
        { 
            this._frequency = value;
            FilterUtil.applyEffectProperty("_frequency", this._frequency, this.effect, setRequiresRedraw);
        }
        
        /** Ticker (increase at rate of speed (e.g. .01) for animation) */
        public function get ticker():Number { return this._ticker; }
        public function set ticker(value:Number):void 
        { 
            this._ticker = value;
            FilterUtil.applyEffectProperty("_ticker", this._ticker, this.effect, setRequiresRedraw);
        }
        
        /** Is Wave horizontal or not */
        public function get isHorizontal():Boolean { return this._isHorizontal; }
        public function set isHorizontal(value:Boolean):void 
        { 
            this._isHorizontal = value;
            FilterUtil.applyEffectProperty("_isHorizontal", this._isHorizontal, this.effect, setRequiresRedraw);
        }
        
        /** Create effect */
        override protected function createEffect():FilterEffect 
        {
            var effect:SineWaveEffect = new SineWaveEffect();
            effect._amplitude = this._amplitude;
            effect._frequency = this._frequency;
            effect._ticker = this._ticker;
            effect._isHorizontal = this._isHorizontal;
            return effect;
        }
    }

}