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
    
import starling.effects.KaleidoscopeEffect;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.rendering.FilterEffect;

/**
 * Creates a Kaleidoscope Effect
 * @author Devon O.
 */
public class KaleidoscopeFilter extends FragmentFilter
{

    /**
     * Create a new CRTFilter
     * @param autoUpdate    should effect upate automatically
     */
    public function KaleidoscopeFilter(autoUpdate:Boolean=false) 
    {
        super();
        this.autoUpdate = autoUpdate;
    }
    
    /** Dispose */
    override public function dispose():void 
    {
        removeEventListener(Event.ENTER_FRAME, onUpdate);
        super.dispose();
    }
    
    /** Auto Update */
    public function set autoUpdate(value:Boolean):void
    {
        if (value) 
            addEventListener(Event.ENTER_FRAME, onUpdate);
        else 
            removeEventListener(Event.ENTER_FRAME, onUpdate);
        
    }
    public function get autoUpdate():Boolean { return hasEventListener(EnterFrameEvent.ENTER_FRAME); }
    
    
    /** Levels */
    public function set levels(value:Number):void 
    {
        (this.effect as KaleidoscopeEffect).levels = value;
        setRequiresRedraw();
    };
    public function get levels():Number { return (this.effect as KaleidoscopeEffect).levels; }
    
    /** Speed */
    public function set speed(value:Number):void 
    {
        (this.effect as KaleidoscopeEffect).speed = value;
        setRequiresRedraw();
    };
    public function get speed():Number { return (this.effect as KaleidoscopeEffect).speed; }
    
    /** Time */
    public function set time(value:Number):void
    {
        (this.effect as KaleidoscopeEffect).time = value;
        setRequiresRedraw();
    }
    public function get time():Number { return (this.effect as KaleidoscopeEffect).time; }
    
    // Implementation
    
    /** Create Effect */
    override protected function createEffect():FilterEffect 
    {
        return new KaleidoscopeEffect();
    }
    
    // Events
    
    /** On Update */
    public function onUpdate(e:Event):void
    {
        time += (this.effect as KaleidoscopeEffect).speed / 512;
    }
    
}

}