package starling.filters 
{
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DProgramType;
    import starling.textures.Texture;
    
	/**
     * Cross Processing effect
     * @author Devon O.
     */
    public class CrossProcessingFilter extends BaseFilter
    {
        [Embed(source="assets/cross-processing.jpg")]
        private static const SAMPLE_SOURCE:Class;
        
        private var sample:Texture;
        private var vars:Vector.<Number> = new <Number>[1, .50, 0, .0];
        
        private var _amount:Number;
        
        /** Create a new CrossProcessingFilter */
        public function CrossProcessingFilter() 
        {
            this.sample = Texture.fromBitmap(new SAMPLE_SOURCE(), false);
        }
        
        /** Dispose */
        override public function dispose():void 
        {
            this.sample.dispose();
            super.dispose();
        }
        
        /** Set AGAL */
        override protected function setAgal():void 
        {
            FRAGMENT_SHADER =
            <![CDATA[
            
            tex ft0, v0, fs0<2d, clamp, linear, mipnone>
            
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
        
        /** Activate */
        override protected function activate(pass:int, context:Context3D, texture:Texture):void 
        {
            this.vars[0] = this._amount;
            
            context.setTextureAt(1, this.sample.base);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.vars, 1);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            
            super.activate(pass, context, texture);
        }
        
        /** Deactivate */
        override protected function deactivate(pass:int, context:Context3D, texture:Texture):void 
        {
            context.setTextureAt(1, null);
            context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
        }
        
        /** Amount */
        public function set amount(value:Number):void { this._amount = value; }
        public function get amount():Number { return this._amount; }
    }

}