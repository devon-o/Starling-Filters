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
     * Creates glitchy line slice effect
     * @author Devon O.
     */

    public class LineGlitchFilter extends BaseFilter
    {
        
        private var vars:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 2.0];
        
        private var _size:Number;
        private var _angle:Number;
        private var _distance:Number;
        
        /**
         * Creates a new LineGlitchFilter
         * @param   size        Size of lines (roughly in pixels)
         * @param   angle       Angle of lines (in degrees)
         * @param   distance    Distance of separation effect (in texels)
         */
        public function LineGlitchFilter(size:Number=1.0, angle:Number=45.0, distance:Number=.01)
        {
            this._size = size;
            this._angle = angle;
            this._distance = distance;
        }
        
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
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
                tex ft1, ft1.xy, fs0<2d, repeat, linear, mipnone>
                
                add ft2.xy, v0.xy, ft3.xy
                tex ft2, ft2.xy, fs0<2d, repeat, linear, mipnone>
                
                sge ft6.xyz, fc0.x, ft5.x
                mul ft6.xyz, ft6.xyz, ft1.xyz
                slt ft4.xxx, fc0.x, ft5.x
                mul ft4.xxx, ft4.xxx, ft2.xyz
                add ft6.xyz, ft6.xyz, ft4.xxx
                
                mov ft6.w, ft1.w
                mov oc, ft6
            ]]>
        }
        
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            // average out size
            var s:Number = (texture.width + texture.height) * .50;
            mVars[0] = this._size / s;
            mVars[1] = this._angle * RADIAN;
            mVars[2] = this._distance;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.vars, 1);
            context.setProgram(mShaderProgram);
        }
		
        private static const RADIAN:Number = Math.PI / 180;
        
        /** Size */
        public function get size():Number { return _size; }
        public function set size(value:Number):void { _size = value; }
        
        /** Angle */
        public function get angle():Number { return _angle; }
        public function set angle(value:Number):void { _angle = value; }
        
        /** Distance */
        public function get distance():Number { return _distance; }
        public function set distance(value:Number):void { _distance = value; }
	}
}