package com.bigpoint.utils
{
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class PointLite
   {
      
      public static const ZERO:PointLite = new PointLite(0,0,0);
      
      protected var _x:Number;
      
      protected var _y:Number;
      
      protected var _z:Number;
      
      public function PointLite(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this._x = param1;
         this._y = param2;
         this._z = param3;
      }
      
      public static function fromPoint(param1:Point) : PointLite
      {
         return new PointLite(param1.x,param1.y);
      }
      
      public static function distanceTwoPoints(param1:PointLite, param2:PointLite) : Number
      {
         return param1.distanceTo(param2.x,param2.y,param2.z);
      }
      
      public static function clone(param1:PointLite) : PointLite
      {
         return new PointLite(param1.x,param1.y,param1.z);
      }
      
      public static function toVector3d(param1:PointLite) : Vector3D
      {
         return new Vector3D(param1.x,param1.z,-param1.y);
      }
      
      public static function toPointLite3d(param1:PointLite) : PointLite
      {
         return new PointLite(param1.x,param1.z,-param1.y);
      }
      
      public function add(param1:PointLite) : PointLite
      {
         return new PointLite(this.x + param1.x,this.y + param1.y,this.z + param1.z);
      }
      
      public function toString() : String
      {
         return "PointLite(" + this.x + "/" + this.y + "/" + this.z + ") ";
      }
      
      public function normalize(param1:Number = 1) : void
      {
         var _loc2_:Number = param1 / Math.sqrt(this._x * this._x + this._y * this._y + this._z * this._z);
         this.x *= _loc2_;
         this.y *= _loc2_;
         this.z *= _loc2_;
      }
      
      public function setTo(param1:Number, param2:Number, param3:Number) : void
      {
         this._x = param1;
         this._y = param2;
         this._z = param3;
      }
      
      public function setToPoint(param1:PointLite) : void
      {
         this.setTo(param1.x,param1.y,param1.z);
      }
      
      public function subtract(param1:PointLite) : PointLite
      {
         return new PointLite(this.x - param1.x,this.y - param1.y,this.z - param1.z);
      }
      
      public function get length() : Number
      {
         return FastMath.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
      }
      
      public function toPoint() : Point
      {
         return new Point(this.x,this.y);
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         this._x = param1;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(param1:Number) : void
      {
         this._y = param1;
      }
      
      public function get z() : Number
      {
         return this._z;
      }
      
      public function set z(param1:Number) : void
      {
         this._z = param1;
      }
      
      public function equals(param1:PointLite) : Boolean
      {
         return this.x == param1.x && this.y == param1.y && this.z == param1.z;
      }
      
      public function clone() : PointLite
      {
         return new PointLite(this.x,this.y,this.z);
      }
      
      public function incrementBy(param1:PointLite) : void
      {
         this.x += param1.x;
         this.y += param1.y;
         this.z += param1.z;
      }
      
      public function distanceTo(param1:Number, param2:Number, param3:Number = 0) : Number
      {
         var _loc4_:Number = this._x - param1;
         var _loc5_:Number = this._y - param2;
         var _loc6_:Number = this._z - param3;
         return Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_ + _loc6_ * _loc6_);
      }
   }
}

