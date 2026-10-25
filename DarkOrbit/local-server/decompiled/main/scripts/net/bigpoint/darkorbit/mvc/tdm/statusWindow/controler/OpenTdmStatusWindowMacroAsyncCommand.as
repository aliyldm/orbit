package net.bigpoint.darkorbit.mvc.tdm.statusWindow.controler
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class OpenTdmStatusWindowMacroAsyncCommand extends AsyncMacroCommand
   {
      
      public function OpenTdmStatusWindowMacroAsyncCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(LoadTdmStatusWindowGraphicsAsyncCommand);
         addSubCommand(ShowTdmStatusWindowAsyncCommand);
         addSubCommand(UpdateTdmStatusWindowCommand);
         addSubCommand(RemoveOpenTdmStatusWindowMacroAsyncCommandCommand);
      }
   }
}

