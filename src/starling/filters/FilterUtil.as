/**
 *	Copyright (c) 2017 Devon O. Wolfgang
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
    import starling.rendering.FilterEffect;
    
	/**
     * Collection of static utility methods for filter effects
     * @author Devon O.
     */
    public class FilterUtil 
    {
        /**
         * Apply property to FilterEffect
         * @param prop      Name of property to set
         * @param value     Value to set property
         * @param effect    FilterEffect containing property
         * @param update    Function to call after setting property
         */
        public static function applyEffectProperty(prop:String, value:*, effect:FilterEffect, update:Function):void
        {
            if (effect==null)
                return;
                
            try
            {
                effect[prop] = value;
                update();
            }
            catch (e:Error)
            {
                trace("[FilterUtil] ERROR: Could not set ("+prop+") to ("+value+") on ("+effect+")", e);
            }
        }
        
    }

}