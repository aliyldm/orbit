package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events
{
   import flash.events.Event;
   
   public class MachineEvent extends Event
   {
      
      public static const ON_RESIZE:String = "MachineEvent.onResize";
      
      public var offsetY:int;
      
      public function MachineEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

