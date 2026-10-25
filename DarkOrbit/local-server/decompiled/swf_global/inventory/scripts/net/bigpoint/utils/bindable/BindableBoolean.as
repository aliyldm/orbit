package net.bigpoint.utils.bindable
{
   public class BindableBoolean extends AbstractBindable
   {
      
      private var _value:Boolean = false;
      
      public function BindableBoolean()
      {
         super();
      }
      
      public function set value(param1:Boolean) : void
      {
         if(this._value != param1)
         {
            this._value = param1;
            dispatchEventChangedEvent();
         }
         dispatchEventSetValueEvent();
      }
      
      public function get value() : Boolean
      {
         return this._value;
      }
   }
}

