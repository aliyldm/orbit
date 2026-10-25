package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.lifecycle
{
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.TeamDeathMatchLobbywindowNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.close.TeamDeathMatchCloseLobbyWindowCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.open.TeamDeathMatchOpenLobbyWindowAsyncMacroCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.model.TeamDeathMatchLobbywindowProxy;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbywindowMediator;
   import net.bigpoint.darkorbit.mvc.tdm.popups.view.TeamDeathMatchErrorPopUpMediator;
   import net.bigpoint.darkorbit.mvc.tdm.popups.view.TeamDeathMatchLevelRequirementPopupMediator;
   import net.bigpoint.darkorbit.mvc.tdm.popups.view.TeamDeathMatchParticipationPopupMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchRegisterLobbyWindowMVCActorsCommand extends SimpleCommand
   {
      
      public function TeamDeathMatchRegisterLobbyWindowMVCActorsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         if(!facade.hasMediator(TeamDeathMatchLobbywindowMediator.NAME))
         {
            facade.registerMediator(new TeamDeathMatchLobbywindowMediator());
         }
         if(!facade.hasMediator(TeamDeathMatchLevelRequirementPopupMediator.NAME))
         {
            facade.registerMediator(new TeamDeathMatchLevelRequirementPopupMediator());
         }
         if(!facade.hasMediator(TeamDeathMatchParticipationPopupMediator.NAME))
         {
            facade.registerMediator(new TeamDeathMatchParticipationPopupMediator());
         }
         if(!facade.hasMediator(TeamDeathMatchErrorPopUpMediator.NAME))
         {
            facade.registerMediator(new TeamDeathMatchErrorPopUpMediator());
         }
         if(!facade.hasProxy(TeamDeathMatchLobbywindowProxy.NAME))
         {
            facade.registerProxy(new TeamDeathMatchLobbywindowProxy());
         }
         if(!facade.hasCommand(TeamDeathMatchLobbywindowNotifications.OPEN_TDM_LOBBY_WINDOW))
         {
            facade.registerCommand(TeamDeathMatchLobbywindowNotifications.OPEN_TDM_LOBBY_WINDOW,TeamDeathMatchOpenLobbyWindowAsyncMacroCommand);
         }
         if(!facade.hasCommand(TeamDeathMatchLobbywindowNotifications.CLOSE_TDM_LOBBY_WINDOW))
         {
            facade.registerCommand(TeamDeathMatchLobbywindowNotifications.CLOSE_TDM_LOBBY_WINDOW,TeamDeathMatchCloseLobbyWindowCommand);
         }
      }
   }
}

