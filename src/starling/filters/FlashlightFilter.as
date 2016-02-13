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

import starling.rendering.FilterEffect;

/**
 * Creates Flashlight effect
 * @author Devon O.
 */
public class FlashlightFilter extends FragmentFilter
{
    private var _x:Number;
    private var _y:Number;
    private var _angle:Number;
    
    /**
     * Create a new Flashlight Filter
     * @param x     x position
     * @param y     y position
     * @param angle angle of light cone
     */
    public function FlashlightFilter(x:Number=0.0, y:Number=0.0, angle:Number=0.0) 
    {
        this._x = x;
        this._y = y;
        this._angle = angle;
        
        super();
    }
    
    /** X position */
    public function set x(value:Number):void 
    {
        this._x = value;
        (this.effect as FlashlightEffect).x = value;
        setRequiresRedraw();
    }
    public function get x():Number { return this._x; }
    
    /** Y position */
    public function set y(value:Number):void 
    {
        this._y = value;
        (this.effect as FlashlightEffect).y = value;
        setRequiresRedraw();
    }
    public function get y():Number { return this._y; }
    
    /** Angle */
    public function set angle(value:Number):void 
    {
        this._angle = value;
        (this.effect as FlashlightEffect).angle = value;
        setRequiresRedraw();
    }
    public function get angle():Number { return this._angle; }
    
    /** Outer cone */
    public function set outerCone(value:Number):void 
    {
        (this.effect as FlashlightEffect).outerCone = value;
        setRequiresRedraw();
    }
    public function get outerCone():Number { return (this.effect as FlashlightEffect).outerCone; }
    
    /** Inner cone */
    public function set innerCone(value:Number):void 
    {
        (this.effect as FlashlightEffect).innerCone = value;
        setRequiresRedraw();
    }
    public function get innerCone():Number { return (this.effect as FlashlightEffect).innerCone; }
    
    /** Azimuth */
    public function set azimuth(value:Number):void 
    {
        (this.effect as FlashlightEffect).azimuth = value;
        setRequiresRedraw();
    }
    public function get azimuth():Number { return (this.effect as FlashlightEffect).azimuth; }
    
    /** Attenuation 1 */
    public function set attenuation1(value:Number):void 
    {
        (this.effect as FlashlightEffect).a1 = value;
        setRequiresRedraw();
    }
    public function get attenuation1():Number { return (this.effect as FlashlightEffect).a1; }
    
    /** Attenuation 2 */
    public function set attenuation2(value:Number):void 
    {
        (this.effect as FlashlightEffect).a2 = value;
        setRequiresRedraw();
    }
    public function get attenuation2():Number { return (this.effect as FlashlightEffect).a2; }
    
    /** Attenuation 3 */
    public function set attenuation3(value:Number):void 
    {
        (this.effect as FlashlightEffect).a3 = value;
        setRequiresRedraw();
    }
    public function get attenuation3():Number { return (this.effect as FlashlightEffect).a3; }
    
    /** Red */
    public function set red(value:Number):void 
    {
        (this.effect as FlashlightEffect).r = value;
        setRequiresRedraw();
    }
    public function get red():Number { return (this.effect as FlashlightEffect).r; }
    
    /** Green */
    public function set green(value:Number):void 
    {
        (this.effect as FlashlightEffect).g = value;
        setRequiresRedraw();
    }
    public function get green():Number { return (this.effect as FlashlightEffect).g ; }
    
    /** Blue */
    public function set blue(value:Number):void 
    {
        (this.effect as FlashlightEffect).b = value;
        setRequiresRedraw();
    }
    public function get blue():Number { return (this.effect as FlashlightEffect).b; }
    
    // Implementation
    
    /** Create Effect */
    override protected function createEffect():FilterEffect 
    {
        var e:FlashlightEffect = new FlashlightEffect();
        e.x = this._x;
        e.y = this._y;
        e.angle = this._angle;
        return e;
    }
}

}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import starling.filters.BaseFilterEffect;

class FlashlightEffect extends BaseFilterEffect
{
    private static const RADIAN:Number = Math.PI / 180;
    
    public var x:Number;
    public var y:Number;
    public var angle:Number;
    
    public var outerCone:Number = 10.0;
    public var innerCone:Number = 50.0;
    public var azimuth:Number = 0;
    
    public var a1:Number = .50;
    public var a2:Number = 10.0;
    public var a3:Number = 100.0;
    
    public var r:Number = 1.0;
    public var g:Number = 1.0;
    public var b:Number = 1.0;
        
    private var center:Vector.<Number> = new <Number>[1, 1, 0, 1];
    private var vars:Vector.<Number> = new <Number>[1, 1, 1, 1];
    private var lightColor:Vector.<Number> = new <Number>[1, 1, 1, 1];
    private var attenuation:Vector.<Number> = new <Number>[.50, 10, 100, 1];
    private var smoothStep:Vector.<Number> = new <Number>[2, 3, 1, 1];
    
    /** Create Shaders */
    override protected function createShaders():void 
    {
        this.fragmentShader = 
        <![CDATA[
            // azimuth
            mov ft0.z, fc1.y
            sin ft0.z, ft0.z
            neg ft0.z, ft0.z
            
            // direction
            mov ft1.x, fc1.y
            cos ft1.x, ft1.x
            mov ft2.x, fc1.x
            cos ft2.y, ft2.x
            sin ft2.z, ft2.x
            mul ft0.x, ft1.x, ft2.y
            mul ft0.y, ft1.x, ft2.z
            nrm ft3.xyz, ft0.xyz
            
            // distance
            sub ft2.y, v0.x, fc0.x
            mul ft2.y, ft2.y, ft2.y
            sub ft2.z, v0.y, fc0.y
            mul ft2.z, ft2.z, ft2.z
            add ft2.y, ft2.y, ft2.z
            sqt ft2.x, ft2.y
            
            // shadow
            mul ft4.y, ft2.x, fc3.y
            mul ft4.z, fc3.z, ft2.x
            mul ft4.z, ft4.z, ft2.x
            add ft4.x, fc3.x, ft4.y
            add ft4.x, ft4.x, ft4.z
            rcp ft4.x, ft4.x
            
            // cones
            mov ft0.xy, v0.xy
            mov ft0.z, fc0.z
            mov ft1.xy, fc0.xy
            mov ft1.z, fc0.z
            sub ft0.xyz, ft0.xyz, ft1.xyz
            nrm ft2.xyz, ft0.xyz
            mov ft0.x, fc1.z
            cos ft0.x, ft0.x
            mov ft0.y, fc1.w
            cos ft0.y, ft0.y
            dp3 ft0.z, ft2.xyz, ft3.xyz
            
            // Smoothstep
            sub ft1.x, ft0.z, ft0.y
            sub ft1.y, ft0.x, ft0.y
            div ft1.x, ft1.x, ft1.y
            sat ft0.z, ft1.x
            mul ft1.x, fc4.x, ft0.z
            sub ft1.x, fc4.y, ft1.x
            mul ft0.z, ft0.z, ft1.x
            mul ft0.z, ft0.z, ft0.z
            
            // shadow
            mul ft0.xyz, ft0.zzz, ft4.xxx
            
            // lightcolor
            mul ft0.xyz, ft0.xyz, fc2.xyz
            
            // Sample
            tex ft6, v0.xy, fs0<2d, clamp, linear, mipnone>
            mul ft6.xyz, ft6.xyz, ft0.xyz
            mov oc, ft6
        ]]>
    }
    
    /** Before Draw */
    override protected function beforeDraw(context:Context3D):void 
    {
        this.center[0] = (this.x * this.texture.width) / this.texture.root.nativeWidth;
        this.center[1] = (this.y * this.texture.height) / this.texture.root.nativeHeight;
        
        this.vars[0] = this.angle   * RADIAN;   // angle
        this.vars[1] = this.azimuth * RADIAN;	// azimuth
        this.vars[2] = this.outerCone * RADIAN;	// outer cone angle
        this.vars[3] = this.innerCone * RADIAN;	// inner cone angle
        
        this.lightColor[0] = this.r;
        this.lightColor[1] = this.g;
        this.lightColor[2] = this.b;
        
        this.attenuation[0] = this.a1;
        this.attenuation[1] = this.a2;
        this.attenuation[2] = this.a3;
        
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.center,      1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.vars,        1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.lightColor,  1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, this.attenuation, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, this.smoothStep,  1);
        
        super.beforeDraw(context);
    }
}