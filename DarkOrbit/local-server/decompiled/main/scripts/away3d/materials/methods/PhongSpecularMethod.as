package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class PhongSpecularMethod extends BasicSpecularMethod
   {
      
      public function PhongSpecularMethod()
      {
         super();
      }
      
      override arcane function getFragmentCodePerLight(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterCache) : String
      {
         var _loc6_:ShaderRegisterElement = null;
         var _loc5_:String = "";
         if(_isFirstLight)
         {
            _loc6_ = _totalLightColorReg;
         }
         else
         {
            _loc6_ = param4.getFreeFragmentVectorTemp();
            param4.addFragmentTempUsages(_loc6_,1);
         }
         var _loc7_:ShaderRegisterElement = _sharedRegisters.viewDirFragment;
         var _loc8_:ShaderRegisterElement = _sharedRegisters.normalFragment;
         _loc5_ += "dp3 " + _loc6_ + ".w, " + param2 + ", " + _loc8_ + "\n" + "add " + _loc6_ + ".w, " + _loc6_ + ".w, " + _loc6_ + ".w\n" + "mul " + _loc6_ + ".xyz, " + _loc8_ + ", " + _loc6_ + ".w\n" + "sub " + _loc6_ + ".xyz, " + _loc6_ + ", " + param2 + "\n" + "add" + _loc6_ + ".w, " + _loc6_ + ".w, " + _sharedRegisters.commons + ".w\n" + "sat " + _loc6_ + ".w, " + _loc6_ + ".w\n" + "mul " + _loc6_ + ".xyz, " + _loc6_ + ", " + _loc6_ + ".w\n" + "dp3 " + _loc6_ + ".w, " + _loc6_ + ", " + _loc7_ + "\n" + "sat " + _loc6_ + ".w, " + _loc6_ + ".w\n";
         if(_useTexture)
         {
            _loc5_ += "mul " + _specularTexData + ".w, " + _specularTexData + ".y, " + _specularDataRegister + ".w\n" + "pow " + _loc6_ + ".w, " + _loc6_ + ".w, " + _specularTexData + ".w\n";
         }
         else
         {
            _loc5_ += "pow " + _loc6_ + ".w, " + _loc6_ + ".w, " + _specularDataRegister + ".w\n";
         }
         if(param1.useLightFallOff)
         {
            _loc5_ += "mul " + _loc6_ + ".w, " + _loc6_ + ".w, " + param2 + ".w\n";
         }
         if(_modulateMethod != null)
         {
            _loc5_ += _modulateMethod(param1,_loc6_,param4,_sharedRegisters);
         }
         _loc5_ += "mul " + _loc6_ + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".w\n";
         if(!_isFirstLight)
         {
            _loc5_ += "add " + _totalLightColorReg + ".xyz, " + _totalLightColorReg + ".xyz, " + _loc6_ + ".xyz\n";
            param4.removeFragmentTempUsage(_loc6_);
         }
         _isFirstLight = false;
         return _loc5_;
      }
   }
}

