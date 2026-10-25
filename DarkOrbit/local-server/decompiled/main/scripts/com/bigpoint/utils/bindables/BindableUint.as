package com.bigpoint.utils.bindables
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableUint
   {
      
      public const changed:ISignal = new Signal();
      
      public var minValue:uint = 0;
      
      public var maxValue:uint = 4294967295;
      
      private var _value:uint = 0;
      
      public function BindableUint(param1:uint = 0, param2:uint = 0, param3:uint = 4294967295)
      {
         super();
         this._value = param1;
         this.minValue = param2;
         this.maxValue = param3;
      }
      
      public function get value() : uint
      {
         return this._value;
      }
      
      public function set value(param1:uint) : void
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

