package net.bigpoint.darkorbit.net.netty.handlers.tdm
{
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.lifecycle.TeamDeathMatchRegisterLobbyWindowMVCActorsCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.update.TeamDeathMatchLobbywindowUpdateMatchCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class TeamDeathMatchOverviewHandler extends AsyncMacroCommand
   {
      
      public function TeamDeathMatchOverviewHandler()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(TeamDeathMatchRegisterLobbyWindowMVCActorsCommand);
         addSubCommand(TeamDeathMatchLobbywindowUpdateMatchCommand);
      }
   }
}

