package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.darkorbit.com.module.InvitationBlockModule;
   import net.bigpoint.darkorbit.mvc.groupsystem.notification.GroupSystemNotification;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InvitationBlockHandler extends GroupSystemHandler
   {
      
      public function InvitationBlockHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:InvitationBlockModule = param1.getBody() as InvitationBlockModule;
         sendNotification(GroupSystemNotification.UPDATE_BLOCK_INVITATION_STATE,_loc2_.active);
      }
   }
}

