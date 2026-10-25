package net.bigpoint.darkorbit.mvc.groupsystem.control
{
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import net.bigpoint.darkorbit.mvc.groupsystem.notification.GroupSystemNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitGroupSystemModelCommand extends SimpleCommand
   {
      
      public function InitGroupSystemModelCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         this.createProxy();
         this.registerCommands();
      }
      
      private function registerCommands() : void
      {
         if(!facade.hasCommand(GroupSystemNotification.CHANGE_SHIP_GROUP_STATE))
         {
            facade.registerCommand(GroupSystemNotification.CHANGE_SHIP_GROUP_STATE,ChangeShipGroupStateCommand);
         }
         if(!facade.hasCommand(GroupSystemNotification.UPDATE_MODEL_PING_STATE))
         {
            facade.registerCommand(GroupSystemNotification.UPDATE_MODEL_PING_STATE,UpdatePingStateCommand);
         }
         if(!facade.hasCommand(GroupSystemNotification.REMOVE_INVITATION_BY_MEMBER_ID))
         {
            facade.registerCommand(GroupSystemNotification.REMOVE_INVITATION_BY_MEMBER_ID,RemoveInvitationByMemberIdCommand);
         }
      }
      
      private function createProxy() : void
      {
         if(!facade.hasProxy(GroupProxy.NAME))
         {
            facade.registerProxy(new GroupProxy());
         }
      }
   }
}

