package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDetailCommand;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDetailRequest;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchJoinRequest;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchLeaveQueueRequest;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewCommand;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.TeamDeathMatchLobbywindowNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.events.TeamDeathMatchLobbyWindowEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class TeamDeathMatchLobbywindowMediator extends Mediator
   {
      
      public static const NAME:String = "TeamDeathMatchLobbywindowMediator";
      
      protected var _creationCompleteCallback:Function;
      
      public function TeamDeathMatchLobbywindowMediator()
      {
         super(NAME);
      }
      
      public function setWindow(param1:Object, param2:Function = null) : void
      {
         this._creationCompleteCallback = param2;
         this.removeEventListeners();
         super.setViewComponent(param1);
         this.addEventListeners();
      }
      
      public function get window() : ITeamDeathMatchLobbywindow
      {
         return viewComponent as ITeamDeathMatchLobbywindow;
      }
      
      override public function onRegister() : void
      {
         this.addEventListeners();
      }
      
      override public function onRemove() : void
      {
         this.removeEventListeners();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_OVERVIEW,TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_DETAIL,TeamDeathMatchLobbywindowNotifications.UPDATE_LEVELRANGE,TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_TIME,TeamDeathMatchLobbywindowNotifications.CLEAR_MATCH_TIME,TeamDeathMatchLobbywindowNotifications.SET_UI_INTERACTIVITY,GuiNotifications.CLOSE_ALL_FLEX_WINDOWS,GuiNotifications.CLOSE_WINDOW_BY_TYPE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:TeamDeathMatchOverviewCommand = null;
         var _loc4_:TeamDeathMatchDetailCommand = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_OVERVIEW:
               _loc3_ = param1.getBody() as TeamDeathMatchOverviewCommand;
               this.updateMatchOverviewData(_loc3_);
               break;
            case TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_DETAIL:
               _loc4_ = param1.getBody() as TeamDeathMatchDetailCommand;
               this.updateMatchDetailData(_loc4_);
               break;
            case TeamDeathMatchLobbywindowNotifications.UPDATE_LEVELRANGE:
               _loc5_ = param1.getBody() as Array;
               this.updateLevelrange(_loc5_[0],_loc5_[1]);
               break;
            case TeamDeathMatchLobbywindowNotifications.UPDATE_MATCH_TIME:
               _loc6_ = param1.getBody() as String;
               this.updateMatchTime(_loc6_);
               break;
            case TeamDeathMatchLobbywindowNotifications.CLEAR_MATCH_TIME:
               this.clearMatchTime();
               break;
            case TeamDeathMatchLobbywindowNotifications.SET_UI_INTERACTIVITY:
               _loc7_ = param1.getBody() as Boolean;
               this.setUIInteractivity(_loc7_);
               break;
            case GuiNotifications.CLOSE_ALL_FLEX_WINDOWS:
               this.handleWindowRemoved();
               break;
            case GuiNotifications.CLOSE_WINDOW_BY_TYPE:
               _loc8_ = param1.getBody() as String;
               if(_loc8_ == FlexWindowManager.TEAMDEATHMATCH_LOBBY_WINDOW)
               {
                  this.handleWindowRemoved();
               }
         }
      }
      
      private function updateMatchDetailData(param1:TeamDeathMatchDetailCommand) : void
      {
         if(this.window)
         {
            this.window.updateMatchDetailData(param1);
         }
      }
      
      private function updateMatchOverviewData(param1:TeamDeathMatchOverviewCommand) : void
      {
         if(this.window)
         {
            this.window.updateMatchOverviewData(param1);
         }
      }
      
      private function updateLevelrange(param1:uint, param2:uint) : void
      {
         if(this.window)
         {
            this.window.updateLevelrange(param1,param2);
         }
      }
      
      private function setUIInteractivity(param1:Boolean) : void
      {
         if(this.window)
         {
            this.window.enableUserInteraction(param1);
         }
      }
      
      private function clearMatchTime() : void
      {
         if(this.window)
         {
            this.window.clearMatchTime();
         }
      }
      
      private function updateMatchTime(param1:String) : void
      {
         if(this.window)
         {
            this.window.updateMatchTime(param1);
         }
      }
      
      private function addEventListeners() : void
      {
         if(this.window)
         {
            this.window.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleWindowRemoved);
            this.window.addEventListener(TeamDeathMatchLobbyWindowEvent.WINDOW_CREATED,this.handleWindowCreated);
            this.window.addEventListener(TeamDeathMatchLobbyWindowEvent.SEND_MATCH_OVERVIEW_REQUEST,this.handleSendMatchOverviewRequest);
            this.window.addEventListener(TeamDeathMatchLobbyWindowEvent.JOIN_BUTTON_CLICKED,this.handleJoinButtonClicked);
            this.window.addEventListener(TeamDeathMatchLobbyWindowEvent.LEAVE_BUTTON_CLICKED,this.handleLeaveButtonClicked);
            this.window.addEventListener(TeamDeathMatchLobbyWindowEvent.MATCHOVERVIEW_SELECTION_CHANGED,this.handleItemListSelectionChanged);
         }
      }
      
      private function removeEventListeners() : void
      {
         if(this.window)
         {
            this.window.removeEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleWindowRemoved);
            this.window.removeEventListener(TeamDeathMatchLobbyWindowEvent.WINDOW_CREATED,this.handleWindowCreated);
            this.window.removeEventListener(TeamDeathMatchLobbyWindowEvent.SEND_MATCH_OVERVIEW_REQUEST,this.handleSendMatchOverviewRequest);
            this.window.removeEventListener(TeamDeathMatchLobbyWindowEvent.JOIN_BUTTON_CLICKED,this.handleJoinButtonClicked);
            this.window.removeEventListener(TeamDeathMatchLobbyWindowEvent.LEAVE_BUTTON_CLICKED,this.handleLeaveButtonClicked);
            this.window.removeEventListener(TeamDeathMatchLobbyWindowEvent.MATCHOVERVIEW_SELECTION_CHANGED,this.handleItemListSelectionChanged);
         }
      }
      
      private function handleWindowRemoved(param1:Event = null) : void
      {
         this.unregisterMediator();
      }
      
      private function unregisterMediator() : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      private function handleWindowCreated(param1:Event) : void
      {
         if(this._creationCompleteCallback != null)
         {
            this._creationCompleteCallback();
         }
      }
      
      private function handleSendMatchOverviewRequest(param1:TeamDeathMatchLobbyWindowEvent) : void
      {
      }
      
      private function handleJoinButtonClicked(param1:TeamDeathMatchLobbyWindowEvent) : void
      {
         var _loc2_:uint = uint(param1.matchId);
         facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TeamDeathMatchJoinRequest(_loc2_));
      }
      
      private function handleLeaveButtonClicked(param1:TeamDeathMatchLobbyWindowEvent) : void
      {
         var _loc2_:uint = uint(param1.matchId);
         facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TeamDeathMatchLeaveQueueRequest());
      }
      
      private function handleItemListSelectionChanged(param1:TeamDeathMatchLobbyWindowEvent) : void
      {
         var _loc2_:uint = uint(param1.matchId);
         facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TeamDeathMatchDetailRequest(_loc2_));
      }
   }
}

