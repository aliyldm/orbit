package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.lights.LightBase;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class HardShadowMapMethod extends SimpleShadowMapMethodBase
   {
      
      public function HardShadowMapMethod(param1:LightBase)
      {
         super(param1);
      }
      
      override protected function getPlanarFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc5_:ShaderRegisterElement = null;
         var _loc4_:ShaderRegisterElement = param2.getFreeTextureReg();
         _loc5_ = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = _loc6_ = param2.getFreeFragmentConstant();
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc8_:String = "";
         param1.fragmentConstantsIndex = _loc5_.index * 4;
         param1.texturesIndex = _loc4_.index;
         return _loc8_ + ("tex " + _loc7_ + ", " + _depthMapCoordReg + ", " + _loc4_ + " <2d, nearest, clamp>\n" + "dp4 " + _loc7_ + ".z, " + _loc7_ + ", " + _loc5_ + "\n" + "slt " + param3 + ".w, " + _depthMapCoordReg + ".z, " + _loc7_ + ".z\n");
      }
      
      override protected function getPointFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = param2.getFreeTextureReg();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc8_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc8_,1);
         var _loc9_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc10_:String = "";
         param1.fragmentConstantsIndex = _loc5_.index * 4;
         param1.texturesIndex = _loc4_.index;
         _loc10_ += "sub " + _loc9_ + ", " + _sharedRegisters.globalPositionVarying + ", " + _loc7_ + "\n" + "dp3 " + _loc9_ + ".w, " + _loc9_ + ".xyz, " + _loc9_ + ".xyz\n" + "mul " + _loc9_ + ".w, " + _loc9_ + ".w, " + _loc7_ + ".w\n" + "nrm " + _loc9_ + ".xyz, " + _loc9_ + ".xyz\n" + "tex " + _loc8_ + ", " + _loc9_ + ", " + _loc4_ + " <cube, nearest, clamp>\n" + "dp4 " + _loc8_ + ".z, " + _loc8_ + ", " + _loc5_ + "\n" + "add " + param3 + ".w, " + _loc9_ + ".w, " + _loc6_ + ".x\n" + "slt " + param3 + ".w, " + param3 + ".w, " + _loc8_ + ".z\n";
         param2.removeFragmentTempUsage(_loc8_);
         return _loc10_;
      }
      
      override arcane function getCascadeFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterElement, param6:ShaderRegisterElement) : String
      {
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         return "tex " + _loc7_ + ", " + param5 + ", " + param4 + " <2d, nearest, clamp>\n" + "dp4 " + _loc7_ + ".z, " + _loc7_ + ", " + param3 + "\n" + "slt " + param6 + ".w, " + param5 + ".z, " + _loc7_ + ".z\n";
      }
      
      override arcane function activateForCascade(param1:MethodVO, param2:Stage3DProxy) : void
      {
      }
   }
}

