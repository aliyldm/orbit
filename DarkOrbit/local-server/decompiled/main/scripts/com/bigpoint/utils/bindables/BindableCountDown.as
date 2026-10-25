package com.bigpoint.utils.bindables
{
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableCountDown extends BindableNumber
   {
      
      private var _stepsInMilisecs:Number;
      
      private var _stepSize:Number;
      
      private var _intervalId:uint = 0;
      
      public const complete:ISignal = new Signal();
      
      public function BindableCountDown(param1:Number = 0, param2:Number = 1000, param3:Number = 0, param4:Number = 1)
      {
         super(param1,param3);
         this._stepsInMilisecs = param2;
         this._stepSize = param4;
         changed.add(this.handleValueChanged);
         this.handleValueChanged();
      }
      
      public function recover() : void
      {
         this.handleValueChanged();
      }
      
      private function handleValueChanged() : void
      {
         if(value > minValue)
         {
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

