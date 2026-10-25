package net.bigpoint.darkorbit.mvc.tdm.statusWindow.controler
{
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RemoveOpenTdmStatusWindowMacroAsyncCommandCommand extends SimpleCommand
   {
      
      public function RemoveOpenTdmStatusWindowMacroAsyncCommandCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.removeCommand(TDMStatusNotification.UPDATE);
         facade.registerCommand(TDMStatusNotification.UPDATE,UpdateTdmStatusWindowCommand);
         facade.registerCommand(TDMStatusNotification.CLEANUP,CleanupTdmStatusWindowCommand);
      }
   }
}

