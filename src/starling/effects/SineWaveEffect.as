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
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    
    public class SineWaveEffect extends BaseFilterEffect
    {
        private var fc0:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var fc1:Vector.<Number> = new <Number>[1, 1, 1, 1];
        
        public var _amplitude:Number
        public var _ticker:Number;
        public var _frequency:Number;
        public var _isHorizontal:Boolean;
        
        public function SineWaveEffect() 
        {}
        
        /** Create Shaders */
        override protected function createShaders():void 
        {
            this.fragmentShader = 
            <![CDATA[
                mov ft0, v0
                sub ft1.xy, v0.xy, fc0.zz
                mul ft1.xy, ft1.xy, fc0.ww
                sin ft1.xy, ft1.xy
                mul ft1.xy, ft1.xy, fc0.yy
                
                // horizontal
                mul ft2.x, ft1.y, fc1.x
                add ft0.x, ft0.x, ft2.x
                
                // vertical
                mul ft2.x, ft1.x, fc1.y
                add ft0.y, ft0.y, ft2.x
            ]]> + tex("oc", "ft0", 0, this.texture);
        }
        
        /** Before draw */
        override protected function beforeDraw(context:Context3D):void 
        {
            super.beforeDraw(context);
            
            this.fc0[1] = this._amplitude / this.texture.height;
            this.fc0[2] = this._ticker;
            this.fc0[3] = this._frequency;
            
            this.fc1[0] = int(this._isHorizontal);
            this.fc1[1] = int(!this._isHorizontal);
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fc0, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.fc1, 1);
        }
    }

}