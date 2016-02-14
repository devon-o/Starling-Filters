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

package starling.filters 
{
    
import starling.animation.IAnimatable;
import starling.core.Starling;
import starling.rendering.FilterEffect;

/**
 * Creates a CRT screen effect
 * @author Devon O.
 */
public class CRTFilter extends FragmentFilter implements IAnimatable
{

    /**
     * Create a new CRTFilter
     * @param autoUpdate    should effect upate automatically
     */
    public function CRTFilter(autoUpdate:Boolean=true) 
    {
        super();
        this.autoUpdate = autoUpdate;
    }
    
    /** Dispose */
    override public function dispose():void 
    {
        Starling.juggler.remove(this);
        super.dispose();
    }
    
    /** Auto Update */
    public function set autoUpdate(value:Boolean)
    {
        if (value) Starling.juggler.add(this);
        else Starling.juggler.remove(this);
        
    }
    public function get autoUpdate():Boolean { return Starling.juggler.contains(this); }
    
    /** Red */
    public function set red(value:Number):void 
    {
        (this.effect as CRTEffect).fc3[1] = value;
        setRequiresRedraw();
    }
    public function get red():Number { return (this.effect as CRTEffect).fc3[1]; }
    
    /** Green */
    public function set green(value:Number):void
    {
        (this.effect as CRTEffect).fc3[2] = value;
        setRequiresRedraw()
    }
    public function get green():Number { return (this.effect as CRTEffect).fc3[2]; }
    
    /** Blue */
    public function set blue(value:Number):void
    {
        (this.effect as CRTEffect).fc3[3] = value;
        setRequiresRedraw();
    }
    public function get blue():Number { return (this.effect as CRTEffect).fc3[3]; }
    
    /** Brightness */
    public function set brightness(value:Number):void
    {
        (this.effect as CRTEffect).fc4[0] = value; 
        setRequiresRedraw();
    }
    public function get brightness():Number { return (this.effect as CRTEffect).fc4[0]; }
    
    /** Distortion */
    public function set distortion(value:Number):void
    {
        (this.effect as CRTEffect).fc4[1] = value;
        setRequiresRedraw();
    }
    public function get distortion():Number { return (this.effect as CRTEffect).fc4[1]; }
    
    /** Scanline Frequency */
    public function set frequency(value:Number):void
    {
        (this.effect as CRTEffect).fc4[2] = value;
        setRequiresRedraw();
    }
    public function get frequency():Number { return (this.effect as CRTEffect).fc4[2]; }
    
    /** Scanline Intensity */
    public function set intensity(value:Number):void
    {
        (this.effect as CRTEffect).fc4[3] = value; 
        setRequiresRedraw();
    }
    public function get intensity():Number { return (this.effect as CRTEffect).fc4[3]; }
    
    /** Speed */
    public function set speed(value:Number):void 
    {
        (this.effect as CRTEffect).speed = value;
        advanceTime(0.0);
    };
    public function get speed():Number { return (this.effect as CRTEffect).speed; }
    
    // Implementation
    
    /** Create Effect */
    override protected function createEffect():FilterEffect 
    {
        return new CRTEffect();
    }
    
    // IAnimatable implementation
    
    /** Advance Time */
    public function advanceTime(time:Number):void
    {
        (this.effect as CRTEffect).time += (this.effect as CRTEffect).speed / 512;
        setRequiresRedraw();
    }
}

}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import starling.filters.BaseFilterEffect;

class CRTEffect extends BaseFilterEffect
{
    public var time:Number=0.0;
    public var speed:Number=10.0;
    
    public var fc0:Vector.<Number> = new <Number>[0.0, .25, .50, 1.0];
    public var fc1:Vector.<Number> = new <Number>[Math.sqrt(.50), 2.5, 1.55, Math.PI];
    public var fc2:Vector.<Number> = new <Number>[2.2, 1.4, 2.0, .2];
    public var fc3:Vector.<Number> = new <Number>[3.5, 0.7, 1, 0.7];
    public var fc4:Vector.<Number> = new <Number>[1, 0, 256, 4];
    public var fc5:Vector.<Number> = new <Number>[1, 1, 1, .0000001];
    
    /** Create Shaders */
    override protected function createShaders():void 
    {
        this.fragmentShader = 
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
                
                tex ft2, ft0.xy, fs0<2d, wrap, nearest, mipnone>
                
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
                
                mul ft1.x, ft0.x, ft0.y
                mul ft1.x, ft1.x, ft0.z
                
                // set output alpha to 1 or 0 depending on multiplied out color (solid black will have 0 alpha)
                sge ft0.w, ft1.x, fc5.w
                mov oc, ft0
            ]]>
    }
    
    /** Before Draw */
    override protected function beforeDraw(context:Context3D):void 
    {
        super.beforeDraw(context);
        
        fc5[0] = time;
            
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fc0, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.fc1, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.fc2, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, this.fc3, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, this.fc4, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, this.fc5, 1); 
    }
    
}