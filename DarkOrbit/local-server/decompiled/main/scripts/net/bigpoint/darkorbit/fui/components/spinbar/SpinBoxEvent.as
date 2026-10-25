package net.bigpoint.darkorbit.fui.components.spinbar
{
   import flash.events.Event;
   
   public class SpinBoxEvent extends Event
   {
      
      public static const VALUE_CHANGED:String = "SpinBoxEvent.valueChangedEvent";
      
      private var _value:Number;
      
      public function SpinBoxEvent(param1:String)
      {
         super(param1);
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         this._value = param1;
      }
   }
}

