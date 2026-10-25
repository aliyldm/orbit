package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.events.ShadingMethodEvent;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterData;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class CompositeDiffuseMethod extends BasicDiffuseMethod
   {
      
      protected var _baseMethod:BasicDiffuseMethod;
      
      public function CompositeDiffuseMethod(param1:Function = null, param2:BasicDiffuseMethod = null)
      {
         super();
         this._baseMethod = param2 || new BasicDiffuseMethod();
         this._baseMethod._modulateMethod = param1;
         this._baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
      }
      
      public function get baseMethod() : BasicDiffuseMethod
      {
         return this._baseMethod;
      }
      
      public function set baseMethod(param1:BasicDiffuseMethod) : void
      {
         if(this._baseMethod == param1)
         {
            return;
         }
         this._baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this._baseMethod = param1;
         this._baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated,false,0,true);
         invalidateShaderProgram();
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         this._baseMethod.initVO(param1);
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         this._baseMethod.initConstants(param1);
      }
      
      override public function dispose() : void
      {
         this._baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this._baseMethod.dispose();
      }
      
      override public function get alphaThreshold() : Number
      {
         return this._baseMethod.alphaThreshold;
      }
      
      override public function set alphaThreshold(param1:Number) : void
      {
         this._baseMethod.alphaThreshold = param1;
      }
      
      override public function get texture() : Texture2DBase
      {
         return this._baseMethod.texture;
      }
      
      override public function set texture(param1:Texture2DBase) : void
      {
         this._baseMethod.texture = param1;
      }
      
      override public function get diffuseAlpha() : Number
      {
         return this._baseMethod.diffuseAlpha;
      }
      
      override public function get diffuseColor() : uint
      {
         return this._baseMethod.diffuseColor;
      }
      
      override public function set diffuseColor(param1:uint) : void
      {
         this._baseMethod.diffuseColor = param1;
      }
      
      override public function set diffuseAlpha(param1:Number) : void
      {
         this._baseMethod.diffuseAlpha = param1;
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return this._baseMethod.getFragmentPreLightingCode(param1,param2);
      }
      
      override arcane function getFragmentCodePerLight(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterCache) : String
      {
         var _loc5_:String = this._baseMethod.getFragmentCodePerLight(param1,param2,param3,param4);
         _totalLightColorReg = this._baseMethod._totalLightColorReg;
         return _loc5_;
      }
      
      override arcane function getFragmentCodePerProbe(param1:MethodVO, param2:ShaderRegisterElement, param3:String, param4:ShaderRegisterCache) : String
      {
         var _loc5_:String = this._baseMethod.getFragmentCodePerProbe(param1,param2,param3,param4);
         _totalLightColorReg = this._baseMethod._totalLightColorReg;
         return _loc5_;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         this._baseMethod.activate(param1,param2);
      }
      
      override arcane function deactivate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         this._baseMethod.deactivate(param1,param2);
      }
      
      override arcane function getVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return this._baseMethod.getVertexCode(param1,param2);
      }
      
      override arcane function getFragmentPostLightingCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         return this._baseMethod.getFragmentPostLightingCode(param1,param2,param3);
      }
      
      override arcane function reset() : void
      {
         this._baseMethod.reset();
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._baseMethod.cleanCompilationData();
      }
      
      override arcane function set sharedRegisters(param1:ShaderRegisterData) : void
      {
         super.arcane::sharedRegisters = this._baseMethod.sharedRegisters = param1;
      }
      
      override arcane function set shadowRegister(param1:ShaderRegisterElement) : void
      {
         super.arcane::shadowRegister = param1;
         this._baseMethod.shadowRegister = param1;
      }
      
      private function onShaderInvalidated(param1:ShadingMethodEvent) : void
      {
         invalidateShaderProgram();
      }
   }
}

