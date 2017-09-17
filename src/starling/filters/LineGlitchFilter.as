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
    import starling.effects.LineGlitchEffect;
    import starling.rendering.FilterEffect;
    
	/**
     * Creates an angled line glitch image effect
     * @author Devon O.
     */
    public class LineGlitchFilter extends FragmentFilter
    {
        private var _size:Number;
        private var _angle:Number;
        private var _distance:Number;
        
        /**
         * Create a new LineGlitchFilter
         * @param size          Size of lines (roughly in pixels)
         * @param angle         Angle of lines in degrees
         * @param distance      Distance of lines (0-1)
         */
        public function LineGlitchFilter(size:Number=2, angle:Number=45, distance:Number=.01) 
        {
            this._size = size;
            this._angle = angle;
            this._distance = distance;
            this.padding.setTo(1, 1, 1, 1);
        }
        
        /** Size of lines (roughly in pixels) */
        public function get size():Number { return this._size; }
        public function set size(value:Number):void 
        {
            // size cannot be <=0
            if (value<=0)
                value = 1;
                
            this._size = value;
            FilterUtil.applyEffectProperty("_size", this._size, this.effect, setRequiresRedraw);
        }
        
        /** Angle in degrees */
        public function get angle():Number { return this._angle; }
        public function set angle(value:Number):void 
        { 
            this._angle = value;
            FilterUtil.applyEffectProperty("_angle", this._angle, this.effect, setRequiresRedraw);
        }
        
        /** Distance of lines (best in range of 0-1) */
        public function get distance():Number { return this._distance; }
        public function set distance(value:Number):void 
        { 
            this._distance = value;
            FilterUtil.applyEffectProperty("_distance", this._distance, this.effect, setRequiresRedraw);
        }
        
        /** Create effect */
        override protected function createEffect():FilterEffect 
        {
            var effect:LineGlitchEffect = new LineGlitchEffect();
            effect._size = this._size;
            effect._angle = this._angle;
            effect._distance = this._distance;
            return effect;
        }
    }

}