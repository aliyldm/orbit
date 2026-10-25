package com.bigpoint.utils
{
   import com.bigpoint.utils.time.TimeVo;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class TimeFormatter
   {
      
      private static var _tmpTimeVO:TimeVo = new TimeVo();
      
      private static var _delimiter:String = ":";
      
      public function TimeFormatter()
      {
         super();
      }
      
      public static function formatTime(param1:int, param2:Boolean = true, param3:Boolean = false) : String
      {
         var _loc4_:String = "";
         var _loc5_:int = Math.floor(param1 / 3600);
         if(_loc5_ > 0 || param3)
         {
            _loc4_ += _loc5_ + _delimiter;
         }
         param1 -= _loc5_ * 3600;
         var _loc6_:int = Math.floor(param1 / 60);
         if(param2)
         {
            if(_loc5_ > 0 && _loc6_ < 10)
            {
               _loc4_ += "0";
            }
            _loc4_ += _loc6_ + _delimiter;
         }
         param1 -= _loc6_ * 60;
         if(param1 < 10)
         {
            _loc4_ += "0";
         }
         return _loc4_ + String(param1);
      }
      
      public static function formatTimeWithZero(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = Math.floor(param1 / 3600);
         if(_loc3_ < 10)
         {
            _loc2_ += "0";
         }
         _loc2_ += _loc3_ + _delimiter;
         param1 -= _loc3_ * 3600;
         var _loc4_:int = Math.floor(param1 / 60);
         if(_loc4_ < 10)
         {
            _loc2_ += "0";
         }
         _loc2_ += _loc4_ + _delimiter;
         param1 -= _loc4_ * 60;
         if(param1 < 10)
         {
            _loc2_ += "0";
         }
         return _loc2_ + param1.toString();
      }
      
      public static function getSeparatedTimeValues(param1:Number, param2:Boolean = true, param3:Boolean = true, param4:TimeVo = null) : TimeVo
      {
         var _loc9_:int = 0;
         var _loc5_:int = param1 % 60;
         var _loc6_:int = param1 / 60;
         var _loc7_:int = Math.floor(_loc6_ / 1440);
         if(param3 && _loc7_ > 0)
         {
            _loc6_ -= _loc7_ * 1440;
         }
         if(param2)
         {
            _loc9_ = Math.floor(_loc6_ / 60);
            _loc6_ -= _loc9_ * 60;
         }
         var _loc8_:int = _loc6_;
         if(!param4)
         {
            param4 = new TimeVo(_loc7_,_loc9_,_loc8_,_loc5_);
         }
         else
         {
            param4.daysVal = _loc7_;
            param4.hoursVal = _loc9_;
            param4.minutesVal = _loc8_;
            param4.secondsVal = _loc5_;
         }
         return param4;
      }
      
      public static function formatTimeValueFromSeconds(param1:int, param2:Boolean = false) : String
      {
         var _loc3_:String = "";
         var _loc4_:int = Math.floor(param1 / 86400);
         if(param2 && _loc4_ > 0)
         {
            param1 -= _loc4_ * 86400;
            _loc3_ += BPLocale.getItem("abbreviation_days").replace("%VALUE%",_loc4_);
         }
         var _loc5_:int = Math.floor(param1 / 3600);
         if(_loc5_ > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += " ";
            }
            _loc3_ += BPLocale.getItem("abbreviation_hours").replace("%VALUE%",_loc5_);
         }
         var _loc6_:int = param1 / 60 % 60;
         if(_loc6_ > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += " ";
            }
            _loc3_ += BPLocale.getItem("abbreviation_minutes").replace("%VALUE%",_loc6_);
         }
         var _loc7_:int = param1 % 60;
         if(_loc7_ > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += " ";
            }
            _loc3_ += BPLocale.getItem("abbreviation_seconds").replace("%VALUE%",_loc7_);
         }
         return _loc3_;
      }
      
      public static function formatTimeValueFromMinutes(param1:int, param2:Boolean = false) : String
      {
         var _loc3_:String = "";
         var _loc4_:int = Math.floor(param1 / 1440);
         if(param2 && _loc4_ > 0)
         {
            param1 -= _loc4_ * 1440;
            _loc3_ += BPLocale.getItem("abbreviation_days").replace("%VALUE%",_loc4_);
         }
         var _loc5_:int = Math.floor(param1 / 60);
         if(_loc5_ > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += " ";
            }
            _loc3_ += BPLocale.getItem("abbreviation_hours").replace("%VALUE%",_loc5_);
         }
         var _loc6_:int = param1 % 60;
         if(_loc6_ >= 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += " ";
            }
            _loc3_ += BPLocale.getItem("abbreviation_minutes").replace("%VALUE%",_loc6_);
         }
         return _loc3_;
      }
      
      public static function getSmartFormatedTime(param1:Number) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:TimeVo = TimeFormatter.getSeparatedTimeValues(param1,true,true,_tmpTimeVO);
         var _loc3_:String = "";
         if(_loc2_.daysVal > 0)
         {
            _loc4_ = BPLocale.getItem("abbreviation_days");
            _loc3_ += _loc4_.replace("%VALUE%",_loc2_.daysVal.toString());
         }
         if(_loc2_.hoursVal > 0 || _loc2_.daysVal > 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += " ";
            }
            _loc5_ = BPLocale.getItem("abbreviation_hours");
            _loc3_ += _loc5_.replace("%VALUE%",_loc2_.hoursVal.toString());
         }
         if(_loc2_.daysVal <= 0)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += " ";
            }
            _loc6_ = BPLocale.getItem("abbreviation_minutes");
            _loc3_ += _loc6_.replace("%VALUE%",_loc2_.minutesVal.toString());
            if(_loc3_.length > 0)
            {
               _loc3_ += " ";
            }
            _loc7_ = BPLocale.getItem("abbreviation_seconds");
            _loc3_ += _loc7_.replace("%VALUE%",_loc2_.secondsVal.toString());
         }
         return _loc3_;
      }
      
      public static function getSmartFormatedTimeSmall(param1:Number) : String
      {
         var _loc3_:String = null;
         var _loc2_:TimeVo = TimeFormatter.getSeparatedTimeValues(param1,true,true,_tmpTimeVO);
         if(_loc2_.daysVal > 0)
         {
            _loc3_ = BPLocale.getItem("abbreviation_days");
            return _loc3_.replace("%VALUE%",_loc2_.daysVal.toString());
         }
         if(_loc2_.hoursVal > 0 || _loc2_.minutesVal > 0)
         {
            return alz(_loc2_.hoursVal) + ":" + alz(_loc2_.minutesVal) + ":" + alz(_loc2_.secondsVal);
         }
         return BPLocale.getItem("abbreviation_seconds").replace("%VALUE%",_loc2_.secondsVal.toString());
      }
      
      public static function alz(param1:uint, param2:int = 2) : String
      {
         var _loc3_:String = param1.toString();
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
   }
}

