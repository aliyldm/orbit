package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.open
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.model.TeamDeathMatchLobbywindowProxy;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbywindow;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbywindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class TeamDeathMatchShowLobbywindowAsyncCommand extends AsyncCommand
   {
      
      public function TeamDeathMatchShowLobbywindowAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:TeamDeathMatchLobbywindow = null;
         var _loc4_:TeamDeathMatchLobbywindowMediator = null;
         super.execute(param1);
         var _loc2_:TeamDeathMatchLobbywindowProxy = facade.retrieveProxy(TeamDeathMatchLobbywindowProxy.NAME) as TeamDeathMatchLobbywindowProxy;
         if(_loc2_.isRequiredLevel())
         {
            _loc3_ = FlexWindowManager.getInstance().getWindowByType(FlexWindowManager.TEAMDEATHMATCH_LOBBY_WINDOW) as TeamDeathMatchLobbywindow;
            if(_loc3_ == null)
            {
               _loc3_ = FlexWindowManager.getInstance().createWindow(FlexWindowManager.TEAMDEATHMATCH_LOBBY_WINDOW,FlexWindowManager.WINDOW_RIGHT_ALIGNED) as TeamDeathMatchLobbywindow;
               if(_loc3_.visible)
               {
                  AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_QUEST_WINDOW_OPEN_SOUND);
               }
            }
            _loc4_ = facade.retrieveMediator(TeamDeathMatchLobbywindowMediator.NAME) as TeamDeathMatchLobbywindowMediator;
            _loc4_.setWindow(_loc3_,this.windowCreatedCallback);
         }
      }
      
      protected function windowCreatedCallback() : void
      {
         var _loc1_:TeamDeathMatchLobbywindowProxy = facade.retrieveProxy(TeamDeathMatchLobbywindowProxy.NAME) as TeamDeathMatchLobbywindowProxy;
         _loc1_.refreshObserver();
      }
   }
}

