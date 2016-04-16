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

import starling.effects.FlashlightEffect;
import starling.rendering.FilterEffect;

/**
 * Creates Flashlight effect
 * @author Devon O.
 */
public class FlashlightFilter extends FragmentFilter
{
    private var _x:Number;
    private var _y:Number;
    private var _angle:Number;
    
    /**
     * Create a new Flashlight Filter
     * @param x     x position
     * @param y     y position
     * @param angle angle of light cone
     */
    public function FlashlightFilter(x:Number=0.0, y:Number=0.0, angle:Number=0.0) 
    {
        this._x = x;
        this._y = y;
        this._angle = angle;
        
        super();
    }
    
    /** X position */
    public function set x(value:Number):void 
    {
        this._x = value;
        (this.effect as FlashlightEffect).x = value;
        setRequiresRedraw();
    }
    public function get x():Number { return this._x; }
    
    /** Y position */
    public function set y(value:Number):void 
    {
        this._y = value;
        (this.effect as FlashlightEffect).y = value;
        setRequiresRedraw();
    }
    public function get y():Number { return this._y; }
    
    /** Angle */
    public function set angle(value:Number):void 
    {
        this._angle = value;
        (this.effect as FlashlightEffect).angle = value;
        setRequiresRedraw();
    }
    public function get angle():Number { return this._angle; }
    
    /** Outer cone */
    public function set outerCone(value:Number):void 
    {
        (this.effect as FlashlightEffect).outerCone = value;
        setRequiresRedraw();
    }
    public function get outerCone():Number { return (this.effect as FlashlightEffect).outerCone; }
    
    /** Inner cone */
    public function set innerCone(value:Number):void 
    {
        (this.effect as FlashlightEffect).innerCone = value;
        setRequiresRedraw();
    }
    public function get innerCone():Number { return (this.effect as FlashlightEffect).innerCone; }
    
    /** Azimuth */
    public function set azimuth(value:Number):void 
    {
        (this.effect as FlashlightEffect).azimuth = value;
        setRequiresRedraw();
    }
    public function get azimuth():Number { return (this.effect as FlashlightEffect).azimuth; }
    
    /** Attenuation 1 */
    public function set attenuation1(value:Number):void 
    {
        (this.effect as FlashlightEffect).a1 = value;
        setRequiresRedraw();
    }
    public function get attenuation1():Number { return (this.effect as FlashlightEffect).a1; }
    
    /** Attenuation 2 */
    public function set attenuation2(value:Number):void 
    {
        (this.effect as FlashlightEffect).a2 = value;
        setRequiresRedraw();
    }
    public function get attenuation2():Number { return (this.effect as FlashlightEffect).a2; }
    
    /** Attenuation 3 */
    public function set attenuation3(value:Number):void 
    {
        (this.effect as FlashlightEffect).a3 = value;
        setRequiresRedraw();
    }
    public function get attenuation3():Number { return (this.effect as FlashlightEffect).a3; }
    
    /** Red */
    public function set red(value:Number):void 
    {
        (this.effect as FlashlightEffect).r = value;
        setRequiresRedraw();
    }
    public function get red():Number { return (this.effect as FlashlightEffect).r; }
    
    /** Green */
    public function set green(value:Number):void 
    {
        (this.effect as FlashlightEffect).g = value;
        setRequiresRedraw();
    }
    public function get green():Number { return (this.effect as FlashlightEffect).g ; }
    
    /** Blue */
    public function set blue(value:Number):void 
    {
        (this.effect as FlashlightEffect).b = value;
        setRequiresRedraw();
    }
    public function get blue():Number { return (this.effect as FlashlightEffect).b; }
    
    // Implementation
    
    /** Create Effect */
    override protected function createEffect():FilterEffect 
    {
        var e:FlashlightEffect = new FlashlightEffect();
        e.x = this._x;
        e.y = this._y;
        e.angle = this._angle;
        return e;
    }
}

}