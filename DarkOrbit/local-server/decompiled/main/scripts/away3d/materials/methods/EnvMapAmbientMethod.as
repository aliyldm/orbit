package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.CubeTextureBase;
   
   use namespace arcane;
   
   public class EnvMapAmbientMethod extends BasicAmbientMethod
   {
      
      private var _cubeTexture:CubeTextureBase;
      
      public function EnvMapAmbientMethod(param1:CubeTextureBase)
      {
         super();
         this._cubeTexture = param1;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         super.arcane::initVO(param1);
         param1.needsNormals = true;
      }
      
      override public function dispose() : void
      {
      }
      
      public function get envMap() : CubeTextureBase
      {
         return this._cubeTexture;
      }
      
      public function set envMap(param1:CubeTextureBase) : void
      {
         this._cubeTexture = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         param2._context3D.setTextureAt(param1.texturesIndex,this._cubeTexture.getTextureForStage3D(param2));
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:String = "";
         var _loc5_:ShaderRegisterElement = param2.getFreeTextureReg();
         param1.texturesIndex = _loc5_.index;
         _loc4_ += getTexCubeSampleCode(param1,param3,_loc5_,this._cubeTexture,_sharedRegisters.normalFragment);
         _ambientInputRegister = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _ambientInputRegister.index;
         return _loc4_ + ("add " + param3 + ".xyz, " + param3 + ".xyz, " + _ambientInputRegister + ".xyz\n");
      }
   }
}

