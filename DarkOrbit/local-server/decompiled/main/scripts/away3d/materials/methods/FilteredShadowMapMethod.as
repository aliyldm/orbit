package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.lights.DirectionalLight;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class FilteredShadowMapMethod extends SimpleShadowMapMethodBase
   {
      
      public function FilteredShadowMapMethod(param1:DirectionalLight)
      {
         super(param1);
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         super.arcane::initConstants(param1);
         var _loc2_:Vector.<Number> = param1.fragmentData;
         var _loc3_:int = param1.fragmentConstantsIndex;
         _loc2_[_loc3_ + 8] = 0.5;
         var _loc4_:int = int(castingLight.shadowMapper.depthMapSize);
         _loc2_[_loc3_ + 9] = _loc4_;
         _loc2_[_loc3_ + 10] = 1 / _loc4_;
      }
      
      override protected function getPlanarFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc9_:ShaderRegisterElement = null;
         _loc4_ = param2.getFreeTextureReg();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = _loc6_ = param2.getFreeFragmentConstant();
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc8_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc10_:String = "";
         param1.fragmentConstantsIndex = _loc5_.index * 4;
         param2.addFragmentTempUsages(_loc8_,1);
         _loc9_ = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc9_,1);
         _loc10_ += "mov " + _loc9_ + ", " + _depthMapCoordReg + "\n" + "tex " + _loc8_ + ", " + _depthMapCoordReg + ", " + _loc4_ + " <2d, nearest, clamp>\n" + "dp4 " + _loc8_ + ".z, " + _loc8_ + ", " + _loc5_ + "\n" + "slt " + _loc9_ + ".z, " + _depthMapCoordReg + ".z, " + _loc8_ + ".z\n" + "add " + _loc9_ + ".x, " + _depthMapCoordReg + ".x, " + _loc7_ + ".z\n" + "tex " + _loc8_ + ", " + _loc9_ + ", " + _loc4_ + " <2d, nearest, clamp>\n" + "dp4 " + _loc8_ + ".z, " + _loc8_ + ", " + _loc5_ + "\n" + "slt " + _loc9_ + ".w, " + _depthMapCoordReg + ".z, " + _loc8_ + ".z\n" + "mul " + _loc8_ + ".x, " + _depthMapCoordReg + ".x, " + _loc7_ + ".y\n" + "frc " + _loc8_ + ".x, " + _loc8_ + ".x\n" + "sub " + _loc9_ + ".w, " + _loc9_ + ".w, " + _loc9_ + ".z\n" + "mul " + _loc9_ + ".w, " + _loc9_ + ".w, " + _loc8_ + ".x\n" + "add " + param3 + ".w, " + _loc9_ + ".z, " + _loc9_ + ".w\n" + "mov " + _loc9_ + ".x, " + _depthMapCoordReg + ".x\n" + "add " + _loc9_ + ".y, " + _depthMapCoordReg + ".y, " + _loc7_ + ".z\n" + "tex " + _loc8_ + ", " + _loc9_ + ", " + _loc4_ + " <2d, nearest, clamp>\n" + "dp4 " + _loc8_ + ".z, " + _loc8_ + ", " + _loc5_ + "\n" + "slt " + _loc9_ + ".z, " + _depthMapCoordReg + ".z, " + _loc8_ + ".z\n" + "add " + _loc9_ + ".x, " + _depthMapCoordReg + ".x, " + _loc7_ + ".z\n" + "tex " + _loc8_ + ", " + _loc9_ + ", " + _loc4_ + " <2d, nearest, clamp>\n" + "dp4 " + _loc8_ + ".z, " + _loc8_ + ", " + _loc5_ + "\n" + "slt " + _loc9_ + ".w, " + _depthMapCoordReg + ".z, " + _loc8_ + ".z\n" + "mul " + _loc8_ + ".x, " + _depthMapCoordReg + ".x, " + _loc7_ + ".y\n" + "frc " + _loc8_ + ".x, " + _loc8_ + ".x\n" + "sub " + _loc9_ + ".w, " + _loc9_ + ".w, " + _loc9_ + ".z\n" + "mul " + _loc9_ + ".w, " + _loc9_ + ".w, " + _loc8_ + ".x\n" + "add " + _loc9_ + ".w, " + _loc9_ + ".z, " + _loc9_ + ".w\n" + "mul " + _loc8_ + ".x, " + _depthMapCoordReg + ".y, " + _loc7_ + ".y\n" + "frc " + _loc8_ + ".x, " + _loc8_ + ".x\n" + "sub " + _loc9_ + ".w, " + _loc9_ + ".w, " + param3 + ".w\n" + "mul " + _loc9_ + ".w, " + _loc9_ + ".w, " + _loc8_ + ".x\n" + "add " + param3 + ".w, " + param3 + ".w, " + _loc9_ + ".w\n";
         param2.removeFragmentTempUsage(_loc8_);
         param2.removeFragmentTempUsage(_loc9_);
         param1.texturesIndex = _loc4_.index;
         return _loc10_;
      }
      
      override arcane function activateForCascade(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:int = int(_castingLight.shadowMapper.depthMapSize);
         var _loc4_:int = param1.secondaryFragmentConstantsIndex;
         var _loc5_:Vector.<Number> = param1.fragmentData;
         _loc5_[_loc4_] = _loc3_;
         _loc5_[_loc4_ + 1] = 1 / _loc3_;
      }
      
      override arcane function getCascadeFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterElement, param6:ShaderRegisterElement) : String
      {
         var _loc7_:String = null;
         var _loc8_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         param1.secondaryFragmentConstantsIndex = _loc8_.index * 4;
         var _loc9_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc9_,1);
         var _loc10_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc10_,1);
         _loc7_ = "tex " + _loc9_ + ", " + param5 + ", " + param4 + " <2d, nearest, clamp>\n" + "dp4 " + _loc9_ + ".z, " + _loc9_ + ", " + param3 + "\n" + "slt " + _loc10_ + ".x, " + param5 + ".z, " + _loc9_ + ".z\n" + "add " + param5 + ".x, " + param5 + ".x, " + _loc8_ + ".y\n" + "tex " + _loc9_ + ", " + param5 + ", " + param4 + " <2d, nearest, clamp>\n" + "dp4 " + _loc9_ + ".z, " + _loc9_ + ", " + param3 + "\n" + "slt " + _loc10_ + ".z, " + param5 + ".z, " + _loc9_ + ".z\n" + "add " + param5 + ".y, " + param5 + ".y, " + _loc8_ + ".y\n" + "tex " + _loc9_ + ", " + param5 + ", " + param4 + " <2d, nearest, clamp>\n" + "dp4 " + _loc9_ + ".z, " + _loc9_ + ", " + param3 + "\n" + "slt " + _loc10_ + ".w, " + param5 + ".z, " + _loc9_ + ".z\n" + "sub " + param5 + ".x, " + param5 + ".x, " + _loc8_ + ".y\n" + "tex " + _loc9_ + ", " + param5 + ", " + param4 + " <2d, nearest, clamp>\n" + "dp4 " + _loc9_ + ".z, " + _loc9_ + ", " + param3 + "\n" + "slt " + _loc10_ + ".y, " + param5 + ".z, " + _loc9_ + ".z\n" + "mul " + _loc9_ + ".xy, " + param5 + ".xy, " + _loc8_ + ".x\n" + "frc " + _loc9_ + ".xy, " + _loc9_ + ".xy\n" + "sub " + param5 + ", " + _loc10_ + ".xyzw, " + _loc10_ + ".zwxy\n" + "mul " + param5 + ", " + param5 + ", " + _loc9_ + ".x\n" + "add " + _loc10_ + ".xy, " + _loc10_ + ".xy, " + param5 + ".zw\n" + "sub " + _loc10_ + ".y, " + _loc10_ + ".y, " + _loc10_ + ".x\n" + "mul " + _loc10_ + ".y, " + _loc10_ + ".y, " + _loc9_ + ".y\n" + "add " + param6 + ".w, " + _loc10_ + ".x, " + _loc10_ + ".y\n";
         param2.removeFragmentTempUsage(_loc9_);
         param2.removeFragmentTempUsage(_loc10_);
         return _loc7_;
      }
   }
}

