package away3d.materials.methods
{
   import away3d.*;
   import away3d.cameras.*;
   import away3d.core.base.*;
   import away3d.core.managers.*;
   import away3d.events.*;
   import away3d.lights.*;
   import away3d.lights.shadowmaps.*;
   import away3d.materials.compilation.*;
   import flash.events.*;
   
   use namespace arcane;
   
   public class CascadeShadowMapMethod extends ShadowMapMethodBase
   {
      
      private var _baseMethod:SimpleShadowMapMethodBase;
      
      private var _cascadeShadowMapper:CascadeShadowMapper;
      
      private var _depthMapCoordVaryings:Vector.<ShaderRegisterElement>;
      
      private var _cascadeProjections:Vector.<ShaderRegisterElement>;
      
      public function CascadeShadowMapMethod(param1:SimpleShadowMapMethodBase)
      {
         super(param1.castingLight);
         this._baseMethod = param1;
         if(!(_castingLight is DirectionalLight))
         {
            throw new Error("CascadeShadowMapMethod is only compatible with DirectionalLight");
         }
         this._cascadeShadowMapper = _castingLight.shadowMapper as CascadeShadowMapper;
         if(!this._cascadeShadowMapper)
         {
            throw new Error("CascadeShadowMapMethod requires a light that has a CascadeShadowMapper instance assigned to shadowMapper.");
         }
         this._cascadeShadowMapper.addEventListener(Event.CHANGE,this.onCascadeChange,false,0,true);
         this._baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated,false,0,true);
      }
      
      public function get baseMethod() : SimpleShadowMapMethodBase
      {
         return this._baseMethod;
      }
      
      public function set baseMethod(param1:SimpleShadowMapMethodBase) : void
      {
         if(this._baseMethod == param1)
         {
            return;
         }
         this._baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this._baseMethod = param1;
         this._baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated,false,0,true);
         invalidateShaderProgram();
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         var _loc2_:MethodVO = new MethodVO();
         this._baseMethod.initVO(_loc2_);
         param1.needsGlobalVertexPos = true;
         param1.needsProjection = true;
      }
      
      override arcane function set sharedRegisters(param1:ShaderRegisterData) : void
      {
         super.arcane::sharedRegisters = param1;
         this._baseMethod.sharedRegisters = param1;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         var _loc2_:Vector.<Number> = param1.fragmentData;
         var _loc3_:Vector.<Number> = param1.vertexData;
         var _loc4_:int = param1.fragmentConstantsIndex;
         _loc2_[_loc4_] = 1;
         _loc2_[_loc4_ + 1] = 1 / 255;
         _loc2_[_loc4_ + 2] = 1 / 65025;
         _loc2_[_loc4_ + 3] = 1 / 16581375;
         _loc2_[_loc4_ + 6] = 0.5;
         _loc2_[_loc4_ + 7] = -0.5;
         _loc4_ = param1.vertexConstantsIndex;
         _loc3_[_loc4_] = 0.5;
         _loc3_[_loc4_ + 1] = -0.5;
         _loc3_[_loc4_ + 2] = 0;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._cascadeProjections = null;
         this._depthMapCoordVaryings = null;
      }
      
      override arcane function getVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc3_:String = "";
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexConstant();
         this.initProjectionsRegs(param2);
         param1.vertexConstantsIndex = _loc4_.index * 4;
         var _loc5_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc6_:int = 0;
         while(_loc6_ < this._cascadeShadowMapper.numCascades)
         {
            _loc3_ += "m44 " + _loc5_ + ", " + _sharedRegisters.globalPositionVertex + ", " + this._cascadeProjections[_loc6_] + "\n" + "add " + this._depthMapCoordVaryings[_loc6_] + ", " + _loc5_ + ", " + _loc4_ + ".zzwz\n";
            _loc6_++;
         }
         return _loc3_;
      }
      
      private function initProjectionsRegs(param1:ShaderRegisterCache) : void
      {
         this._cascadeProjections = new Vector.<ShaderRegisterElement>(this._cascadeShadowMapper.numCascades);
         this._depthMapCoordVaryings = new Vector.<ShaderRegisterElement>(this._cascadeShadowMapper.numCascades);
         var _loc2_:int = 0;
         while(_loc2_ < this._cascadeShadowMapper.numCascades)
         {
            this._depthMapCoordVaryings[_loc2_] = param1.getFreeVarying();
            this._cascadeProjections[_loc2_] = param1.getFreeVertexConstant();
            param1.getFreeVertexConstant();
            param1.getFreeVertexConstant();
            param1.getFreeVertexConstant();
            _loc2_++;
         }
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc10_:String = null;
         var _loc14_:ShaderRegisterElement = null;
         var _loc15_:ShaderRegisterElement = null;
         var _loc4_:int = this._cascadeShadowMapper.numCascades;
         var _loc5_:ShaderRegisterElement = param2.getFreeTextureReg();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc8_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc9_:Vector.<String> = new <String>[_loc8_ + ".x",_loc8_ + ".y",_loc8_ + ".z",_loc8_ + ".w"];
         param1.fragmentConstantsIndex = _loc6_.index * 4;
         param1.texturesIndex = _loc5_.index;
         var _loc11_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc11_,1);
         var _loc12_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc12_,1);
         _loc10_ = "mov " + _loc12_ + ", " + this._depthMapCoordVaryings[_loc4_ - 1] + "\n";
         var _loc13_:* = int(_loc4_ - 2);
         while(_loc13_ >= 0)
         {
            _loc14_ = this._depthMapCoordVaryings[_loc13_];
            _loc10_ += "slt " + _loc11_ + ".z, " + _sharedRegisters.projectionFragment + ".z, " + _loc9_[_loc13_] + "\n";
            _loc15_ = param2.getFreeFragmentVectorTemp();
            _loc10_ += "sub " + _loc15_ + ", " + _loc14_ + ", " + _loc12_ + "\n" + "mul " + _loc15_ + ", " + _loc15_ + ", " + _loc11_ + ".z\n" + "add " + _loc12_ + ", " + _loc12_ + ", " + _loc15_ + "\n";
            _loc13_--;
         }
         param2.removeFragmentTempUsage(_loc11_);
         _loc10_ += "div " + _loc12_ + ", " + _loc12_ + ", " + _loc12_ + ".w\n" + "mul " + _loc12_ + ".xy, " + _loc12_ + ".xy, " + _loc7_ + ".zw\n" + "add " + _loc12_ + ".xy, " + _loc12_ + ".xy, " + _loc7_ + ".zz\n";
         _loc10_ = _loc10_ + (this._baseMethod.getCascadeFragmentCode(param1,param2,_loc6_,_loc5_,_loc12_,param3) + "add " + param3 + ".w, " + param3 + ".w, " + _loc7_ + ".y\n");
         param2.removeFragmentTempUsage(_loc12_);
         return _loc10_;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         param2._context3D.setTextureAt(param1.texturesIndex,_castingLight.shadowMapper.depthMap.getTextureForStage3D(param2));
         var _loc3_:Vector.<Number> = param1.vertexData;
         var _loc4_:int = param1.vertexConstantsIndex;
         param1.vertexData[param1.vertexConstantsIndex + 3] = -1 / (this._cascadeShadowMapper.depth * _epsilon);
         var _loc5_:int = this._cascadeShadowMapper.numCascades;
         _loc4_ += 4;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            this._cascadeShadowMapper.getDepthProjections(_loc6_).copyRawDataTo(_loc3_,_loc4_,true);
            _loc4_ += 16;
            _loc6_++;
         }
         var _loc7_:Vector.<Number> = param1.fragmentData;
         var _loc8_:int = param1.fragmentConstantsIndex;
         _loc7_[uint(_loc8_ + 5)] = 1 - _alpha;
         var _loc9_:Vector.<Number> = this._cascadeShadowMapper.nearPlaneDistances;
         _loc8_ += 8;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc5_)
         {
            _loc7_[uint(_loc8_ + _loc10_)] = _loc9_[_loc10_];
            _loc10_++;
         }
         this._baseMethod.activateForCascade(param1,param2);
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
      }
      
      private function onCascadeChange(param1:Event) : void
      {
         invalidateShaderProgram();
      }
      
      private function onShaderInvalidated(param1:ShadingMethodEvent) : void
      {
         invalidateShaderProgram();
      }
   }
}

