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
    
import starling.effects.VignetteEffect;
import starling.rendering.FilterEffect;

/**
 * Creates a Vignette effect on images with an option sepia tone
 * @author Devon O.
 */
public class VignetteFilter extends FragmentFilter
{
    private var _centerX:Number;
    private var _centerY:Number;
    private var _amount:Number;
    private var _radius:Number;
    private var _size:Number;
    private var _useSepia:Boolean;
    
    /**
     * Create a new Vignette Filter
     * @param size      Size of effect
     * @param radius    Radius of effect
     * @param amount    Amount of effect
     * @param cx        Center X of effect
     * @param cy        Center Y of effect
     * @param sepia     Should/Should not use Sepia
     */
    public function VignetteFilter(size:Number=.50, radius:Number=1.0, amount:Number=0.7, cx:Number=.50, cy:Number=.50, sepia:Boolean=false) 
    {
        this._centerX = cx;
        this._centerY = cy;
        this._amount = amount;
        this._radius = radius;
        this._size = size;
        this._useSepia = sepia;
        super();
    }
    
    /** Center X */
    public function set centerX(value:Number):void
    {
        this._centerX = value;
        (this.effect as VignetteEffect).centerX = value;
        setRequiresRedraw();
    }
    public function get centerX():Number { return this._centerX; }
    
    /** Center Y */
    public function set centerY(value:Number):void
    {
        this._centerY = value;
        (this.effect as VignetteEffect).centerY = value;
        setRequiresRedraw();
    }
    public function get centerY():Number { return this._centerY; }
    
    /** Amount */
    public function set amount(value:Number):void
    {
        this._amount = value;
        (this.effect as VignetteEffect).amount = value;
        setRequiresRedraw();
    }
    public function get amount():Number { return this._amount; }
    
    /** Radius */
    public function set radius(value:Number):void
    {
        this._radius = value;
        (this.effect as VignetteEffect).radius = value;
        setRequiresRedraw();
    }
    public function get radius():Number { return this._radius; }
    
    /** Size */
    public function set size(value:Number):void
    {
        this._size = value;
        (this.effect as VignetteEffect).size = value;
        setRequiresRedraw();
    }
    public function get size():Number { return this._size; }
    
    /** Use Sepia */
    public function set useSepia(value:Boolean):void
    {
        this._useSepia = value;
        (this.effect as VignetteEffect).useSepia = value;
        setRequiresRedraw();
    }
    public function get useSepia():Boolean { return this._useSepia; }
    
    // Implementation
    
    /** Create Effect */
    override protected function createEffect():FilterEffect 
    {
        var e:VignetteEffect = new VignetteEffect();
        e.centerX = this._centerX;
        e.centerY = this._centerY;
        e.amount = this._amount;
        e.radius = this._radius;
        e.size = this._size;
        e.useSepia = this._useSepia;
        return e;
    }
}

}