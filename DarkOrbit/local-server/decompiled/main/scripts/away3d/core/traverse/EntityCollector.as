package away3d.core.traverse
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.data.EntityListItem;
   import away3d.core.data.EntityListItemPool;
   import away3d.core.data.RenderableListItem;
   import away3d.core.data.RenderableListItemPool;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.math.Plane3D;
   import away3d.core.partition.NodeBase;
   import away3d.entities.Entity;
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightBase;
   import away3d.lights.LightProbe;
   import away3d.lights.PointLight;
   import away3d.materials.MaterialBase;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class EntityCollector extends PartitionTraverser
   {
      
      protected var _skyBox:IRenderable;
      
      protected var _opaqueRenderableHead:RenderableListItem;
      
      protected var _blendedRenderableHead:RenderableListItem;
      
      private var _entityHead:EntityListItem;
      
      protected var _renderableListItemPool:RenderableListItemPool;
      
      protected var _entityListItemPool:EntityListItemPool;
      
      protected var _lights:Vector.<LightBase>;
      
      private var _directionalLights:Vector.<DirectionalLight>;
      
      private var _pointLights:Vector.<PointLight>;
      
      private var _lightProbes:Vector.<LightProbe>;
      
      protected var _numEntities:uint;
      
      protected var _numLights:uint;
      
      protected var _numTriangles:uint;
      
      protected var _numMouseEnableds:uint;
      
      protected var _camera:Camera3D;
      
      private var _numDirectionalLights:uint;
      
      private var _numPointLights:uint;
      
      private var _numLightProbes:uint;
      
      protected var _cameraForward:Vector3D;
      
      private var _customCullPlanes:Vector.<Plane3D>;
      
      private var _cullPlanes:Vector.<Plane3D>;
      
      private var _numCullPlanes:uint;
      
      public function EntityCollector()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._lights = new Vector.<LightBase>();
         this._directionalLights = new Vector.<DirectionalLight>();
         this._pointLights = new Vector.<PointLight>();
         this._lightProbes = new Vector.<LightProbe>();
         this._renderableListItemPool = new RenderableListItemPool();
         this._entityListItemPool = new EntityListItemPool();
      }
      
      public function get camera() : Camera3D
      {
         return this._camera;
      }
      
      public function set camera(param1:Camera3D) : void
      {
         this._camera = param1;
         _entryPoint = this._camera.scenePosition;
         this._cameraForward = Matrix3DUtils.getForward(this._camera.transform,this._cameraForward);
         this._cullPlanes = this._camera.frustumPlanes;
      }
      
      public function get cullPlanes() : Vector.<Plane3D>
      {
         return this._customCullPlanes;
      }
      
      public function set cullPlanes(param1:Vector.<Plane3D>) : void
      {
         this._customCullPlanes = param1;
      }
      
      public function get numMouseEnableds() : uint
      {
         return this._numMouseEnableds;
      }
      
      public function get skyBox() : IRenderable
      {
         return this._skyBox;
      }
      
      public function get opaqueRenderableHead() : RenderableListItem
      {
         return this._opaqueRenderableHead;
      }
      
      public function set opaqueRenderableHead(param1:RenderableListItem) : void
      {
         this._opaqueRenderableHead = param1;
      }
      
      public function get blendedRenderableHead() : RenderableListItem
      {
         return this._blendedRenderableHead;
      }
      
      public function set blendedRenderableHead(param1:RenderableListItem) : void
      {
         this._blendedRenderableHead = param1;
      }
      
      public function get entityHead() : EntityListItem
      {
         return this._entityHead;
      }
      
      public function get lights() : Vector.<LightBase>
      {
         return this._lights;
      }
      
      public function get directionalLights() : Vector.<DirectionalLight>
      {
         return this._directionalLights;
      }
      
      public function get pointLights() : Vector.<PointLight>
      {
         return this._pointLights;
      }
      
      public function get lightProbes() : Vector.<LightProbe>
      {
         return this._lightProbes;
      }
      
      public function clear() : void
      {
         if(this._camera)
         {
            _entryPoint = this._camera.scenePosition;
            this._cameraForward = Matrix3DUtils.getForward(this._camera.transform,this._cameraForward);
         }
         this._cullPlanes = this._customCullPlanes ? this._customCullPlanes : (this._camera ? this._camera.frustumPlanes : null);
         this._numCullPlanes = this._cullPlanes ? this._cullPlanes.length : 0;
         this._numTriangles = this._numMouseEnableds = 0;
         this._blendedRenderableHead = null;
         this._opaqueRenderableHead = null;
         this._entityHead = null;
         this._renderableListItemPool.freeAll();
         this._entityListItemPool.freeAll();
         this._skyBox = null;
         if(this._numLights > 0)
         {
            this._lights.length = this._numLights = 0;
         }
         if(this._numDirectionalLights > 0)
         {
            this._directionalLights.length = this._numDirectionalLights = 0;
         }
         if(this._numPointLights > 0)
         {
            this._pointLights.length = this._numPointLights = 0;
         }
         if(this._numLightProbes > 0)
         {
            this._lightProbes.length = this._numLightProbes = 0;
         }
      }
      
      override public function enterNode(param1:NodeBase) : Boolean
      {
         var _loc2_:Boolean = _collectionMark != param1._collectionMark && param1.isInFrustum(this._cullPlanes,this._numCullPlanes);
         param1._collectionMark = _collectionMark;
         return _loc2_;
      }
      
      override public function applySkyBox(param1:IRenderable) : void
      {
         this._skyBox = param1;
      }
      
      override public function applyRenderable(param1:IRenderable) : void
      {
         var _loc2_:MaterialBase = null;
         var _loc4_:RenderableListItem = null;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:Entity = param1.sourceEntity;
         if(param1.mouseEnabled)
         {
            ++this._numMouseEnableds;
         }
         this._numTriangles += param1.numTriangles;
         _loc2_ = param1.material;
         if(_loc2_)
         {
            _loc4_ = this._renderableListItemPool.getItem();
            _loc4_.renderable = param1;
            _loc4_.materialId = _loc2_._uniqueId;
            _loc4_.renderOrderId = _loc2_._renderOrderId;
            _loc4_.cascaded = false;
            _loc5_ = _loc3_.scenePosition;
            _loc6_ = _entryPoint.x - _loc5_.x;
            _loc7_ = _entryPoint.y - _loc5_.y;
            _loc8_ = _entryPoint.z - _loc5_.z;
            _loc4_.zIndex = _loc6_ * this._cameraForward.x + _loc7_ * this._cameraForward.y + _loc8_ * this._cameraForward.z + _loc3_.zOffset;
            _loc4_.renderSceneTransform = param1.getRenderSceneTransform(this._camera);
            if(_loc2_.requiresBlending)
            {
               _loc4_.next = this._blendedRenderableHead;
               this._blendedRenderableHead = _loc4_;
            }
            else
            {
               _loc4_.next = this._opaqueRenderableHead;
               this._opaqueRenderableHead = _loc4_;
            }
         }
      }
      
      override public function applyEntity(param1:Entity) : void
      {
         ++this._numEntities;
         var _loc2_:EntityListItem = this._entityListItemPool.getItem();
         _loc2_.entity = param1;
         _loc2_.next = this._entityHead;
         this._entityHead = _loc2_;
      }
      
      override public function applyUnknownLight(param1:LightBase) : void
      {
         this._lights[this._numLights++] = param1;
      }
      
      override public function applyDirectionalLight(param1:DirectionalLight) : void
      {
         this._lights[this._numLights++] = param1;
         this._directionalLights[this._numDirectionalLights++] = param1;
      }
      
      override public function applyPointLight(param1:PointLight) : void
      {
         this._lights[this._numLights++] = param1;
         this._pointLights[this._numPointLights++] = param1;
      }
      
      override public function applyLightProbe(param1:LightProbe) : void
      {
         this._lights[this._numLights++] = param1;
         this._lightProbes[this._numLightProbes++] = param1;
      }
      
      public function get numTriangles() : uint
      {
         return this._numTriangles;
      }
      
      public function cleanUp() : void
      {
      }
   }
}

