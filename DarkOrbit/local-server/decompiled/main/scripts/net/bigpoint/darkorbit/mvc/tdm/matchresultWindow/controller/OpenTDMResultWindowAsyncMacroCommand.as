package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.controller
{
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.control.LoadHeaderLibraryAsyncCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class OpenTDMResultWindowAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function OpenTDMResultWindowAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(LoadHeaderLibraryAsyncCommand);
         addSubCommand(LoadTDMResultWindowAssetsAsyncCommand);
         addSubCommand(CreateTDMViewCommand);
         addSubCommand(ShowTDMMatchResultCommand);
      }
   }
}

