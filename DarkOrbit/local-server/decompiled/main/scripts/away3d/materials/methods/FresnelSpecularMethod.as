package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterData;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class FresnelSpecularMethod extends CompositeSpecularMethod
   {
      
      private var _dataReg:ShaderRegisterElement;
      
      private var _incidentLight:Boolean;
      
      private var _fresnelPower:Number = 5;
      
      private var _normalReflectance:Number = 0.028;
      
      public function FresnelSpecularMethod(param1:Boolean = true, param2:BasicSpecularMethod = null)
      {
         super(this.modulateSpecular,param2);
         this._incidentLight = !param1;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         var _loc2_:int = param1.secondaryFragmentConstantsIndex;
         param1.fragmentData[_loc2_ + 2] = 1;
         param1.fragmentData[_loc2_ + 3] = 0;
      }
      
      public function get basedOnSurface() : Boolean
      {
         return !this._incidentLight;
      }
      
      public function set basedOnSurface(param1:Boolean) : void
      {
         if(this._incidentLight != param1)
         {
            return;
         }
         this._incidentLight = !param1;
         invalidateShaderProgram();
      }
      
      public function get fresnelPower() : Number
      {
         return this._fresnelPower;
      }
      
      public function set fresnelPower(param1:Number) : void
      {
         this._fresnelPower = param1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._dataReg = null;
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
         super.arcane::activate(param1,param2);
         var _loc3_:Vector.<Number> = param1.fragmentData;
         var _loc4_:int = param1.secondaryFragmentConstantsIndex;
         _loc3_[_loc4_] = this._normalReflectance;
         _loc3_[_loc4_ + 1] = this._fresnelPower;
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         this._dataReg = param2.getFreeFragmentConstant();
         param1.secondaryFragmentConstantsIndex = this._dataReg.index * 4;
         return super.arcane::getFragmentPreLightingCode(param1,param2);
      }
      
      private function modulateSpecular(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterCache, param4:ShaderRegisterData) : String
      {
         var _loc5_:String = null;
         return "dp3 " + param2 + ".y, " + param4.viewDirFragment + ".xyz, " + (this._incidentLight ? param2 + ".xyz\n" : param4.normalFragment + ".xyz\n") + "sub " + param2 + ".y, " + this._dataReg + ".z, " + param2 + ".y\n" + "pow " + param2 + ".x, " + param2 + ".y, " + this._dataReg + ".y\n" + "sub " + param2 + ".y, " + this._dataReg + ".z, " + param2 + ".y\n" + "mul " + param2 + ".y, " + this._dataReg + ".x, " + param2 + ".y\n" + "add " + param2 + ".y, " + param2 + ".x, " + param2 + ".y\n" + "mul " + param2 + ".w, " + param2 + ".w, " + param2 + ".y\n";
      }
   }
}

