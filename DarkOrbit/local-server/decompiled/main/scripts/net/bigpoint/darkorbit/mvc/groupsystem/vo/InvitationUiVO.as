package net.bigpoint.darkorbit.mvc.groupsystem.vo
{
   public class InvitationUiVO
   {
      
      public var memberID:int;
      
      public var invitationType:int;
      
      public function InvitationUiVO(param1:int, param2:int)
      {
         super();
         this.invitationType = param2;
         this.memberID = param1;
      }
   }
}

