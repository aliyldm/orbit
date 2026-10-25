package net.bigpoint.darkorbit.mvc.wargame.view.lobby
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.com.module.WarGameJoinRequest;
   import net.bigpoint.darkorbit.com.module.WarGameLeaveQueueRequest;
   import net.bigpoint.darkorbit.com.module.WarGameLobbyStatusModule;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.view.EventRewardsDataAssigner;
   import net.bigpoint.darkorbit.mvc.wargame.constants.WargameConst;
   import net.bigpoint.darkorbit.mvc.wargame.control.WargameNotification;
   import net.bigpoint.darkorbit.mvc.wargame.model.WargameLobbyProxy;
   import net.bigpoint.darkorbit.mvc.wargame.model.data.WargameSingupModel;
   
   public class WargameLobbyMediator extends SimpleWindowMediator
   {
      
      private var _lobbyView:WarGameLobbyView;
      
      private var _data:WargameSingupModel;
      
      private var _state2View:Object = {};
      
      private var _statusFunctions:Object = {};
      
      public function WargameLobbyMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleOnClose);
         param2.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleOnMaximized);
      }
      
      private function handleOnMaximized(param1:SimpleWindowEvent) : void
      {
         sendNotification(WargameNotification.UPDATE_LOBBY);
      }
      
      private function handleOnClose(param1:SimpleWindowEvent) : void
      {
         window.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleOnClose);
         window.removeEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleOnMaximized);
         facade.removeMediator(getMediatorName());
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.initLobbyView();
      }
      
      override public function onRemove() : void
      {
         this.removeEventListener();
         this.data = null;
         super.onRemove();
      }
      
      private function initLobbyView() : void
      {
         this._lobbyView = new WarGameLobbyView(UIContentContainer);
         this._lobbyView.rewards.itemDataAssigner = EventRewardsDataAssigner;
         this.addEventListener();
         this._statusFunctions[WarGameLobbyStatusModule.STATUS_GEAR_SCORE_TOO_LOW] = this.showWarning;
         this._statusFunctions[WarGameLobbyStatusModule.STATUS_IN_QUEUE] = this.showInQueue;
         this._statusFunctions[WarGameLobbyStatusModule.STATUS_READY] = this.showReady;
         this._state2View[WarGameLobbyStatusModule.STATUS_GEAR_SCORE_TOO_LOW] = this._lobbyView.stateGEAR_SCORE_TOO_LOWContainer;
         this._state2View[WarGameLobbyStatusModule.STATUS_IN_QUEUE] = this._lobbyView.stateIN_QUEUEContainer;
         this._state2View[WarGameLobbyStatusModule.STATUS_READY] = this._lobbyView.stateREADYContainer;
         this.data = (retrieveWindowProxy() as WargameLobbyProxy).getData() as WargameSingupModel;
      }
      
      private function addEventListener() : void
      {
         this._lobbyView.singUpButton.addEventListener(MouseEvent.CLICK,this.handleSignUpClicked);
         this._lobbyView.rewardsLeftButton.addEventListener(MouseEvent.CLICK,this.handleLeftClicked);
         this._lobbyView.rewardsRightButton.addEventListener(MouseEvent.CLICK,this.handleRightClicked);
         this._lobbyView.stateIN_QUEUEContainerLeave.addEventListener(MouseEvent.CLICK,this.handleLeaveClicked);
      }
      
      private function removeEventListener() : void
      {
         this._lobbyView.singUpButton.removeEventListener(MouseEvent.CLICK,this.handleSignUpClicked);
         this._lobbyView.rewardsLeftButton.removeEventListener(MouseEvent.CLICK,this.handleLeftClicked);
         this._lobbyView.rewardsRightButton.removeEventListener(MouseEvent.CLICK,this.handleRightClicked);
         this._lobbyView.stateIN_QUEUEContainerLeave.removeEventListener(MouseEvent.CLICK,this.handleLeaveClicked);
      }
      
      private function set data(param1:WargameSingupModel) : void
      {
         if(this._data)
         {
            this._data.change.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.change.add(this.update);
            this.update();
         }
      }
      
      private function showReady(param1:WarGameLobbyStatusModule) : void
      {
         this.updateState(param1.status);
      }
      
      private function showInQueue(param1:WarGameLobbyStatusModule) : void
      {
         this.updateState(param1.status);
      }
      
      private function showWarning(param1:WarGameLobbyStatusModule) : void
      {
         this.updateState(param1.status);
      }
      
      private function update() : void
      {
         this.setRewards(this._data.rewards);
         try
         {
            if(this._data.status)
            {
               this._statusFunctions[this._data.status.status](this._data.status);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function updateState(param1:int) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._state2View)
         {
            (this._state2View[_loc2_] as Coreponent).visible = _loc2_ == param1;
         }
      }
      
      private function setRewards(param1:Vector.<RewardContentModule>) : void
      {
         this._lobbyView.rewards.list = new VectorCollection(param1);
         this._lobbyView.rewardsLeftButton.visible = this._lobbyView.rewardsRightButton.visible = !this._lobbyView.rewards.allItemsDisplayed();
      }
      
      private function handleRightClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = this._lobbyView.rewards.getScrollOneItemAmount() * WargameConst.SCROLL_REWARD_VISIBLE_ELEMENTS;
         this._lobbyView.rewards.setScrollPositionInPercent(this._lobbyView.rewards.getScrollPositionInPercent() + _loc2_);
      }
      
      private function handleLeftClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = this._lobbyView.rewards.getScrollOneItemAmount() * WargameConst.SCROLL_REWARD_VISIBLE_ELEMENTS;
         this._lobbyView.rewards.setScrollPositionInPercent(this._lobbyView.rewards.getScrollPositionInPercent() - _loc2_);
      }
      
      private function handleSignUpClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new WarGameJoinRequest());
      }
      
      private function handleLeaveClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new WarGameLeaveQueueRequest());
      }
   }
}

