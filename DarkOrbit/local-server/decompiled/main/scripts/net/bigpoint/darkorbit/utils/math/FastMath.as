package net.bigpoint.darkorbit.utils.math
{
   import com.bigpoint.utils.PointLite;
   
   public class FastMath
   {
      
      public static var seedRandomGenerator:PM_PRNG = new PM_PRNG();
      
      public static const PI:Number = Math.PI;
      
      public static const DEGTORAD:Number = Math.PI / 180;
      
      public static const RADTODEG:Number = 180 / Math.PI;
      
      private static const MAX_RATIO:Number = 1 / int.MAX_VALUE;
      
      public function FastMath()
      {
         super();
      }
      
      public static function sqrt(param1:Number) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(isNaN(param1))
         {
            return NaN;
         }
         var _loc2_:Number = 0.002;
         var _loc3_:Number = param1 * 0.25;
         if(param1 == 0)
         {
            return 0;
         }
         do
         {
            _loc5_ = param1 / _loc3_;
            _loc3_ = (_loc3_ + _loc5_) * 0.5;
            _loc4_ = _loc3_ - _loc5_;
            if(_loc4_ < 0)
            {
               _loc4_ = -_loc4_;
            }
         }
         while(_loc4_ > _loc2_);
         return _loc3_;
      }
      
      public static function asDegrees(param1:Number) : Number
      {
         return param1 * RADTODEG;
      }
      
      public static function asRadians(param1:Number) : Number
      {
         return param1 * DEGTORAD;
      }
      
      public static function getRandomCount(param1:int, param2:int) : int
      {
         return param1 + Math.floor(Math.random() * (param2 - param1 + 1));
      }
      
      public static function getDistance(param1:int, param2:int, param3:int, param4:int) : Number
      {
         return Math.sqrt((param1 - param3) * (param1 - param3) + (param2 - param4) * (param2 - param4));
      }
      
      public static function abs(param1:Number) : Number
      {
         return param1 < 0 ? -param1 : param1;
      }
      
      public static function floor(param1:Number) : int
      {
         var _loc2_:int = param1;
         return param1 < 0 && param1 != _loc2_ ? int(_loc2_ - 1) : _loc2_;
      }
      
      public static function ceil(param1:Number) : int
      {
         var _loc2_:int = param1;
         return param1 >= 0 && param1 != _loc2_ ? int(_loc2_ + 1) : _loc2_;
      }
      
      public static function round(param1:Number) : int
      {
         return param1 < 0 ? (param1 + 0.5 == (param1 | 0) ? int(param1) : int(param1 - 0.5)) : int(param1 + 0.5);
      }
      
      public static function getUpperByte(param1:int) : int
      {
         return param1 & 0xFF;
      }
      
      public static function getLowerByte(param1:int) : int
      {
         return param1 >> 16;
      }
      
      public static function merge2Shorts(param1:int, param2:int) : int
      {
         return param1 | param2 << 16;
      }
      
      public static function isNumeric(param1:String) : Boolean
      {
         return !isNaN(parseInt(param1));
      }
      
      public static function getRandomBySeed(param1:int, param2:int = 0, param3:int = 1) : Number
      {
         seedRandomGenerator.seed = param1;
         seedRandomGenerator.seed = seedRandomGenerator.nextInt() * param1;
         return seedRandomGenerator.nextDoubleRange(param2,param3);
      }
      
      public static function rotatePointAroundPoint(param1:Number, param2:Number, param3:Number, param4:Number = 0, param5:Number = 0) : PointLite
      {
         var _loc6_:Number = Math.cos(param1) * (param2 - param4) - Math.sin(param1) * (param3 - param5) + param4;
         var _loc7_:Number = Math.sin(param1) * (param2 - param4) + Math.cos(param1) * (param3 - param5) + param5;
         return new PointLite(_loc6_,_loc7_);
      }
      
      public static function getRandomNumber(param1:Number, param2:Number) : Number
      {
         return param1 + Math.random() * (param2 - param1);
      }
      
      public static function roundTo(param1:Number, param2:int) : Number
      {
         var _loc3_:int = Math.pow(10,param2);
         return int(param1 * _loc3_) / _loc3_;
      }
      
      public static function asAbsoluteRadius(param1:Number) : Number
      {
         param1 %= 360;
         while(param1 < 0)
         {
            param1 += 360;
         }
         return param1;
      }
      
      public static function smartFormat(param1:Number, param2:int = 4) : String
      {
         var _loc3_:Number = Math.round(param1 * Math.pow(10,param2)) / Math.pow(10,param2);
         var _loc4_:Number = Math.round(_loc3_);
         var _loc5_:Number = Math.abs(_loc3_ - _loc4_);
         if(_loc5_ < 0.0001)
         {
            return _loc4_.toString();
         }
         var _loc6_:String = _loc3_.toFixed(param2);
         return _loc6_.replace(/\.?0+$/,"");
      }
   }
}

