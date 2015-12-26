/**
 *	Copyright (c) 2014 Devon O. Wolfgang
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
     * Produces a vintage Lomo camera type hue shift effect
     * @author Devon O.
     */
    public class LomoFilter extends BaseFilter
    {
        
        private var fc0:Vector.<Number> = new <Number>[0.50, 1.0, 0.25, 0.99609375];
        private var fc1:Vector.<Number> = new <Number>[2.0, 0.14453125, 1, 1];
        
        private var _amount:Number;
        
        /**
         * Create a new Lomo Filter
         * @param amount    Amount of filter to apply (between 0 and 1 is good)
         */
        public function LomoFilter(amount:Number=.75)
        {
            this._amount = amount;
        }
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
            
            tex ft0, v0, fs0<2d, clamp, linear, mipnone>
            
            mov ft1, ft0
            
            slt ft2.x, ft1.x, fc0.x
            mul ft2.x, ft2.x, ft1.x
            sge ft2.y, ft1.x, fc0.x
            sub ft2.z, fc0.y, ft1.x
            mul ft2.y, ft2.y, ft2.z
            add ft2.x, ft2.x, ft2.y
            
            mul ft2.x, ft2.x, ft2.x
            mul ft2.x, ft2.x, ft2.x
            div ft2.x, ft2.x, fc0.z
            div ft2.x, ft2.x, fc0.y
            
            slt ft3.x, ft0.x, fc0.x
            mul ft3.x, ft3.x, ft2.x
            sge ft3.y, ft0.x, fc0.x
            sub ft3.z, fc0.w, ft2.x
            mul ft3.y, ft3.y, ft3.z
            add ft3.x, ft3.x, ft3.y
            
            // RED
            sat ft1.x, ft3.x
            
            slt ft2.x, ft0.y, fc0.x
            mul ft2.x, ft2.x, ft0.y
            sge ft2.y, ft0.y, fc0.x
            sub ft2.z, fc0.y, ft0.y
            mul ft2.y, ft2.y, ft2.z
            add ft2.x, ft2.x, ft2.y
            
            mul ft2.x, ft2.x, ft2.x
            div ft2.x, ft2.x, fc0.x
            
            slt ft3.x, ft0.y, fc0.x
            mul ft3.x, ft3.x, ft2.x
            sge ft3.y, ft0.y, fc0.x
            sub ft3.z, fc0.w, ft2.x
            mul ft3.y, ft3.y, ft3.z
            add ft3.x, ft3.x, ft3.y
            
            // GREEN
            sat ft1.y, ft3.x
            
            div ft3.x, ft0.z, fc1.x
            add ft3.x, ft3.x, fc1.y
            
            // BLUE
            sat ft1.z, ft3.x
            
            // mix output ft0, ft1, amount
            sub ft6, ft1, ft0
            mul ft6, ft6, fc1.z
            add oc, ft6, ft0
            
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            fc1[2] = this._amount;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc0, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fc1, 1);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            
            super.activate(pass, context, texture);
        }
        
        /** Deactivate */
        override protected function deactivate(pass:int, context:Context3D, texture:Texture):void 
        {
            context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
        }
        
        /** Amount of effect (between 0 and 1 is generally good) */
        public function get amount():Number { return _amount; }
        public function set amount(value:Number):void { _amount = value; }
    }
}