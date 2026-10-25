package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events
{
   import flash.events.Event;
   
   public class MultiplierEvent extends Event
   {
      
      public static const TOGGLE_SET_ON:String = "MultiplierEvent.toggleSetOn";
      
      public static const TOGGLE_SET_OFF:String = "MultiplierEvent.toggleSetOff";
      
      public static const CHANGE:String = "MultiplierEvent.change";
      
      public function MultiplierEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

