/**
 *	Copyright (c) 2016 Devon O. Wolfgang
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
import flash.display3D.Context3DProgramType;
import starling.effects.BaseFilterEffect;

public class KaleidoscopeEffect extends BaseFilterEffect
{
    public var time:Number=0.0;
    public var speed:Number = 10.0;
    public var levels:Number = 3.50;
    
    public var fc0:Vector.<Number> = new <Number>[1, 0, Math.PI, 2 * Math.PI];
    public var fc1:Vector.<Number> = new <Number>[1e-10, Math.PI / 2, 0, 4];
    public var fc2:Vector.<Number> = new <Number>[-1, 1, Math.PI/levels,  0.0];
    public var fc3:Vector.<Number> = new <Number>[.1, .2, 2, 0];
    
    /** Create Shaders */
    override protected function createShaders():void 
    {
        this.fragmentShader = 
            <![CDATA[
                mov ft2.xy, v0.xy
                mov ft2.w, fc2.x
                sub ft2.z, fc2.y, ft2.w
                mul ft2.z, ft2.z, ft2.x
                add ft2.x, ft2.z, fc2.x

                sub ft2.z, fc2.y, ft2.w
                mul ft2.z, ft2.z, ft2.y
                add ft2.y, ft2.z, fc2.x

                //resolution tweak
                div ft2.x, ft2.x, fc3.w

                // Atan2
                add ft2.x, ft2.x, fc1.x
                 
                div ft3.x, ft2.y, ft2.x
                neg ft3.y, ft3.x 
                 
                mul ft4.y, fc1.y, ft3.x 
                add ft4.z, fc0.x, ft3.x
                div ft5.x, ft4.y, ft4.z  
                 
                mul ft4.y, fc1.y, ft3.y
                add ft4.z, fc0.x, ft3.y
                div ft5.y, ft4.y, ft4.z  
                 
                slt ft4.x, ft2.x, fc0.y
                slt ft4.y, ft2.y, fc0.y
                sub ft4.z, fc0.x, ft4.x
                sub ft4.w, fc0.x, ft4.y
                 
                mul ft3.x, ft4.z, ft4.w
                mul ft3.y, ft4.x, ft4.w
                mul ft3.z, ft4.x, ft4.y
                mul ft3.w, ft4.z, ft4.y
                 
                sub ft4.x, ft5.x, fc0.z 
                neg ft4.y, ft5.y      
                mov ft4.z, ft5.x 
                sub ft4.w, fc0.z, ft5.y 
                 
                mul ft4, ft4, ft3
                 
                add ft4.xy, ft4.xz, ft4.yw 
                add ft4.x, ft4.x, ft4.y
                
                // eo Atan2

                mul ft0.x, ft2.x, ft2.x
                mul ft0.y, ft2.y, ft2.y
                add ft0.x, ft0.x, ft0.y
                sqt ft0.x, ft0.x
                
                mov ft5.x, fc2.z
                div ft5.x, ft5.x, fc1.w
                add ft5.x, ft4.x, ft5.x
                div ft5.y, ft5.x, fc2.z
                frc ft5.y, ft5.y
                mul ft5.y, ft5.y, fc2.z
                
                mov ft5.x, fc2.z
                div ft5.x, ft5.x fc3.z
                sub ft5.x, ft5.y, ft5.x
                abs ft5.x, ft5.x
                add ft5.y, ft0.x, fc2.y
                div ft4.x, ft5.x, ft5.y
                
                mul ft0.x, ft0.x, fc3.x
                cos ft1.x, ft4.x
                mul ft1.x, ft1.x, ft0.x
                sin ft1.y, ft4.x
                mul ft1.y, ft1.y, ft0.x
                
                mov ft4.x, fc2.w
                
                cos ft2.x, ft4.x
                sin ft2.y, ft4.x
                
                mul ft3.x, ft2.y, fc3.y
                mul ft3.y, ft1.y, ft2.y
                mul ft3.z, ft1.x, ft2.x
                sub ft6.x, ft3.z, ft3.y
                sub ft6.x, ft6.x, ft3.x
                
                mul ft3.x, ft2.x, fc3.y
                mul ft3.y, ft1.y, ft2.x
                mul ft3.z, ft1.x, ft2.y
                add ft6.y, ft3.z, ft3.y
                add ft6.y, ft6.y, ft3.x
                
                mul ft6.xy, ft6.xy, fc3.z
                
                tex oc, ft6.xy, fs0<2d, clamp, nearest, mipnone>
            ]]>
    }
    
    /** Before Draw */
    override protected function beforeDraw(context:Context3D):void 
    {
        super.beforeDraw(context);
        
        fc2[2] = Math.PI / levels;
        fc2[3] = time;
        fc3[3] = texture.height / texture.width;
        
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fc0, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.fc1, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.fc2, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, this.fc3, 1);
    }
    
}

}