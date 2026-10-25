package net.bigpoint.darkorbit.map.view3D.utils
{
   import flash.geom.Vector3D;
   
   public final class ExtMath
   {
      
      public static const PI:Number = Math.PI;
      
      public static const DOUBLE_PI:Number = 2 * Math.PI;
      
      public static const E:Number = Math.E;
      
      public static const _PI_DIV_180:Number = Math.PI / 180;
      
      public static const _180_DIV_PI:Number = 180 / Math.PI;
      
      public function ExtMath()
      {
         super();
      }
      
      public static function getShortAngleRadians(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param2 - param1) % DOUBLE_PI;
         if(_loc3_ != _loc3_ % PI)
         {
            _loc3_ = _loc3_ < 0 ? _loc3_ + DOUBLE_PI : _loc3_ - DOUBLE_PI;
         }
         return _loc3_;
      }
      
      public static function getShortAngleDegrees(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param2 - param1) % 360;
         if(_loc3_ != _loc3_ % 180)
         {
            _loc3_ = _loc3_ < 0 ? _loc3_ + 360 : _loc3_ - 360;
         }
         return _loc3_;
      }
      
      public static function angleDifferenceRadians(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param2 - param1) % DOUBLE_PI;
         if(_loc3_ != _loc3_ % PI)
         {
            _loc3_ = _loc3_ < 0 ? _loc3_ + DOUBLE_PI : _loc3_ - DOUBLE_PI;
         }
         return _loc3_;
      }
      
      public static function angleDifferenceDegrees(param1:Number, param2:Number) : Number
      {
         return angleDifferenceRadians(param1 * _PI_DIV_180,param2 * _PI_DIV_180) * _180_DIV_PI;
      }
      
      public static function tiltPan2Vector(param1:Number, param2:Number, param3:Number = 1, param4:Vector3D = null) : Vector3D
      {
         if(param4 == null)
         {
            param4 = new Vector3D();
         }
         param4.setTo(param3 * Math.sin(param1 * _PI_DIV_180) * Math.sin(param2 * _PI_DIV_180),param3 * Math.sin(param1 * _PI_DIV_180) * Math.cos(param2 * _PI_DIV_180),param3 * Math.cos(param1 * _PI_DIV_180));
         return param4;
      }
      
      public static function sin(param1:Number) : Number
      {
         return Math.sin(param1);
      }
      
      public static function cos(param1:Number) : Number
      {
         return Math.cos(param1);
      }
      
      public static function tan(param1:Number) : Number
      {
         return Math.tan(param1);
      }
      
      public static function asin(param1:Number) : Number
      {
         return Math.asin(param1);
      }
      
      public static function acos(param1:Number) : Number
      {
         return Math.acos(param1);
      }
      
      public static function atan(param1:Number) : Number
      {
         return Math.atan(param1);
      }
      
      public static function csc(param1:Number) : Number
      {
         return 1 / Math.sin(param1);
      }
      
      public static function sec(param1:Number) : Number
      {
         return 1 / Math.cos(param1);
      }
      
      public static function cot(param1:Number) : Number
      {
         return 1 / Math.tan(param1);
      }
      
      public static function acsc(param1:Number) : Number
      {
         return Math.asin(1 / param1);
      }
      
      public static function asec(param1:Number) : Number
      {
         return Math.acos(1 / param1);
      }
      
      public static function acot(param1:Number) : Number
      {
         if(param1 != 0)
         {
            return Math.atan(1 / param1);
         }
         return PI / 2;
      }
      
      public static function log(param1:Number, param2:Number) : Number
      {
         return Math.log(param2) / Math.log(param1);
      }
      
      public static function ln(param1:Number) : Number
      {
         return Math.log(param1);
      }
      
      public static function sqrt(param1:Number) : Number
      {
         return Math.sqrt(param1);
      }
      
      public static function root(param1:Number, param2:Number) : Number
      {
         return Math.pow(param1,1 / param2);
      }
      
      public static function pow(param1:Number, param2:Number) : Number
      {
         return Math.pow(param1,param2);
      }
      
      public static function exp(param1:Number) : Number
      {
         return Math.exp(param1);
      }
      
      public static function abs(param1:Number) : Number
      {
         return Math.abs(param1);
      }
      
      public static function round(param1:Number) : Number
      {
         return Math.round(param1);
      }
      
      public static function ceil(param1:Number) : Number
      {
         return Math.ceil(param1);
      }
      
      public static function floor(param1:Number) : Number
      {
         return Math.floor(param1);
      }
      
      public static function gcd(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = 0;
         while(param2 != 0)
         {
            _loc3_ = param2;
            param2 = param1 % param2;
            param1 = _loc3_;
         }
         return param1;
      }
      
      public static function lcm(param1:uint, param2:uint) : uint
      {
         return param1 / gcd(param1,param2) * param2;
      }
      
      public static function random(param1:Number = 0, param2:Number = 1) : Number
      {
         return param1 + Math.random() * (param2 - param1);
      }
      
      public static function factorial(param1:uint) : uint
      {
         var _loc2_:uint = 1;
         while(param1 > 0)
         {
            _loc2_ *= param1--;
         }
         return _loc2_;
      }
      
      public static function perm(param1:uint, param2:uint) : uint
      {
         return factorial(param1) / factorial(param1 - param2);
      }
      
      public static function comb(param1:uint, param2:uint) : uint
      {
         return perm(param1,param2) / factorial(param2);
      }
   }
}

