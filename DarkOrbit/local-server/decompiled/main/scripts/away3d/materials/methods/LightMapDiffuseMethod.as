package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class LightMapDiffuseMethod extends CompositeDiffuseMethod
   {
      
      public static const MULTIPLY:String = "multiply";
      
      public static const ADD:String = "add";
      
      private var _texture:Texture2DBase;
      
      private var _blendMode:String;
      
      private var _useSecondaryUV:Boolean;
      
      public function LightMapDiffuseMethod(param1:Texture2DBase, param2:String = "multiply", param3:Boolean = false, param4:BasicDiffuseMethod = null)
      {
         super(null,param4);
         this._useSecondaryUV = param3;
         this._texture = param1;
         this.blendMode = param2;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsSecondaryUV = this._useSecondaryUV;
         param1.needsUV = !this._useSecondaryUV;
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         if(param1 != ADD && param1 != MULTIPLY)
         {
            throw new Error("Unknown blendmode!");
         }
         if(this._blendMode == param1)
         {
            return;
         }
         this._blendMode = param1;
         invalidateShaderProgram();
      }
      
      public function get lightMapTexture() : Texture2DBase
      {
         return this._texture;
      }
      
      public function set lightMapTexture(param1:Texture2DBase) : void
      {
         this._texture = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         param2._context3D.setTextureAt(param1.secondaryTexturesIndex,this._texture.getTextureForStage3D(param2));
         super.arcane::activate(param1,param2);
      }
      
      override arcane function getFragmentPostLightingCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:String = null;
         var _loc5_:ShaderRegisterElement = param2.getFreeTextureReg();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param1.secondaryTexturesIndex = _loc5_.index;
         _loc4_ = getTex2DSampleCode(param1,_loc6_,_loc5_,this._texture,_sharedRegisters.secondaryUVVarying);
         switch(this._blendMode)
         {
            case MULTIPLY:
               _loc4_ += "mul " + _totalLightColorReg + ", " + _totalLightColorReg + ", " + _loc6_ + "\n";
               break;
            case ADD:
               _loc4_ += "add " + _totalLightColorReg + ", " + _totalLightColorReg + ", " + _loc6_ + "\n";
         }
         return _loc4_ + super.arcane::getFragmentPostLightingCode(param1,param2,param3);
      }
   }
}

