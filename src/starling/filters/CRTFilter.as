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
     * Creates a CRT screen effect
     * @author Devon O.
     */
	public class CRTFilter extends BaseFilter
	{
        private var fc0:Vector.<Number> = new <Number>[0.0, .25, .50, 1.0];
        private var fc1:Vector.<Number> = new <Number>[Math.sqrt(.50), 2.5, 1.55, Math.PI];
        private var fc2:Vector.<Number> = new <Number>[2.2, 1.4, 2.0, .2];
        private var fc3:Vector.<Number> = new <Number>[3.5, 0.7, 1, 0.7];
        private var fc4:Vector.<Number> = new <Number>[1, 0, 256, 4];
        private var fc5:Vector.<Number> = new <Number>[1, 1, 1, 1];
        
        private var time:Number = 0.0;
        private var _speed:Number = 10.0;
		
        /** Create a new CRTFilter */
        public function CRTFilter()
        {}
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
                mov ft0.xy, v0.xy
                sub ft0.xy, v0.xy, fc0.zz
                
                mov ft0.z, fc0.x
                dp3 ft0.w, ft0.xyz, ft0.xyz
                mul ft0.z, ft0.w, fc4.y
                
                add ft0.w, fc0.w, ft0.z
                mul ft0.w, ft0.w, ft0.z
                mul ft0.xy, ft0.ww, ft0.xy
                add ft0.xy, ft0.xy, v0.xy
                
                tex ft2, ft0.xy, fs0<2d, clamp, nearest, mipnone>
                
                sge ft3.x, ft0.x, fc0.x
                sge ft3.y, ft0.y, fc0.x
                slt ft3.z, ft0.x, fc0.w
                slt ft3.w, ft0.y, fc0.w
                mul ft3.x, ft3.x, ft3.y
                mul ft3.x, ft3.x, ft3.z
                mul ft3.x, ft3.x, ft3.w
                
                max ft4.x, ft2.x, ft2.y
                max ft4.x, ft4.x, ft2.z
                min ft4.y, ft2.x, ft2.y
                min ft4.y, ft4.y, ft2.z
                div ft4.y, ft4.y, fc2.z
                add ft4.x, ft4.x, ft4.y
                mov ft4.xyzw, ft4.xxxx
                mul ft4.xyzw, ft4.xyzw, ft3.xxxx
                
                mov ft2.x, ft0.y
                mul ft2.x, ft2.x, fc1.w
                mul ft2.x, ft2.x, fc4.z
                sin ft2.x, ft2.x
                mul ft2.x, ft2.x, fc0.y
                sat ft2.x, ft2.x
                mul ft2.x, ft2.x, fc0.y
                mul ft2.x, ft2.x, fc4.w
                add ft2.x, ft2.x, fc0.w
                
                mov ft2.y, fc0.w
                
                mov ft2.z, fc5.x
                mul ft2.z, ft2.z, fc0.z
                add ft2.z, ft2.z, ft0.y
                mul ft2.z, ft2.z, fc1.w
                mul ft2.z, ft2.z, fc3.x
                sin ft2.z, ft2.z
                mul ft2.z, ft2.z, fc2.w
                add ft2.y, ft2.y, ft2.z
                
                add ft2.z, ft0.y, fc5.x
                mul ft2.z, ft2.z, fc1.w
                mul ft2.z, ft2.z, fc2.z
                sin ft2.z, ft2.z
                mul ft2.z, ft2.z, fc2.w
                add ft2.y, ft2.y, ft2.z
                
                mul ft2.y, ft2.y, fc4.x
                
                mul ft0.xyz, ft4.xyz, ft3.xxx
                mul ft0.xyz, ft0.xyz, fc3.yzw
                mul ft0.xyz, ft0.xyz, ft2.xxx
                mul ft0.xyz, ft0.xyz, ft2.yyy
                mov ft0.w, fc0.w
                mov oc, ft0
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            this.time += this._speed/512;
            fc5[0] = time;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fc0, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.fc1, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.fc2, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, this.fc3, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, this.fc4, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, this.fc5, 1);
            
            super.activate(pass, context, texture);
        }
		
        /** Red */
        public function set red(value:Number):void { this.fc3[1] = value; }
        public function get red():Number { return this.fc3[1]; }
        
        /** Green */
        public function set green(value:Number):void { this.fc3[2] = value; }
        public function get green():Number { return this.fc3[2]; }
        
        /** Blue */
        public function set blue(value:Number):void { this.fc3[3] = value; }
        public function get blue():Number { return this.fc3[3]; }
        
        /** Brightness */
        public function set brightness(value:Number):void { this.fc4[0] = value; }
        public function get brightness():Number { return this.fc4[0]; }
        
        /** Distortion */
        public function set distortion(value:Number):void { this.fc4[1] = value; }
        public function get distortion():Number { return this.fc4[1]; }
        
        /** Scanline Frequency */
        public function set frequency(value:Number):void { this.fc4[2] = value; }
        public function get frequency():Number { return this.fc4[2]; }
        
        /** Scanline Intensity */
        public function set intensity(value:Number):void { this.fc4[3] = value; }
        public function get intensity():Number { return this.fc4[3]; }
        
        /** Speed */
        public function set speed(value:Number):void { this._speed = value; };
        public function get speed():Number { return this._speed; }
    }
}