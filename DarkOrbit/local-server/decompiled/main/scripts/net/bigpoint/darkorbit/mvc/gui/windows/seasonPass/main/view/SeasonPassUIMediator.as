package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.RogueLiteUIWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.SeasonPassUIPopUpUtils;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model.SeasonPassUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.SeasonPassUIMissionsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.SeasonPassUIMissionsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.view.SeasonPassUIMissionsMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.purchaseLevels.SeasonPassUIPurchaseLevelsMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.SeasonPassUIRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.SeasonPassUIRewardsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.view.SeasonPassUIRewardsMediator;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SeasonPassUIMediator extends SimpleWindowMediator
   {
      
      private static const SEASON_PASS_WINDOWS:Array = [GuiConstants.SEASON_PASS_POPUP_PURCHASE_LEVELS,GuiConstants.SEASON_PASS_POPUP_ERROR,GuiConstants.SEASON_PASS_POPUP_BUY_GOLD_PASS,GuiConstants.SEASON_PASS,GuiConstants.SEASON_PASS_POPUP_CONFIRM_REFRESH];
      
      private var _subviews:Vector.<ITabItem> = new Vector.<ITabItem>(0);
      
      private var _loadCounter:int = 0;
      
      private var _data:SeasonPassUIData;
      
      private var _view:SeasonPassUIView;
      
      private var _rewardsData:SeasonPassUIRewardsData;
      
      private var _missionsData:SeasonPassUIMissionsData;
      
      public function SeasonPassUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         var _loc1_:SeasonPassUIRewardsProxy = null;
         var _loc2_:SeasonPassUIMissionsProxy = null;
         super.onRegister();
         facade.registerProxy(_loc1_ = new SeasonPassUIRewardsProxy(GuiConstants.SEASON_PASS_REWARDS));
         facade.registerProxy(_loc2_ = new SeasonPassUIMissionsProxy(GuiConstants.SEASON_PASS_MISSIONS));
         registerMediator(new SeasonPassUIRewardsMediator(GuiConstants.SEASON_PASS_REWARDS,simpleWindow));
         registerMediator(new SeasonPassUIMissionsMediator(GuiConstants.SEASON_PASS_MISSIONS,simpleWindow));
         this._rewardsData = _loc1_.viewData;
         this._missionsData = _loc2_.viewData;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.loadAndBuildWithResKey(GuiConstants.SEASON_PASS_REWARDS,param1);
         this.loadAndBuildWithResKey(GuiConstants.SEASON_PASS_MISSIONS,param1);
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param1);
         }
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      private function addListeners() : void
      {
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onWindowMaximize);
         this._view.btnPurchase.addEventListener(MouseEvent.CLICK,this.onPurchaseLevelBtnClicked);
      }
      
      private function removeListeners() : void
      {
         window.removeEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onWindowMaximize);
         this._view.btnPurchase.removeEventListener(MouseEvent.CLICK,this.onPurchaseLevelBtnClicked);
      }
      
      private function manualLoadMediator(param1:String, param2:Class, param3:ITabItem) : void
      {
         var _loc4_:* = retrieveMediator(param1) as param2;
         if(_loc4_ != null)
         {
            _loc4_.manualLoad(param3);
         }
      }
      
      private function loadAndBuildWithResKey(param1:String, param2:Array) : void
      {
         ++this._loadCounter;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc3_,this._internalHandleBuildComplete,[_loc3_,param2]);
      }
      
      private function _internalHandleBuildComplete(param1:Sprite, param2:Array) : void
      {
         var _loc3_:DisplayObjectContainer = window.getUIContainer().getChildByName("root") as DisplayObjectContainer;
         var _loc4_:Container = param1.getChildAt(0) as Container;
         _loc3_.addChild(_loc4_.getChildAt(0));
         --this._loadCounter;
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param2);
         }
      }
      
      protected function handleFinalContentLoaded(param1:Array) : void
      {
         this._view = new SeasonPassUIView(simpleWindow,this._subviews);
         this.data = retrieveWindowProxy().getData() as SeasonPassUIData;
         this.addListeners();
         this.manualLoadMediator(GuiConstants.SEASON_PASS_REWARDS,SeasonPassUIRewardsMediator,this._view.rewards);
         this.manualLoadMediator(GuiConstants.SEASON_PASS_MISSIONS,SeasonPassUIMissionsMediator,this._view.missions);
         var _loc2_:Map = ScreenManager.getInstance().map;
         if(RogueLiteUIWindowMediator.FORBIDDEN_MAP.indexOf(_loc2_.mapID) >= 0)
         {
            return;
         }
      }
      
      public function set data(param1:SeasonPassUIData) : void
      {
         if(this._data)
         {
            this._data.seasonRunning.changed.remove(this.onChangingSeason);
            this._data.ptsServer.changed.remove(this.onServerPtsUpdate);
            this._data.countdownTimer.changed.remove(this.onCountdownUpdate);
            this._data.subTitleKey.changed.remove(this.onSubTitleKeyUpdate);
            this._data.bannerKey.changed.remove(this.onBannerKeyUpdate);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.seasonRunning.changed.add(this.onChangingSeason);
            this._data.ptsServer.changed.add(this.onServerPtsUpdate);
            this._data.countdownTimer.changed.add(this.onCountdownUpdate);
            this._data.subTitleKey.changed.add(this.onSubTitleKeyUpdate);
            this._data.bannerKey.changed.add(this.onBannerKeyUpdate);
            this.update();
         }
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this.syncPoints();
         this.onCountdownUpdate();
         this.onSubTitleKeyUpdate();
         this.onBannerKeyUpdate();
         this.toggleContainer();
      }
      
      private function toggleContainer() : *
      {
         if(this._data == null || !isUIReady())
         {
            this._view.showContainer = false;
            return;
         }
         this._view.showContainer = this._data.countdownTimer.value > 0;
      }
      
      private function onWindowMaximize(param1:SimpleWindowEvent) : void
      {
         if(!isUIReady())
         {
            return;
         }
         this.toggleContainer();
         this.onServerPtsUpdate();
      }
      
      private function onChangingSeason() : void
      {
         this.toggleContainer();
      }
      
      private function syncPoints() : void
      {
         this._data.levelVisual.value = this._data.levelServer.value;
         this._view.labelLevel.text = TextFormatter.roundInteger(this._data.levelVisual.value >= this._data.levelServer.maxValue ? this._data.levelServer.maxValue : this._data.levelVisual.value + 1);
         this._data.ptsVisual.value = this._data.ptsServer.value;
         this._data.ptsVisualBar.maxValue = this._data.ptsServerBar.maxValue;
         this._data.ptsVisualBar.value = this._data.ptsServerBar.value;
         this._view.labelPtsIncrease.text = "";
         this._view.labelPtsCurrent.text = this._data.ptsVisualBar.value + "/" + this._data.ptsVisualBar.maxValue;
         this._view.progressBar.tweenComplete.remove(this.syncPoints);
         this.forceResetBar();
         this._view.btnPurchase.enabled = this._data.levelServer.value < SeasonPassUIPurchaseLevelsMediator.MAX_LEVEL_PURCHASABLE_INDEX;
      }
      
      private function forceResetBar() : *
      {
         this._view.progressBar.setCurrentValueNoTween(this._data.ptsVisualBar.value);
         if(this._data.ptsVisualBar.maxValue == this._data.ptsServerBar.maxValue && this._view.progressBar.maxValue != this._data.ptsServerBar.maxValue)
         {
            this._view.progressBar.maxValue = this._data.ptsServerBar.maxValue;
            this._view.progressBar.setCurrentValueNoTween(this._data.ptsServerBar.value);
         }
      }
      
      private function onServerPtsUpdate() : void
      {
         var _loc1_:int = 0;
         if(this._data.ptsServer.value < this._data.ptsVisual.value)
         {
            this.syncPoints();
            return;
         }
         if(simpleWindow.maximized && this._data.levelVisual.value < this._data.levelVisual.maxValue)
         {
            _loc1_ = this._data.ptsServer.value - this._data.ptsVisual.value;
            this._view.labelPtsIncrease.text = _loc1_ > 0 ? "+" + TextFormatter.roundInteger(_loc1_) : "";
            this.forceResetBar();
            this._view.progressBar.tweenComplete.add(this.syncPoints);
            this._view.progressBar.currentValue = this._data.levelServer.value > this._data.levelVisual.value ? this._data.ptsVisualBar.maxValue : this._data.ptsServerBar.value;
         }
      }
      
      private function onCountdownUpdate() : void
      {
         var _loc1_:String = null;
         var _loc2_:SimpleWindow = null;
         if(this._data.countdownTimer.value > 0)
         {
            this._view.labelCountdown.text = BPLocale.getItem("window_event_progress_label_timeleft") + " " + TimeFormatter.getSmartFormatedTime(this._data.countdownTimer.value);
         }
         else
         {
            this._view.labelCountdown.text = BPLocale.getItem("window_main_sp_season-ended");
            for each(_loc1_ in SEASON_PASS_WINDOWS)
            {
               _loc2_ = guiManager.getWindow(_loc1_);
               if(_loc2_)
               {
                  _loc2_.minimize(true,true);
               }
            }
            this.toggleContainer();
         }
      }
      
      private function onSubTitleKeyUpdate() : void
      {
         this._view.subTitle = this._data.subTitleKey.value;
      }
      
      private function onBannerKeyUpdate() : void
      {
         this._view.banner.loadResource(this._data.bannerKey.value,this.handleBannerLoaded,this.handleBannerLoadError,AssetsProxy.EVENTS);
      }
      
      private function handleBannerLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.banner);
         var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._view.banner.width;
         _loc2_.height = this._view.banner.height;
         this._view.banner.addChild(_loc2_);
      }
      
      private function handleBannerLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.banner);
      }
      
      private function onPurchaseLevelBtnClicked(param1:MouseEvent) : void
      {
         if(this._data.levelServer.value < SeasonPassUIPurchaseLevelsMediator.MAX_LEVEL_PURCHASABLE_INDEX)
         {
            if(!GuiManager.instance.getWindow(GuiConstants.SEASON_PASS_POPUP_PURCHASE_LEVELS))
            {
               sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,SimpleWindowCreationMap.getById(GuiConstants.SEASON_PASS_POPUP_PURCHASE_LEVELS));
               return;
            }
            sendNotification(GuiNotifications.MAXIMIZE_WINDOW_BY_ID,GuiConstants.SEASON_PASS_POPUP_PURCHASE_LEVELS);
         }
         else
         {
            this._view.btnPurchase.enabled = false;
            SeasonPassUIPopUpUtils.createPopup(GuiConstants.SEASON_PASS_POPUP_ERROR,null,null,"window_purchaselevel_sp_tab_level-error");
         }
      }
   }
}

