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
    
    public class WarpEffect extends BaseFilterEffect
    {
        private var mLeft:Vector.<Number> = new <Number>[0.0, 0.0, 0.0, 0.0];
        private var mRight:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        private var mVars:Vector.<Number> = new <Number>[1.0, 2.0, 3.0, 0.0];
        
        public var l1:Number;
        public var l2:Number;
        public var l3:Number;
        public var l4:Number;
        public var r1:Number;
        public var r2:Number;
        public var r3:Number;
        public var r4:Number;
        
        public function WarpEffect() 
        {}
        
        /** Create Shaders */
        override protected function createShaders():void 
        {
            this.fragmentShader = 
            <![CDATA[
                mov ft0.xy, v0.xy
                mov ft1.x, fc2.x
                sub ft1.x, ft1.x, ft0.y
                pow ft1.x, ft1.x, fc2.z
                mov ft1.y, fc2.x
                sub ft1.y, ft1.y, ft0.y
                pow ft1.y, ft1.y, fc2.y
                mul ft1.y, ft1.y, fc2.z
                mul ft1.y, ft1.y, ft0.y
                mov ft1.z, fc2.x
                sub ft1.z, ft1.z, ft0.y
                mul ft1.z, ft1.z, fc2.z
                mul ft1.z, ft1.z, ft0.y
                mul ft1.z, ft1.z, ft0.y
                pow ft1.w, ft0.y, fc2.z
                mul ft2.x, ft1.x, fc0.x
                mul ft2.y, ft1.y, fc0.y
                mul ft2.z, ft1.z, fc0.z
                mul ft2.w, ft1.w, fc0.w
                add ft2.x, ft2.x, ft2.y
                add ft2.x, ft2.x, ft2.z
                add ft2.x, ft2.x, ft2.w
                mul ft3.x, ft1.x, fc1.x
                mul ft3.y, ft1.y, fc1.y
                mul ft3.z, ft1.z, fc1.z
                mul ft3.w, ft1.w, fc1.w
                add ft3.x, ft3.x, ft3.y
                add ft3.x, ft3.x, ft3.z
                add ft3.x, ft3.x, ft3.w
                sub ft4.x, ft0.x, ft2.x
                sub ft4.y, ft3.x, ft2.x
                div ft4.x, ft4.x, ft4.y
                mov ft4.y, ft0.y
            ]]> +  tex("ft5", "ft4.xy", 0, this.texture) +
            <![CDATA[
                
                // Kill off pixels out of range
                sge ft6.x, ft0.x, ft2.x
                sub ft6.w, ft6.x, fc2.x
                kil ft6.w
                
                slt ft6.y, ft0.x, ft3.x
                sub ft6.w, ft6.y, fc2.x
                kil ft6.w
                
                mov oc, ft5
            ]]>
        }
        
        /** Before draw */
        override protected function beforeDraw(context:Context3D):void 
        {
            super.beforeDraw(context);
            
            this.mLeft[0] = this.l1;
            this.mLeft[1] = this.l2;
            this.mLeft[2] = this.l3;
            this.mLeft[3] = this.l4;
            
            this.mRight[0] = this.r1;
            this.mRight[1] = this.r2;
            this.mRight[2] = this.r3;
            this.mRight[3] = this.r4;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mLeft,  1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mRight, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, mVars,  1);
        }
    }

}