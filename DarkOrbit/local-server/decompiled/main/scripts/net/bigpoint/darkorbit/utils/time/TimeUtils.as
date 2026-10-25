package net.bigpoint.darkorbit.utils.time
{
   public class TimeUtils
   {
      
      public function TimeUtils()
      {
         super();
      }
      
      public static function formatTime(param1:int) : String
      {
         return formatNum(param1 / 3600) + ":" + formatNum(param1 / 60) + ":" + formatNum(param1 % 60);
      }
      
      private static function formatNum(param1:int) : String
      {
         if(param1 < 10)
         {
            return "0" + param1;
         }
         return "" + param1;
      }
      
      public static function formatTimeMinutes(param1:int) : String
      {
         return Math.floor(param1 / 60) + ":" + formatNum(param1 % 60);
      }
   }
}

