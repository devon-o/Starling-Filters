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

import starling.effects.NewsprintEffect;
import starling.rendering.FilterEffect;

/**
 * Creates a funky 'news print'/half tone effect
 * @author Devon O.
 */
public class NewsprintFilter extends FragmentFilter
{
    private var _size:Number;
    private var _scale:Number;
    private var _angle:Number
    
    /**
     * Create a new Newsprint Filter
     * @param size      size of effect
     * @param scale     scale of effect
     * @param angle     angle of effect (in degrees)
     */
    public function NewsprintFilter(size:Number=120.0, scale:Number=3.0, angle:Number=0.0) 
    {
        this._size = size;
        this._scale = scale;
        this._angle = angle;
        super();
    }
    
    /** Size */
    public function set size(value:Number):void
    {
        this._size = value;
        (this.effect as NewsprintEffect).size = value;
        setRequiresRedraw();
    }
    public function get size():Number { return this._size; }
    
    /** Scale */
    public function set scale(value:Number):void
    {
        this._scale = value;
        (this.effect as NewsprintEffect).scale = value;
        setRequiresRedraw();
    }
    public function get scale():Number { return this._scale; }
    
    /** Angle */
    public function set angle(value:Number):void
    {
        this._angle = angle;
        (this.effect as NewsprintEffect).angle = value;
        setRequiresRedraw();
    }
    public function get angle():Number { return this._angle; }
    
    // Implementation
    
    /** Create effect */
    override protected function createEffect():FilterEffect 
    {
        var e:NewsprintEffect = new NewsprintEffect();
        e.size = this._size;
        e.scale = this._scale;
        e.angle = this._angle;
        return e;
    }
}

}