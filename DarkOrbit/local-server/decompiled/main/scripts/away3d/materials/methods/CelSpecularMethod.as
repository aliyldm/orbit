package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterData;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class CelSpecularMethod extends CompositeSpecularMethod
   {
      
      private var _dataReg:ShaderRegisterElement;
      
      private var _smoothness:Number = 0.1;
      
      private var _specularCutOff:Number = 0.1;
      
      public function CelSpecularMethod(param1:Number = 0.5, param2:BasicSpecularMethod = null)
      {
         super(this.clampSpecular,param2);
         this._specularCutOff = param1;
      }
      
      public function get smoothness() : Number
      {
         return this._smoothness;
      }
      
      public function set smoothness(param1:Number) : void
      {
         this._smoothness = param1;
      }
      
      public function get specularCutOff() : Number
      {
         return this._specularCutOff;
      }
      
      public function set specularCutOff(param1:Number) : void
      {
         this._specularCutOff = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:int = param1.secondaryFragmentConstantsIndex;
         var _loc4_:Vector.<Number> = param1.fragmentData;
         _loc4_[_loc3_] = this._smoothness;
         _loc4_[_loc3_ + 1] = this._specularCutOff;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._dataReg = null;
      }
      
      private function clampSpecular(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterCache, param4:ShaderRegisterData) : String
      {
         param1 = param1;
         param3 = param3;
         param4 = param4;
         return "sub " + param2 + ".y, " + param2 + ".w, " + this._dataReg + ".y\n" + "div " + param2 + ".y, " + param2 + ".y, " + this._dataReg + ".x\n" + "sat " + param2 + ".y, " + param2 + ".y\n" + "sge " + param2 + ".w, " + param2 + ".w, " + this._dataReg + ".y\n" + "mul " + param2 + ".w, " + param2 + ".w, " + param2 + ".y\n";
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         this._dataReg = param2.getFreeFragmentConstant();
         param1.secondaryFragmentConstantsIndex = this._dataReg.index * 4;
         return super.arcane::getFragmentPreLightingCode(param1,param2);
      }
   }
}

