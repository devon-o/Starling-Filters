/**
 *	Copyright (c) 2012 Devon O. Wolfgang
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
    import flash.display3D.Program3D;
    import starling.textures.Texture;
	
    /**
     * Produces a spotlight or vignette like effect on Starling display objects.
     * @author Devon O.
     */
 
    public class SpotlightFilter extends FragmentFilter
    {
        private static const FRAGMENT_SHADER:String =
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
            mul ft6, ft6, ft1
            mov ft6.w, ft1.w
            mov oc, ft6
        ]]>
	
        private var mCenter:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private var mVars:Vector.<Number> = new <Number>[.50, .50, .50, .50];
        private var mShaderProgram:Program3D;

        private var mCenterX:Number;
        private var mCenterY:Number;
        private var mAmount:Number;
        private var mSize:Number;
        private var mRadius:Number;
        private var mUseFlicker:Boolean;
 
        /**
         * Creates a new SpotlightFilter
         * @param   cx          center x of spotlight. should be relative to display object being filtered
         * @param   cy          center y of spotlight. should be relative to display object being filtered
         * @param   amount      how much should the effect be applied (smaller number is less noticable result).
         * @param   radius      the amount of inner bright light.
         * @param   size        the size of the effect
         * @param   useFlicker  creates a flickering light effect
         */
        public function SpotlightFilter(cx:Number=0.0, cy:Number=0.0, amount:Number=1.0, radius:Number=.25, size:Number=.25, useFlicker:Boolean=false)
        {
            mCenterX	= cx;
            mCenterY	= cy;
            mAmount		= amount;
            mRadius		= radius;
            mSize		= size;
            mUseFlicker	= useFlicker;
        }
 
        public override function dispose():void
        {
            if (mShaderProgram) mShaderProgram.dispose();
            super.dispose();
        }
 
        protected override function createPrograms():void
        {
            mShaderProgram = assembleAgal(FRAGMENT_SHADER);
        }
 
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {
            var halfSize:Number = mSize * .50;
            var cx:Number = mCenterX / texture.width - halfSize;
            var cy:Number = mCenterY / texture.height - halfSize;
            mCenter[0] = cx;
            mCenter[1] = cy;

            var radius:Number = mUseFlicker ? mRadius * Math.random() : mRadius;

            mVars[0] = mAmount;
            mVars[1] = radius;
            mVars[3] = mSize;

            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mCenter, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mVars,   1);
            context.setProgram(mShaderProgram);
        }
 
        public function get centerX():Number { return mCenterX; }
        public function set centerX(value:Number):void { mCenterX = value; }

        public function get centerY():Number { return mCenterY; }
        public function set centerY(value:Number):void { mCenterY = value; }

        public function get amount():Number { return mAmount; }
        public function set amount(value:Number):void { mAmount = value; }

        public function get size():Number { return mSize; }
        public function set size(value:Number):void { mSize = value; }

        public function get radius():Number { return mRadius; }
        public function set radius(value:Number):void { mRadius = value; }

        public function get useFlicker():Boolean { return mUseFlicker; }
        public function set useFlicker(value:Boolean):void { mUseFlicker = value; }
    }
}