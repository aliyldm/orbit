package away3d.core.render
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.data.RenderableListItem;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.traverse.EntityCollector;
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightBase;
   import away3d.lights.PointLight;
   import away3d.lights.shadowmaps.ShadowMapperBase;
   import away3d.materials.MaterialBase;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.textures.TextureBase;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class DefaultRenderer extends RendererBase
   {
      
      private static var RTT_PASSES:int = 1;
      
      private static var SCREEN_PASSES:int = 2;
      
      private static var ALL_PASSES:int = 3;
      
      private var _activeMaterial:MaterialBase;
      
      private var _distanceRenderer:DepthRenderer;
      
      private var _depthRenderer:DepthRenderer;
      
      private var _skyboxProjection:Matrix3D = new Matrix3D();
      
      private var _tempSkyboxMatrix:Matrix3D = new Matrix3D();
      
      private var _skyboxTempVector:Vector3D = new Vector3D();
      
      public function DefaultRenderer()
      {
         super();
         this._depthRenderer = new DepthRenderer();
         this._distanceRenderer = new DepthRenderer(false,true);
      }
      
      override arcane function set stage3DProxy(param1:Stage3DProxy) : void
      {
         super.arcane::stage3DProxy = param1;
         this._distanceRenderer.stage3DProxy = this._depthRenderer.stage3DProxy = param1;
      }
      
      override protected function executeRender(param1:EntityCollector, param2:TextureBase = null, param3:Rectangle = null, param4:int = 0) : void
      {
         this.updateLights(param1);
         if(param2)
         {
            this.drawRenderables(param1.opaqueRenderableHead,param1,RTT_PASSES);
            this.drawRenderables(param1.blendedRenderableHead,param1,RTT_PASSES);
         }
         super.executeRender(param1,param2,param3,param4);
      }
      
      private function updateLights(param1:EntityCollector) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:LightBase = null;
         var _loc7_:ShadowMapperBase = null;
         var _loc2_:Vector.<DirectionalLight> = param1.directionalLights;
         var _loc3_:Vector.<PointLight> = param1.pointLights;
         _loc4_ = _loc2_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc7_ = _loc6_.shadowMapper;
            if(_loc6_.castsShadows && (_loc7_.autoUpdateShadows || _loc7_._shadowsInvalid))
            {
               _loc7_.renderDepthMap(_stage3DProxy,param1,this._depthRenderer);
            }
            _loc5_++;
         }
         _loc4_ = _loc3_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc7_ = _loc6_.shadowMapper;
            if(_loc6_.castsShadows && (_loc7_.autoUpdateShadows || _loc7_._shadowsInvalid))
            {
               _loc7_.renderDepthMap(_stage3DProxy,param1,this._distanceRenderer);
            }
            _loc5_++;
         }
      }
      
      override protected function draw(param1:EntityCollector, param2:TextureBase) : void
      {
         _context.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         if(param1.skyBox)
         {
            if(this._activeMaterial)
            {
               this._activeMaterial.deactivate(_stage3DProxy);
            }
            this._activeMaterial = null;
            _context.setDepthTest(false,Context3DCompareMode.ALWAYS);
            this.drawSkyBox(param1);
         }
         _context.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
         var _loc3_:int = param2 ? SCREEN_PASSES : ALL_PASSES;
         this.drawRenderables(param1.opaqueRenderableHead,param1,_loc3_);
         this.drawRenderables(param1.blendedRenderableHead,param1,_loc3_);
         _context.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
         if(this._activeMaterial)
         {
            this._activeMaterial.deactivate(_stage3DProxy);
         }
         this._activeMaterial = null;
      }
      
      private function drawSkyBox(param1:EntityCollector) : void
      {
         var _loc2_:IRenderable = param1.skyBox;
         var _loc3_:MaterialBase = _loc2_.material;
         var _loc4_:Camera3D = param1.camera;
         this.updateSkyBoxProjection(_loc4_);
         _loc3_.activatePass(0,_stage3DProxy,_loc4_);
         _loc3_.renderPass(0,_loc2_,_stage3DProxy,param1,this._skyboxProjection);
         _loc3_.deactivatePass(0,_stage3DProxy);
      }
      
      private function updateSkyBoxProjection(param1:Camera3D) : void
      {
         this._skyboxProjection.copyFrom(_rttViewProjectionMatrix);
         this._skyboxProjection.copyRowTo(2,this._skyboxTempVector);
         var _loc2_:Vector3D = param1.scenePosition;
         var _loc3_:Number = this._skyboxTempVector.x;
         var _loc4_:Number = this._skyboxTempVector.y;
         var _loc5_:Number = this._skyboxTempVector.z;
         var _loc6_:Number = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
         this._skyboxTempVector.x = 0;
         this._skyboxTempVector.y = 0;
         this._skyboxTempVector.z = 0;
         this._skyboxTempVector.w = 1;
         this._tempSkyboxMatrix.copyFrom(param1.sceneTransform);
         this._tempSkyboxMatrix.copyColumnFrom(3,this._skyboxTempVector);
         this._skyboxTempVector.x = 0;
         this._skyboxTempVector.y = 0;
         this._skyboxTempVector.z = 1;
         this._skyboxTempVector.w = 0;
         Matrix3DUtils.transformVector(this._tempSkyboxMatrix,this._skyboxTempVector,this._skyboxTempVector);
         this._skyboxTempVector.normalize();
         var _loc7_:Number = Math.acos(this._skyboxTempVector.x * (_loc3_ / _loc6_) + this._skyboxTempVector.y * (_loc4_ / _loc6_) + this._skyboxTempVector.z * (_loc5_ / _loc6_));
         if(Math.abs(_loc7_) > 0.000001)
         {
            return;
         }
         var _loc8_:Number = -(_loc3_ * _loc2_.x + _loc4_ * _loc2_.y + _loc5_ * _loc2_.z + _loc6_);
         var _loc9_:Number = _loc3_ >= 0 ? 1 : -1;
         var _loc10_:Number = _loc4_ >= 0 ? 1 : -1;
         var _loc11_:Vector3D = this._skyboxTempVector;
         _loc11_.x = _loc9_;
         _loc11_.y = _loc10_;
         _loc11_.z = 1;
         _loc11_.w = 1;
         this._tempSkyboxMatrix.copyFrom(this._skyboxProjection);
         this._tempSkyboxMatrix.invert();
         var _loc12_:Vector3D = Matrix3DUtils.transformVector(this._tempSkyboxMatrix,_loc11_,Matrix3DUtils.CALCULATION_VECTOR3D);
         this._skyboxProjection.copyRowTo(3,_loc11_);
         var _loc13_:Number = (_loc12_.x * _loc11_.x + _loc12_.y * _loc11_.y + _loc12_.z * _loc11_.z + _loc12_.w * _loc11_.w) / (_loc3_ * _loc12_.x + _loc4_ * _loc12_.y + _loc5_ * _loc12_.z + _loc8_ * _loc12_.w);
         this._skyboxTempVector.x = _loc3_ * _loc13_;
         this._skyboxTempVector.y = _loc4_ * _loc13_;
         this._skyboxTempVector.z = _loc5_ * _loc13_;
         this._skyboxTempVector.w = _loc8_ * _loc13_;
         this._skyboxProjection.copyRowFrom(2,this._skyboxTempVector);
      }
      
      private function drawRenderables(param1:RenderableListItem, param2:EntityCollector, param3:int) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:RenderableListItem = null;
         var _loc8_:int = 0;
         var _loc6_:Camera3D = param2.camera;
         while(param1)
         {
            this._activeMaterial = param1.renderable.material;
            this._activeMaterial.updateMaterial(_context);
            _loc4_ = this._activeMaterial.numPasses;
            _loc5_ = 0;
            do
            {
               _loc7_ = param1;
               _loc8_ = this._activeMaterial.passRendersToTexture(_loc5_) ? 1 : 2;
               if((_loc8_ & param3) != 0)
               {
                  this._activeMaterial.activatePass(_loc5_,_stage3DProxy,_loc6_);
                  do
                  {
                     this._activeMaterial.renderPass(_loc5_,_loc7_.renderable,_stage3DProxy,param2,_rttViewProjectionMatrix);
                  }
                  while(_loc7_ = _loc7_.next, (Boolean(_loc7_)) && _loc7_.renderable.material == this._activeMaterial);
                  this._activeMaterial.deactivatePass(_loc5_,_stage3DProxy);
               }
               else
               {
                  while(true)
                  {
                     _loc7_ = _loc7_.next;
                     if(!((Boolean(_loc7_)) && _loc7_.renderable.material == this._activeMaterial))
                     {
                        break;
                     }
                  }
               }
            }
            while(++_loc5_ < _loc4_);
            param1 = _loc7_;
         }
      }
      
      override arcane function dispose() : void
      {
         super.arcane::dispose();
         this._depthRenderer.dispose();
         this._distanceRenderer.dispose();
         this._depthRenderer = null;
         this._distanceRenderer = null;
      }
   }
}

