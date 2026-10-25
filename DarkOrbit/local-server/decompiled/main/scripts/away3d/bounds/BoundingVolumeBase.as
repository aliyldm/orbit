package away3d.bounds
{
   import away3d.arcane;
   import away3d.core.base.*;
   import away3d.core.math.Plane3D;
   import away3d.errors.*;
   import away3d.primitives.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class BoundingVolumeBase
   {
      
      protected var _min:Vector3D;
      
      protected var _max:Vector3D;
      
      protected var _aabbPoints:Vector.<Number> = new Vector.<Number>();
      
      protected var _aabbPointsDirty:Boolean = true;
      
      protected var _boundingRenderable:WireframePrimitiveBase;
      
      public function BoundingVolumeBase()
      {
         super();
         this._min = new Vector3D();
         this._max = new Vector3D();
      }
      
      public function get max() : Vector3D
      {
         return this._max;
      }
      
      public function get min() : Vector3D
      {
         return this._min;
      }
      
      public function get aabbPoints() : Vector.<Number>
      {
         if(this._aabbPointsDirty)
         {
            this.updateAABBPoints();
         }
         return this._aabbPoints;
      }
      
      public function get boundingRenderable() : WireframePrimitiveBase
      {
         if(!this._boundingRenderable)
         {
            this._boundingRenderable = this.createBoundingRenderable();
            this.updateBoundingRenderable();
         }
         return this._boundingRenderable;
      }
      
      public function nullify() : void
      {
         this._min.x = this._min.y = this._min.z = 0;
         this._max.x = this._max.y = this._max.z = 0;
         this._aabbPointsDirty = true;
         if(this._boundingRenderable)
         {
            this.updateBoundingRenderable();
         }
      }
      
      public function disposeRenderable() : void
      {
         if(this._boundingRenderable)
         {
            this._boundingRenderable.dispose();
         }
         this._boundingRenderable = null;
      }
      
      public function fromVertices(param1:Vector.<Number>) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:uint = param1.length;
         if(_loc3_ == 0)
         {
            this.nullify();
            return;
         }
         _loc4_ = _loc7_ = param1[uint(_loc2_++)];
         _loc5_ = _loc8_ = param1[uint(_loc2_++)];
         _loc6_ = _loc9_ = param1[uint(_loc2_++)];
         while(_loc2_ < _loc3_)
         {
            _loc10_ = param1[_loc2_++];
            if(_loc10_ < _loc4_)
            {
               _loc4_ = _loc10_;
            }
            else if(_loc10_ > _loc7_)
            {
               _loc7_ = _loc10_;
            }
            _loc10_ = param1[_loc2_++];
            if(_loc10_ < _loc5_)
            {
               _loc5_ = _loc10_;
            }
            else if(_loc10_ > _loc8_)
            {
               _loc8_ = _loc10_;
            }
            _loc10_ = param1[_loc2_++];
            if(_loc10_ < _loc6_)
            {
               _loc6_ = _loc10_;
            }
            else if(_loc10_ > _loc9_)
            {
               _loc9_ = _loc10_;
            }
         }
         this.fromExtremes(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
      }
      
      public function fromGeometry(param1:Geometry) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:ISubGeometry = null;
         var _loc11_:Vector.<Number> = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:Number = NaN;
         var _loc2_:Vector.<ISubGeometry> = param1.subGeometries;
         var _loc3_:uint = _loc2_.length;
         if(_loc3_ > 0)
         {
            _loc10_ = _loc2_[0];
            _loc11_ = _loc10_.vertexData;
            _loc12_ = uint(_loc10_.vertexOffset);
            _loc4_ = _loc7_ = _loc11_[_loc12_];
            _loc5_ = _loc8_ = _loc11_[_loc12_ + 1];
            _loc6_ = _loc9_ = _loc11_[_loc12_ + 2];
            _loc13_ = 0;
            while(_loc13_ < _loc3_)
            {
               _loc10_ = _loc2_[_loc13_++];
               _loc11_ = _loc10_.vertexData;
               _loc14_ = _loc11_.length;
               _loc12_ = uint(_loc10_.vertexOffset);
               _loc15_ = _loc10_.vertexStride;
               while(_loc12_ < _loc14_)
               {
                  _loc16_ = _loc11_[_loc12_];
                  if(_loc16_ < _loc4_)
                  {
                     _loc4_ = _loc16_;
                  }
                  else if(_loc16_ > _loc7_)
                  {
                     _loc7_ = _loc16_;
                  }
                  _loc16_ = _loc11_[_loc12_ + 1];
                  if(_loc16_ < _loc5_)
                  {
                     _loc5_ = _loc16_;
                  }
                  else if(_loc16_ > _loc8_)
                  {
                     _loc8_ = _loc16_;
                  }
                  _loc16_ = _loc11_[_loc12_ + 2];
                  if(_loc16_ < _loc6_)
                  {
                     _loc6_ = _loc16_;
                  }
                  else if(_loc16_ > _loc9_)
                  {
                     _loc9_ = _loc16_;
                  }
                  _loc12_ += _loc15_;
               }
            }
            this.fromExtremes(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
         }
         else
         {
            this.fromExtremes(0,0,0,0,0,0);
         }
      }
      
      public function fromSphere(param1:Vector3D, param2:Number) : void
      {
         this.fromExtremes(param1.x - param2,param1.y - param2,param1.z - param2,param1.x + param2,param1.y + param2,param1.z + param2);
      }
      
      public function fromExtremes(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this._min.x = param1;
         this._min.y = param2;
         this._min.z = param3;
         this._max.x = param4;
         this._max.y = param5;
         this._max.z = param6;
         this._aabbPointsDirty = true;
         if(this._boundingRenderable)
         {
            this.updateBoundingRenderable();
         }
      }
      
      public function isInFrustum(param1:Vector.<Plane3D>, param2:int) : Boolean
      {
         throw new AbstractMethodError();
      }
      
      public function overlaps(param1:BoundingVolumeBase) : Boolean
      {
         var _loc2_:Vector3D = param1._min;
         var _loc3_:Vector3D = param1._max;
         return this._max.x > _loc2_.x && this._min.x < _loc3_.x && this._max.y > _loc2_.y && this._min.y < _loc3_.y && this._max.z > _loc2_.z && this._min.z < _loc3_.z;
      }
      
      public function clone() : BoundingVolumeBase
      {
         throw new AbstractMethodError();
      }
      
      public function rayIntersection(param1:Vector3D, param2:Vector3D, param3:Vector3D) : Number
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         return -1;
      }
      
      public function containsPoint(param1:Vector3D) : Boolean
      {
         param1 = param1;
         return false;
      }
      
      protected function updateAABBPoints() : void
      {
         var _loc1_:Number = this._max.x;
         var _loc2_:Number = this._max.y;
         var _loc3_:Number = this._max.z;
         var _loc4_:Number = this._min.x;
         var _loc5_:Number = this._min.y;
         var _loc6_:Number = this._min.z;
         this._aabbPoints[0] = _loc4_;
         this._aabbPoints[1] = _loc5_;
         this._aabbPoints[2] = _loc6_;
         this._aabbPoints[3] = _loc1_;
         this._aabbPoints[4] = _loc5_;
         this._aabbPoints[5] = _loc6_;
         this._aabbPoints[6] = _loc4_;
         this._aabbPoints[7] = _loc2_;
         this._aabbPoints[8] = _loc6_;
         this._aabbPoints[9] = _loc1_;
         this._aabbPoints[10] = _loc2_;
         this._aabbPoints[11] = _loc6_;
         this._aabbPoints[12] = _loc4_;
         this._aabbPoints[13] = _loc5_;
         this._aabbPoints[14] = _loc3_;
         this._aabbPoints[15] = _loc1_;
         this._aabbPoints[16] = _loc5_;
         this._aabbPoints[17] = _loc3_;
         this._aabbPoints[18] = _loc4_;
         this._aabbPoints[19] = _loc2_;
         this._aabbPoints[20] = _loc3_;
         this._aabbPoints[21] = _loc1_;
         this._aabbPoints[22] = _loc2_;
         this._aabbPoints[23] = _loc3_;
         this._aabbPointsDirty = false;
      }
      
      protected function updateBoundingRenderable() : void
      {
         throw new AbstractMethodError();
      }
      
      protected function createBoundingRenderable() : WireframePrimitiveBase
      {
         throw new AbstractMethodError();
      }
      
      public function classifyToPlane(param1:Plane3D) : int
      {
         throw new AbstractMethodError();
      }
      
      public function transformFrom(param1:BoundingVolumeBase, param2:Matrix3D) : void
      {
         throw new AbstractMethodError();
      }
   }
}

