package com.bigpoint.utils.bindables
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableBoolean
   {
      
      public const changed:ISignal = new Signal();
      
      private var _value:Boolean = false;
      
      public function BindableBoolean(param1:Boolean = false)
      {
         super();
         this._value = param1;
      }
      
      public function get value() : Boolean
      {
         return this._value;
      }
      
      public function set value(param1:Boolean) : void
      {
         if(this._value != param1)
         {
            this._value = param1;
            this.changed.dispatch();
         }
      }
   }
}

