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
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    import starling.textures.Texture;
	
    /**
     * Creates a pen and ink cross hatched effect. 
     * Will only work in Context3DProfile.BASELINE mode 
     * and only on square textures with Power of Two width and height
     * @author Devon O.
     */
    
    public class CrossHatchFilter extends BaseFilter
    {
        private var _vars:Vector.<Number> = new <Number>[1, .75, .50, .3465];
        private var _vars2:Vector.<Number> = new <Number>[10, 5, 0, 1];
        private var _color:Vector.<Number> = new <Number>[1, 1, 1, 1];
        
        private var _red:Number = 1.0;
        private var _green:Number = 1.0;
        private var _blue:Number = 1.0;
        
        /** Create a new CrossHatchFilter */
        public function CrossHatchFilter(){}
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
                tex ft0, v0.xy, fs0<2d, clamp, linear, mipnone>
                
                dp3 ft0.x, ft0.xyz, ft0.xyz
                sqt ft0.x, ft0.x
                
                add ft1.x, v0.x, v0.y
                div ft4.z, ft1.x, fc1.x
                frc ft4.w, ft4.z
                sub ft4.w, ft4.z, ft4.w
                mul ft4.z, fc1.x, ft4.w
                sub ft1.x, ft1.x, ft4.z
                
                sub ft1.y, v0.x, v0.y
                div ft4.z, ft1.y, fc1.x
                frc ft4.w, ft4.z
                sub ft4.w, ft4.z, ft4.w
                mul ft4.z, fc1.x, ft4.w
                sub ft1.y, ft1.y, ft4.z
                
                add ft1.z, v0.x, v0.y
                sub ft1.z, ft1.z, fc1.y
                div ft4.z, ft1.z, fc1.x
                frc ft4.w, ft4.z
                sub ft4.w, ft4.z, ft4.w
                mul ft4.z, fc1.x, ft4.w
                sub ft1.z, ft1.z, ft4.z
                
                sub ft1.w, v0.x, v0.y
                sub ft1.w, ft1.w, fc1.y
                div ft4.z, ft1.w, fc1.x
                frc ft4.w, ft4.z
                sub ft4.w, ft4.z, ft4.w
                mul ft4.z, fc1.x, ft4.w
                sub ft1.w, ft1.w, ft4.z
                
                mov ft2, fc2
                
                slt ft4.x, ft0.x, fc0.x
                seq ft4.y, ft1.x, fc1.z
                mul ft4.z, ft4.x, ft4.y
                sub ft2.xyz, ft2.xyz, ft4.zzz
                
                slt ft4.x, ft0.x, fc0.y
                seq ft4.y, ft1.y, fc1.z
                mul ft4.z, ft4.x, ft4.y
                sub ft2.xyz, ft2.xyz, ft4.zzz
                
                slt ft4.x, ft0.x, fc0.z
                seq ft4.y, ft1.z, fc1.z
                mul ft4.z, ft4.x, ft4.y
                sub ft2.xyz, ft2.xyz, ft4.zzz
                
                slt ft4.x, ft0.x, fc0.w
                seq ft4.y, ft1.w, fc1.z
                mul ft4.z, ft4.x, ft4.y
                sub ft2.xyz, ft2.xyz, ft4.zzz
                
                mov ft2.w, ft0.w
                mov oc, ft2
            ]]>
        }
		
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {	
            _vars2[0] = 10.0 / texture.width;
            _vars2[1] = 5.0 / texture.width;
            
            _color[0] = _red;
            _color[1] = _green;
            _color[2] = _blue;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _vars, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, _vars2, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, _color, 1);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            
            super.activate(pass, context, texture);
        }
		
        /** Deactivate */
        override protected function deactivate(pass:int, context:Context3D, texture:Texture):void 
        {
            context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
        }
		
        /** Red */
        public function get red():Number { return _red; }
        public function set red(value:Number):void { _red = value; }
        
        /** Green */
        public function get green():Number { return _green; }
        public function set green(value:Number):void { _green = value; }
        
        /** Blue */
        public function get blue():Number { return _blue; }
        public function set blue(value:Number):void { _blue = value; }
    }
}