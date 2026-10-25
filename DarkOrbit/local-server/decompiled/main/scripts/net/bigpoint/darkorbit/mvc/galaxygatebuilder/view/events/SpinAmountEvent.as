package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events
{
   import flash.events.Event;
   
   public class SpinAmountEvent extends Event
   {
      
      public static const ITEM_SELECT:String = "SpinAmountEvent.itemSelect";
      
      public var value:int;
      
      public var text:String;
      
      public function SpinAmountEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

