package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterData;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class CelDiffuseMethod extends CompositeDiffuseMethod
   {
      
      private var _levels:uint;
      
      private var _dataReg:ShaderRegisterElement;
      
      private var _smoothness:Number = 0.1;
      
      public function CelDiffuseMethod(param1:uint = 3, param2:BasicDiffuseMethod = null)
      {
         super(this.clampDiffuse,param2);
         this._levels = param1;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         var _loc2_:Vector.<Number> = param1.fragmentData;
         var _loc3_:int = param1.secondaryFragmentConstantsIndex;
         super.arcane::initConstants(param1);
         _loc2_[_loc3_ + 1] = 1;
         _loc2_[_loc3_ + 2] = 0;
      }
      
      public function get levels() : uint
      {
         return this._levels;
      }
      
      public function set levels(param1:uint) : void
      {
         this._levels = param1;
      }
      
      public function get smoothness() : Number
      {
         return this._smoothness;
      }
      
      public function set smoothness(param1:Number) : void
      {
         this._smoothness = param1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._dataReg = null;
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         this._dataReg = param2.getFreeFragmentConstant();
         param1.secondaryFragmentConstantsIndex = this._dataReg.index * 4;
         return super.arcane::getFragmentPreLightingCode(param1,param2);
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:Vector.<Number> = param1.fragmentData;
         var _loc4_:int = param1.secondaryFragmentConstantsIndex;
         _loc3_[_loc4_] = this._levels;
         _loc3_[_loc4_ + 3] = this._smoothness;
      }
      
      private function clampDiffuse(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterCache, param4:ShaderRegisterData) : String
      {
         return "mul " + param2 + ".w, " + param2 + ".w, " + this._dataReg + ".x\n" + "frc " + param2 + ".z, " + param2 + ".w\n" + "sub " + param2 + ".y, " + param2 + ".w, " + param2 + ".z\n" + "mov " + param2 + ".x, " + this._dataReg + ".x\n" + "sub " + param2 + ".x, " + param2 + ".x, " + this._dataReg + ".y\n" + "rcp " + param2 + ".x," + param2 + ".x\n" + "mul " + param2 + ".w, " + param2 + ".y, " + param2 + ".x\n" + "sub " + param2 + ".y, " + param2 + ".w, " + param2 + ".x\n" + "div " + param2 + ".z, " + param2 + ".z, " + this._dataReg + ".w\n" + "sat " + param2 + ".z, " + param2 + ".z\n" + "mul " + param2 + ".w, " + param2 + ".w, " + param2 + ".z\n" + "sub " + param2 + ".z, " + this._dataReg + ".y, " + param2 + ".z\n" + "mul " + param2 + ".y, " + param2 + ".y, " + param2 + ".z\n" + "add " + param2 + ".w, " + param2 + ".w, " + param2 + ".y\n" + "sat " + param2 + ".w, " + param2 + ".w\n";
      }
   }
}

