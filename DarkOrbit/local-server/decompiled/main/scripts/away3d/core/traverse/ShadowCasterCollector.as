package away3d.core.traverse
{
   import away3d.arcane;
   import away3d.core.base.IRenderable;
   import away3d.core.data.RenderableListItem;
   import away3d.entities.Entity;
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightBase;
   import away3d.lights.LightProbe;
   import away3d.lights.PointLight;
   import away3d.materials.MaterialBase;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ShadowCasterCollector extends EntityCollector
   {
      
      public function ShadowCasterCollector()
      {
         super();
      }
      
      override public function applyRenderable(param1:IRenderable) : void
      {
         var _loc4_:RenderableListItem = null;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:MaterialBase = param1.material;
         var _loc3_:Entity = param1.sourceEntity;
         if(param1.castsShadows && Boolean(_loc2_))
         {
            _loc4_ = _renderableListItemPool.getItem();
            _loc4_.renderable = param1;
            _loc4_.next = _opaqueRenderableHead;
            _loc4_.cascaded = false;
            _loc5_ = _loc3_.scenePosition;
            _loc6_ = _entryPoint.x - _loc5_.x;
            _loc7_ = _entryPoint.y - _loc5_.y;
            _loc8_ = _entryPoint.z - _loc5_.z;
            _loc4_.zIndex = _loc6_ * _cameraForward.x + _loc7_ * _cameraForward.y + _loc8_ * _cameraForward.z;
            _loc4_.renderSceneTransform = param1.getRenderSceneTransform(_camera);
            _loc4_.renderOrderId = _loc2_._depthPassId;
            _opaqueRenderableHead = _loc4_;
         }
      }
      
      override public function applyUnknownLight(param1:LightBase) : void
      {
      }
      
      override public function applyDirectionalLight(param1:DirectionalLight) : void
      {
      }
      
      override public function applyPointLight(param1:PointLight) : void
      {
      }
      
      override public function applyLightProbe(param1:LightProbe) : void
      {
      }
      
      override public function applySkyBox(param1:IRenderable) : void
      {
      }
   }
}

