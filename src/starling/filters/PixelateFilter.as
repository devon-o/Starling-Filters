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
    import starling.effects.PixelateEffect;
    import starling.rendering.FilterEffect;
    
	/**
     * Creates a pixelated image effect
     * @author Devon O.
     */
    public class PixelateFilter extends FragmentFilter
    {
        private var _sizeX:int;
        private var _sizeY:int;
        
        /**
         * Create a new PixelateFilter
         * @param sizeX     Size of 'pixel' in horizontal dimension
         * @param sizeY     Size of 'pixel' in vertical dimension
         */
        public function PixelateFilter(sizeX:int=8,sizeY:int=8) 
        {
            this._sizeX = sizeX;
            this._sizeY = sizeY;
        }
        
        /** Size of X Pixelation (roughly in pixels) */
        public function get sizeX():int { return this._sizeX; }
        public function set sizeX(value:int):void
        {
            this._sizeX = value;
            FilterUtil.applyEffectProperty("_sizeX", this._sizeX, this.effect, setRequiresRedraw);
        }
        
        /** Size of Y Pixelation (roughly in pixels) */
        public function get sizeY():int { return this._sizeY; }
        public function set sizeY(value:int):void
        {
            this._sizeY = value;
            FilterUtil.applyEffectProperty("_sizeY", this._sizeY, this.effect, setRequiresRedraw);
        }
        
        /** Create effect */
        override protected function createEffect():FilterEffect 
        {
            var effect:PixelateEffect = new PixelateEffect();
            effect._sizeX = this._sizeX;
            effect._sizeY = this._sizeY;
            return effect;
        }
    }

}