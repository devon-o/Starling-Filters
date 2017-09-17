/**
 *	Copyright (c) 2017 Devon O. Wolfgang & William Erndt
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
    
    public class PixelateEffect extends BaseFilterEffect
    {
        private var fc0:Vector.<Number> = new <Number>[1, 1, 1, 1];
        
        public var _sizeX:int;
        public var _sizeY:int;
        
        public function PixelateEffect() 
        {}
        
        /** Create Shaders */
        override protected function createShaders():void 
        {
            this.fragmentShader = 
            <![CDATA[
                div ft0.xy, v0.xy, fc0.xy
                frc ft1.xy, ft0.xy
                sub ft0.xy, ft0.xy, ft1.xy
                mul ft0.xy, ft0.xy, fc0.xy
                add ft0.xy, ft0.xy, fc0.zw
            ]]> + tex("oc", "ft0.xy", 0, this.texture);
        }
        
        /** Before draw */
        override protected function beforeDraw(context:Context3D):void 
        {
            super.beforeDraw(context);
            
            this.fc0[0] = this._sizeX / this.texture.width;
            this.fc0[1] = this._sizeY / this.texture.height;
            this.fc0[2] = this.fc0[0] * .50;
            this.fc0[3] = this.fc0[1] * .50;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fc0, 1);
        }
    }

}