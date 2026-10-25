package net.bigpoint.darkorbit.mvc.sectorControlWindow.view
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchDetailCommand;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchDetailRequest;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchJoinRequest;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchLeaveQueueRequest;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchOverviewRequest;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.controller.SectorControlSelectionChangedCommand;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.LableUpdateVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.events.SectorControlLobbyWindowEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class SectorControlLobbyWindowMediator extends Mediator
   {
      
      public static const NAME:String = "SectorControlLobbyWindowMediator";
      
      public function SectorControlLobbyWindowMediator(param1:ISectorControlLobbyWindow = null)
      {
         super(NAME,param1);
      }
      
      override public function setViewComponent(param1:Object) : void
      {
         this.removeEventListener();
         super.setViewComponent(param1);
         this.addEventListeners();
      }
      
      override public function onRegister() : void
      {
         facade.registerCommand(SectorControlWindowNotifications.SELECTION_CHANGED,SectorControlSelectionChangedCommand);
         this.addEventListeners();
      }
      
      override public function onRemove() : void
      {
         this.removeEventListener();
         sendNotification(SectorControlWindowNotifications.SELECTION_REMOVE);
         facade.removeCommand(SectorControlWindowNotifications.SELECTION_CHANGED);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [SectorControlWindowNotifications.UPDATE_ITEMLIST,SectorControlWindowNotifications.UPDATE_LEVELRANGE,SectorControlWindowNotifications.UPDATE_MATCH_DETAIL_PANEL,SectorControlWindowNotifications.UPDATE_MATCH_TIME,SectorControlWindowNotifications.CLEAR_MATCH_TIME,MapNotification.CLEANUP,SectorControlWindowNotifications.UPDATE_MIN_PLAYERS_PER_TEAM,SectorControlWindowNotifications.SET_UI_INTERACTIVITY,SectorControlWindowNotifications.SET_JOIN_LEAVE_BUTTON_STATE,SectorControlWindowNotifications.UPDATE_MESSAGE_LABLE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Vector.<SectorControlItemlistOverviewVO> = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:SectorControlMatchDetailCommand = null;
         var _loc8_:String = null;
         var _loc9_:DOWindow = null;
         var _loc10_:LableUpdateVO = null;
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case SectorControlWindowNotifications.UPDATE_ITEMLIST:
               _loc3_ = param1.getBody() as Vector.<SectorControlItemlistOverviewVO>;
               this.updateItemList(_loc3_);
               break;
            case SectorControlWindowNotifications.UPDATE_LEVELRANGE:
               _loc4_ = param1.getBody() as Array;
               _loc5_ = uint(_loc4_[0]);
               _loc6_ = uint(_loc4_[1]);
               this.updateLevelRange(_loc5_,_loc6_);
               break;
            case SectorControlWindowNotifications.UPDATE_MATCH_DETAIL_PANEL:
               _loc7_ = param1.getBody() as SectorControlMatchDetailCommand;
               this.updateMatchStatePanel(_loc7_);
               break;
            case SectorControlWindowNotifications.UPDATE_MATCH_TIME:
               _loc8_ = param1.getBody() as String;
               this.updateMatchTime(_loc8_);
               break;
            case SectorControlWindowNotifications.CLEAR_MATCH_TIME:
               this.clearMatchTime();
               break;
            case MapNotification.CLEANUP:
               _loc9_ = this.window as DOWindow;
               sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,_loc9_.windowType);
               break;
            case SectorControlWindowNotifications.UPDATE_MIN_PLAYERS_PER_TEAM:
               this.window.updateUserMinPlayerPerTeam(param1.getBody() as int);
               break;
            case SectorControlWindowNotifications.SET_UI_INTERACTIVITY:
               this.window.enableUserInteraction(param1.getBody() as Boolean);
               break;
            case SectorControlWindowNotifications.SET_JOIN_LEAVE_BUTTON_STATE:
               this.window.updateActionButtonLable(param1.getBody() as String);
               break;
            case SectorControlWindowNotifications.UPDATE_MESSAGE_LABLE:
               _loc10_ = param1.getBody() as LableUpdateVO;
               this.window.updateMessageLable(_loc10_.playerAlreadyQueued,_loc10_.minimumPlayersReached);
         }
      }
      
      private function addEventListeners() : void
      {
         this.window.addEventListener(Event.CLOSE,this.handleWindowRemoved);
         this.window.addEventListener(SectorControlLobbyWindowEvent.SEND_MATCH_OVERVIEW_REQUEST,this.handleSendMatchOverviewRequest);
         this.window.addEventListener(SectorControlLobbyWindowEvent.ACTIONBUTTON_CLICKED,this.handleActionButtonClicked);
         this.window.addEventListener(SectorControlLobbyWindowEvent.ITEMLIST_SELECTION_CHANGED,this.handleItemListSelectionChanged);
      }
      
      private function removeEventListener() : void
      {
         this.window.removeEventListener(Event.CLOSE,this.handleWindowRemoved);
         this.window.removeEventListener(SectorControlLobbyWindowEvent.SEND_MATCH_OVERVIEW_REQUEST,this.handleSendMatchOverviewRequest);
         this.window.removeEventListener(SectorControlLobbyWindowEvent.ACTIONBUTTON_CLICKED,this.handleActionButtonClicked);
         this.window.removeEventListener(SectorControlLobbyWindowEvent.ITEMLIST_SELECTION_CHANGED,this.handleItemListSelectionChanged);
      }
      
      private function handleSendMatchOverviewRequest(param1:SectorControlLobbyWindowEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SectorControlMatchOverviewRequest());
      }
      
      private function handleActionButtonClicked(param1:SectorControlLobbyWindowEvent) : void
      {
         switch(param1.action)
         {
            case SectorControlLobbyWindowEvent.ACTION_JOIN:
               this.joinMatch(param1);
               break;
            case SectorControlLobbyWindowEvent.ACTION_LEAVE:
               this.leaveMatch(param1);
               break;
            case SectorControlLobbyWindowEvent.ACTION_SHOW_LEAVE_QUEUE_DIALOG:
               this.showLeaveQueueDialog(param1);
         }
      }
      
      private function handleItemListSelectionChanged(param1:SectorControlLobbyWindowEvent) : void
      {
         var _loc2_:SectorControlItemlistOverviewVO = param1.itemListVO;
         sendNotification(SectorControlWindowNotifications.SELECTION_CHANGED,_loc2_);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SectorControlMatchDetailRequest(_loc2_.matchID));
      }
      
      private function handleWindowRemoved(param1:Event) : void
      {
         this.sectorControlProxy.clearTimer();
         facade.removeMediator(this.getMediatorName());
      }
      
      private function joinMatch(param1:SectorControlLobbyWindowEvent) : void
      {
         var _loc2_:int = int(param1.matchID);
         if(_loc2_ > 0)
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SectorControlMatchJoinRequest(_loc2_));
         }
      }
      
      private function leaveMatch(param1:SectorControlLobbyWindowEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SectorControlMatchLeaveQueueRequest());
      }
      
      private function showLeaveQueueDialog(param1:SectorControlLobbyWindowEvent) : void
      {
         sendNotification(SectorControlWindowNotifications.OPEN_SECTOR_CONTROL_LEAVEQUEUE_WINDOW,param1.matchID);
      }
      
      private function updateMatchStatePanel(param1:SectorControlMatchDetailCommand) : void
      {
         this.window.updateMatchStatePanel(param1);
      }
      
      private function updateItemList(param1:Vector.<SectorControlItemlistOverviewVO>) : void
      {
         this.window.updateItemlist(param1);
      }
      
      private function updateLevelRange(param1:uint, param2:uint) : void
      {
         this.window.updateUserLevel(Hero.level,param1,param2);
      }
      
      private function updateMatchTime(param1:String) : void
      {
         this.window.updateMatchTime(param1);
      }
      
      private function clearMatchTime() : void
      {
         this.window.clearMatchTime();
      }
      
      private function get sectorControlProxy() : SectorControlProxy
      {
         return this.facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
      }
      
      protected function get window() : ISectorControlLobbyWindow
      {
         return viewComponent as ISectorControlLobbyWindow;
      }
   }
}

