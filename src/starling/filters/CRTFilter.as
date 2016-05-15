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
    
import starling.effects.CRTEffect;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.rendering.FilterEffect;

/**
 * Creates a CRT screen effect
 * @author Devon O.
 */
public class CRTFilter extends FragmentFilter
{

    /**
     * Create a new CRTFilter
     * @param autoUpdate    should effect upate automatically
     */
    public function CRTFilter(autoUpdate:Boolean=true) 
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
    
    /** Red */
    public function set red(value:Number):void 
    {
        (this.effect as CRTEffect).fc3[1] = value;
        setRequiresRedraw();
    }
    public function get red():Number { return (this.effect as CRTEffect).fc3[1]; }
    
    /** Green */
    public function set green(value:Number):void
    {
        (this.effect as CRTEffect).fc3[2] = value;
        setRequiresRedraw()
    }
    public function get green():Number { return (this.effect as CRTEffect).fc3[2]; }
    
    /** Blue */
    public function set blue(value:Number):void
    {
        (this.effect as CRTEffect).fc3[3] = value;
        setRequiresRedraw();
    }
    public function get blue():Number { return (this.effect as CRTEffect).fc3[3]; }
    
    /** Brightness */
    public function set brightness(value:Number):void
    {
        (this.effect as CRTEffect).fc4[0] = value; 
        setRequiresRedraw();
    }
    public function get brightness():Number { return (this.effect as CRTEffect).fc4[0]; }
    
    /** Distortion */
    public function set distortion(value:Number):void
    {
        (this.effect as CRTEffect).fc4[1] = value;
        setRequiresRedraw();
    }
    public function get distortion():Number { return (this.effect as CRTEffect).fc4[1]; }
    
    /** Scanline Frequency */
    public function set frequency(value:Number):void
    {
        (this.effect as CRTEffect).fc4[2] = value;
        setRequiresRedraw();
    }
    public function get frequency():Number { return (this.effect as CRTEffect).fc4[2]; }
    
    /** Scanline Intensity */
    public function set intensity(value:Number):void
    {
        (this.effect as CRTEffect).fc4[3] = value; 
        setRequiresRedraw();
    }
    public function get intensity():Number { return (this.effect as CRTEffect).fc4[3]; }
    
    /** Speed */
    public function set speed(value:Number):void 
    {
        (this.effect as CRTEffect).speed = value;
        onUpdate(null);
    };
    public function get speed():Number { return (this.effect as CRTEffect).speed; }
    
    // Implementation
    
    /** Create Effect */
    override protected function createEffect():FilterEffect 
    {
        return new CRTEffect();
    }
    
    // Events
    
    /** On Update */
    public function onUpdate(e:Event):void
    {
        (this.effect as CRTEffect).time += (this.effect as CRTEffect).speed / 512;
        setRequiresRedraw();
    }
}

}