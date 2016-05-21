/**
 *	Copyright (c) 2016 Devon O. Wolfgang | Rob Lockhart (http://importantlittlegames.com/)
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

import starling.filters.FragmentFilter;
import starling.filters.IFilterHelper;
import starling.rendering.FilterEffect;
import starling.rendering.Painter;
import starling.textures.Texture;

/**
 * RadialBlurFilter
 * Creates a Circular/Spin Blur around a specified normalized point.
 * For best results, apply to a Power-Of-Two texture.
 * 
 * @author Devon O.
 */
public class RadialBlurFilter extends FragmentFilter
{
    /** Radian Conversion */
    private static const RADIAN:Number=Math.PI/180;
    
    /** Horizontal position */
    private var _x:Number;
    
    /** Vertical position */
    private var _y:Number;
    
    /** Blur angle/amount */
    private var _angle:Number;
    
    /** Number of samples */
    private var samples:int;
    
    /** Number of passes */
    private var passes:int;

    /** Radial Blur Effect */
    private var blurEffect:RadialBlurEffect;
    
    /**
     * Create a new RadialBlurFilter
     * @param x         X position of blur center (0-1)
     * @param y         Y position of blur center (0-1)
     * @param angle     Angle in degrees and amount of blur effect
     * @param samples   Number samples used to produce blur. The higher the number, the better the effect, but performance may degrade.
     * @param passes    Number of passes to apply to filter (1 pass=1 draw call)
     */
    public function RadialBlurFilter(x:Number, y:Number, angle:Number, samples:int=10, passes:int=1) 
    {
        this._x=x;
        this._y=y;
        this._angle=angle;
        this.samples=samples;
        this.passes=passes;
    }
    
    /** Get number of passes */
    override public function get numPasses():int 
    {
        return this.passes;
    }
    
    /** Process */
    override public function process(painter:Painter, helper:IFilterHelper, input0:Texture=null, input1:Texture=null, input2:Texture=null, input3:Texture=null):Texture 
    {
        var p:Number=this.numPasses;
        var outTexture:Texture=input0;
        var inTexture:Texture;
        while (p > 0)
        {
            inTexture=outTexture;
            outTexture=super.process(painter, helper, inTexture);
            
            p--;
            
            if (inTexture!=input0) 
                helper.putTexture(inTexture);
        }
        return outTexture;
    }
    
    /** Create Effect */
    override protected function createEffect():FilterEffect 
    {
        this.blurEffect=new RadialBlurEffect(this.samples);
        this.blurEffect.cx=this._x;
        this.blurEffect.cy=this._y;
        this.blurEffect.angle=this._angle*RADIAN;
        return this.blurEffect;
    }
    
    /** X Position (0-1) */
    public function get x():Number { return this._x; }
    public function set x(value:Number):void
    {
        this._x=value;
        applyProperty("cx", this._x);
    }
    
    /** Y Position (0-1) */
    public function get y():Number { return this._y; }
    public function set y(value:Number):void
    {
        this._y=value;
        applyProperty("cy", this._y);
    }
    
    /** Angle/Amount of Blur */
    public function get angle():Number { return this._angle; }
    public function set angle(value:Number):void
    {
        this._angle=value;
        applyProperty("angle", this._angle*RADIAN);
    }
    
    /** Apply effect property to Effect instance */
    private function applyProperty(prop:String, value:*):void
    {
        if (this.blurEffect==null)
            return;
            
        this.blurEffect[prop]=value;
        setRequiresRedraw();
    }
}
}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import starling.rendering.FilterEffect;
import starling.rendering.Program;

/** FilterEffect for RadialBlurFilter */

class RadialBlurEffect extends FilterEffect
{

    /** Angle of blur */
    public var angle:Number;
    
    /** Center X */
    public var cx:Number;
    
    /** Center Y */
    public var cy:Number;
    
    /** Number of samples */
    private var samples:int;
    
    // Shader Constants
    private var fc0:Vector.<Number> = new <Number>[0.0, 1.0, 0.0, 0.0];
    private var fc1:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
    
    /**
     * Create a new RadialBlurEffect
     * @param samples   Number of samples
     */
    public function RadialBlurEffect(samples:int)
    {
        this.samples=samples;
    }
    
    /** Create Program */
    override protected function createProgram():Program 
    {
        var agal:String=createShader();
        return Program.fromSource(STD_VERTEX_SHADER, agal);
    }
    
    /** Before Draw */
    override protected function beforeDraw(context:Context3D):void 
    {
        super.beforeDraw(context);
        
        this.fc0[3] = -this.samples*.50;
        
        this.fc1[0] = (this.cx * this.texture.width) / this.texture.root.nativeWidth;
        this.fc1[1] = (this.cy * this.texture.height) / this.texture.root.nativeHeight;
        this.fc1[2] = this.angle;
        this.fc1[3] = this.samples;
        
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fc0, 1);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.fc1, 1);
    }
    
    /** Create Shader */
    private function createShader():String
    {
        var s:String = "";
        
        // total
        s+="mov ft1.xyzw, fc0.xxxx \n";
        
        // subtract offset from uv
        s+="sub ft0.xy, v0.xy, fc1.xy \n";
        
        // loop counter
        s+="mov ft0.z, fc0.w \n";
        for (var i:int=0; i < this.samples; i++)
        {
            // theta = counter*(angle/numSamples)
            s+="mov ft2.x, fc1.z \n";
            s+="div ft2.x, ft2.x, fc1.w \n";
            s+="mul ft2.x, ft2.x, ft0.z \n";
            
            // (sin(theta), cos(theta))
            s+="sin ft3.x, ft2.x \n";
            s+="cos ft3.y, ft2.x \n";
            
            // x = dp2((cx,cy), (cos,-sin))
            // y = dp2((cx,cy), (sin, cos))
            
            s+="mul ft5.y, ft0.x, ft3.x \n";
            s+="mul ft5.z, ft0.y, ft3.y \n";
            s+="add ft5.y, ft5.y, ft5.z \n";
            
            s+="neg ft3.x, ft3.x \n"
            
            s+="mul ft5.x, ft0.x, ft3.y \n";
            s+="mul ft5.w, ft0.y, ft3.x \n";
            s+="add ft5.x, ft5.x, ft5.w \n";
            
            // add offset back in
            s+="add ft5.xy, ft5.xy, fc1.xy \n";
            
            // sample
            s+="tex ft6, ft5.xy, fs0<2d, nomip, clamp> \n";
            
            // total+=sample
            s+="add ft1, ft1, ft6 \n";
            
            // increase loop counter
            s+="add ft0.z, ft0.z, fc0.y \n";
        }
        
        // outpuColor=total/numSamples
        s+="div oc, ft1.xyzw, fc1.wwww \n";
        
        return s;
    }
}