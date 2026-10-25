package com.bigpoint.utils.bindables
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableInt
   {
      
      public const changed:ISignal = new Signal();
      
      public var minValue:Number = -1.7976931348623157e+308;
      
      public var maxValue:Number = 1.7976931348623157e+308;
      
      private var _value:Number = 0;
      
      public function BindableInt(param1:Number = 0, param2:Number = -100000000000000, param3:Number = 100000000000000)
      {
         super();
         this.minValue = param2;
         this.maxValue = param3;
         this.value = param1;
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

