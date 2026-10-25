package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class WrapDiffuseMethod extends BasicDiffuseMethod
   {
      
      private var _wrapDataRegister:ShaderRegisterElement;
      
      private var _wrapFactor:Number;
      
      public function WrapDiffuseMethod(param1:Number = 0.5)
      {
         super();
         this.wrapFactor = param1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._wrapDataRegister = null;
      }
      
      public function get wrapFactor() : Number
      {
         return this._wrapFactor;
      }
      
      public function set wrapFactor(param1:Number) : void
      {
         this._wrapFactor = param1;
         this._wrapFactor = 1 / (param1 + 1);
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc3_:String = null;
         _loc3_ = super.arcane::getFragmentPreLightingCode(param1,param2);
         _isFirstLight = true;
         this._wrapDataRegister = param2.getFreeFragmentConstant();
         param1.secondaryFragmentConstantsIndex = this._wrapDataRegister.index * 4;
         return _loc3_;
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
         _loc5_ += "dp3 " + _loc6_ + ".x, " + param2 + ".xyz, " + _sharedRegisters.normalFragment + ".xyz\n" + "add " + _loc6_ + ".y, " + _loc6_ + ".x, " + this._wrapDataRegister + ".x\n" + "mul " + _loc6_ + ".y, " + _loc6_ + ".y, " + this._wrapDataRegister + ".y\n" + "sat " + _loc6_ + ".w, " + _loc6_ + ".y\n" + "mul " + _loc6_ + ".xz, " + _loc6_ + ".w, " + param2 + ".wz\n";
         if(_modulateMethod != null)
         {
            _loc5_ += _modulateMethod(param1,_loc6_,param4,_sharedRegisters);
         }
         _loc5_ += "mul " + _loc6_ + ", " + _loc6_ + ".x, " + param3 + "\n";
         if(!_isFirstLight)
         {
            _loc5_ += "add " + _totalLightColorReg + ".xyz, " + _totalLightColorReg + ".xyz, " + _loc6_ + ".xyz\n";
            param4.removeFragmentTempUsage(_loc6_);
         }
         _isFirstLight = false;
         return _loc5_;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:int = param1.secondaryFragmentConstantsIndex;
         var _loc4_:Vector.<Number> = param1.fragmentData;
         _loc4_[_loc3_] = this._wrapFactor;
         _loc4_[_loc3_ + 1] = 1 / (this._wrapFactor + 1);
      }
   }
}

