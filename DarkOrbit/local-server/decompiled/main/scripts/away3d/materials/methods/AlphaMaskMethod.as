package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class AlphaMaskMethod extends EffectMethodBase
   {
      
      private var _texture:Texture2DBase;
      
      private var _useSecondaryUV:Boolean;
      
      public function AlphaMaskMethod(param1:Texture2DBase, param2:Boolean = false)
      {
         super();
         this._texture = param1;
         this._useSecondaryUV = param2;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsSecondaryUV = this._useSecondaryUV;
         param1.needsUV = !this._useSecondaryUV;
      }
      
      public function get useSecondaryUV() : Boolean
      {
         return this._useSecondaryUV;
      }
      
      public function set useSecondaryUV(param1:Boolean) : void
      {
         if(this._useSecondaryUV == param1)
         {
            return;
         }
         this._useSecondaryUV = param1;
         invalidateShaderProgram();
      }
      
      public function get texture() : Texture2DBase
      {
         return this._texture;
      }
      
      public function set texture(param1:Texture2DBase) : void
      {
         this._texture = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         param2._context3D.setTextureAt(param1.texturesIndex,this._texture.getTextureForStage3D(param2));
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = param2.getFreeTextureReg();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc6_:ShaderRegisterElement = this._useSecondaryUV ? _sharedRegisters.secondaryUVVarying : _sharedRegisters.uvVarying;
         param1.texturesIndex = _loc4_.index;
         return getTex2DSampleCode(param1,_loc5_,_loc4_,this._texture,_loc6_) + "mul " + param3 + ", " + param3 + ", " + _loc5_ + ".x\n";
      }
   }
}

