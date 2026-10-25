package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.refreshMissions
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.liveops.seasonpass.SeasonPassRefreshRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.SeasonPassUIPopUpUtils;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.vo.SeasonPassMissionVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.view.SeasonPassUIMissionsMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.view.SeasonPassUIRewardsMediator;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class SeasonPassRefreshConfirmMediator extends SimpleWindowMediator
   {
      
      private var _view:SeasonPassRefreshConfirmView;
      
      private var _data:SeasonPassMissionVO = null;
      
      public function SeasonPassRefreshConfirmMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new SeasonPassRefreshConfirmView(this.simpleWindow.getUIContainer());
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.resetUI);
         this._view.btnCancel.addEventListener(MouseEvent.CLICK,this.minimizeWindow);
         this._view.confirmBtn.addEventListener(MouseEvent.CLICK,this.reroll);
         this._view.btnUpgrade.addEventListener(MouseEvent.CLICK,this.upgrade);
         this.resetUI(null);
      }
      
      public function set data(param1:SeasonPassMissionVO) : void
      {
         this._data = param1;
      }
      
      protected function resetUI(param1:SimpleWindowEvent) : void
      {
         var _loc3_:SeasonPassUIRewardsMediator = null;
         if(this._data == null || !isUIReady())
         {
            return;
         }
         var _loc2_:SeasonPassUIMissionsMediator = GameFacade.getInstance().retrieveMediator(GuiConstants.SEASON_PASS_MISSIONS) as SeasonPassUIMissionsMediator;
         this._view.labelMain.localizedText = "window_mission_refresh_times_hint";
         this._view.labelMain.text = this._view.labelMain.text.replace("%VALUE%",_loc2_.data.CurUsedCount + "/" + _loc2_.data.CurMaxCount);
         _loc3_ = GameFacade.getInstance().retrieveMediator(GuiConstants.SEASON_PASS_REWARDS) as SeasonPassUIRewardsMediator;
         this._view.btnUpgrade.visible = _loc3_.goldPassLocked;
         this._view.upgradeOpenHintLabel.visible = _loc3_.goldPassLocked;
         this._view.btnCancel.autoSizeHeight = _loc3_.goldPassLocked;
         this._view.confirmBtn.autoSizeHeight = _loc3_.goldPassLocked;
         this._view.messageContainer.marginTop = _loc3_.goldPassLocked ? 0 : 50;
         this._view.confirmButtonsContainer.marginTop = _loc3_.goldPassLocked ? 100 : 180;
      }
      
      private function minimizeWindow(param1:MouseEvent) : void
      {
         (window as SimpleWindow).activateModalLayer(false);
         window.minimize(false,true);
      }
      
      private function reroll(param1:MouseEvent) : void
      {
         if(this._data == null)
         {
            return;
         }
         var _loc2_:SeasonPassRefreshRequest = new SeasonPassRefreshRequest(SeasonPassRefreshRequest.COSTTYPE_FREE_CHANCE,this._data.quest.id);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
         this.minimizeWindow(null);
      }
      
      private function upgrade(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         var handleOk:Function = function():void
         {
            JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials",null);
         };
         SeasonPassUIPopUpUtils.createPopupBanner(GuiConstants.SEASON_PASS_POPUP_BUY_GOLD_PASS,handleOk);
         this.minimizeWindow(null);
      }
   }
}

