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
	import flash.display3D.Program3D;
	import starling.textures.Texture;
    
	/**
	 * Creates a 'God Rays' / fake volumetric light filter effect.
	 * Only use with Context3DProfile.BASELINE (not compatible with constrained profile)
	 * @author Devon O.
	 */
	
    public class GodRaysFilter extends FragmentFilter
    {
        
		private var mShaderProgram:Program3D;
		
		private var mNumSteps:int;
		
		// lightx, lighty
		private var mLightPos:Vector.<Number> = Vector.<Number>( [ .5, .5, 1, 1 ]);
		
		// numsamples, density, numsamples * density, 1 / numsamples * density
		private var mVars1:Vector.<Number> = Vector.<Number>( [ 1, 1, 1, 1 ]);
		
		// weight, decay, exposure
		private var mVars2:Vector.<Number> = Vector.<Number>( [ 1, 1, 1, 1 ]);
		
		
		private var mLightX:Number 		= 0.0;
		private var mLightY:Number		= 0.0;
		private var mWeight:Number		= .50;
		private var mDecay:Number		= .87;
		private var mExposure:Number	= .35;
		private var mDensity:Number		= 2.0;
        
		/**
		 * 
		 * @param	numSteps	Number of samples to take along the ray path (maximum 32 with Context3DProfile.BASELINE)
		 */
        public function GodRaysFilter(numSteps:int=30)
        {
			mNumSteps = numSteps;
        }
        
        public override function dispose():void
        {
            if (mShaderProgram) mShaderProgram.dispose();
            super.dispose();
        }
        
        protected override function createPrograms():void
        {
            var frag:String = "";
			
			// Calculate vector from pixel to light source in screen space.
			frag += "sub ft0.xy, v0.xy, fc0.xy \n";
			
			// Divide by number of samples and scale by control factor.  
			frag += "mul ft0.xy, ft0.xy, fc1.ww \n";
			
			// Store initial sample.  
			frag += "tex ft1,  v0, fs0 <2d, clamp, linear, mipnone> \n";
			
			// Set up illumination decay factor.  
			frag += "mov ft2.x, fc0.w \n";
			
			// Store the texcoords
			frag += "mov ft4.xy, v0.xy \n";
			
			for (var i:int = 0; i < mNumSteps; i++)
			{
				// Step sample location along ray. 
				frag += "sub ft4.xy, ft4.xy, ft0.xy \n";
				
				// Retrieve sample at new location.  
				frag += "tex ft3,  ft4.xy, fs0 <2d, clamp, linear, mipnone> \n";
				
				// Apply sample attenuation scale/decay factors.  
				frag += "mul ft2.y, ft2.x, fc2.x \n";
				frag += "mul ft3.xyz, ft3.xyz, ft2.yyy \n";
				
				// Accumulate combined color.  
				frag += "add ft1.xyz, ft1.xyz, ft3.xyz \n";
				
				// Update exponential decay factor.  
				frag += "mul ft2.x, ft2.x, fc2.y \n";
			}
			
			// Output final color with a further scale control factor. 
			frag += "mul ft1.xyz, ft1.xyz, fc2.zzz \n";
			frag += "mov oc, ft1";
				
            mShaderProgram = assembleAgal(frag);
        }
        
        protected override function activate(pass:int, context:Context3D, texture:Texture):void
        {		
			// light position
			mLightPos[0] = mLightX / texture.width;
			mLightPos[1] = mLightY / texture.height;
			
			// numsamples, density, numsamples * density, 1 / numsamples * density
			mVars1[0] = mNumSteps;
			mVars1[1] = mDensity;
			mVars1[2] = mNumSteps * mVars1[1];
			mVars1[3] = 1 / mVars1[2];
			
			// weight, decay, exposure
			mVars2[0] = mWeight;
			mVars2[1] = mDecay;
			mVars2[2] = mExposure;
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mLightPos, 	1 );	
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mVars1,  	1 );
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, mVars2,  	1 );
			
            context.setProgram(mShaderProgram);
			
        }
		
		public function set x(value:Number):void { mLightX = value; }
		public function get x():Number { return mLightX; }
		
		public function set y(value:Number):void { mLightY = value; }
		public function get y():Number { return mLightY; }
		
		public function set decay(value:Number):void { mDecay = value; }
		public function get decay():Number { return mDecay; }
		
		public function set exposure(value:Number):void { mExposure = value; }
		public function get exposure():Number { return mExposure; }
		
		public function set weight(value:Number):void { mWeight = value; }
		public function get weight():Number { return mWeight; }
		
		public function set density(value:Number):void { mDensity = value; }
		public function get density():Number { return mDensity; }
		
    }
}