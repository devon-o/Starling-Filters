/**
 *	Copyright (c) 2016 Devon O. Wolfgang
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
    import starling.effects.SpotlightEffect;
    import starling.rendering.FilterEffect;
    
	/**
     * Creates a Spotlight effect
     * @author Devon O.
     */
    public class SpotlightFilter extends FragmentFilter
    {
        private var sEffect:SpotlightEffect;
        
        private var _x:Number;
        private var _y:Number;
        private var _radius:Number;
        private var _corona:Number;
        
        private var _r:Number=1.0;
        private var _g:Number=1.0;
        private var _b:Number=1.0;
        
        /**
         * Create a new Spotlight Filter
         * @param x         x position of center of effect (0-1)
         * @param y         y position of center of effect (0-1)
         * @param radius    light radius (0-1)
         * @param corona    light corona
         */
        public function SpotlightFilter(x:Number=0.0, y:Number=0.0, radius:Number=.25, corona:Number=2.0) 
        {
            this._x=x;
            this._y=y;
            this._radius=radius;
            this._corona=corona;
        }
        
        /** X Position (0-1) */
        public function get x():Number { return this._x; }
        public function set x(value:Number):void 
        { 
            this._x = value;
            if (this.sEffect != null)
            {
                this.sEffect._x = this._x; 
                setRequiresRedraw();
            }
        }
        
        /** Y Position (0-1) */
        public function get y():Number { return this._y; }
        public function set y(value:Number):void
        { 
            this._y = value;
            if (this.sEffect != null)
            {
                this.sEffect._y = this._y; 
                setRequiresRedraw();
            }
        }
        
        /** Corona */
        public function get corona():Number { return this._corona; }
        public function set corona(value:Number):void
        { 
            this._corona = value;
            if (this.sEffect != null)
            {
                this.sEffect._corona = this._corona; 
                setRequiresRedraw();
            }
        }
        
        /** Radius (0-1) */
        public function get radius():Number{ return this._radius; }
        public function set radius(value:Number):void
        {
            this._radius = value;
            if (this.sEffect != null)
            {
                this.sEffect._radius = this._radius; 
                setRequiresRedraw();
            }
        }
        
        /** Red */
        public function get red():Number { return this._r; }
        public function set red(value:Number):void
        { 
            this._r = value;
            if (this.sEffect != null)
            {
                this.sEffect._red = this._r;
                setRequiresRedraw();
            }
        }
        
        /** Green */
        public function get green():Number { return this._g; }
        public function set green(value:Number):void
        { 
            this._g = value;
            if (this.sEffect != null)
            {
                this.sEffect._green = this._g; 
                setRequiresRedraw();
            }
        }
        
        /** Blue */
        public function get blue():Number { return this._b; }
        public function set blue(value:Number):void
        { 
            this._b = value;
            if (this.sEffect != null)
            {
                this.sEffect._blue = this._b; 
                setRequiresRedraw();
            }
        }
        
        /** Create effect */
        override protected function createEffect():FilterEffect 
        {
            this.sEffect = new SpotlightEffect();
            this.sEffect._x = this._x;
            this.sEffect._y = this._y;
            this.sEffect._corona = this._corona;
            this.sEffect._radius = this._radius;
            this.sEffect._red = this._r;
            this.sEffect._green = this._g;
            this.sEffect._blue = this._b;
            return this.sEffect;
        }
    }

}