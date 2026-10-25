package net.bigpoint.darkorbit.mvc.dominationWindow.controller.init
{
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationNotificationNames;
   import net.bigpoint.darkorbit.mvc.dominationWindow.model.DominationWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class CleanupDominationWindowCommand extends SimpleCommand
   {
      
      public function CleanupDominationWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.removeProxy(DominationWindowProxy.NAME);
         facade.registerCommand(DominationNotificationNames.INIT,InitDominationWindowMVCActorsAsyncCommand);
      }
   }
}

