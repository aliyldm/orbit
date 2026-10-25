package net.bigpoint.darkorbit.net.netty.handlers.tdm
{
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.lifecycle.TeamDeathMatchLobbywindowMatchOverviewInitCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.lifecycle.TeamDeathMatchRegisterLobbyWindowMVCActorsCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.open.TeamDeathMatchOpenLobbyWindowPreconditionCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class TeamDeathMatchOverviewInitHandler extends AsyncMacroCommand
   {
      
      public function TeamDeathMatchOverviewInitHandler()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(TeamDeathMatchRegisterLobbyWindowMVCActorsCommand);
         addSubCommand(TeamDeathMatchLobbywindowMatchOverviewInitCommand);
         addSubCommand(TeamDeathMatchOpenLobbyWindowPreconditionCommand);
      }
   }
}

