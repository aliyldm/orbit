package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class GradientDiffuseMethod extends BasicDiffuseMethod
   {
      
      private var _gradientTextureRegister:ShaderRegisterElement;
      
      private var _gradient:Texture2DBase;
      
      public function GradientDiffuseMethod(param1:Texture2DBase)
      {
         super();
         this._gradient = param1;
      }
      
      public function get gradient() : Texture2DBase
      {
         return this._gradient;
      }
      
      public function set gradient(param1:Texture2DBase) : void
      {
         if(param1.hasMipMaps != this._gradient.hasMipMaps || param1.format != this._gradient.format)
         {
            invalidateShaderProgram();
         }
         this._gradient = param1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._gradientTextureRegister = null;
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc3_:String = super.arcane::getFragmentPreLightingCode(param1,param2);
         _isFirstLight = true;
         if(param1.numLights > 0)
         {
            this._gradientTextureRegister = param2.getFreeTextureReg();
            param1.secondaryTexturesIndex = this._gradientTextureRegister.index;
         }
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
         _loc5_ += "dp3 " + _loc6_ + ".w, " + param2 + ".xyz, " + _sharedRegisters.normalFragment + ".xyz\n" + "mul " + _loc6_ + ".w, " + _loc6_ + ".w, " + _sharedRegisters.commons + ".x\n" + "add " + _loc6_ + ".w, " + _loc6_ + ".w, " + _sharedRegisters.commons + ".x\n" + "mul " + _loc6_ + ".xyz, " + _loc6_ + ".w, " + param2 + ".w\n";
         if(_modulateMethod != null)
         {
            _loc5_ += _modulateMethod(param1,_loc6_,param4,_sharedRegisters);
         }
         _loc5_ += getTex2DSampleCode(param1,_loc6_,this._gradientTextureRegister,this._gradient,_loc6_,"clamp") + "mul " + _loc6_ + ".xyz, " + _loc6_ + ".xyz, " + param3 + ".xyz\n";
         if(!_isFirstLight)
         {
            _loc5_ += "add " + _totalLightColorReg + ".xyz, " + _totalLightColorReg + ".xyz, " + _loc6_ + ".xyz\n";
            param4.removeFragmentTempUsage(_loc6_);
         }
         _isFirstLight = false;
         return _loc5_;
      }
      
      override protected function applyShadow(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc3_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         return "mov " + _loc3_ + ", " + _shadowRegister + ".wwww\n" + getTex2DSampleCode(param1,_loc3_,this._gradientTextureRegister,this._gradient,_loc3_,"clamp") + "mul " + _totalLightColorReg + ".xyz, " + _totalLightColorReg + ", " + _loc3_ + "\n";
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         param2._context3D.setTextureAt(param1.secondaryTexturesIndex,this._gradient.getTextureForStage3D(param2));
      }
   }
}

