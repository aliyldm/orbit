package net.bigpoint.darkorbit.mvc.influenceWindow.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   import net.bigpoint.darkorbit.mvc.influenceWindow.model.InfluenceWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CleanupInfluenceWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function CleanupInfluenceWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.removeProxy(InfluenceWindowProxy.NAME);
         facade.removeCommand(InfluenceWindowNotifications.UPDATE_VIEW_FULL);
         registerCommand(InfluenceWindowNotifications.INIT,InitInfluenceSystemCommand);
      }
   }
}

