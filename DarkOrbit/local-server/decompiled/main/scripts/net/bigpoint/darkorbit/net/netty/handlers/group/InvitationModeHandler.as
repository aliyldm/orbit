package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.darkorbit.com.module.InvitationModeModule;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InvitationModeHandler extends GroupSystemHandler
   {
      
      public function InvitationModeHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:InvitationModeModule = param1.getBody() as InvitationModeModule;
         groupProxy.handleInvitationBehaviourChange(_loc2_.mode);
      }
   }
}

