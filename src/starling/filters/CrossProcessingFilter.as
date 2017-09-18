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

import starling.effects.CrossProcessEffect;
import starling.rendering.FilterEffect;
    
/**
 * Performs a color cross process effect
 * @author Devon O.
 */

public class CrossProcessingFilter extends FragmentFilter
{
    
    private var _amount:Number;
    
    /** Create a new CrossProcessing Filter */
    public function CrossProcessingFilter(amount:Number=1.0) 
    {
        this._amount = amount;
        super();
    }
    
    /** Amount */
    public function set amount(value:Number):void
    {
        this._amount = value;
        FilterUtil.applyEffectProperty("amount", this._amount, this.effect, setRequiresRedraw);
    }
    public function get amount():Number { return this._amount; }
    
    // Implementation
    
    /** Create effect */
    override protected function createEffect():FilterEffect 
    {
        var e:CrossProcessEffect = new CrossProcessEffect();
        e.amount=this._amount;
        return e;
    }
    
}

}