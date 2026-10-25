package com.bigpoint.utils.countDownTimer
{
   import flash.events.Event;
   
   public class CountDownEvent extends Event
   {
      
      public static const COUNT_DOWN_TICK:String = "countDownTick";
      
      public static const COUNT_DOWN_FINISH:String = "countDownFinish";
      
      private var _timeLeft:int;
      
      public function CountDownEvent(param1:String, param2:int = 0)
      {
         super(param1,true);
         this._timeLeft = param2;
      }
      
      public function get timeLeft() : int
      {
         return this._timeLeft;
      }
      
      public function get timeLeftSec() : int
      {
         return Math.ceil(this._timeLeft / 1000);
      }
   }
}

