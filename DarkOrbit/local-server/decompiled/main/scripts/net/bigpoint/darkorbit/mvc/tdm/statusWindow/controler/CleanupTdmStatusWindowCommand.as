package net.bigpoint.darkorbit.mvc.tdm.statusWindow.controler
{
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusNotification;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.TDMStatusProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class CleanupTdmStatusWindowCommand extends SimpleCommand
   {
      
      public function CleanupTdmStatusWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.removeCommand(TDMStatusNotification.UPDATE);
         facade.registerCommand(TDMStatusNotification.UPDATE,OpenTdmStatusWindowMacroAsyncCommand);
         facade.removeProxy(TDMStatusProxy.NAME);
      }
   }
}

