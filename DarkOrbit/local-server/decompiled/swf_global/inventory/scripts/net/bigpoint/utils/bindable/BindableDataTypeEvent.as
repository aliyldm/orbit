package net.bigpoint.utils.bindable
{
   import flash.events.Event;
   
   public class BindableDataTypeEvent extends Event
   {
      
      public static const EVENT_VALUE_CHANGE:String = "AbstractBindable::EVENT_VALUE_CHANGE";
      
      public static const EVENT_VALUE_SET:String = "AbstractBindable::EVENT_VALUE_SET";
      
      protected var _data:AbstractBindable;
      
      public function BindableDataTypeEvent(param1:String, param2:AbstractBindable = null)
      {
         super(param1);
         this._data = param2;
      }
      
      public function get data() : AbstractBindable
      {
         return this._data;
      }
   }
}

