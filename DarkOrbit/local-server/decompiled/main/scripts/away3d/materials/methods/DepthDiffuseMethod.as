package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class DepthDiffuseMethod extends BasicDiffuseMethod
   {
      
      public function DepthDiffuseMethod()
      {
         super();
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         var _loc2_:Vector.<Number> = param1.fragmentData;
         var _loc3_:int = param1.fragmentConstantsIndex;
         _loc2_[_loc3_] = 1;
         _loc2_[_loc3_ + 1] = 1 / 255;
         _loc2_[_loc3_ + 2] = 1 / 65025;
         _loc2_[_loc3_ + 3] = 1 / 16581375;
      }
      
      override arcane function getFragmentPostLightingCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc5_:ShaderRegisterElement = null;
         var _loc6_:ShaderRegisterElement = null;
         var _loc4_:String = "";
         if(!_useTexture)
         {
            throw new Error("DepthDiffuseMethod requires texture!");
         }
         if(param1.numLights > 0)
         {
            if(_shadowRegister)
            {
               _loc4_ += "mul " + _totalLightColorReg + ".xyz, " + _totalLightColorReg + ".xyz, " + _shadowRegister + ".w\n";
            }
            _loc4_ += "add " + param3 + ".xyz, " + _totalLightColorReg + ".xyz, " + param3 + ".xyz\n" + "sat " + param3 + ".xyz, " + param3 + ".xyz\n";
            param2.removeFragmentTempUsage(_totalLightColorReg);
         }
         _loc5_ = param1.numLights > 0 ? param2.getFreeFragmentVectorTemp() : param3;
         _diffuseInputRegister = param2.getFreeTextureReg();
         param1.texturesIndex = _diffuseInputRegister.index;
         _loc6_ = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _loc6_.index * 4;
         _loc4_ += getTex2DSampleCode(param1,_loc5_,_diffuseInputRegister,texture) + "dp4 " + _loc5_ + ".x, " + _loc5_ + ", " + _loc6_ + "\n" + "mov " + _loc5_ + ".yz, " + _loc5_ + ".xx\t\t\t\n" + "mov " + _loc5_ + ".w, " + _loc6_ + ".x\n" + "sub " + _loc5_ + ".xyz, " + _loc6_ + ".xxx, " + _loc5_ + ".xyz\n";
         if(param1.numLights == 0)
         {
            return _loc4_;
         }
         return _loc4_ + ("mul " + param3 + ".xyz, " + _loc5_ + ".xyz, " + param3 + ".xyz\n" + "mov " + param3 + ".w, " + _loc5_ + ".w\n");
      }
   }
}

