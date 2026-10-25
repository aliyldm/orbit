package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.CubeTextureBase;
   import away3d.textures.Texture2DBase;
   import flash.display3D.Context3D;
   
   use namespace arcane;
   
   public class FresnelEnvMapMethod extends EffectMethodBase
   {
      
      private var _cubeTexture:CubeTextureBase;
      
      private var _fresnelPower:Number = 5;
      
      private var _normalReflectance:Number = 0;
      
      private var _alpha:Number;
      
      private var _mask:Texture2DBase;
      
      public function FresnelEnvMapMethod(param1:CubeTextureBase, param2:Number = 1)
      {
         super();
         this._cubeTexture = param1;
         this._alpha = param2;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsNormals = true;
         param1.needsView = true;
         param1.needsUV = this._mask != null;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         param1.fragmentData[param1.fragmentConstantsIndex + 3] = 1;
      }
      
      public function get mask() : Texture2DBase
      {
         return this._mask;
      }
      
      public function set mask(param1:Texture2DBase) : void
      {
         if(Boolean(param1) != Boolean(this._mask) || Boolean(param1 && this._mask) && (Boolean(param1.hasMipMaps != this._mask.hasMipMaps || param1.format != this._mask.format)))
         {
            invalidateShaderProgram();
         }
         this._mask = param1;
      }
      
      public function get fresnelPower() : Number
      {
         return this._fresnelPower;
      }
      
      public function set fresnelPower(param1:Number) : void
      {
         this._fresnelPower = param1;
      }
      
      public function get envMap() : CubeTextureBase
      {
         return this._cubeTexture;
      }
      
      public function set envMap(param1:CubeTextureBase) : void
      {
         this._cubeTexture = param1;
      }
      
      override public function dispose() : void
      {
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha = param1;
      }
      
      public function get normalReflectance() : Number
      {
         return this._normalReflectance;
      }
      
      public function set normalReflectance(param1:Number) : void
      {
         this._normalReflectance = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:Vector.<Number> = param1.fragmentData;
         var _loc4_:int = param1.fragmentConstantsIndex;
         var _loc5_:Context3D = param2._context3D;
         _loc3_[_loc4_] = this._alpha;
         _loc3_[_loc4_ + 1] = this._normalReflectance;
         _loc3_[_loc4_ + 2] = this._fresnelPower;
         _loc5_.setTextureAt(param1.texturesIndex,this._cubeTexture.getTextureForStage3D(param2));
         if(this._mask)
         {
            _loc5_.setTextureAt(param1.texturesIndex + 1,this._mask.getTextureForStage3D(param2));
         }
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc11_:ShaderRegisterElement = null;
         var _loc4_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc6_:String = "";
         var _loc7_:ShaderRegisterElement = param2.getFreeTextureReg();
         var _loc8_:ShaderRegisterElement = _sharedRegisters.viewDirFragment;
         var _loc9_:ShaderRegisterElement = _sharedRegisters.normalFragment;
         param1.texturesIndex = _loc7_.index;
         param1.fragmentConstantsIndex = _loc4_.index * 4;
         param2.addFragmentTempUsages(_loc5_,1);
         var _loc10_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         _loc6_ += "dp3 " + _loc5_ + ".w, " + _loc8_ + ".xyz, " + _loc9_ + ".xyz\t\t\n" + "add " + _loc5_ + ".w, " + _loc5_ + ".w, " + _loc5_ + ".w\t\t\t\t\t\t\t\t\t\t\t\n" + "mul " + _loc5_ + ".xyz, " + _loc9_ + ".xyz, " + _loc5_ + ".w\t\t\t\t\t\t\n" + "sub " + _loc5_ + ".xyz, " + _loc5_ + ".xyz, " + _loc8_ + ".xyz\t\t\t\t\t\n" + getTexCubeSampleCode(param1,_loc5_,_loc7_,this._cubeTexture,_loc5_) + "sub " + _loc10_ + ".w, " + _loc5_ + ".w, fc0.x\t\t\t\t\t\t\t\t\t\n" + "kil " + _loc10_ + ".w\n" + "sub " + _loc5_ + ", " + _loc5_ + ", " + param3 + "\t\t\t\t\t\t\t\t\t\t\t\n";
         _loc6_ = _loc6_ + ("dp3 " + _loc8_ + ".w, " + _loc8_ + ".xyz, " + _loc9_ + ".xyz\n" + "sub " + _loc8_ + ".w, " + _loc4_ + ".w, " + _loc8_ + ".w\n" + "pow " + _loc8_ + ".w, " + _loc8_ + ".w, " + _loc4_ + ".z\n" + "sub " + _loc9_ + ".w, " + _loc4_ + ".w, " + _loc8_ + ".w\n" + "mul " + _loc9_ + ".w, " + _loc4_ + ".y, " + _loc9_ + ".w\n" + "add " + _loc8_ + ".w, " + _loc8_ + ".w, " + _loc9_ + ".w\n" + "mul " + _loc8_ + ".w, " + _loc4_ + ".x, " + _loc8_ + ".w\n");
         if(this._mask)
         {
            _loc11_ = param2.getFreeTextureReg();
            _loc6_ += getTex2DSampleCode(param1,_loc10_,_loc11_,this._mask,_sharedRegisters.uvVarying) + "mul " + _loc8_ + ".w, " + _loc10_ + ".x, " + _loc8_ + ".w\n";
         }
         _loc6_ += "mul " + _loc5_ + ", " + _loc5_ + ", " + _loc8_ + ".w\t\t\t\t\t\t\n" + "add " + param3 + ", " + param3 + ", " + _loc5_ + "\t\t\t\t\t\t\n";
         param2.removeFragmentTempUsage(_loc5_);
         return _loc6_;
      }
   }
}

