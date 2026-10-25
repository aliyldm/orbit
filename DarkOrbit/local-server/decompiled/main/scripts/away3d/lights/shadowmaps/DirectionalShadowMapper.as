package away3d.lights.shadowmaps
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.cameras.lenses.FreeMatrixLens;
   import away3d.containers.Scene3D;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.math.Plane3D;
   import away3d.core.render.DepthRenderer;
   import away3d.lights.DirectionalLight;
   import flash.display3D.textures.TextureBase;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class DirectionalShadowMapper extends ShadowMapperBase
   {
      
      protected var _overallDepthCamera:Camera3D;
      
      protected var _localFrustum:Vector.<Number>;
      
      protected var _lightOffset:Number = 10000;
      
      protected var _matrix:Matrix3D;
      
      protected var _overallDepthLens:FreeMatrixLens;
      
      protected var _snap:Number = 64;
      
      protected var _cullPlanes:Vector.<Plane3D>;
      
      protected var _minZ:Number;
      
      protected var _maxZ:Number;
      
      public function DirectionalShadowMapper()
      {
         super();
         this._cullPlanes = new Vector.<Plane3D>();
         this._overallDepthLens = new FreeMatrixLens();
         this._overallDepthCamera = new Camera3D(this._overallDepthLens);
         this._localFrustum = new Vector.<Number>(8 * 3);
         this._matrix = new Matrix3D();
      }
      
      public function get snap() : Number
      {
         return this._snap;
      }
      
      public function set snap(param1:Number) : void
      {
         this._snap = param1;
      }
      
      public function get lightOffset() : Number
      {
         return this._lightOffset;
      }
      
      public function set lightOffset(param1:Number) : void
      {
         this._lightOffset = param1;
      }
      
      arcane function get depthProjection() : Matrix3D
      {
         return this._overallDepthCamera.viewProjection;
      }
      
      arcane function get depth() : Number
      {
         return this._maxZ - this._minZ;
      }
      
      override protected function drawDepthMap(param1:TextureBase, param2:Scene3D, param3:DepthRenderer) : void
      {
         _casterCollector.camera = this._overallDepthCamera;
         _casterCollector.cullPlanes = this._cullPlanes;
         _casterCollector.clear();
         param2.traversePartitions(_casterCollector);
         param3.render(_casterCollector,param1);
         _casterCollector.cleanUp();
      }
      
      protected function updateCullPlanes(param1:Camera3D) : void
      {
         var _loc10_:Plane3D = null;
         var _loc2_:Vector.<Plane3D> = this._overallDepthCamera.frustumPlanes;
         var _loc3_:Vector.<Plane3D> = param1.frustumPlanes;
         this._cullPlanes.length = 4;
         this._cullPlanes[0] = _loc2_[0];
         this._cullPlanes[1] = _loc2_[1];
         this._cullPlanes[2] = _loc2_[2];
         this._cullPlanes[3] = _loc2_[3];
         var _loc4_:Vector3D = DirectionalLight(_light).sceneDirection;
         var _loc5_:Number = _loc4_.x;
         var _loc6_:Number = _loc4_.y;
         var _loc7_:Number = _loc4_.z;
         var _loc8_:* = 4;
         var _loc9_:int = 0;
         while(_loc9_ < 6)
         {
            _loc10_ = _loc3_[_loc9_];
            if(_loc10_.a * _loc5_ + _loc10_.b * _loc6_ + _loc10_.c * _loc7_ < 0)
            {
               var _loc11_:Number;
               this._cullPlanes[_loc11_ = _loc8_++] = _loc10_;
            }
            _loc9_++;
         }
      }
      
      override protected function updateDepthProjection(param1:Camera3D) : void
      {
         this.updateProjectionFromFrustumCorners(param1,param1.lens.frustumCorners,this._matrix);
         this._overallDepthLens.matrix = this._matrix;
         this.updateCullPlanes(param1);
      }
      
      protected function updateProjectionFromFrustumCorners(param1:Camera3D, param2:Vector.<Number>, param3:Matrix3D) : void
      {
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:uint = 0;
         var _loc4_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         _loc5_ = DirectionalLight(_light).sceneDirection;
         this._overallDepthCamera.transform = _light.sceneTransform;
         _loc6_ = int((param1.x - _loc5_.x * this._lightOffset) / this._snap) * this._snap;
         _loc7_ = int((param1.y - _loc5_.y * this._lightOffset) / this._snap) * this._snap;
         _loc8_ = int((param1.z - _loc5_.z * this._lightOffset) / this._snap) * this._snap;
         this._overallDepthCamera.x = _loc6_;
         this._overallDepthCamera.y = _loc7_;
         this._overallDepthCamera.z = _loc8_;
         this._matrix.copyFrom(this._overallDepthCamera.inverseSceneTransform);
         this._matrix.prepend(param1.sceneTransform);
         this._matrix.transformVectors(param2,this._localFrustum);
         _loc9_ = _loc11_ = this._localFrustum[0];
         _loc10_ = _loc12_ = this._localFrustum[1];
         this._maxZ = this._localFrustum[2];
         _loc13_ = 3;
         while(_loc13_ < 24)
         {
            _loc6_ = this._localFrustum[_loc13_];
            _loc7_ = this._localFrustum[uint(_loc13_ + 1)];
            _loc8_ = this._localFrustum[uint(_loc13_ + 2)];
            if(_loc6_ < _loc9_)
            {
               _loc9_ = _loc6_;
            }
            if(_loc6_ > _loc11_)
            {
               _loc11_ = _loc6_;
            }
            if(_loc7_ < _loc10_)
            {
               _loc10_ = _loc7_;
            }
            if(_loc7_ > _loc12_)
            {
               _loc12_ = _loc7_;
            }
            if(_loc8_ > this._maxZ)
            {
               this._maxZ = _loc8_;
            }
            _loc13_ += 3;
         }
         this._minZ = 1;
         var _loc14_:Number = _loc11_ - _loc9_;
         var _loc15_:Number = _loc12_ - _loc10_;
         var _loc16_:Number = 1 / (this._maxZ - this._minZ);
         if(_loc9_ < 0)
         {
            _loc9_ -= this._snap;
         }
         if(_loc10_ < 0)
         {
            _loc10_ -= this._snap;
         }
         _loc9_ = int(_loc9_ / this._snap) * this._snap;
         _loc10_ = int(_loc10_ / this._snap) * this._snap;
         var _loc17_:Number = 2 * this._snap;
         _loc14_ = int(_loc14_ / _loc17_ + 2) * _loc17_;
         _loc15_ = int(_loc15_ / _loc17_ + 2) * _loc17_;
         _loc11_ = _loc9_ + _loc14_;
         _loc12_ = _loc10_ + _loc15_;
         _loc14_ = 1 / _loc14_;
         _loc15_ = 1 / _loc15_;
         _loc4_[0] = 2 * _loc14_;
         _loc4_[5] = 2 * _loc15_;
         _loc4_[10] = _loc16_;
         _loc4_[12] = -(_loc11_ + _loc9_) * _loc14_;
         _loc4_[13] = -(_loc12_ + _loc10_) * _loc15_;
         _loc4_[14] = -this._minZ * _loc16_;
         _loc4_[15] = 1;
         _loc4_[1] = _loc4_[2] = _loc4_[3] = _loc4_[4] = _loc4_[6] = _loc4_[7] = _loc4_[8] = _loc4_[9] = _loc4_[11] = 0;
         param3.copyRawDataFrom(_loc4_);
      }
   }
}

