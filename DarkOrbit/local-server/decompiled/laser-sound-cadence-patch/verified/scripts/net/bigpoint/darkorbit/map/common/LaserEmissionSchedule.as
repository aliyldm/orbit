package net.bigpoint.darkorbit.map.common
{
   import flash.utils.Dictionary;
   
   public final class LaserEmissionSchedule
   {
      
      private static const LAST_SOUNDS:Dictionary = new Dictionary(true);
      
      public function LaserEmissionSchedule()
      {
         super();
      }
      
      public static function soundAllowed(param1:Object, param2:int, param3:int) : Boolean
      {
         if(param2 == 6)
         {
            return true;
         }
         var previous:Object = LAST_SOUNDS[param1];
         if(previous !== undefined && param3 >= Number(previous) && param3 - Number(previous) < 2000)
         {
            return false;
         }
         LAST_SOUNDS[param1] = param3;
         return true;
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
         return param2 * 200;
      }
   }
}

