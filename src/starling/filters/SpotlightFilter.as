/**
 *	Copyright (c) 2013 Devon O. Wolfgang
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
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import starling.textures.Texture;
	
    /**
     * Produces a spotlight or vignette like effect on Starling display objects.
     * @author Devon O.
     */
 
    public class SpotlightFilter extends BaseFilter
    {
		
        private var center:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var vars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var lightColor:Vector.<Number> = new <Number>[1, 1, 1, 0];
        
        private var _x:Number;
        private var _y:Number;
        private var _corona:Number;
        private var _radius:Number;
        private var _red:Number=1.0;
        private var _green:Number=1.0;
        private var _blue:Number=1.0;
		
        /**
         * Creates a new Spotlight2Filter
         * @param   x       x position
         * @param   y       y position
         * @param   radius  radius of spotlight (0 - 1)
         * @param   corona  "softness" of spotlight
         */
        public function SpotlightFilter(x:Number=0.0, y:Number=0.0, radius:Number=.25, corona:Number=2.0)
        {
            this._x      = x;
            this._y      = y;
            this._radius = radius;
            this._corona = corona;
        }
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
                tex ft1, v0, fs0<2d, clamp, linear, mipnone>
                sub ft2.x, v0.x, fc0.x
                mul ft2.x, ft2.x, ft2.x
                div ft2.x, ft2.x, fc1.w
                sub ft2.y, v0.y, fc0.y
                mul ft2.y, ft2.y, ft2.y
                mul ft2.y, ft2.y, fc1.w
                add ft2.x, ft2.x, ft2.y
                sqt ft4.x, ft2.x
                mov ft3.x, fc1.x
                add ft3.x, ft3.x, fc0.w
                div ft3.x, fc0.z, ft3.x
                div ft4.x, ft4.x, ft3.x
                sub ft4.x, fc1.x, ft4.x
                add ft4.x, ft4.x, fc0.w
                min ft4.x, ft4.x, fc1.x
                mul ft6.xyz, ft1.xyz, ft4.xxx
                mul ft6.xyz, ft6.xyz, fc2
                mov ft6.w, ft1.w
                mov oc, ft6
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            this.center[0] = this._x / texture.width;
            this.center[1] = this._y / texture.height;
            this.center[2] = this._radius;
            this.center[3] = this._corona;
            
            // texture ratio to produce rounded lights on rectangular textures
            this.vars[3] = texture.height / texture.width;
            
            this.lightColor[0] = this._red;
            this.lightColor[1] = this._green;
            this.lightColor[2] = this._blue;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.center, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.vars,   1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.lightColor,   1);
            
            super.activate(pass, context, texture);
        }
        
        /** X Position */
        public function get x():Number { return this._x; }
        public function set x(value:Number):void { this._x = value; }
        
        /** Y Position */
        public function get y():Number { return this._y; }
        public function set y(value:Number):void { this._y = value; }
        
        /** Corona */
        public function get corona():Number { return this._corona; }
        public function set corona(value:Number):void { this._corona = value; }
        
        /** Radius */
        public function get radius():Number { return this._radius; }
        public function set radius(value:Number):void { this._radius = value; }
        
        /** Red */
        public function get red():Number { return this._red; }
        public function set red(value:Number):void { this._red = value; }
        
        /** Green */
        public function get green():Number { return this._green; }
        public function set green(value:Number):void { this._green = value; }
        
        /** Blue */
        public function get blue():Number { return this._blue; }
        public function set blue(value:Number):void { this._blue = value; }
    }
}