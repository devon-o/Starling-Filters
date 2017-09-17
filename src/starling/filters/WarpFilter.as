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
    import starling.effects.WarpEffect;
    import starling.rendering.FilterEffect;
    
	/**
     * Creates a warped image effect
     * @author Devon O.
     */
    public class WarpFilter extends FragmentFilter
    {
        private var _l1:Number
        private var _l2:Number;
        private var _l3:Number;
        private var _l4:Number;
        private var _r1:Number
        private var _r2:Number;
        private var _r3:Number;
        private var _r4:Number;
        
        /** Create a new WarpFilter */
        public function WarpFilter() 
        {
            this._l1=this._l2=this._l3=this._l4 = 0.0;
            this._r1=this._r2=this._r3=this._r4 = 1.0;
        }
        
        /** Top left control */
        public function get l1():Number { return this._l1; }
        public function set l1(value:Number):void
        {
            this._l1 = value;
            FilterUtil.applyEffectProperty("l1", this._l1, this.effect, setRequiresRedraw);
        }
        
        /** Top middle left control */
        public function get l2():Number { return this._l2; }
        public function set l2(value:Number):void
        {
            this._l2 = value;
            FilterUtil.applyEffectProperty("l2", this._l2, this.effect, setRequiresRedraw);
        }
        
        /** Bottom middle left control */
        public function get l3():Number { return this._l3; }
        public function set l3(value:Number):void
        {
            this._l3 = value;
            FilterUtil.applyEffectProperty("l3", this._l3, this.effect, setRequiresRedraw);
        }
        
        /** Bottom left control */
        public function get l4():Number { return this._l4; }
        public function set l4(value:Number):void
        {
            this._l4 = value;
            FilterUtil.applyEffectProperty("l4", this._l4, this.effect, setRequiresRedraw);
        }
        
        /** Top right control */
        public function get r1():Number { return this._r1; }
        public function set r1(value:Number):void
        {
            this._r1 = value;
            FilterUtil.applyEffectProperty("r1", this._r1, this.effect, setRequiresRedraw);
        }
        
        /** Top middle right control */
        public function get r2():Number { return this._r2; }
        public function set r2(value:Number):void
        {
            this._r2 = value;
            FilterUtil.applyEffectProperty("r2", this._r2, this.effect, setRequiresRedraw);
        }
        
        /** Bottom middle right control */
        public function get r3():Number { return this._r3; }
        public function set r3(value:Number):void
        {
            this._r3 = value;
            FilterUtil.applyEffectProperty("r3", this._r3, this.effect, setRequiresRedraw);
        }
        
        /** Bottom right control */
        public function get r4():Number { return this._r4; }
        public function set r4(value:Number):void
        {
            this._r4 = value;
            FilterUtil.applyEffectProperty("r4", this._r4, this.effect, setRequiresRedraw);
        }
        
        /** Create effect */
        override protected function createEffect():FilterEffect 
        {
            var effect:WarpEffect = new WarpEffect();
            effect.l1 = this._l1;
            effect.l2 = this._l2;
            effect.l3 = this._l3;
            effect.l4 = this._l4;
            effect.r1 = this._r1;
            effect.r2 = this._r2;
            effect.r3 = this._r3;
            effect.r4 = this._r4;
            return effect;
        }
    }

}