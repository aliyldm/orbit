package net.bigpoint.darkorbit.gui.windows.components.repair
{
   import flash.events.Event;
   
   public class RepairEvent extends Event
   {
      
      public static const SET_SELECTED:String = "SET_SELECTED";
      
      public static const LOGOUT:String = "LOGOUT";
      
      public static const REPAIR:String = "REPAIR";
      
      public static const OPEN_PROFILE_PAGE:String = "OPEN_PROFILE_PAGE";
      
      public var selectedID:int;
      
      public function RepairEvent(param1:String, param2:int = 0, param3:Boolean = false, param4:Boolean = false)
      {
         this.selectedID = param2;
         super(param1,param3,param4);
      }
   }
}

