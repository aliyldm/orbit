package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.open
{
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.TeamDeathMatchLobbywindowNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.model.TeamDeathMatchLobbywindowProxy;
   import net.bigpoint.darkorbit.mvc.tdm.popups.TeamDeathMatchPopupNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchOpenLobbyWindowPreconditionCommand extends SimpleCommand
   {
      
      public function TeamDeathMatchOpenLobbyWindowPreconditionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TeamDeathMatchLobbywindowProxy = facade.retrieveProxy(TeamDeathMatchLobbywindowProxy.NAME) as TeamDeathMatchLobbywindowProxy;
         if(_loc2_.isRequiredLevel())
         {
            sendNotification(TeamDeathMatchLobbywindowNotifications.OPEN_TDM_LOBBY_WINDOW);
         }
         else
         {
            sendNotification(TeamDeathMatchPopupNotifications.OPEN_PLAYER_REQUIREMENT_POPUP);
         }
      }
   }
}

