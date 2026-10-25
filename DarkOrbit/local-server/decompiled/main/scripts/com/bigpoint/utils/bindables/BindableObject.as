package com.bigpoint.utils.bindables
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableObject
   {
      
      private var _value:*;
      
      public const changed:ISignal = new Signal();
      
      public function BindableObject(param1:* = null)
      {
         super();
         this._value = param1;
      }
      
      public function get value() : *
      {
         return this._value;
      }
      
      public function set value(param1:*) : void
      {
         if(this._value !== param1)
         {
            this._value = param1;
            this.changed.dispatch();
         }
      }
   }
}

