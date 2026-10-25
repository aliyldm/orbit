package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.control
{
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.control.LoadHeaderLibraryAsyncCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class OpenJackpotArenaMatchResultCommand extends AsyncMacroCommand
   {
      
      public function OpenJackpotArenaMatchResultCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(LoadHeaderLibraryAsyncCommand);
         addSubCommand(JackpotResultWindowLoadUILibraryAsyncCommand);
         addSubCommand(ShowJackpotArenaMatchResultCommand);
      }
   }
}

