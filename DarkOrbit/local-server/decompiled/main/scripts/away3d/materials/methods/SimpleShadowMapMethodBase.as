package away3d.materials.methods
{
   import away3d.*;
   import away3d.cameras.*;
   import away3d.core.base.*;
   import away3d.core.managers.*;
   import away3d.errors.*;
   import away3d.lights.*;
   import away3d.lights.shadowmaps.*;
   import away3d.materials.compilation.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class SimpleShadowMapMethodBase extends ShadowMapMethodBase
   {
      
      protected var _depthMapCoordReg:ShaderRegisterElement;
      
      protected var _usePoint:Boolean;
      
      public function SimpleShadowMapMethodBase(param1:LightBase)
      {
         this._usePoint = param1 is PointLight;
         super(param1);
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsView = true;
         param1.needsGlobalVertexPos = true;
         param1.needsGlobalFragmentPos = this._usePoint;
         param1.needsNormals = param1.numLights > 0;
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
         _loc2_[_loc4_ + 6] = 0;
         _loc2_[_loc4_ + 7] = 1;
         if(this._usePoint)
         {
            _loc2_[_loc4_ + 8] = 0;
            _loc2_[_loc4_ + 9] = 0;
            _loc2_[_loc4_ + 10] = 0;
            _loc2_[_loc4_ + 11] = 1;
         }
         _loc4_ = param1.vertexConstantsIndex;
         if(_loc4_ != -1)
         {
            _loc3_[_loc4_] = 0.5;
            _loc3_[_loc4_ + 1] = -0.5;
            _loc3_[_loc4_ + 2] = 0;
            _loc3_[_loc4_ + 3] = 1;
         }
      }
      
      arcane function get depthMapCoordReg() : ShaderRegisterElement
      {
         return this._depthMapCoordReg;
      }
      
      arcane function set depthMapCoordReg(param1:ShaderRegisterElement) : void
      {
         this._depthMapCoordReg = param1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._depthMapCoordReg = null;
      }
      
      override arcane function getVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return this._usePoint ? this.getPointVertexCode(param1,param2) : this.getPlanarVertexCode(param1,param2);
      }
      
      protected function getPointVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         param1.vertexConstantsIndex = -1;
         return "";
      }
      
      protected function getPlanarVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc3_:String = "";
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc5_:ShaderRegisterElement = param2.getFreeVertexConstant();
         var _loc6_:ShaderRegisterElement = param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         this._depthMapCoordReg = param2.getFreeVarying();
         param1.vertexConstantsIndex = _loc5_.index * 4;
         return _loc3_ + ("m44 " + _loc4_ + ", " + _sharedRegisters.globalPositionVertex + ", " + _loc6_ + "\n" + "div " + _loc4_ + ", " + _loc4_ + ", " + _loc4_ + ".w\n" + "mul " + _loc4_ + ".xy, " + _loc4_ + ".xy, " + _loc5_ + ".xy\n" + "add " + this._depthMapCoordReg + ", " + _loc4_ + ", " + _loc5_ + ".xxwz\n");
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:String = this._usePoint ? this.getPointFragmentCode(param1,param2,param3) : this.getPlanarFragmentCode(param1,param2,param3);
         return _loc4_ + ("add " + param3 + ".w, " + param3 + ".w, fc" + (param1.fragmentConstantsIndex / 4 + 1) + ".y\n" + "sat " + param3 + ".w, " + param3 + ".w\n");
      }
      
      protected function getPlanarFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         throw new AbstractMethodError();
      }
      
      protected function getPointFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         throw new AbstractMethodError();
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
         if(!this._usePoint)
         {
            DirectionalShadowMapper(_shadowMapper).depthProjection.copyRawDataTo(param1.vertexData,param1.vertexConstantsIndex + 4,true);
         }
      }
      
      arcane function getCascadeFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterElement, param6:ShaderRegisterElement) : String
      {
         throw new Error("This shadow method is incompatible with cascade shadows");
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc3_:Vector.<Number> = param1.fragmentData;
         var _loc4_:int = param1.fragmentConstantsIndex;
         if(this._usePoint)
         {
            _loc3_[_loc4_ + 4] = -Math.pow(1 / ((_castingLight as PointLight).fallOff * _epsilon),2);
         }
         else
         {
            param1.vertexData[param1.vertexConstantsIndex + 3] = -1 / (DirectionalShadowMapper(_shadowMapper).depth * _epsilon);
         }
         _loc3_[_loc4_ + 5] = 1 - _alpha;
         if(this._usePoint)
         {
            _loc5_ = _castingLight.scenePosition;
            _loc3_[_loc4_ + 8] = _loc5_.x;
            _loc3_[_loc4_ + 9] = _loc5_.y;
            _loc3_[_loc4_ + 10] = _loc5_.z;
            _loc6_ = PointLight(_castingLight)._fallOff;
            _loc3_[_loc4_ + 11] = 1 / (2 * _loc6_ * _loc6_);
         }
         param2._context3D.setTextureAt(param1.texturesIndex,_castingLight.shadowMapper.depthMap.getTextureForStage3D(param2));
      }
      
      arcane function activateForCascade(param1:MethodVO, param2:Stage3DProxy) : void
      {
         throw new Error("This shadow method is incompatible with cascade shadows");
      }
   }
}

