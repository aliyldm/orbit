package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.events.ShadingMethodEvent;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterData;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.passes.MaterialPassBase;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class CompositeSpecularMethod extends BasicSpecularMethod
   {
      
      private var _baseMethod:BasicSpecularMethod;
      
      public function CompositeSpecularMethod(param1:Function, param2:BasicSpecularMethod = null)
      {
         super();
         this._baseMethod = param2 || new BasicSpecularMethod();
         this._baseMethod._modulateMethod = param1;
         this._baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         this._baseMethod.initVO(param1);
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         this._baseMethod.initConstants(param1);
      }
      
      public function get baseMethod() : BasicSpecularMethod
      {
         return this._baseMethod;
      }
      
      public function set baseMethod(param1:BasicSpecularMethod) : void
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
      
      override public function get gloss() : Number
      {
         return this._baseMethod.gloss;
      }
      
      override public function set gloss(param1:Number) : void
      {
         this._baseMethod.gloss = param1;
      }
      
      override public function get specular() : Number
      {
         return this._baseMethod.specular;
      }
      
      override public function set specular(param1:Number) : void
      {
         this._baseMethod.specular = param1;
      }
      
      override public function get passes() : Vector.<MaterialPassBase>
      {
         return this._baseMethod.passes;
      }
      
      override public function dispose() : void
      {
         this._baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this._baseMethod.dispose();
      }
      
      override public function get texture() : Texture2DBase
      {
         return this._baseMethod.texture;
      }
      
      override public function set texture(param1:Texture2DBase) : void
      {
         this._baseMethod.texture = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         this._baseMethod.activate(param1,param2);
      }
      
      override arcane function deactivate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         this._baseMethod.deactivate(param1,param2);
      }
      
      override arcane function set sharedRegisters(param1:ShaderRegisterData) : void
      {
         super.arcane::sharedRegisters = this._baseMethod.sharedRegisters = param1;
      }
      
      override arcane function getVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return this._baseMethod.getVertexCode(param1,param2);
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return this._baseMethod.getFragmentPreLightingCode(param1,param2);
      }
      
      override arcane function getFragmentCodePerLight(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterCache) : String
      {
         return this._baseMethod.getFragmentCodePerLight(param1,param2,param3,param4);
      }
      
      override arcane function getFragmentCodePerProbe(param1:MethodVO, param2:ShaderRegisterElement, param3:String, param4:ShaderRegisterCache) : String
      {
         return this._baseMethod.getFragmentCodePerProbe(param1,param2,param3,param4);
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

