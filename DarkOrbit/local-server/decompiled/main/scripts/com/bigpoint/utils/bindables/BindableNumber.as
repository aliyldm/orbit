package com.bigpoint.utils.bindables
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableNumber
   {
      
      public const changed:ISignal = new Signal();
      
      public var minValue:Number = Number.MIN_VALUE;
      
      public var maxValue:Number = 1.7976931348623157e+308;
      
      private var _value:Number = NaN;
      
      public function BindableNumber(param1:Number = NaN, param2:Number = -Infinity, param3:Number = Infinity)
      {
         super();
         this._value = param1;
         this.minValue = param2;
         this.maxValue = param3;
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         param1 = Math.max(this.minValue,Math.min(param1,this.maxValue));
         if(this._value != param1)
         {
            this._value = param1;
            this.changed.dispatch();
         }
      }
   }
}

