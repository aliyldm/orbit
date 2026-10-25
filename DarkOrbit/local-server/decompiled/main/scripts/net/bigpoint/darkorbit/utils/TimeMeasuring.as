package net.bigpoint.darkorbit.utils
{
   import flash.utils.Dictionary;
   
   public class TimeMeasuring
   {
      
      public static const TIMEFORMAT_NONE:String = " ";
      
      public static const TIMEFORMAT_SECONDS:String = "s";
      
      public static const TIMEFORMAT_MINUTES:String = "m";
      
      public static const ID_NOT_FOUND:int = -1;
      
      private static var idCollection:Dictionary = new Dictionary();
      
      public function TimeMeasuring()
      {
         super();
      }
      
      public static function start(param1:String) : void
      {
         var _loc2_:Array = null;
         if(idCollection[param1] != null)
         {
            _loc2_ = idCollection[param1];
            _loc2_.push(new MeasuringData(param1));
         }
         else
         {
            idCollection[param1] = [new MeasuringData(param1)];
         }
      }
      
      public static function stop(param1:String, param2:String = " ") : Number
      {
         var _loc3_:Array = null;
         var _loc4_:MeasuringData = null;
         var _loc5_:Number = NaN;
         if(idCollection[param1] != null)
         {
            _loc3_ = idCollection[param1];
            _loc4_ = _loc3_.shift() as MeasuringData;
            _loc5_ = _loc4_.calculateTimeDelta();
            _loc5_ = timeUnit(_loc5_,param2);
            if(_loc3_.length == 0)
            {
               idCollection[param1] = null;
               delete idCollection[param1];
            }
            return _loc5_;
         }
         return -1;
      }
      
      private static function timeUnit(param1:Number, param2:String) : Number
      {
         switch(param2)
         {
            case TIMEFORMAT_NONE:
               break;
            case TIMEFORMAT_SECONDS:
               param1 /= 1000;
               break;
            case TIMEFORMAT_MINUTES:
               param1 = param1 / 1000 / 60;
         }
         return param1;
      }
   }
}

import flash.utils.getTimer;

class MeasuringData
{
   
   public var id:String;
   
   public var startTime:Number;
   
   public var endTime:Number;
   
   public var deltaTime:Number;
   
   public function MeasuringData(param1:String)
   {
      super();
      this.id = param1;
      this.startTime = getTimer();
   }
   
   public function calculateTimeDelta() : Number
   {
      var _loc1_:Number = getTimer();
      this.deltaTime = _loc1_ - this.startTime;
      return this.deltaTime;
   }
}
