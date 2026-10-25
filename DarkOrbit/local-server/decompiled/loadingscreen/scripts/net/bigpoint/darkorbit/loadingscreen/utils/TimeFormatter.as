package net.bigpoint.darkorbit.loadingscreen.utils
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class TimeFormatter
   {
      
      private static var _delimiter:String = ":";
      
      public function TimeFormatter()
      {
         super();
      }
      
      public static function formatTime(param1:int, param2:Boolean = true) : String
      {
         var _loc3_:int = param1 % 60;
         var _loc4_:int = param1 / 60;
         var _loc5_:int = Math.floor(_loc4_ / 1440);
         if(param2 && _loc5_ > 0)
         {
            _loc4_ -= _loc5_ * 1440;
         }
         var _loc6_:int = Math.floor(_loc4_ / 60);
         var _loc7_:int = _loc4_ -= _loc6_ * 60;
         return toStr(_loc5_) + _delimiter + toStr(_loc6_) + _delimiter + toStr(_loc7_) + _delimiter + toStr(_loc3_);
      }
      
      public static function formatTimeDMY(param1:int) : String
      {
         var _loc2_:int = param1 / 60;
         var _loc3_:int = Math.floor(_loc2_ / 1440);
         if(_loc3_ > 0)
         {
            _loc2_ -= _loc3_ * 1440;
         }
         var _loc4_:int = Math.floor(_loc2_ / 60);
         _loc2_ -= _loc4_ * 60;
         var _loc5_:int = _loc2_;
         var _loc6_:String = BPLocale.getItem("login_time_day_short");
         var _loc7_:String = BPLocale.getItem("login_time_hour_short");
         var _loc8_:String = BPLocale.getItem("login_time_minute_short");
         return toStr(_loc3_) + _loc6_ + " " + toStr(_loc4_) + _loc7_ + " " + toStr(_loc5_) + _loc8_;
      }
      
      private static function toStr(param1:uint) : String
      {
         if(param1 <= 9)
         {
            return "0" + param1.toString();
         }
         return param1.toString();
      }
   }
}

