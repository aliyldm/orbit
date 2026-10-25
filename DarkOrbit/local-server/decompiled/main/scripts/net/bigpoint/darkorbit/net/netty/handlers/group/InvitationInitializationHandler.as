package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.darkorbit.com.module.InvitationInitializationCommand;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.GroupMember;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.Invitation;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InvitationInitializationHandler extends GroupSystemHandler
   {
      
      public function InvitationInitializationHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:InvitationInitializationCommand = param1.getBody() as InvitationInitializationCommand;
         var _loc3_:Invitation = new Invitation();
         var _loc4_:GroupMember = new GroupMember();
         _loc4_.init(_loc2_.candidateId,_loc2_.candidateName);
         _loc4_.memberObject.shipType = _loc2_.candidateShip.shipIcon;
         _loc3_.setCandidate(_loc4_);
         var _loc5_:GroupMember = new GroupMember();
         _loc5_.init(_loc2_.inviterId,_loc2_.inviterName);
         _loc5_.memberObject.shipType = _loc2_.inviterShip.shipIcon;
         _loc3_.setInviter(_loc5_);
         groupProxy.handleInvitation(_loc3_);
      }
   }
}

