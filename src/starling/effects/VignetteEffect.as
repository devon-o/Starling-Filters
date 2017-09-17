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

public class VignetteEffect extends BaseFilterEffect
{
    public var centerX:Number;
    public var centerY:Number;
    public var amount:Number;
    public var radius:Number;
    public var size:Number;
    public var useSepia:Boolean;
    
    private var center:Vector.<Number> = new <Number>[1, 1, 1, 1];
    private var vars:Vector.<Number> = new <Number>[.50, .50, .50, .50];
    
    private var sepia1:Vector.<Number> = new <Number>[0.393, 0.769, 0.189, 0.000];
    private var sepia2:Vector.<Number> = new <Number>[0.349, 0.686, 0.168, 0.000];
    private var sepia3:Vector.<Number> = new <Number>[0.272, 0.534, 0.131, 0.000];
    
    private var noSepia1:Vector.<Number> = new <Number>[1.0, 0.0, 0.0, 0.000];
    private var noSepia2:Vector.<Number> = new <Number>[0.0, 1.0, 0.0, 0.000];
    private var noSepia3:Vector.<Number> = new <Number>[0.0, 0.0, 1.0, 0.000];
    
    /** Create Shaders */
    override protected function createShaders():void 
    {
        this.fragmentShader = 
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
            ]]>
            +tex("ft1", "v0", 0, this.texture)+
            <![CDATA[
                // sepia  
                dp3 ft2.x, ft1, fc2
                dp3 ft2.y, ft1, fc3
                dp3 ft2.z, ft1, fc4
                
                mul ft6.xyz, ft6.xyz, ft2.xyz
                mov ft6.w, ft1.w
                mov oc, ft6
            ]]>
    }
    
    /** Before Draw */
    override protected function beforeDraw(context:Context3D):void 
    {
        var halfSize:Number = this.size * .50;
        this.center[0] = this.centerX - halfSize
        this.center[1] = this.centerY - halfSize;
        
        this.vars[0] = this.amount;
        this.vars[1] = this.radius;
        this.vars[3] = this.size;
        
        // to sepia or not to sepia
        var s1:Vector.<Number> = this.useSepia ? this.sepia1 : this.noSepia1;
        var s2:Vector.<Number> = this.useSepia ? this.sepia2 : this.noSepia2;
        var s3:Vector.<Number> = this.useSepia ? this.sepia3 : this.noSepia3;
        
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.center, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.vars, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, s1, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, s2, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, s3, 1);
        
        super.beforeDraw(context);
    }
    
}

}