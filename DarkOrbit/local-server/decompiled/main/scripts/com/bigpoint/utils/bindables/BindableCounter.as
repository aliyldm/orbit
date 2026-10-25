package com.bigpoint.utils.bindables
{
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableCounter extends BindableNumber
   {
      
      private var _stepsInMilisecs:Number;
      
      private var _stepSize:Number;
      
      private var _intervalId:uint = 0;
      
      public const complete:ISignal = new Signal();
      
      public function BindableCounter(param1:Number = 0, param2:Number = 1000, param3:Number = Infinity, param4:Number = 1)
      {
         super(param1,Number.NEGATIVE_INFINITY,param3);
         this._stepsInMilisecs = param2;
         this._stepSize = param4;
         changed.add(this.handleValueChanged);
         this.handleValueChanged();
      }
      
      private function handleValueChanged() : void
      {
         if(value <= maxValue)
         {
            if(this._intervalId == 0)
            {
               this._intervalId = setInterval(this.goUp,this._stepsInMilisecs);
            }
         }
         else
         {
            this.complete.dispatch();
            this.stop();
         }
      }
      
      private function goUp() : void
      {
         value += this._stepSize;
      }
      
      public function stop() : void
      {
         clearInterval(this._intervalId);
         this._intervalId = 0;
      }
   }
}

