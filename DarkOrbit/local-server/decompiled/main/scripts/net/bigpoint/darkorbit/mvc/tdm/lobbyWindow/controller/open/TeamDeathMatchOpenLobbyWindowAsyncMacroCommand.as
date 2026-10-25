package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.open
{
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class TeamDeathMatchOpenLobbyWindowAsyncMacroCommand extends AsyncMacroCommand
   {
      
      public function TeamDeathMatchOpenLobbyWindowAsyncMacroCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         addSubCommand(TeamDeathMatchLoadUILibraryAsyncCommand);
         addSubCommand(TeamDeathMatchShowLobbywindowAsyncCommand);
      }
   }
}

