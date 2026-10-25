package away3d.entities
{
   import away3d.arcane;
   import away3d.bounds.AxisAlignedBoundingBox;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.containers.ObjectContainer3D;
   import away3d.containers.Scene3D;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.partition.EntityNode;
   import away3d.core.partition.Partition3D;
   import away3d.core.pick.IPickingCollider;
   import away3d.core.pick.PickingCollisionVO;
   import away3d.errors.AbstractMethodError;
   import away3d.library.assets.AssetType;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class Entity extends ObjectContainer3D
   {
      
      private var _showBounds:Boolean;
      
      private var _partitionNode:EntityNode;
      
      private var _boundsIsShown:Boolean = false;
      
      private var _shaderPickingDetails:Boolean;
      
      arcane var _pickingCollisionVO:PickingCollisionVO;
      
      arcane var _pickingCollider:IPickingCollider;
      
      arcane var _staticNode:Boolean;
      
      protected var _bounds:BoundingVolumeBase;
      
      protected var _boundsInvalid:Boolean = true;
      
      private var _worldBounds:BoundingVolumeBase;
      
      arcane var _worldBoundsInvalid:Boolean = true;
      
      public function Entity()
      {
         super();
         this._bounds = this.getDefaultBoundingVolume();
         this._worldBounds = this.getDefaultBoundingVolume();
      }
      
      override public function set ignoreTransform(param1:Boolean) : void
      {
         if(_scene)
         {
            _scene.invalidateEntityBounds(this);
         }
         super.ignoreTransform = param1;
      }
      
      public function get shaderPickingDetails() : Boolean
      {
         return this._shaderPickingDetails;
      }
      
      public function set shaderPickingDetails(param1:Boolean) : void
      {
         this._shaderPickingDetails = param1;
      }
      
      public function get staticNode() : Boolean
      {
         return this._staticNode;
      }
      
      public function set staticNode(param1:Boolean) : void
      {
         this._staticNode = param1;
      }
      
      public function get pickingCollisionVO() : PickingCollisionVO
      {
         if(!this._pickingCollisionVO)
         {
            this._pickingCollisionVO = new PickingCollisionVO(this);
         }
         return this._pickingCollisionVO;
      }
      
      arcane function collidesBefore(param1:Number, param2:Boolean) : Boolean
      {
         param1 = param1;
         param2 = param2;
         return true;
      }
      
      public function get showBounds() : Boolean
      {
         return this._showBounds;
      }
      
      public function set showBounds(param1:Boolean) : void
      {
         if(param1 == this._showBounds)
         {
            return;
         }
         this._showBounds = param1;
         if(this._showBounds)
         {
            this.addBounds();
         }
         else
         {
            this.removeBounds();
         }
      }
      
      override public function get minX() : Number
      {
         if(this._boundsInvalid)
         {
            this.updateBounds();
         }
         return this._bounds.min.x;
      }
      
      override public function get minY() : Number
      {
         if(this._boundsInvalid)
         {
            this.updateBounds();
         }
         return this._bounds.min.y;
      }
      
      override public function get minZ() : Number
      {
         if(this._boundsInvalid)
         {
            this.updateBounds();
         }
         return this._bounds.min.z;
      }
      
      override public function get maxX() : Number
      {
         if(this._boundsInvalid)
         {
            this.updateBounds();
         }
         return this._bounds.max.x;
      }
      
      override public function get maxY() : Number
      {
         if(this._boundsInvalid)
         {
            this.updateBounds();
         }
         return this._bounds.max.y;
      }
      
      override public function get maxZ() : Number
      {
         if(this._boundsInvalid)
         {
            this.updateBounds();
         }
         return this._bounds.max.z;
      }
      
      public function get bounds() : BoundingVolumeBase
      {
         if(this._boundsInvalid)
         {
            this.updateBounds();
         }
         return this._bounds;
      }
      
      public function set bounds(param1:BoundingVolumeBase) : void
      {
         this.removeBounds();
         this._bounds = param1;
         this._worldBounds = param1.clone();
         this.invalidateBounds();
         if(this._showBounds)
         {
            this.addBounds();
         }
      }
      
      public function get worldBounds() : BoundingVolumeBase
      {
         if(this._worldBoundsInvalid)
         {
            this.updateWorldBounds();
         }
         return this._worldBounds;
      }
      
      private function updateWorldBounds() : void
      {
         this._worldBounds.transformFrom(this.bounds,sceneTransform);
         this._worldBoundsInvalid = false;
      }
      
      override arcane function set implicitPartition(param1:Partition3D) : void
      {
         if(param1 == _implicitPartition)
         {
            return;
         }
         if(_implicitPartition)
         {
            this.notifyPartitionUnassigned();
         }
         super.arcane::implicitPartition = param1;
         this.notifyPartitionAssigned();
      }
      
      override public function set scene(param1:Scene3D) : void
      {
         if(param1 == _scene)
         {
            return;
         }
         if(_scene)
         {
            _scene.unregisterEntity(this);
         }
         if(param1)
         {
            param1.registerEntity(this);
         }
         super.scene = param1;
      }
      
      override public function get assetType() : String
      {
         return AssetType.ENTITY;
      }
      
      public function get pickingCollider() : IPickingCollider
      {
         return this._pickingCollider;
      }
      
      public function set pickingCollider(param1:IPickingCollider) : void
      {
         this._pickingCollider = param1;
      }
      
      public function getEntityPartitionNode() : EntityNode
      {
         return this._partitionNode = this._partitionNode || this.createEntityPartitionNode();
      }
      
      public function isIntersectingRay(param1:Vector3D, param2:Vector3D) : Boolean
      {
         if(!this.pickingCollisionVO.localRayPosition)
         {
            this.pickingCollisionVO.localRayPosition = new Vector3D();
         }
         if(!this.pickingCollisionVO.localRayDirection)
         {
            this.pickingCollisionVO.localRayDirection = new Vector3D();
         }
         if(!this.pickingCollisionVO.localNormal)
         {
            this.pickingCollisionVO.localNormal = new Vector3D();
         }
         var _loc3_:Vector3D = this.pickingCollisionVO.localRayPosition;
         var _loc4_:Vector3D = this.pickingCollisionVO.localRayDirection;
         Matrix3DUtils.transformVector(inverseSceneTransform,param1,_loc3_);
         Matrix3DUtils.deltaTransformVector(inverseSceneTransform,param2,_loc4_);
         var _loc5_:Number = this.bounds.rayIntersection(_loc3_,_loc4_,this.pickingCollisionVO.localNormal);
         if(_loc5_ < 0)
         {
            return false;
         }
         this.pickingCollisionVO.rayEntryDistance = _loc5_;
         this.pickingCollisionVO.rayPosition = param1;
         this.pickingCollisionVO.rayDirection = param2;
         this.pickingCollisionVO.rayOriginIsInsideBounds = _loc5_ == 0;
         return true;
      }
      
      protected function createEntityPartitionNode() : EntityNode
      {
         throw new AbstractMethodError();
      }
      
      protected function getDefaultBoundingVolume() : BoundingVolumeBase
      {
         return new AxisAlignedBoundingBox();
      }
      
      protected function updateBounds() : void
      {
         throw new AbstractMethodError();
      }
      
      override protected function invalidateSceneTransform() : void
      {
         if(!_ignoreTransform)
         {
            super.invalidateSceneTransform();
            this._worldBoundsInvalid = true;
            this.notifySceneBoundsInvalid();
         }
      }
      
      protected function invalidateBounds() : void
      {
         this._boundsInvalid = true;
         this._worldBoundsInvalid = true;
         this.notifySceneBoundsInvalid();
      }
      
      override protected function updateMouseChildren() : void
      {
         var _loc1_:IPickingCollider = null;
         if(Boolean(_parent) && !this.pickingCollider)
         {
            if(_parent is Entity)
            {
               _loc1_ = Entity(_parent).pickingCollider;
               if(_loc1_)
               {
                  this.pickingCollider = _loc1_;
               }
            }
         }
         super.updateMouseChildren();
      }
      
      private function notifySceneBoundsInvalid() : void
      {
         if(_scene)
         {
            _scene.invalidateEntityBounds(this);
         }
      }
      
      private function notifyPartitionAssigned() : void
      {
         if(_scene)
         {
            _scene.registerPartition(this);
         }
      }
      
      private function notifyPartitionUnassigned() : void
      {
         if(_scene)
         {
            _scene.unregisterPartition(this);
         }
      }
      
      private function addBounds() : void
      {
         if(!this._boundsIsShown)
         {
            this._boundsIsShown = true;
            addChild(this._bounds.boundingRenderable);
         }
      }
      
      private function removeBounds() : void
      {
         if(this._boundsIsShown)
         {
            this._boundsIsShown = false;
            removeChild(this._bounds.boundingRenderable);
            this._bounds.disposeRenderable();
         }
      }
      
      arcane function internalUpdate() : void
      {
         if(_controller)
         {
            _controller.update();
         }
      }
   }
}

