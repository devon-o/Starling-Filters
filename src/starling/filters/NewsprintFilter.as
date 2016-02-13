package starling.filters 
{

import starling.rendering.FilterEffect;

/**
 * Creates a funky 'news print'/half tone effect
 * @author Devon O.
 */
public class NewsprintFilter extends FragmentFilter
{
    private var _size:Number;
    private var _scale:Number;
    private var _angle:Number
    
    /**
     * Create a new Newsprint Filter
     * @param size      size of effect
     * @param scale     scale of effect
     * @param angle     angle of effect (in degrees)
     */
    public function NewsprintFilter(size:Number=120.0, scale:Number=3.0, angle:Number=0.0) 
    {
        this._size = size;
        this._scale = scale;
        this._angle = angle;
        super();
    }
    
    /** Size */
    public function set size(value:Number):void
    {
        this._size = value;
        (this.effect as NewsprintEffect).size = value;
        setRequiresRedraw();
    }
    public function get size():Number { return this._size; }
    
    /** Scale */
    public function set scale(value:Number):void
    {
        this._scale = value;
        (this.effect as NewsprintEffect).scale = value;
        setRequiresRedraw();
    }
    public function get scale():Number { return this._scale; }
    
    /** Angle */
    public function set angle(value:Number):void
    {
        this._angle = angle;
        (this.effect as NewsprintEffect).angle = value;
        setRequiresRedraw();
    }
    public function get angle():Number { return this._angle; }
    
    // Implementation
    
    /** Create effect */
    override protected function createEffect():FilterEffect 
    {
        var e:NewsprintEffect = new NewsprintEffect();
        e.size = this._size;
        e.scale = this._scale;
        e.angle = this._angle;
        return e;
    }
}

}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import starling.filters.BaseFilterEffect;

class NewsprintEffect extends BaseFilterEffect
{
    private static const RADIAN:Number = Math.PI/180;
    
    public var size:Number;
    public var scale:Number;
    public var angle:Number;
    
    private var vars:Vector.<Number> = new <Number>[1.0, 1.0, 1.0,  1.0];
    private var constants:Vector.<Number> = new <Number>[4.0, 5.0, 10.0, 3.0];;
    
    /** Create shaders */
    override protected function createShaders():void 
    {
        this.fragmentShader = 
        <![CDATA[
            tex ft0, v0, fs0<2d, clamp, nearest, nomip>
            mov ft1, fc0.w
            add ft1.x, ft0.x, ft0.y
            add ft1.x, ft1.x, ft0.z
            div ft1.x, ft1.x, fc1.w
            mul ft2, ft1.x, fc1.z 
            sub ft2, ft2, fc1.y 
            mov ft5, fc0.w 
            mov ft5.x, fc0.x
            sin ft5.x, ft5.x
            mov ft5.y, fc0.x 
            cos ft5.y, ft5.y
            mul ft6, v0, fc0.z
            sub ft6, ft6, fc0.w 
            mov ft7, fc0.w
            mul ft7.z, ft5.y, ft6.x
            mul ft7.w, ft5.x, ft6.y
            sub ft7.x, ft7.z, ft7.w
            mul ft7.x, ft7.x, fc0.y 
            mul ft7.z, ft5.x, ft6.x
            mul ft7.w, ft5.y, ft6.y 
            add ft7.y, ft7.z, ft7.w 
            mul ft7.y, ft7.y, fc0.y
            sin ft6.x, ft7.x
            sin ft6.y, ft7.y
            mul ft3, ft6.x, ft6.y
            mul ft3, ft3, fc1.x 
            add ft2, ft2, ft3
            mov ft2.w, ft0.w
            mov oc, ft2
        ]]>;
    }
    
    /** Before draw */
    override protected function beforeDraw(context:Context3D):void 
    {
        this.vars[0] = this.angle * RADIAN;
        this.vars[1] = this.scale;
        this.vars[2] = this.size;
        
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.vars, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.constants, 1);
        
        super.beforeDraw(context);
    }
}