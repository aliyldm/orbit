package net.bigpoint.darkorbit.mvc.groupsystem.view.events
{
   import flash.events.Event;
   
   public class GroupSystemBehaviorEvent extends Event
   {
      
      public static const INVITATION_BEHAVIOR_TOGGLE:String = "INVITATION_BEHAVIOR_TOGGLE";
      
      private var _mode:int;
      
      public function GroupSystemBehaviorEvent(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         this._mode = param2;
         super(param1,param3,param4);
      }
      
      public function get mode() : int
      {
         return this._mode;
      }
   }
}

