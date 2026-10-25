package net.bigpoint.darkorbit.map.common
{
   public final class LaserEmissionSchedule
   {
      
      public function LaserEmissionSchedule()
      {
         super();
      }
      
      public static function emissionCount(param1:int, param2:int) : int
      {
         return param2 <= 0 ? 0 : param2;
      }
      
      public static function cannonGroupIndex(param1:int, param2:int, param3:int) : int
      {
         if(param2 < 0 || param3 <= 0)
         {
            throw new RangeError("Invalid cannon group");
         }
         return param2 % param3;
      }
      
      public static function delayMs(param1:int, param2:int, param3:int) : Number
      {
         if(param2 < 0 || param3 <= 0)
         {
            throw new RangeError("Invalid cannon group");
         }
         return param2 * (param1 == 6 ? 200 : 220);
      }
   }
}

