package net.bigpoint.darkorbit.mvc.groupsystem.model
{
   public class Invitation
   {
      
      private var _inviter:GroupMember;
      
      private var _candidate:GroupMember;
      
      public function Invitation()
      {
         super();
      }
      
      public function setInviter(param1:GroupMember) : void
      {
         this._inviter = param1;
      }
      
      public function getInviter() : GroupMember
      {
         return this._inviter;
      }
      
      public function setCandidate(param1:GroupMember) : void
      {
         this._candidate = param1;
      }
      
      public function getCandidate() : GroupMember
      {
         return this._candidate;
      }
   }
}

