package net.bigpoint.utils.bindable
{
   import flash.events.EventDispatcher;
   
   public class AbstractBindable extends EventDispatcher
   {
      
      public function AbstractBindable()
      {
         super();
      }
      
      public function dispatchEventChangedEvent() : void
      {
         dispatchEvent(new BindableDataTypeEvent(BindableDataTypeEvent.EVENT_VALUE_CHANGE,this));
      }
      
      public function dispatchEventSetValueEvent() : void
      {
         dispatchEvent(new BindableDataTypeEvent(BindableDataTypeEvent.EVENT_VALUE_SET,this));
      }
   }
}

