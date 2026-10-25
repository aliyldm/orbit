package com.bigpoint.utils.bindables
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableString
   {
      
      public const changed:ISignal = new Signal();
      
      private var _value:String = null;
      
      public function BindableString(param1:String = null)
      {
         super();
         this._value = param1;
      }
      
      public function get value() : String
      {
         return this._value;
      }
      
      public function set value(param1:String) : void
      {
         if(this._value != param1)
         {
            this._value = param1;
            this.changed.dispatch();
         }
      }
      
      public function toString() : String
      {
         return this._value;
      }
   }
}

