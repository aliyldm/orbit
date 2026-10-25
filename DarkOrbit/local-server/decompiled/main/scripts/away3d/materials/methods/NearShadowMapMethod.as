package away3d.materials.methods
{
   import away3d.*;
   import away3d.cameras.*;
   import away3d.core.base.*;
   import away3d.core.managers.*;
   import away3d.events.*;
   import away3d.lights.shadowmaps.*;
   import away3d.materials.compilation.*;
   
   use namespace arcane;
   
   public class NearShadowMapMethod extends SimpleShadowMapMethodBase
   {
      
      private var _baseMethod:SimpleShadowMapMethodBase;
      
      private var _fadeRatio:Number;
      
      private var _nearShadowMapper:NearDirectionalShadowMapper;
      
      public function NearShadowMapMethod(param1:SimpleShadowMapMethodBase, param2:Number = 0.1)
      {
         super(param1.castingLight);
         this._baseMethod = param1;
         this._fadeRatio = param2;
         this._nearShadowMapper = _castingLight.shadowMapper as NearDirectionalShadowMapper;
         if(!this._nearShadowMapper)
         {
            throw new Error("NearShadowMapMethod requires a light that has a NearDirectionalShadowMapper instance assigned to shadowMapper.");
         }
         this._baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
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
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         super.arcane::initConstants(param1);
         this._baseMethod.initConstants(param1);
         var _loc2_:Vector.<Number> = param1.fragmentData;
         var _loc3_:int = param1.secondaryFragmentConstantsIndex;
         _loc2_[_loc3_ + 2] = 0;
         _loc2_[_loc3_ + 3] = 1;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         this._baseMethod.initVO(param1);
         param1.needsProjection = true;
      }
      
      override public function dispose() : void
      {
         this._baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
      }
      
      override public function get alpha() : Number
      {
         return this._baseMethod.alpha;
      }
      
      override public function set alpha(param1:Number) : void
      {
         this._baseMethod.alpha = param1;
      }
      
      override public function get epsilon() : Number
      {
         return this._baseMethod.epsilon;
      }
      
      override public function set epsilon(param1:Number) : void
      {
         this._baseMethod.epsilon = param1;
      }
      
      public function get fadeRatio() : Number
      {
         return this._fadeRatio;
      }
      
      public function set fadeRatio(param1:Number) : void
      {
         this._fadeRatio = param1;
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:String = this._baseMethod.getFragmentCode(param1,param2,param3);
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentSingleTemp();
         param1.secondaryFragmentConstantsIndex = _loc5_.index * 4;
         return _loc4_ + ("abs " + _loc6_ + ", " + _sharedRegisters.projectionFragment + ".w\n" + "sub " + _loc6_ + ", " + _loc6_ + ", " + _loc5_ + ".x\n" + "mul " + _loc6_ + ", " + _loc6_ + ", " + _loc5_ + ".y\n" + "sat " + _loc6_ + ", " + _loc6_ + "\n" + "sub " + _loc6_ + ", " + _loc5_ + ".w," + _loc6_ + "\n" + "sub " + param3 + ".w, " + _loc5_ + ".w," + param3 + ".w\n" + "mul " + param3 + ".w, " + param3 + ".w, " + _loc6_ + "\n" + "sub " + param3 + ".w, " + _loc5_ + ".w," + param3 + ".w\n");
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         this._baseMethod.activate(param1,param2);
      }
      
      override arcane function deactivate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         this._baseMethod.deactivate(param1,param2);
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
         var _loc5_:Number = param4.lens.near;
         var _loc6_:Number = param4.lens.far - _loc5_;
         var _loc7_:Number = this._nearShadowMapper.coverageRatio;
         var _loc8_:Number = _loc7_ * (1 - this._fadeRatio);
         _loc7_ = _loc5_ + _loc7_ * _loc6_;
         _loc8_ = _loc5_ + _loc8_ * _loc6_;
         var _loc9_:Vector.<Number> = param1.fragmentData;
         var _loc10_:int = param1.secondaryFragmentConstantsIndex;
         _loc9_[_loc10_] = _loc8_;
         _loc9_[_loc10_ + 1] = 1 / (_loc7_ - _loc8_);
         this._baseMethod.setRenderState(param1,param2,param3,param4);
      }
      
      override arcane function getVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return this._baseMethod.getVertexCode(param1,param2);
      }
      
      override arcane function reset() : void
      {
         this._baseMethod.reset();
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._baseMethod.cleanCompilationData();
      }
      
      override arcane function set sharedRegisters(param1:ShaderRegisterData) : void
      {
         super.arcane::sharedRegisters = this._baseMethod.sharedRegisters = param1;
      }
      
      private function onShaderInvalidated(param1:ShadingMethodEvent) : void
      {
         invalidateShaderProgram();
      }
   }
}

