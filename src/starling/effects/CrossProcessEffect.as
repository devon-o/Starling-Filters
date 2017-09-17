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
import starling.textures.Texture;

public class CrossProcessEffect extends BaseFilterEffect
{
    [Embed(source="assets/cross-processing.jpg")]
    private static const SAMPLE:Class;
    
    public var amount:Number = 1.0;
    
    private var sample:Texture;
    private var fc0:Vector.<Number> = new <Number>[1, .50, 0, .0];
    
    /** Create a CrossProcess Effect */
    public function CrossProcessEffect()
    {
        this.sample = Texture.fromBitmap(new SAMPLE());
    }
    
    /** Dispose */
    override public function dispose():void 
    {
        this.sample.dispose();
        super.dispose();
    }
    
    /** Create Shaders */
    override protected function createShaders():void 
    {
        this.fragmentShader = 
            tex("ft0", "v0", 0, this.texture)+
        <![CDATA[
            mov ft1.y, fc0.y
            
            // r
            mov ft1.x, ft0.x
            tex ft2, ft1.xy, fs1<2d, clamp, linear, mipnone>
            mov ft3.x, ft2.x
            
            // g
            mov ft1.x, ft0.y
            tex ft2, ft1.xy, fs1<2d, clamp, linear, mipnone>
            mov ft3.y, ft2.y
            
            // g
            mov ft1.x, ft0.z
            tex ft2, ft1.xy, fs1<2d, clamp, linear, mipnone>
            mov ft3.z, ft2.z
            
            // ft2 = mix (ft0, ft3, fc0.x)
            sub ft2.xyz, ft3.xyz, ft0.xyz
            mul ft2.xyz, ft2.xyz, fc0.x
            add ft2.xyz, ft2.xyz, ft0.xyz
            
            mov ft0.xyz, ft2.xyz
            
            mov oc, ft0
        ]]>
    }
    
    /** Before Draw */
    override protected function beforeDraw(context:Context3D):void 
    {
        this.fc0[0] = this.amount;
            
        context.setTextureAt(1, this.sample.base);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.fc0, 1);
        
        super.beforeDraw(context);
    }
    
    /** After Draw */
    override protected function afterDraw(context:Context3D):void 
    {
        context.setTextureAt(1, null);
        super.afterDraw(context);
    }
    
}

}