package away3d.bounds
{
   import away3d.arcane;
   import away3d.core.math.*;
   import away3d.primitives.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class BoundingSphere extends BoundingVolumeBase
   {
      
      private var _radius:Number = 0;
      
      private var _centerX:Number = 0;
      
      private var _centerY:Number = 0;
      
      private var _centerZ:Number = 0;
      
      public function BoundingSphere()
      {
         super();
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
      
      override public function nullify() : void
      {
         super.nullify();
         this._centerX = this._centerY = this._centerZ = 0;
         this._radius = 0;
      }
      
      override public function isInFrustum(param1:Vector.<Plane3D>, param2:int) : Boolean
      {
         var _loc4_:Plane3D = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:uint = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = _loc4_.a < 0 ? -this._radius : this._radius;
            _loc6_ = _loc4_.b < 0 ? -this._radius : this._radius;
            _loc7_ = _loc4_.c < 0 ? -this._radius : this._radius;
            _loc8_ = _loc4_.a * (this._centerX + _loc5_) + _loc4_.b * (this._centerY + _loc6_) + _loc4_.c * (this._centerZ + _loc7_) - _loc4_.d;
            if(_loc8_ < 0)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      override public function fromSphere(param1:Vector3D, param2:Number) : void
      {
         this._centerX = param1.x;
         this._centerY = param1.y;
         this._centerZ = param1.z;
         this._radius = param2;
         _max.x = this._centerX + param2;
         _max.y = this._centerY + param2;
         _max.z = this._centerZ + param2;
         _min.x = this._centerX - param2;
         _min.y = this._centerY - param2;
         _min.z = this._centerZ - param2;
         _aabbPointsDirty = true;
         if(_boundingRenderable)
         {
            this.updateBoundingRenderable();
         }
      }
      
      override public function fromExtremes(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this._centerX = (param4 + param1) * 0.5;
         this._centerY = (param5 + param2) * 0.5;
         this._centerZ = (param6 + param3) * 0.5;
         var _loc7_:Number = param4 - param1;
         var _loc8_:Number = param5 - param2;
         var _loc9_:Number = param6 - param3;
         if(_loc8_ > _loc7_)
         {
            _loc7_ = _loc8_;
         }
         if(_loc9_ > _loc7_)
         {
            _loc7_ = _loc9_;
         }
         this._radius = _loc7_ * Math.sqrt(0.5);
         super.fromExtremes(param1,param2,param3,param4,param5,param6);
      }
      
      override public function clone() : BoundingVolumeBase
      {
         var _loc1_:BoundingSphere = new BoundingSphere();
         _loc1_.fromSphere(new Vector3D(this._centerX,this._centerY,this._centerZ),this._radius);
         return _loc1_;
      }
      
      override public function rayIntersection(param1:Vector3D, param2:Vector3D, param3:Vector3D) : Number
      {
         var _loc10_:Number = NaN;
         var _loc15_:Number = NaN;
         if(this.containsPoint(param1))
         {
            return 0;
         }
         var _loc4_:Number = param1.x - this._centerX;
         var _loc5_:Number = param1.y - this._centerY;
         var _loc6_:Number = param1.z - this._centerZ;
         var _loc7_:Number = param2.x;
         var _loc8_:Number = param2.y;
         var _loc9_:Number = param2.z;
         var _loc11_:Number = _loc7_ * _loc7_ + _loc8_ * _loc8_ + _loc9_ * _loc9_;
         var _loc12_:Number = 2 * (_loc4_ * _loc7_ + _loc5_ * _loc8_ + _loc6_ * _loc9_);
         var _loc13_:Number = _loc4_ * _loc4_ + _loc5_ * _loc5_ + _loc6_ * _loc6_ - this._radius * this._radius;
         var _loc14_:Number = _loc12_ * _loc12_ - 4 * _loc11_ * _loc13_;
         if(_loc14_ >= 0)
         {
            _loc15_ = Math.sqrt(_loc14_);
            _loc10_ = (-_loc12_ - _loc15_) / (2 * _loc11_);
            if(_loc10_ >= 0)
            {
               param3.x = _loc4_ + _loc10_ * _loc7_;
               param3.y = _loc5_ + _loc10_ * _loc8_;
               param3.z = _loc6_ + _loc10_ * _loc9_;
               param3.normalize();
               return _loc10_;
            }
         }
         return -1;
      }
      
      override public function containsPoint(param1:Vector3D) : Boolean
      {
         var _loc2_:Number = param1.x - this._centerX;
         var _loc3_:Number = param1.y - this._centerY;
         var _loc4_:Number = param1.z - this._centerZ;
         var _loc5_:Number = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_ + _loc4_ * _loc4_);
         return _loc5_ <= this._radius;
      }
      
      override protected function updateBoundingRenderable() : void
      {
         var _loc1_:Number = this._radius;
         if(_loc1_ == 0)
         {
            _loc1_ = 0.001;
         }
         _boundingRenderable.scaleX = _loc1_;
         _boundingRenderable.scaleY = _loc1_;
         _boundingRenderable.scaleZ = _loc1_;
         _boundingRenderable.x = this._centerX;
         _boundingRenderable.y = this._centerY;
         _boundingRenderable.z = this._centerZ;
      }
      
      override protected function createBoundingRenderable() : WireframePrimitiveBase
      {
         return new WireframeSphere(1,16,12,16777215,0.5);
      }
      
      override public function classifyToPlane(param1:Plane3D) : int
      {
         var _loc2_:Number = param1.a;
         var _loc3_:Number = param1.b;
         var _loc4_:Number = param1.c;
         var _loc5_:Number = _loc2_ * this._centerX + _loc3_ * this._centerY + _loc4_ * this._centerZ - param1.d;
         if(_loc2_ < 0)
         {
            _loc2_ = -_loc2_;
         }
         if(_loc3_ < 0)
         {
            _loc3_ = -_loc3_;
         }
         if(_loc4_ < 0)
         {
            _loc4_ = -_loc4_;
         }
         var _loc6_:Number = (_loc2_ + _loc3_ + _loc4_) * this._radius;
         return _loc5_ > _loc6_ ? PlaneClassification.FRONT : (_loc5_ < -_loc6_ ? PlaneClassification.BACK : PlaneClassification.INTERSECT);
      }
      
      override public function transformFrom(param1:BoundingVolumeBase, param2:Matrix3D) : void
      {
         var _loc3_:BoundingSphere = BoundingSphere(param1);
         var _loc4_:Number = _loc3_._centerX;
         var _loc5_:Number = _loc3_._centerY;
         var _loc6_:Number = _loc3_._centerZ;
         var _loc7_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         param2.copyRawDataTo(_loc7_);
         var _loc8_:Number = _loc7_[0];
         var _loc9_:Number = _loc7_[4];
         var _loc10_:Number = _loc7_[8];
         var _loc11_:Number = _loc7_[12];
         var _loc12_:Number = _loc7_[1];
         var _loc13_:Number = _loc7_[5];
         var _loc14_:Number = _loc7_[9];
         var _loc15_:Number = _loc7_[13];
         var _loc16_:Number = _loc7_[2];
         var _loc17_:Number = _loc7_[6];
         var _loc18_:Number = _loc7_[10];
         var _loc19_:Number = _loc7_[14];
         this._centerX = _loc4_ * _loc8_ + _loc5_ * _loc9_ + _loc6_ * _loc10_ + _loc11_;
         this._centerY = _loc4_ * _loc12_ + _loc5_ * _loc13_ + _loc6_ * _loc14_ + _loc15_;
         this._centerZ = _loc4_ * _loc16_ + _loc5_ * _loc17_ + _loc6_ * _loc18_ + _loc19_;
         if(_loc8_ < 0)
         {
            _loc8_ = -_loc8_;
         }
         if(_loc9_ < 0)
         {
            _loc9_ = -_loc9_;
         }
         if(_loc10_ < 0)
         {
            _loc10_ = -_loc10_;
         }
         if(_loc12_ < 0)
         {
            _loc12_ = -_loc12_;
         }
         if(_loc13_ < 0)
         {
            _loc13_ = -_loc13_;
         }
         if(_loc14_ < 0)
         {
            _loc14_ = -_loc14_;
         }
         if(_loc16_ < 0)
         {
            _loc16_ = -_loc16_;
         }
         if(_loc17_ < 0)
         {
            _loc17_ = -_loc17_;
         }
         if(_loc18_ < 0)
         {
            _loc18_ = -_loc18_;
         }
         var _loc20_:Number = _loc3_._radius;
         var _loc21_:Number = _loc8_ + _loc9_ + _loc10_;
         var _loc22_:Number = _loc12_ + _loc13_ + _loc14_;
         var _loc23_:Number = _loc16_ + _loc17_ + _loc18_;
         this._radius = _loc20_ * Math.sqrt(_loc21_ * _loc21_ + _loc22_ * _loc22_ + _loc23_ * _loc23_);
         _min.x = this._centerX - this._radius;
         _min.y = this._centerY - this._radius;
         _min.z = this._centerZ - this._radius;
         _max.x = this._centerX + this._radius;
         _max.y = this._centerY + this._radius;
         _max.z = this._centerZ + this._radius;
      }
   }
}

