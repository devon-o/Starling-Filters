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
 * Creates a Vignette effect on images with an option sepia tone
 * @author Devon O.
 */
public class VignetteFilter extends FragmentFilter
{
    private var _centerX:Number;
    private var _centerY:Number;
    private var _amount:Number;
    private var _radius:Number;
    private var _size:Number;
    private var _useSepia:Boolean;
    
    /**
     * Create a new Vignette Filter
     * @param size      Size of effect
     * @param radius    Radius of effect
     * @param amount    Amount of effect
     * @param cx        Center X of effect
     * @param cy        Center Y of effect
     * @param sepia     Should/Should not use Sepia
     */
    public function VignetteFilter(size:Number=.50, radius:Number=1.0, amount:Number=0.7, cx:Number=.50, cy:Number=.50, sepia:Boolean=false) 
    {
        this._centerX = cx;
        this._centerY = cy;
        this._amount = amount;
        this._radius = radius;
        this._size = size;
        this._useSepia = sepia;
        super();
    }
    
    /** Center X */
    public function set centerX(value:Number):void
    {
        this._centerX = value;
        (this.effect as VignetteEffect).centerX = value;
        setRequiresRedraw();
    }
    public function get centerX():Number { return this._centerX; }
    
    /** Center Y */
    public function set centerY(value:Number):void
    {
        this._centerY = value;
        (this.effect as VignetteEffect).centerY = value;
        setRequiresRedraw();
    }
    public function get centerY():Number { return this._centerY; }
    
    /** Amount */
    public function set amount(value:Number):void
    {
        this._amount = value;
        (this.effect as VignetteEffect).amount = value;
        setRequiresRedraw();
    }
    public function get amount():Number { return this._amount; }
    
    /** Radius */
    public function set radius(value:Number):void
    {
        this._radius = value;
        (this.effect as VignetteEffect).radius = value;
        setRequiresRedraw();
    }
    public function get radius():Number { return this._radius; }
    
    /** Size */
    public function set size(value:Number):void
    {
        this._size = value;
        (this.effect as VignetteEffect).size = value;
        setRequiresRedraw();
    }
    public function get size():Number { return this._size; }
    
    /** Use Sepia */
    public function set useSepia(value:Boolean):void
    {
        this._useSepia = value;
        (this.effect as VignetteEffect).useSepia = value;
        setRequiresRedraw();
    }
    public function get useSepia():Boolean { return this._useSepia; }
    
    // Implementation
    
    /** Create Effect */
    override protected function createEffect():FilterEffect 
    {
        var e:VignetteEffect = new VignetteEffect();
        e.centerX = this._centerX;
        e.centerY = this._centerY;
        e.amount = this._amount;
        e.radius = this._radius;
        e.size = this._size;
        e.useSepia = this._useSepia;
        return e;
    }
}

}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import starling.filters.BaseFilterEffect;

class VignetteEffect extends BaseFilterEffect
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