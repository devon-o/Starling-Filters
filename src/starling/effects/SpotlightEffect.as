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

package starling.effects 
{
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    
    public class SpotlightEffect extends BaseFilterEffect
    {
        
        private var center:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var vars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var lightColor:Vector.<Number> = new <Number>[1, 1, 1, 0];
        
        // Shader constants
        public var _x:Number;
        public var _y:Number;
        public var _corona:Number;
        public var _radius:Number;
        public var _red:Number=1.0;
        public var _green:Number=1.0;
        public var _blue:Number=1.0;
        
        public function SpotlightEffect() 
        {}
        
        /** Create Shaders */
        override protected function createShaders():void 
        {
            this.fragmentShader = 
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
        
        /** Before draw */
        override protected function beforeDraw(context:Context3D):void 
        {
            super.beforeDraw(context);
            
            this.center[0] = (this._x * this.texture.width) / this.texture.root.width;
            this.center[1] = (this._y * this.texture.height) / this.texture.root.height;
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
        }
    }

}