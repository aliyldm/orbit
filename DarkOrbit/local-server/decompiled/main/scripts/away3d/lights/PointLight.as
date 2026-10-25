package away3d.lights
{
   import away3d.arcane;
   import away3d.bounds.BoundingSphere;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.core.base.IRenderable;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.partition.EntityNode;
   import away3d.core.partition.PointLightNode;
   import away3d.lights.shadowmaps.CubeMapShadowMapper;
   import away3d.lights.shadowmaps.ShadowMapperBase;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class PointLight extends LightBase
   {
      
      arcane var _radius:Number = 90000;
      
      arcane var _fallOff:Number = 100000;
      
      arcane var _fallOffFactor:Number;
      
      public function PointLight()
      {
         super();
         this._fallOffFactor = 1 / (this._fallOff * this._fallOff - this._radius * this._radius);
      }
      
      override protected function createShadowMapper() : ShadowMapperBase
      {
         return new CubeMapShadowMapper();
      }
      
      override protected function createEntityPartitionNode() : EntityNode
      {
         return new PointLightNode(this);
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
      
      public function set radius(param1:Number) : void
      {
         this._radius = param1;
         if(this._radius < 0)
         {
            this._radius = 0;
         }
         else if(this._radius > this._fallOff)
         {
            this._fallOff = this._radius;
            invalidateBounds();
         }
         this._fallOffFactor = 1 / (this._fallOff * this._fallOff - this._radius * this._radius);
      }
      
      arcane function fallOffFactor() : Number
      {
         return this._fallOffFactor;
      }
      
      public function get fallOff() : Number
      {
         return this._fallOff;
      }
      
      public function set fallOff(param1:Number) : void
      {
         this._fallOff = param1;
         if(this._fallOff < 0)
         {
            this._fallOff = 0;
         }
         if(this._fallOff < this._radius)
         {
            this._radius = this._fallOff;
         }
         this._fallOffFactor = 1 / (this._fallOff * this._fallOff - this._radius * this._radius);
         invalidateBounds();
      }
      
      override protected function updateBounds() : void
      {
         _bounds.fromSphere(new Vector3D(),this._fallOff);
         _boundsInvalid = false;
      }
      
      override protected function getDefaultBoundingVolume() : BoundingVolumeBase
      {
         return new BoundingSphere();
      }
      
      override arcane function getObjectProjectionMatrix(param1:IRenderable, param2:Matrix3D = null) : Matrix3D
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc3_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         var _loc4_:BoundingVolumeBase = param1.sourceEntity.bounds;
         var _loc5_:Matrix3D = new Matrix3D();
         _loc5_.copyFrom(param1.sceneTransform);
         _loc5_.append(_parent.inverseSceneTransform);
         lookAt(_loc5_.position);
         _loc5_.copyFrom(param1.sceneTransform);
         _loc5_.append(inverseSceneTransform);
         _loc5_.copyColumnTo(3,_pos);
         var _loc6_:Vector3D = _loc5_.deltaTransformVector(_loc4_.min);
         var _loc7_:Vector3D = _loc5_.deltaTransformVector(_loc4_.max);
         var _loc8_:Number = _pos.z;
         var _loc9_:Number = _loc6_.x * _loc6_.x + _loc6_.y * _loc6_.y + _loc6_.z * _loc6_.z;
         var _loc10_:Number = _loc7_.x * _loc7_.x + _loc7_.y * _loc7_.y + _loc7_.z * _loc7_.z;
         var _loc11_:Number = Math.sqrt(_loc9_ > _loc10_ ? _loc9_ : _loc10_);
         _loc12_ = _loc8_ - _loc11_;
         _loc13_ = _loc8_ + _loc11_;
         _loc3_[uint(5)] = _loc3_[uint(0)] = _loc12_ / _loc11_;
         _loc3_[uint(10)] = _loc13_ / (_loc13_ - _loc12_);
         _loc3_[uint(11)] = 1;
         _loc3_[uint(1)] = _loc3_[uint(2)] = _loc3_[uint(3)] = _loc3_[uint(4)] = _loc3_[uint(6)] = _loc3_[uint(7)] = _loc3_[uint(8)] = _loc3_[uint(9)] = _loc3_[uint(12)] = _loc3_[uint(13)] = _loc3_[uint(15)] = 0;
         _loc3_[uint(14)] = -_loc12_ * _loc3_[uint(10)];
         param2 ||= new Matrix3D();
         param2.copyRawDataFrom(_loc3_);
         param2.prepend(_loc5_);
         return param2;
      }
   }
}

