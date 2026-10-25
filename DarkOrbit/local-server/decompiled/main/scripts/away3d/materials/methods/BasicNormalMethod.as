package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class BasicNormalMethod extends ShadingMethodBase
   {
      
      private var _texture:Texture2DBase;
      
      private var _useTexture:Boolean;
      
      protected var _normalTextureRegister:ShaderRegisterElement;
      
      public function BasicNormalMethod()
      {
         super();
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsUV = Boolean(this._texture);
      }
      
      arcane function get tangentSpace() : Boolean
      {
         return true;
      }
      
      arcane function get hasOutput() : Boolean
      {
         return this._useTexture;
      }
      
      override public function copyFrom(param1:ShadingMethodBase) : void
      {
         this.normalMap = BasicNormalMethod(param1).normalMap;
      }
      
      public function get normalMap() : Texture2DBase
      {
         return this._texture;
      }
      
      public function set normalMap(param1:Texture2DBase) : void
      {
         if(Boolean(param1) != this._useTexture || Boolean(param1 && this._texture) && (Boolean(param1.hasMipMaps != this._texture.hasMipMaps || param1.format != this._texture.format)))
         {
            invalidateShaderProgram();
         }
         this._useTexture = Boolean(param1);
         this._texture = param1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._normalTextureRegister = null;
      }
      
      override public function dispose() : void
      {
         if(this._texture)
         {
            this._texture = null;
         }
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         if(param1.texturesIndex >= 0)
         {
            param2._context3D.setTextureAt(param1.texturesIndex,this._texture.getTextureForStage3D(param2));
         }
      }
      
      arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         this._normalTextureRegister = param2.getFreeTextureReg();
         param1.texturesIndex = this._normalTextureRegister.index;
         return getTex2DSampleCode(param1,param3,this._normalTextureRegister,this._texture) + "sub " + param3 + ".xyz, " + param3 + ".xyz, " + _sharedRegisters.commons + ".xxx\t\n" + "nrm " + param3 + ".xyz, " + param3 + ".xyz\t\t\t\t\t\t\t\n";
      }
   }
}

