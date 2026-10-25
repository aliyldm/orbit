package away3d.entities
{
   import away3d.animators.IAnimator;
   import away3d.arcane;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.partition.*;
   import away3d.events.*;
   import away3d.library.assets.*;
   import away3d.materials.*;
   import away3d.materials.utils.DefaultMaterialManager;
   
   use namespace arcane;
   
   public class Mesh extends Entity implements IMaterialOwner, IAsset
   {
      
      private var _subMeshes:Vector.<SubMesh>;
      
      protected var _geometry:Geometry;
      
      private var _material:MaterialBase;
      
      private var _animator:IAnimator;
      
      private var _castsShadows:Boolean = true;
      
      private var _shareAnimationGeometry:Boolean = true;
      
      public var shaderParams:Object;
      
      public function Mesh(param1:Geometry, param2:MaterialBase = null)
      {
         super();
         this._subMeshes = new Vector.<SubMesh>();
         this.geometry = param1 || new Geometry();
         this.material = param2 || DefaultMaterialManager.getDefaultMaterial(this);
      }
      
      public function bakeTransformations() : void
      {
         this.geometry.applyTransformation(transform);
         transform.identity();
      }
      
      override public function get assetType() : String
      {
         return AssetType.MESH;
      }
      
      private function onGeometryBoundsInvalid(param1:GeometryEvent) : void
      {
         invalidateBounds();
      }
      
      public function get castsShadows() : Boolean
      {
         return this._castsShadows;
      }
      
      public function set castsShadows(param1:Boolean) : void
      {
         this._castsShadows = param1;
      }
      
      public function get animator() : IAnimator
      {
         return this._animator;
      }
      
      public function set animator(param1:IAnimator) : void
      {
         var _loc4_:SubMesh = null;
         if(this._animator)
         {
            this._animator.removeOwner(this);
         }
         this._animator = param1;
         var _loc2_:MaterialBase = this.material;
         this.material = null;
         this.material = _loc2_;
         var _loc3_:uint = this._subMeshes.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._subMeshes[_loc5_];
            _loc2_ = _loc4_._material;
            if(_loc2_)
            {
               _loc4_.material = null;
               _loc4_.material = _loc2_;
            }
            _loc5_++;
         }
         if(this._animator)
         {
            this._animator.addOwner(this);
         }
      }
      
      public function get geometry() : Geometry
      {
         return this._geometry;
      }
      
      public function set geometry(param1:Geometry) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Vector.<ISubGeometry> = null;
         if(this._geometry)
         {
            this._geometry.removeEventListener(GeometryEvent.BOUNDS_INVALID,this.onGeometryBoundsInvalid);
            this._geometry.removeEventListener(GeometryEvent.SUB_GEOMETRY_ADDED,this.onSubGeometryAdded);
            this._geometry.removeEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED,this.onSubGeometryRemoved);
            _loc2_ = 0;
            while(_loc2_ < this._subMeshes.length)
            {
               this._subMeshes[_loc2_].dispose();
               _loc2_++;
            }
            this._subMeshes.length = 0;
         }
         this._geometry = param1;
         if(this._geometry)
         {
            this._geometry.addEventListener(GeometryEvent.BOUNDS_INVALID,this.onGeometryBoundsInvalid);
            this._geometry.addEventListener(GeometryEvent.SUB_GEOMETRY_ADDED,this.onSubGeometryAdded);
            this._geometry.addEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED,this.onSubGeometryRemoved);
            _loc3_ = this._geometry.subGeometries;
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               this.addSubMesh(_loc3_[_loc2_]);
               _loc2_++;
            }
         }
         if(this._material)
         {
            this._material.removeOwner(this);
            this._material.addOwner(this);
         }
      }
      
      public function get material() : MaterialBase
      {
         return this._material;
      }
      
      public function set material(param1:MaterialBase) : void
      {
         if(param1 == this._material)
         {
            return;
         }
         if(this._material)
         {
            this._material.removeOwner(this);
         }
         this._material = param1;
         if(this._material)
         {
            this._material.addOwner(this);
         }
         var _loc2_:int = int(this._subMeshes.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._subMeshes[_loc3_]._material = this._material;
            _loc3_++;
         }
      }
      
      public function get subMeshes() : Vector.<SubMesh>
      {
         this._geometry.validate();
         return this._subMeshes;
      }
      
      public function get shareAnimationGeometry() : Boolean
      {
         return this._shareAnimationGeometry;
      }
      
      public function set shareAnimationGeometry(param1:Boolean) : void
      {
         this._shareAnimationGeometry = param1;
      }
      
      public function clearAnimationGeometry() : void
      {
         var _loc1_:int = int(this._subMeshes.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(!this._shareAnimationGeometry && Boolean(this._subMeshes[_loc2_].animationSubGeometry))
            {
               this._subMeshes[_loc2_].animationSubGeometry.dispose();
            }
            this._subMeshes[_loc2_].animationSubGeometry = null;
            _loc2_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.material = null;
         this.geometry = null;
      }
      
      public function disposeWithAnimatorAndChildren() : void
      {
         disposeWithChildren();
         if(this._animator)
         {
            this._animator.dispose();
         }
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Mesh = new Mesh(this._geometry,this._material);
         _loc1_.transform = transform;
         _loc1_.pivotPoint = pivotPoint;
         _loc1_.partition = partition;
         _loc1_.bounds = _bounds.clone();
         _loc1_.name = name;
         _loc1_.castsShadows = this.castsShadows;
         _loc1_.shareAnimationGeometry = this.shareAnimationGeometry;
         _loc1_.mouseEnabled = this.mouseEnabled;
         _loc1_.mouseChildren = this.mouseChildren;
         _loc1_.extra = this.extra;
         var _loc2_:int = int(this._subMeshes.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_._subMeshes[_loc3_]._material = this._subMeshes[_loc3_]._material;
            _loc3_++;
         }
         _loc2_ = int(numChildren);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.addChild(ObjectContainer3D(getChildAt(_loc3_).clone()));
            _loc3_++;
         }
         if(this._animator)
         {
            _loc1_.animator = this._animator.clone();
         }
         return _loc1_;
      }
      
      override protected function updateBounds() : void
      {
         _bounds.fromGeometry(this._geometry);
         _boundsInvalid = false;
      }
      
      override protected function createEntityPartitionNode() : EntityNode
      {
         return new MeshNode(this);
      }
      
      private function onSubGeometryAdded(param1:GeometryEvent) : void
      {
         this.addSubMesh(param1.subGeometry);
      }
      
      private function onSubGeometryRemoved(param1:GeometryEvent) : void
      {
         var _loc2_:SubMesh = null;
         var _loc5_:uint = 0;
         var _loc3_:ISubGeometry = param1.subGeometry;
         var _loc4_:* = int(this._subMeshes.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this._subMeshes[_loc5_];
            if(_loc2_.subGeometry == _loc3_)
            {
               _loc2_.dispose();
               this._subMeshes.splice(_loc5_,1);
               break;
            }
            _loc5_++;
         }
         _loc4_--;
         while(_loc5_ < _loc4_)
         {
            this._subMeshes[_loc5_]._index = _loc5_;
            _loc5_++;
         }
      }
      
      private function addSubMesh(param1:ISubGeometry) : void
      {
         var _loc2_:SubMesh = new SubMesh(param1,this,null);
         var _loc3_:uint = this._subMeshes.length;
         _loc2_._index = _loc3_;
         this._subMeshes[_loc3_] = _loc2_;
         invalidateBounds();
      }
      
      public function getSubMeshForSubGeometry(param1:SubGeometry) : SubMesh
      {
         return this._subMeshes[this._geometry.subGeometries.indexOf(param1)];
      }
      
      override arcane function collidesBefore(param1:Number, param2:Boolean) : Boolean
      {
         var _loc5_:SubMesh = null;
         _pickingCollider.setLocalRay(_pickingCollisionVO.localRayPosition,_pickingCollisionVO.localRayDirection);
         _pickingCollisionVO.renderable = null;
         var _loc3_:int = int(this._subMeshes.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._subMeshes[_loc4_];
            if(_pickingCollider.testSubMeshCollision(_loc5_,_pickingCollisionVO,param1))
            {
               param1 = _pickingCollisionVO.rayEntryDistance;
               _pickingCollisionVO.renderable = _loc5_;
               if(!param2)
               {
                  return true;
               }
            }
            _loc4_++;
         }
         return _pickingCollisionVO.renderable != null;
      }
   }
}

