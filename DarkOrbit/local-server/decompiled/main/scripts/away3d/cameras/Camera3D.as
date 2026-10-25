package away3d.cameras
{
   import away3d.arcane;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.bounds.NullBounds;
   import away3d.cameras.lenses.LensBase;
   import away3d.cameras.lenses.PerspectiveLens;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.math.Plane3D;
   import away3d.core.partition.CameraNode;
   import away3d.core.partition.EntityNode;
   import away3d.entities.Entity;
   import away3d.events.CameraEvent;
   import away3d.events.LensEvent;
   import away3d.library.assets.AssetType;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class Camera3D extends Entity
   {
      
      private var _viewProjection:Matrix3D = new Matrix3D();
      
      private var _viewProjectionDirty:Boolean = true;
      
      private var _lens:LensBase;
      
      private var _frustumPlanes:Vector.<Plane3D>;
      
      private var _frustumPlanesDirty:Boolean = true;
      
      public function Camera3D(param1:LensBase = null)
      {
         super();
         this._lens = param1 || new PerspectiveLens();
         this._lens.addEventListener(LensEvent.MATRIX_CHANGED,this.onLensMatrixChanged);
         this._frustumPlanes = new Vector.<Plane3D>(6,true);
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            this._frustumPlanes[_loc2_] = new Plane3D();
            _loc2_++;
         }
         z = -1000;
      }
      
      override protected function getDefaultBoundingVolume() : BoundingVolumeBase
      {
         return new NullBounds();
      }
      
      override public function get assetType() : String
      {
         return AssetType.CAMERA;
      }
      
      private function onLensMatrixChanged(param1:LensEvent) : void
      {
         this._viewProjectionDirty = true;
         this._frustumPlanesDirty = true;
         dispatchEvent(param1);
      }
      
      public function get frustumPlanes() : Vector.<Plane3D>
      {
         if(this._frustumPlanesDirty)
         {
            this.updateFrustum();
         }
         return this._frustumPlanes;
      }
      
      private function updateFrustum() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Plane3D = null;
         var _loc22_:Number = NaN;
         var _loc21_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         this.viewProjection.copyRawDataTo(_loc21_);
         _loc4_ = _loc21_[uint(0)];
         _loc5_ = _loc21_[uint(4)];
         _loc6_ = _loc21_[uint(8)];
         _loc7_ = _loc21_[uint(12)];
         _loc8_ = _loc21_[uint(1)];
         _loc9_ = _loc21_[uint(5)];
         _loc10_ = _loc21_[uint(9)];
         _loc11_ = _loc21_[uint(13)];
         _loc12_ = _loc21_[uint(2)];
         _loc13_ = _loc21_[uint(6)];
         _loc14_ = _loc21_[uint(10)];
         _loc15_ = _loc21_[uint(14)];
         _loc16_ = _loc21_[uint(3)];
         _loc17_ = _loc21_[uint(7)];
         _loc18_ = _loc21_[uint(11)];
         _loc19_ = _loc21_[uint(15)];
         _loc20_ = this._frustumPlanes[0];
         _loc1_ = _loc16_ + _loc4_;
         _loc2_ = _loc17_ + _loc5_;
         _loc3_ = _loc18_ + _loc6_;
         _loc22_ = 1 / Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_ + _loc3_ * _loc3_);
         _loc20_.a = _loc1_ * _loc22_;
         _loc20_.b = _loc2_ * _loc22_;
         _loc20_.c = _loc3_ * _loc22_;
         _loc20_.d = -(_loc19_ + _loc7_) * _loc22_;
         _loc20_ = this._frustumPlanes[1];
         _loc1_ = _loc16_ - _loc4_;
         _loc2_ = _loc17_ - _loc5_;
         _loc3_ = _loc18_ - _loc6_;
         _loc22_ = 1 / Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_ + _loc3_ * _loc3_);
         _loc20_.a = _loc1_ * _loc22_;
         _loc20_.b = _loc2_ * _loc22_;
         _loc20_.c = _loc3_ * _loc22_;
         _loc20_.d = (_loc7_ - _loc19_) * _loc22_;
         _loc20_ = this._frustumPlanes[2];
         _loc1_ = _loc16_ + _loc8_;
         _loc2_ = _loc17_ + _loc9_;
         _loc3_ = _loc18_ + _loc10_;
         _loc22_ = 1 / Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_ + _loc3_ * _loc3_);
         _loc20_.a = _loc1_ * _loc22_;
         _loc20_.b = _loc2_ * _loc22_;
         _loc20_.c = _loc3_ * _loc22_;
         _loc20_.d = -(_loc19_ + _loc11_) * _loc22_;
         _loc20_ = this._frustumPlanes[3];
         _loc1_ = _loc16_ - _loc8_;
         _loc2_ = _loc17_ - _loc9_;
         _loc3_ = _loc18_ - _loc10_;
         _loc22_ = 1 / Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_ + _loc3_ * _loc3_);
         _loc20_.a = _loc1_ * _loc22_;
         _loc20_.b = _loc2_ * _loc22_;
         _loc20_.c = _loc3_ * _loc22_;
         _loc20_.d = (_loc11_ - _loc19_) * _loc22_;
         _loc20_ = this._frustumPlanes[4];
         _loc1_ = _loc12_;
         _loc2_ = _loc13_;
         _loc3_ = _loc14_;
         _loc22_ = 1 / Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_ + _loc3_ * _loc3_);
         _loc20_.a = _loc1_ * _loc22_;
         _loc20_.b = _loc2_ * _loc22_;
         _loc20_.c = _loc3_ * _loc22_;
         _loc20_.d = -_loc15_ * _loc22_;
         _loc20_ = this._frustumPlanes[5];
         _loc1_ = _loc16_ - _loc12_;
         _loc2_ = _loc17_ - _loc13_;
         _loc3_ = _loc18_ - _loc14_;
         _loc22_ = 1 / Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_ + _loc3_ * _loc3_);
         _loc20_.a = _loc1_ * _loc22_;
         _loc20_.b = _loc2_ * _loc22_;
         _loc20_.c = _loc3_ * _loc22_;
         _loc20_.d = (_loc15_ - _loc19_) * _loc22_;
         this._frustumPlanesDirty = false;
      }
      
      override protected function invalidateSceneTransform() : void
      {
         super.invalidateSceneTransform();
         this._viewProjectionDirty = true;
         this._frustumPlanesDirty = true;
      }
      
      override protected function updateBounds() : void
      {
         _bounds.nullify();
         _boundsInvalid = false;
      }
      
      override protected function createEntityPartitionNode() : EntityNode
      {
         return new CameraNode(this);
      }
      
      public function get lens() : LensBase
      {
         return this._lens;
      }
      
      public function set lens(param1:LensBase) : void
      {
         if(this._lens == param1)
         {
            return;
         }
         if(!param1)
         {
            throw new Error("Lens cannot be null!");
         }
         this._lens.removeEventListener(LensEvent.MATRIX_CHANGED,this.onLensMatrixChanged);
         this._lens = param1;
         this._lens.addEventListener(LensEvent.MATRIX_CHANGED,this.onLensMatrixChanged);
         dispatchEvent(new CameraEvent(CameraEvent.LENS_CHANGED,this));
      }
      
      public function get viewProjection() : Matrix3D
      {
         if(this._viewProjectionDirty)
         {
            this._viewProjection.copyFrom(inverseSceneTransform);
            this._viewProjection.append(this._lens.matrix);
            this._viewProjectionDirty = false;
         }
         return this._viewProjection;
      }
      
      public function unproject(param1:Number, param2:Number, param3:Number, param4:Vector3D = null) : Vector3D
      {
         return Matrix3DUtils.transformVector(sceneTransform,this.lens.unproject(param1,param2,param3,param4),param4);
      }
      
      public function getRay(param1:Number, param2:Number, param3:Number, param4:Vector3D = null) : Vector3D
      {
         return Matrix3DUtils.deltaTransformVector(sceneTransform,this.lens.unproject(param1,param2,param3,param4),param4);
      }
      
      public function project(param1:Vector3D, param2:Vector3D = null) : Vector3D
      {
         return this.lens.project(Matrix3DUtils.transformVector(inverseSceneTransform,param1,param2),param2);
      }
   }
}

