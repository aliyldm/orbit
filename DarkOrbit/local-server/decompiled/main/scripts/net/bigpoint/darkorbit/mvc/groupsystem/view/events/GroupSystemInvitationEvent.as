package net.bigpoint.darkorbit.mvc.groupsystem.view.events
{
   import flash.events.Event;
   
   public class GroupSystemInvitationEvent extends Event
   {
      
      public static const ACCEPT:String = "ACCEPT";
      
      public static const REVOKE:String = "REVOKE";
      
      public static const REJECT:String = "REJECT";
      
      public static const INVITE:String = "INVITE";
      
      private var _invitationId:int;
      
      private var _candidateName:String;
      
      public function GroupSystemInvitationEvent(param1:String, param2:int = 0, param3:String = null)
      {
         this._candidateName = param3;
         super(param1);
         this._invitationId = param2;
      }
      
      public function get invitationId() : int
      {
         return this._invitationId;
      }
      
      public function get candidateName() : String
      {
         return this._candidateName;
      }
   }
}

