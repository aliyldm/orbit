package net.bigpoint.darkorbit.net.netty.handlers.tdm
{
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.lifecycle.TeamDeathMatchRegisterLobbyWindowMVCActorsCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.update.TeamDeathMatchLobbywindowUpdateMatchDetailCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class TeamDeathMatchDetailHandler extends AsyncMacroCommand
   {
      
      public function TeamDeathMatchDetailHandler()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(TeamDeathMatchRegisterLobbyWindowMVCActorsCommand);
         addSubCommand(TeamDeathMatchLobbywindowUpdateMatchDetailCommand);
      }
   }
}

