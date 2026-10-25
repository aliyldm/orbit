package com.bigpoint.utils.bindables
{
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableSmartCountDown extends BindableNumber
   {
      
      private static const SEC:Number = 1000;
      
      private static const MIN:Number = SEC * 60;
      
      private static const HOUR:Number = MIN * 60;
      
      private static const DAY:Number = HOUR * 24;
      
      private static const YEAR:Number = DAY * 365;
      
      private var _stepsInMilisecs:Number;
      
      private var _stepSize:Number;
      
      private var _intervalId:uint = 0;
      
      public const complete:ISignal = new Signal();
      
      private var _factorToMilis:int;
      
      public function BindableSmartCountDown(param1:Number = 0, param2:Number = 0, param3:int = 1000)
      {
         super(param1,param2);
         this._factorToMilis = param3;
         this.updateStepSize();
         changed.add(this.handleValueChanged);
         this.handleValueChanged();
      }
      
      private function updateStepSize() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:Number = value * this._factorToMilis;
         if(_loc3_ > YEAR)
         {
            _loc1_ = DAY / this._factorToMilis;
            _loc2_ = DAY;
         }
         else if(_loc3_ > DAY)
         {
            _loc1_ = HOUR / this._factorToMilis;
            _loc2_ = HOUR;
         }
         else
         {
            _loc1_ = SEC / this._factorToMilis;
            _loc2_ = SEC;
         }
         if(_loc1_ != this._stepSize || _loc2_ != this._stepsInMilisecs)
         {
            this._intervalId = 0;
            this._stepSize = _loc1_;
            this._stepsInMilisecs = _loc2_;
         }
      }
      
      private function handleValueChanged() : void
      {
         if(value > minValue)
         {
            this.updateStepSize();
            if(this._intervalId == 0)
            {
               this._intervalId = setInterval(this.goDown,this._stepsInMilisecs);
            }
         }
         else
         {
            this.complete.dispatch();
            this.stop();
         }
      }
      
      private function goDown() : void
      {
         value -= this._stepSize;
      }
      
      public function stop() : void
      {
         clearInterval(this._intervalId);
         this._intervalId = 0;
      }
   }
}

