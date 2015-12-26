/**
 *	Copyright (c) 2015 Devon O. Wolfgang
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
    import starling.textures.Texture;
    
    import flash.display3D.Context3D;
    import flash.display3D.Program3D;
    
    /** 
     *  Base Filter class for FragmentFilters in OneByOneDesign Starling Filters Package.
     *  Do not instantiate directly.
     */
    public class BaseFilter extends FragmentFilter
    {
        // Shaders
        
        protected var FRAGMENT_SHADER:String;
        protected var VERTEX_SHADER:String;
        
        /** Program 3D */
        protected var program:Program3D
        
        /** @private */
        public function BaseFilter() 
        {
            super(1, 1.0);
        }
        
        /** Dispose */
        override public function dispose():void 
        {
            if (this.program != null)
                this.program.dispose();
                
            super.dispose();
        }
        
        /** Create Programs */
        override protected function createPrograms():void 
        {
            setAgal();
            this.program = assembleAgal(FRAGMENT_SHADER, VERTEX_SHADER);
        }
        
        /** Set AGAL */
        protected function setAgal():void
        {
            // Override this to assign values to FRAGMENT_SHADER and VERTEX_SHADER
        }
        
        /** Activate */
        override protected function activate(pass:int, context:Context3D, texture:Texture):void 
        {
            context.setProgram(this.program);
        }
    }

    
}