package away3d.lights
{
   import away3d.arcane;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.bounds.NullBounds;
   import away3d.core.base.IRenderable;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.partition.DirectionalLightNode;
   import away3d.core.partition.EntityNode;
   import away3d.lights.shadowmaps.DirectionalShadowMapper;
   import away3d.lights.shadowmaps.ShadowMapperBase;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class DirectionalLight extends LightBase
   {
      
      private var _direction:Vector3D;
      
      private var _tmpLookAt:Vector3D;
      
      private var _sceneDirection:Vector3D;
      
      private var _projAABBPoints:Vector.<Number>;
      
      public function DirectionalLight(param1:Number = 0, param2:Number = -1, param3:Number = 1)
      {
         super();
         this.direction = new Vector3D(param1,param2,param3);
         this._sceneDirection = new Vector3D();
      }
      
      override protected function createEntityPartitionNode() : EntityNode
      {
         return new DirectionalLightNode(this);
      }
      
      public function get sceneDirection() : Vector3D
      {
         if(_sceneTransformDirty)
         {
            this.updateSceneTransform();
         }
         return this._sceneDirection;
      }
      
      public function get direction() : Vector3D
      {
         return this._direction;
      }
      
      public function set direction(param1:Vector3D) : void
      {
         this._direction = param1;
         if(!this._tmpLookAt)
         {
            this._tmpLookAt = new Vector3D();
         }
         this._tmpLookAt.x = x + this._direction.x;
         this._tmpLookAt.y = y + this._direction.y;
         this._tmpLookAt.z = z + this._direction.z;
         lookAt(this._tmpLookAt);
      }
      
      override protected function getDefaultBoundingVolume() : BoundingVolumeBase
      {
         return new NullBounds();
      }
      
      override protected function updateBounds() : void
      {
      }
      
      override protected function updateSceneTransform() : void
      {
         super.updateSceneTransform();
         _sceneTransform.copyColumnTo(2,this._sceneDirection);
         this._sceneDirection.normalize();
      }
      
      override protected function createShadowMapper() : ShadowMapperBase
      {
         return new DirectionalShadowMapper();
      }
      
      override arcane function getObjectProjectionMatrix(param1:IRenderable, param2:Matrix3D = null) : Matrix3D
      {
         var _loc12_:Number = NaN;
         var _loc3_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         var _loc4_:BoundingVolumeBase = param1.sourceEntity.bounds;
         var _loc5_:Matrix3D = new Matrix3D();
         _loc5_.copyFrom(param1.sceneTransform);
         _loc5_.append(inverseSceneTransform);
         if(!this._projAABBPoints)
         {
            this._projAABBPoints = new Vector.<Number>();
         }
         _loc5_.transformVectors(_loc4_.aabbPoints,this._projAABBPoints);
         var _loc6_:Number = Number.POSITIVE_INFINITY;
         var _loc7_:Number = Number.NEGATIVE_INFINITY;
         var _loc8_:Number = Number.POSITIVE_INFINITY;
         var _loc9_:Number = Number.NEGATIVE_INFINITY;
         var _loc10_:Number = Number.POSITIVE_INFINITY;
         var _loc11_:Number = Number.NEGATIVE_INFINITY;
         var _loc13_:* = 0;
         while(_loc13_ < 24)
         {
            _loc12_ = this._projAABBPoints[_loc13_++];
            if(_loc12_ < _loc6_)
            {
               _loc6_ = _loc12_;
            }
            if(_loc12_ > _loc7_)
            {
               _loc7_ = _loc12_;
            }
            _loc12_ = this._projAABBPoints[_loc13_++];
            if(_loc12_ < _loc8_)
            {
               _loc8_ = _loc12_;
            }
            if(_loc12_ > _loc9_)
            {
               _loc9_ = _loc12_;
            }
            _loc12_ = this._projAABBPoints[_loc13_++];
            if(_loc12_ < _loc10_)
            {
               _loc10_ = _loc12_;
            }
            if(_loc12_ > _loc11_)
            {
               _loc11_ = _loc12_;
            }
         }
         var _loc14_:Number = 1 / (_loc7_ - _loc6_);
         var _loc15_:Number = 1 / (_loc9_ - _loc8_);
         var _loc16_:Number = 1 / (_loc11_ - _loc10_);
         _loc3_[0] = 2 * _loc14_;
         _loc3_[5] = 2 * _loc15_;
         _loc3_[10] = _loc16_;
         _loc3_[12] = -(_loc7_ + _loc6_) * _loc14_;
         _loc3_[13] = -(_loc9_ + _loc8_) * _loc15_;
         _loc3_[14] = -_loc10_ * _loc16_;
         _loc3_[1] = _loc3_[2] = _loc3_[3] = _loc3_[4] = _loc3_[6] = _loc3_[7] = _loc3_[8] = _loc3_[9] = _loc3_[11] = 0;
         _loc3_[15] = 1;
         param2 ||= new Matrix3D();
         param2.copyRawDataFrom(_loc3_);
         param2.prepend(_loc5_);
         return param2;
      }
   }
}

