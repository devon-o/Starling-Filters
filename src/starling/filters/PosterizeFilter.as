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
     * Creates a posterization/quantization effect
     * @author Devon O.
     */
    
    public class PosterizeFilter extends BaseFilter
    {
        private var vars:Vector.<Number> = new <Number>[1, 1, 1, 1];
        
        private var _numColors:int;
        private var _gamma:Number;
        
        /**
         * 
         * @param	numColors
         * @param	gamma
         */
        public function PosterizeFilter(numColors:int=8, gamma:Number=.60)
        {
            this._numColors = numColors;
            this._gamma = gamma;
        }
        
        /** Set AGAL */
        protected override function setAgal():void
        {
            FRAGMENT_SHADER =
            <![CDATA[
                tex ft0, v0, fs0<2d, clamp, linear, mipnone>
                pow ft0.xyz, ft0.xyz, fc0.yyy
                mul ft0.xyz, ft0.xyz, fc0.xxx
                frc ft1.xyz, ft0.xyz
                sub ft1.xyz, ft0.xyz, ft1.xyz
                div ft0.xyz, ft1.xyz, fc0.xxx
                pow ft0.xyz, ft0.xyz, fc0.zzz
                mov oc, ft0
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            this.vars[0] = this._numColors;
            this.vars[1] = this._gamma;
            this.vars[2] = 1 / this._gamma;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.vars, 1);
            super.activate(pass, context, texture);
        }
        
        /** Number of Colors */
        public function get numColors():int { return _numColors; }
        public function set numColors(value:int):void { _numColors = value; }
        
        /** Gamma */
        public function get gamma():Number { return _gamma; }
        public function set gamma(value:Number):void { _gamma = value; }
    }
}