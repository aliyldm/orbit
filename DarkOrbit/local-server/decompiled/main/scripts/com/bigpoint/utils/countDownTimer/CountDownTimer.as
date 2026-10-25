package com.bigpoint.utils.countDownTimer
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class CountDownTimer extends EventDispatcher
   {
      
      private static const INTERVAL:int = 200;
      
      private var _timer:Timer;
      
      private var _elapsedTime:Number;
      
      private var _startTime:Number;
      
      private var _initCountDownTime:Number;
      
      private var _timeLeft:Number;
      
      public function CountDownTimer(param1:Number)
      {
         super();
         this._initCountDownTime = param1;
      }
      
      public function start(param1:int = 0) : void
      {
         this._startTime = getTimer();
         this._timeLeft = 0;
         this._timer = new Timer(param1 ? param1 : INTERVAL);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerTick);
         this._timer.start();
         this.timerTick();
      }
      
      public function addCountDownEventEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         addEventListener(param1,param2,param3,param4,param5);
         dispatchEvent(new CountDownEvent(param1,Math.max(this._timeLeft,0)));
      }
      
      private function timerTick(param1:TimerEvent = null) : void
      {
         this._elapsedTime = getTimer() - this._startTime;
         this._timeLeft = this._initCountDownTime - this._elapsedTime;
         if(this._timeLeft > 0 && this._startTime > 0)
         {
            dispatchEvent(new CountDownEvent(CountDownEvent.COUNT_DOWN_TICK,Math.max(this._timeLeft,0)));
         }
         else
         {
            dispatchEvent(new CountDownEvent(CountDownEvent.COUNT_DOWN_TICK,0));
            this.dispose(true);
         }
      }
      
      public function dispose(param1:Boolean = false) : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerTick);
            this._timer = null;
         }
         this._timeLeft = this._elapsedTime = 0;
         if(param1)
         {
            dispatchEvent(new CountDownEvent(CountDownEvent.COUNT_DOWN_FINISH,0));
         }
      }
   }
}

