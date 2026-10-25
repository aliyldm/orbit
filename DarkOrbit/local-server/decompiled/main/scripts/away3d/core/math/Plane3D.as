package away3d.core.math
{
   import away3d.arcane;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class Plane3D
   {
      
      public static const ALIGN_ANY:int = 0;
      
      public static const ALIGN_XY_AXIS:int = 1;
      
      public static const ALIGN_YZ_AXIS:int = 2;
      
      public static const ALIGN_XZ_AXIS:int = 3;
      
      public var a:Number;
      
      public var b:Number;
      
      public var c:Number;
      
      public var d:Number;
      
      arcane var _alignment:int;
      
      public function Plane3D(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super();
         this.a = param1;
         this.b = param2;
         this.c = param3;
         this.d = param4;
         if(param1 == 0 && param2 == 0)
         {
            this._alignment = ALIGN_XY_AXIS;
         }
         else if(param2 == 0 && param3 == 0)
         {
            this._alignment = ALIGN_YZ_AXIS;
         }
         else if(param1 == 0 && param3 == 0)
         {
            this._alignment = ALIGN_XZ_AXIS;
         }
         else
         {
            this._alignment = ALIGN_ANY;
         }
      }
      
      public function fromPoints(param1:Vector3D, param2:Vector3D, param3:Vector3D) : void
      {
         var _loc4_:Number = param2.x - param1.x;
         var _loc5_:Number = param2.y - param1.y;
         var _loc6_:Number = param2.z - param1.z;
         var _loc7_:Number = param3.x - param1.x;
         var _loc8_:Number = param3.y - param1.y;
         var _loc9_:Number = param3.z - param1.z;
         this.a = _loc5_ * _loc9_ - _loc6_ * _loc8_;
         this.b = _loc6_ * _loc7_ - _loc4_ * _loc9_;
         this.c = _loc4_ * _loc8_ - _loc5_ * _loc7_;
         this.d = this.a * param1.x + this.b * param1.y + this.c * param1.z;
         if(this.a == 0 && this.b == 0)
         {
            this._alignment = ALIGN_XY_AXIS;
         }
         else if(this.b == 0 && this.c == 0)
         {
            this._alignment = ALIGN_YZ_AXIS;
         }
         else if(this.a == 0 && this.c == 0)
         {
            this._alignment = ALIGN_XZ_AXIS;
         }
         else
         {
            this._alignment = ALIGN_ANY;
         }
      }
      
      public function fromNormalAndPoint(param1:Vector3D, param2:Vector3D) : void
      {
         this.a = param1.x;
         this.b = param1.y;
         this.c = param1.z;
         this.d = this.a * param2.x + this.b * param2.y + this.c * param2.z;
         if(this.a == 0 && this.b == 0)
         {
            this._alignment = ALIGN_XY_AXIS;
         }
         else if(this.b == 0 && this.c == 0)
         {
            this._alignment = ALIGN_YZ_AXIS;
         }
         else if(this.a == 0 && this.c == 0)
         {
            this._alignment = ALIGN_XZ_AXIS;
         }
         else
         {
            this._alignment = ALIGN_ANY;
         }
      }
      
      public function normalize() : Plane3D
      {
         var _loc1_:Number = 1 / Math.sqrt(this.a * this.a + this.b * this.b + this.c * this.c);
         this.a *= _loc1_;
         this.b *= _loc1_;
         this.c *= _loc1_;
         this.d *= _loc1_;
         return this;
      }
      
      public function distance(param1:Vector3D) : Number
      {
         if(this._alignment == ALIGN_YZ_AXIS)
         {
            return this.a * param1.x - this.d;
         }
         if(this._alignment == ALIGN_XZ_AXIS)
         {
            return this.b * param1.y - this.d;
         }
         if(this._alignment == ALIGN_XY_AXIS)
         {
            return this.c * param1.z - this.d;
         }
         return this.a * param1.x + this.b * param1.y + this.c * param1.z - this.d;
      }
      
      public function classifyPoint(param1:Vector3D, param2:Number = 0.01) : int
      {
         var _loc3_:Number = NaN;
         if(this.d != this.d)
         {
            return PlaneClassification.FRONT;
         }
         if(this._alignment == ALIGN_YZ_AXIS)
         {
            _loc3_ = this.a * param1.x - this.d;
         }
         else if(this._alignment == ALIGN_XZ_AXIS)
         {
            _loc3_ = this.b * param1.y - this.d;
         }
         else if(this._alignment == ALIGN_XY_AXIS)
         {
            _loc3_ = this.c * param1.z - this.d;
         }
         else
         {
            _loc3_ = this.a * param1.x + this.b * param1.y + this.c * param1.z - this.d;
         }
         if(_loc3_ < -param2)
         {
            return PlaneClassification.BACK;
         }
         if(_loc3_ > param2)
         {
            return PlaneClassification.FRONT;
         }
         return PlaneClassification.INTERSECT;
      }
      
      public function toString() : String
      {
         return "Plane3D [a:" + this.a + ", b:" + this.b + ", c:" + this.c + ", d:" + this.d + "].";
      }
   }
}

