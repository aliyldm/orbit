package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.InvitationRemovalCommand;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InvitationRemovalHandler extends GroupSystemHandler
   {
      
      public function InvitationRemovalHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:InvitationRemovalCommand = param1.getBody() as InvitationRemovalCommand;
         groupProxy.deleteInvitation(_loc2_.inviterId,_loc2_.candidateId,_loc2_.reason);
      }
   }
}

