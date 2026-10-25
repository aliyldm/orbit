package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterData;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.passes.MaterialPassBase;
   import away3d.materials.passes.SingleObjectDepthPass;
   import flash.display3D.textures.Texture;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class SubsurfaceScatteringDiffuseMethod extends CompositeDiffuseMethod
   {
      
      private var _depthPass:SingleObjectDepthPass;
      
      private var _lightProjVarying:ShaderRegisterElement;
      
      private var _propReg:ShaderRegisterElement;
      
      private var _scattering:Number;
      
      private var _translucency:Number = 1;
      
      private var _lightColorReg:ShaderRegisterElement;
      
      private var _scatterColor:uint = 16777215;
      
      private var _colorReg:ShaderRegisterElement;
      
      private var _decReg:ShaderRegisterElement;
      
      private var _scatterR:Number = 1;
      
      private var _scatterG:Number = 1;
      
      private var _scatterB:Number = 1;
      
      private var _targetReg:ShaderRegisterElement;
      
      public function SubsurfaceScatteringDiffuseMethod(param1:int = 512, param2:Number = 15)
      {
         super(this.scatterLight);
         _passes = new Vector.<MaterialPassBase>();
         this._depthPass = new SingleObjectDepthPass(param1,param2);
         _passes.push(this._depthPass);
         this._scattering = 0.2;
         this._translucency = 1;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         super.arcane::initConstants(param1);
         var _loc2_:Vector.<Number> = param1.vertexData;
         var _loc3_:int = param1.secondaryVertexConstantsIndex;
         _loc2_[_loc3_] = 0.5;
         _loc2_[_loc3_ + 1] = -0.5;
         _loc2_[_loc3_ + 2] = 0;
         _loc2_[_loc3_ + 3] = 1;
         _loc2_ = param1.fragmentData;
         _loc3_ = param1.secondaryFragmentConstantsIndex;
         _loc2_[_loc3_ + 3] = 1;
         _loc2_[_loc3_ + 4] = 1;
         _loc2_[_loc3_ + 5] = 1 / 255;
         _loc2_[_loc3_ + 6] = 1 / 65025;
         _loc2_[_loc3_ + 7] = 1 / 16581375;
         _loc2_[_loc3_ + 10] = 0.5;
         _loc2_[_loc3_ + 11] = -0.1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._lightProjVarying = null;
         this._propReg = null;
         this._lightColorReg = null;
         this._colorReg = null;
         this._decReg = null;
         this._targetReg = null;
      }
      
      public function get scattering() : Number
      {
         return this._scattering;
      }
      
      public function set scattering(param1:Number) : void
      {
         this._scattering = param1;
      }
      
      public function get translucency() : Number
      {
         return this._translucency;
      }
      
      public function set translucency(param1:Number) : void
      {
         this._translucency = param1;
      }
      
      public function get scatterColor() : uint
      {
         return this._scatterColor;
      }
      
      public function set scatterColor(param1:uint) : void
      {
         this._scatterColor = param1;
         this._scatterR = (param1 >> 16 & 0xFF) / 255;
         this._scatterG = (param1 >> 8 & 0xFF) / 255;
         this._scatterB = (param1 & 0xFF) / 255;
      }
      
      override arcane function getVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:ShaderRegisterElement = null;
         var _loc3_:String = super.arcane::getVertexCode(param1,param2);
         var _loc6_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         _loc5_ = param2.getFreeVertexConstant();
         param1.secondaryVertexConstantsIndex = _loc5_.index * 4;
         this._lightProjVarying = param2.getFreeVarying();
         _loc4_ = param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         return _loc3_ + ("m44 " + _loc6_ + ", vt0, " + _loc4_ + "\n" + "div " + _loc6_ + ".xyz, " + _loc6_ + ".xyz, " + _loc6_ + ".w\n" + "mul " + _loc6_ + ".xy, " + _loc6_ + ".xy, " + _loc5_ + ".xy\n" + "add " + _loc6_ + ".xy, " + _loc6_ + ".xy, " + _loc5_ + ".xx\n" + "mov " + this._lightProjVarying + ".xyz, " + _loc6_ + ".xyz\n" + "mov " + this._lightProjVarying + ".w, va0.w\n");
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         this._colorReg = param2.getFreeFragmentConstant();
         this._decReg = param2.getFreeFragmentConstant();
         this._propReg = param2.getFreeFragmentConstant();
         param1.secondaryFragmentConstantsIndex = this._colorReg.index * 4;
         return super.arcane::getFragmentPreLightingCode(param1,param2);
      }
      
      override arcane function getFragmentCodePerLight(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterCache) : String
      {
         _isFirstLight = true;
         this._lightColorReg = param3;
         return super.arcane::getFragmentCodePerLight(param1,param2,param3,param4);
      }
      
      override arcane function getFragmentPostLightingCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:String = super.arcane::getFragmentPostLightingCode(param1,param2,param3);
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         _loc4_ += "mul " + _loc5_ + ".xyz, " + this._lightColorReg + ".xyz, " + this._targetReg + ".w\n" + "mul " + _loc5_ + ".xyz, " + _loc5_ + ".xyz, " + this._colorReg + ".xyz\n" + "add " + param3 + ".xyz, " + param3 + ".xyz, " + _loc5_ + ".xyz\n";
         if(this._targetReg != _sharedRegisters.viewDirFragment)
         {
            param2.removeFragmentTempUsage(param3);
         }
         return _loc4_;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:int = param1.secondaryFragmentConstantsIndex;
         var _loc4_:Vector.<Number> = param1.fragmentData;
         _loc4_[_loc3_] = this._scatterR;
         _loc4_[_loc3_ + 1] = this._scatterG;
         _loc4_[_loc3_ + 2] = this._scatterB;
         _loc4_[_loc3_ + 8] = this._scattering;
         _loc4_[_loc3_ + 9] = this._translucency;
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
         var _loc5_:Texture = this._depthPass.getDepthMap(param2,param3);
         var _loc6_:Matrix3D = this._depthPass.getProjection(param2);
         param3._context3D.setTextureAt(param1.secondaryTexturesIndex,_loc5_);
         _loc6_.copyRawDataTo(param1.vertexData,param1.secondaryVertexConstantsIndex + 4,true);
      }
      
      private function scatterLight(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterCache, param4:ShaderRegisterData) : String
      {
         if(!_isFirstLight)
         {
            return "";
         }
         _isFirstLight = false;
         var _loc5_:String = "";
         var _loc6_:ShaderRegisterElement = param3.getFreeTextureReg();
         if(param4.viewDirFragment)
         {
            this._targetReg = param4.viewDirFragment;
         }
         else
         {
            this._targetReg = param3.getFreeFragmentVectorTemp();
            param3.addFragmentTempUsages(this._targetReg,1);
         }
         param1.secondaryTexturesIndex = _loc6_.index;
         var _loc7_:ShaderRegisterElement = param3.getFreeFragmentVectorTemp();
         _loc5_ += "tex " + _loc7_ + ", " + this._lightProjVarying + ", " + _loc6_ + " <2d,nearest,clamp>\n" + "dp4 " + param2 + ".z, " + _loc7_ + ", " + this._decReg + "\n";
         return _loc5_ + ("sub " + param2 + ".z, " + this._lightProjVarying + ".z, " + param2 + ".z\n" + "sub " + param2 + ".z, " + this._propReg + ".x, " + param2 + ".z\n" + "mul " + param2 + ".z, " + this._propReg + ".y, " + param2 + ".z\n" + "sat " + param2 + ".z, " + param2 + ".z\n" + "neg " + param2 + ".y, " + param2 + ".x\n" + "mul " + param2 + ".y, " + param2 + ".y, " + this._propReg + ".z\n" + "add " + param2 + ".y, " + param2 + ".y, " + this._propReg + ".z\n" + "mul " + this._targetReg + ".w, " + param2 + ".z, " + param2 + ".y\n" + "sub " + param2 + ".y, " + this._colorReg + ".w, " + this._targetReg + ".w\n" + "mul " + param2 + ".w, " + param2 + ".w, " + param2 + ".y\n");
      }
   }
}

