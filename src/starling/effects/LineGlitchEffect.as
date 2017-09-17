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
    
    public class LineGlitchEffect extends BaseFilterEffect
    {
        private static const RADIAN:Number = Math.PI / 180;
        private var fc0:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 2.0];
        
        public var _size:Number;
        public var _angle:Number;
        public var _distance:Number;
        
        public function LineGlitchEffect() 
        {}
        
        /** Create Shaders */
        override protected function createShaders():void 
        {
            this.fragmentShader = 
            <![CDATA[
                mov ft2.x, fc0.y
                cos ft2.x, ft2.x
                mov ft2.y, fc0.y
                sin ft2.y, ft2.y
                
                mul ft2.z, v0.x, ft2.x
                mul ft1.x, v0.y, ft2.y
                add ft1.x, ft1.x, ft2.z
                
                neg ft2.y, ft2.y
                mul ft3.x, fc0.z, ft2.y
                mul ft3.y, fc0.z, ft2.x
                
                mov ft4.x, fc0.x
                mul ft4.x, ft4.x, fc0.w
                
                div ft5.x, ft1.x, ft4.x
                frc ft5.x, ft5.x
                mul ft5.x, ft5.x, ft4.x
                
                sub ft1.xy, v0.xy, ft3.xy
            ]]> + tex("ft1", "ft1.xy", 0, this.texture) +
            <![CDATA[
                
                add ft2.xy, v0.xy, ft3.xy
                
            ]]> + tex ("ft2", "ft2.xy", 0, this.texture) +
            <![CDATA[
                sge ft6, fc0.x, ft5.x
                mul ft6, ft6, ft1
                
                slt ft4, fc0.x, ft5.x
                mul ft4, ft4, ft2
                
                add ft6, ft6, ft4
                mov oc, ft6
            ]]>;
        }
        
        /** Before draw */
        override protected function beforeDraw(context:Context3D):void 
        {
            super.beforeDraw(context);
            
            // average out size
            var s:Number = (this.texture.width + this.texture.height) * .50;
            this.fc0[0] = this._size / s;
            this.fc0[1] = this._angle * RADIAN;
            this.fc0[2] = this._distance;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fc0, 1);
        }
    }

}