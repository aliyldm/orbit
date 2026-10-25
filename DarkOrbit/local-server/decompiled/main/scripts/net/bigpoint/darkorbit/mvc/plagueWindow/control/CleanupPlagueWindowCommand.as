package net.bigpoint.darkorbit.mvc.plagueWindow.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.plagueWindow.PlagueWindowNotifications;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.PlagueWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CleanupPlagueWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function CleanupPlagueWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.removeProxy(PlagueWindowProxy.NAME);
         registerCommand(PlagueWindowNotifications.INIT,InitPlagueSystemCommand);
      }
   }
}

