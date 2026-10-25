package away3d.bounds
{
   import away3d.arcane;
   import away3d.core.math.*;
   import away3d.primitives.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class AxisAlignedBoundingBox extends BoundingVolumeBase
   {
      
      private var _centerX:Number = 0;
      
      private var _centerY:Number = 0;
      
      private var _centerZ:Number = 0;
      
      private var _halfExtentsX:Number = 0;
      
      private var _halfExtentsY:Number = 0;
      
      private var _halfExtentsZ:Number = 0;
      
      public function AxisAlignedBoundingBox()
      {
         super();
      }
      
      override public function nullify() : void
      {
         super.nullify();
         this._centerX = this._centerY = this._centerZ = 0;
         this._halfExtentsX = this._halfExtentsY = this._halfExtentsZ = 0;
      }
      
      override public function isInFrustum(param1:Vector.<Plane3D>, param2:int) : Boolean
      {
         var _loc4_:Plane3D = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc3_:uint = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = _loc4_.a;
            _loc6_ = _loc4_.b;
            _loc7_ = _loc4_.c;
            _loc8_ = _loc5_ < 0 ? -this._halfExtentsX : this._halfExtentsX;
            _loc9_ = _loc6_ < 0 ? -this._halfExtentsY : this._halfExtentsY;
            _loc10_ = _loc7_ < 0 ? -this._halfExtentsZ : this._halfExtentsZ;
            _loc11_ = _loc5_ * (this._centerX + _loc8_) + _loc6_ * (this._centerY + _loc9_) + _loc7_ * (this._centerZ + _loc10_) - _loc4_.d;
            if(_loc11_ < 0)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      override public function rayIntersection(param1:Vector3D, param2:Vector3D, param3:Vector3D) : Number
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Boolean = false;
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
         if(_loc7_ < 0)
         {
            _loc13_ = (this._halfExtentsX - _loc4_) / _loc7_;
            if(_loc13_ > 0)
            {
               _loc11_ = _loc5_ + _loc13_ * _loc8_;
               _loc12_ = _loc6_ + _loc13_ * _loc9_;
               if(_loc11_ > -this._halfExtentsY && _loc11_ < this._halfExtentsY && _loc12_ > -this._halfExtentsZ && _loc12_ < this._halfExtentsZ)
               {
                  param3.x = 1;
                  param3.y = 0;
                  param3.z = 0;
                  _loc14_ = true;
               }
            }
         }
         if(!_loc14_ && _loc7_ > 0)
         {
            _loc13_ = (-this._halfExtentsX - _loc4_) / _loc7_;
            if(_loc13_ > 0)
            {
               _loc11_ = _loc5_ + _loc13_ * _loc8_;
               _loc12_ = _loc6_ + _loc13_ * _loc9_;
               if(_loc11_ > -this._halfExtentsY && _loc11_ < this._halfExtentsY && _loc12_ > -this._halfExtentsZ && _loc12_ < this._halfExtentsZ)
               {
                  param3.x = -1;
                  param3.y = 0;
                  param3.z = 0;
                  _loc14_ = true;
               }
            }
         }
         if(!_loc14_ && _loc8_ < 0)
         {
            _loc13_ = (this._halfExtentsY - _loc5_) / _loc8_;
            if(_loc13_ > 0)
            {
               _loc10_ = _loc4_ + _loc13_ * _loc7_;
               _loc12_ = _loc6_ + _loc13_ * _loc9_;
               if(_loc10_ > -this._halfExtentsX && _loc10_ < this._halfExtentsX && _loc12_ > -this._halfExtentsZ && _loc12_ < this._halfExtentsZ)
               {
                  param3.x = 0;
                  param3.y = 1;
                  param3.z = 0;
                  _loc14_ = true;
               }
            }
         }
         if(!_loc14_ && _loc8_ > 0)
         {
            _loc13_ = (-this._halfExtentsY - _loc5_) / _loc8_;
            if(_loc13_ > 0)
            {
               _loc10_ = _loc4_ + _loc13_ * _loc7_;
               _loc12_ = _loc6_ + _loc13_ * _loc9_;
               if(_loc10_ > -this._halfExtentsX && _loc10_ < this._halfExtentsX && _loc12_ > -this._halfExtentsZ && _loc12_ < this._halfExtentsZ)
               {
                  param3.x = 0;
                  param3.y = -1;
                  param3.z = 0;
                  _loc14_ = true;
               }
            }
         }
         if(!_loc14_ && _loc9_ < 0)
         {
            _loc13_ = (this._halfExtentsZ - _loc6_) / _loc9_;
            if(_loc13_ > 0)
            {
               _loc10_ = _loc4_ + _loc13_ * _loc7_;
               _loc11_ = _loc5_ + _loc13_ * _loc8_;
               if(_loc11_ > -this._halfExtentsY && _loc11_ < this._halfExtentsY && _loc10_ > -this._halfExtentsX && _loc10_ < this._halfExtentsX)
               {
                  param3.x = 0;
                  param3.y = 0;
                  param3.z = 1;
                  _loc14_ = true;
               }
            }
         }
         if(!_loc14_ && _loc9_ > 0)
         {
            _loc13_ = (-this._halfExtentsZ - _loc6_) / _loc9_;
            if(_loc13_ > 0)
            {
               _loc10_ = _loc4_ + _loc13_ * _loc7_;
               _loc11_ = _loc5_ + _loc13_ * _loc8_;
               if(_loc11_ > -this._halfExtentsY && _loc11_ < this._halfExtentsY && _loc10_ > -this._halfExtentsX && _loc10_ < this._halfExtentsX)
               {
                  param3.x = 0;
                  param3.y = 0;
                  param3.z = -1;
                  _loc14_ = true;
               }
            }
         }
         return _loc14_ ? _loc13_ : -1;
      }
      
      override public function containsPoint(param1:Vector3D) : Boolean
      {
         var _loc2_:Number = param1.x - this._centerX;
         var _loc3_:Number = param1.y - this._centerY;
         var _loc4_:Number = param1.z - this._centerZ;
         return _loc2_ <= this._halfExtentsX && _loc2_ >= -this._halfExtentsX && _loc3_ <= this._halfExtentsY && _loc3_ >= -this._halfExtentsY && _loc4_ <= this._halfExtentsZ && _loc4_ >= -this._halfExtentsZ;
      }
      
      override public function fromExtremes(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this._centerX = (param4 + param1) * 0.5;
         this._centerY = (param5 + param2) * 0.5;
         this._centerZ = (param6 + param3) * 0.5;
         this._halfExtentsX = (param4 - param1) * 0.5;
         this._halfExtentsY = (param5 - param2) * 0.5;
         this._halfExtentsZ = (param6 - param3) * 0.5;
         super.fromExtremes(param1,param2,param3,param4,param5,param6);
      }
      
      override public function clone() : BoundingVolumeBase
      {
         var _loc1_:AxisAlignedBoundingBox = new AxisAlignedBoundingBox();
         _loc1_.fromExtremes(_min.x,_min.y,_min.z,_max.x,_max.y,_max.z);
         return _loc1_;
      }
      
      public function get halfExtentsX() : Number
      {
         return this._halfExtentsX;
      }
      
      public function get halfExtentsY() : Number
      {
         return this._halfExtentsY;
      }
      
      public function get halfExtentsZ() : Number
      {
         return this._halfExtentsZ;
      }
      
      public function closestPointToPoint(param1:Vector3D, param2:Vector3D = null) : Vector3D
      {
         var _loc3_:Number = NaN;
         param2 ||= new Vector3D();
         _loc3_ = param1.x;
         if(_loc3_ < _min.x)
         {
            _loc3_ = _min.x;
         }
         if(_loc3_ > _max.x)
         {
            _loc3_ = _max.x;
         }
         param2.x = _loc3_;
         _loc3_ = param1.y;
         if(_loc3_ < _min.y)
         {
            _loc3_ = _min.y;
         }
         if(_loc3_ > _max.y)
         {
            _loc3_ = _max.y;
         }
         param2.y = _loc3_;
         _loc3_ = param1.z;
         if(_loc3_ < _min.z)
         {
            _loc3_ = _min.z;
         }
         if(_loc3_ > _max.z)
         {
            _loc3_ = _max.z;
         }
         param2.z = _loc3_;
         return param2;
      }
      
      override protected function updateBoundingRenderable() : void
      {
         _boundingRenderable.scaleX = Math.max(this._halfExtentsX * 2,0.001);
         _boundingRenderable.scaleY = Math.max(this._halfExtentsY * 2,0.001);
         _boundingRenderable.scaleZ = Math.max(this._halfExtentsZ * 2,0.001);
         _boundingRenderable.x = this._centerX;
         _boundingRenderable.y = this._centerY;
         _boundingRenderable.z = this._centerZ;
      }
      
      override protected function createBoundingRenderable() : WireframePrimitiveBase
      {
         return new WireframeCube(1,1,1,16777215,0.5);
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
         var _loc6_:Number = _loc2_ * this._halfExtentsX + _loc3_ * this._halfExtentsY + _loc4_ * this._halfExtentsZ;
         return _loc5_ > _loc6_ ? PlaneClassification.FRONT : (_loc5_ < -_loc6_ ? PlaneClassification.BACK : PlaneClassification.INTERSECT);
      }
      
      override public function transformFrom(param1:BoundingVolumeBase, param2:Matrix3D) : void
      {
         var _loc3_:AxisAlignedBoundingBox = AxisAlignedBoundingBox(param1);
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
         var _loc20_:Number = _loc3_._halfExtentsX;
         var _loc21_:Number = _loc3_._halfExtentsY;
         var _loc22_:Number = _loc3_._halfExtentsZ;
         this._halfExtentsX = _loc20_ * _loc8_ + _loc21_ * _loc9_ + _loc22_ * _loc10_;
         this._halfExtentsY = _loc20_ * _loc12_ + _loc21_ * _loc13_ + _loc22_ * _loc14_;
         this._halfExtentsZ = _loc20_ * _loc16_ + _loc21_ * _loc17_ + _loc22_ * _loc18_;
         _min.x = this._centerX - this._halfExtentsX;
         _min.y = this._centerY - this._halfExtentsY;
         _min.z = this._centerZ - this._halfExtentsZ;
         _max.x = this._centerX + this._halfExtentsX;
         _max.y = this._centerY + this._halfExtentsY;
         _max.z = this._centerZ + this._halfExtentsZ;
         _aabbPointsDirty = true;
      }
   }
}

