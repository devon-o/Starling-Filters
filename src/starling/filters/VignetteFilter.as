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
    import flash.display3D.Context3DProgramType;
    import starling.textures.Texture;
	
    /**
     * Produces a vignette effect on Starling display objects.
     * @author Devon O.
     */
 
    public class VignetteFilter extends BaseFilter
    {
        
        private var mCenter:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mVars:Vector.<Number> = new <Number>[.50, .50, .50, .50];
        
        private var mSepia1:Vector.<Number> = new <Number>[0.393, 0.769, 0.189, 0.000];
        private var mSepia2:Vector.<Number> = new <Number>[0.349, 0.686, 0.168, 0.000];
        private var mSepia3:Vector.<Number> = new <Number>[0.272, 0.534, 0.131, 0.000];
        
        private var mNoSepia1:Vector.<Number> = new <Number>[1.0, 0.0, 0.0, 0.000];
        private var mNoSepia2:Vector.<Number> = new <Number>[0.0, 1.0, 0.0, 0.000];
        private var mNoSepia3:Vector.<Number> = new <Number>[0.0, 0.0, 1.0, 0.000];
        
        private var _centerX:Number;
        private var _centerY:Number;
        private var _amount:Number;
        private var _size:Number;
        private var _radius:Number;
        private var _useSepia:Boolean;
 
        /**
         * Creates a new VignetteFilter
         * @param   cx          center x of vignette relative to display object being filtered
         * @param   cy          center y of vignette relative to display object being filtered
         * @param   amount      how much should the effect be applied (smaller number is less noticable result).
         * @param   radius      the amount of inner bright light.
         * @param   size        the size of the effect
         * @param   sepia       Should image be in sepia color
         */
        public function VignetteFilter(cx:Number=0.0, cy:Number=0.0, amount:Number=0.7, radius:Number=1.0, size:Number=.40, sepia:Boolean=false)
        {
            this._centerX    = cx;
            this._centerY    = cy;
            this._amount     = amount;
            this._radius     = radius;
            this._size       = size;
            this._useSepia   = sepia;
        }
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
                sub ft0.xy, v0.xy, fc0.xy
                mov ft2.x, fc1.w
                mul ft2.x, ft2.x, fc1.z
                sub ft3.xy, ft0.xy, ft2.x   
                mul ft4.x, ft3.x, ft3.x
                mul ft4.y, ft3.y, ft3.y
                add ft4.x, ft4.x, ft4.y
                sqt ft4.x, ft4.x
                dp3 ft4.y, ft2.xx, ft2.xx
                sqt ft4.y, ft4.y
                div ft5.x, ft4.x, ft4.y
                pow ft5.y, ft5.x, fc1.y
                mul ft5.z, fc1.x, ft5.y
                sat ft5.z, ft5.z
                min ft5.z, ft5.z, fc0.z
                sub ft6, fc0.z, ft5.z
                tex ft1, v0, fs0<2d, clamp, linear, mipnone>
                
                // sepia  
                dp3 ft2.x, ft1, fc2
                dp3 ft2.y, ft1, fc3
                dp3 ft2.z, ft1, fc4
                
                mul ft6.xyz, ft6.xyz, ft2.xyz
                mov ft6.w, ft1.w
                mov oc, ft6
            ]]>
        }
        
        /** Activate */
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            var halfSize:Number = this._size * .50;
            var cx:Number = this._centerX / texture.width - halfSize;
            var cy:Number = this._centerY / texture.height - halfSize;
            mCenter[0] = cx;
            mCenter[1] = cy;
            
            mVars[0] = this._amount;
            mVars[1] = this._radius;
            mVars[3] = this._size;
            
            // to sepia or not to sepia
            var s1:Vector.<Number> = useSepia ? mSepia1 : mNoSepia1;
            var s2:Vector.<Number> = useSepia ? mSepia2 : mNoSepia2;
            var s3:Vector.<Number> = useSepia ? mSepia3 : mNoSepia3;
            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mCenter, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mVars,   1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, s1,      1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, s2,      1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, s3,      1);
            
            super.activate(pass, context, texture);
        }
        
        /** Center X position of effect relative to Display Object being filtered */
        public function get centerX():Number { return this._centerX; }
        public function set centerX(value:Number):void { this._centerX = value; }
        
        /** Center Y position of effect relative to Display Object being filtered */
        public function get centerY():Number { return this._centerY; }
        public function set centerY(value:Number):void { this._centerY = value; }
        
        /** Amount of effect (smaller value is less noticeable) */
        public function get amount():Number { return this._amount; }
        public function set amount(value:Number):void { this._amount = value; }
        
        /** Size of effect */
        public function get size():Number { return this._size; }
        public function set size(value:Number):void { this._size = value; }
        
        /** Radius of vignette center */
        public function get radius():Number { return this._radius; }
        public function set radius(value:Number):void { this._radius = value; }
        
        /** Apply a sepia color to Display Object being filtered */
        public function get useSepia():Boolean { return this._useSepia; }
        public function set useSepia(value:Boolean):void { this._useSepia = value; }
    }
}