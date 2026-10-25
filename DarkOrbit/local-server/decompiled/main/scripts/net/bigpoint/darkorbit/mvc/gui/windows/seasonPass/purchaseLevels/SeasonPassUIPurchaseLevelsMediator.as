package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.purchaseLevels
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.SeasonPassLevelPurchaseRequest;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.RogueLiteUIWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.SeasonPassUIPopUpUtils;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model.SeasonPassUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model.SeasonPassUIProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SeasonPassUIPurchaseLevelsMediator extends SimpleWindowMediator
   {
      
      public static const MAX_LEVEL_PURCHASABLE_INDEX:Number = 90;
      
      private var _data:SeasonPassUIData;
      
      private var _view:SeasonPassUIPurchaseLevelsView;
      
      private var _upgradeLevel:BindableInt = new BindableInt(0,0,MAX_LEVEL_PURCHASABLE_INDEX);
      
      private var _upgradeCost:Number = 1.7976931348623157e+308;
      
      public function SeasonPassUIPurchaseLevelsMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:SeasonPassUIData) : void
      {
         this._data = param1;
         if(this._data)
         {
            this.resetUI();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new SeasonPassUIPurchaseLevelsView(simpleWindow.getUIContainer());
         var _loc2_:SeasonPassUIProxy = retrieveProxy(GuiConstants.SEASON_PASS) as SeasonPassUIProxy;
         this.data = _loc2_.viewData;
         this.addListeners();
         (window as SimpleWindow).activateModalLayer(true);
         this._view.iconUridium.loadResource(ItemDataProviderHelper.getItem("currency_uridium").getLoot30x30(),this.handleIconLoaded,this.handleIconLoadError,AssetsProxy.ITEMS);
         var _loc3_:Map = ScreenManager.getInstance().map;
         if(RogueLiteUIWindowMediator.FORBIDDEN_MAP.indexOf(_loc3_.mapID) >= 0)
         {
            return;
         }
      }
      
      private function addListeners() : void
      {
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onWindowMaximized);
         this._view.btnMinus.addEventListener(MouseEvent.CLICK,this.onLevelBtnClicked);
         this._view.btnPlus.addEventListener(MouseEvent.CLICK,this.onLevelBtnClicked);
         this._view.btnMax.addEventListener(MouseEvent.CLICK,this.onLevelBtnClicked);
         this._view.btnUpgrade.addEventListener(MouseEvent.CLICK,this.onUpgradeClick);
         this._view.btnCancel.addEventListener(MouseEvent.CLICK,this.minimizeWindow);
         this._data.levelServer.changed.add(this.resetUI);
      }
      
      private function removeListeners() : void
      {
         window.removeEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onWindowMaximized);
         this._view.btnMinus.removeEventListener(MouseEvent.CLICK,this.onLevelBtnClicked);
         this._view.btnPlus.removeEventListener(MouseEvent.CLICK,this.onLevelBtnClicked);
         this._view.btnMax.removeEventListener(MouseEvent.CLICK,this.onLevelBtnClicked);
         this._view.btnUpgrade.removeEventListener(MouseEvent.CLICK,this.onUpgradeClick);
         this._view.btnCancel.removeEventListener(MouseEvent.CLICK,this.minimizeWindow);
         this._data.levelServer.changed.remove(this.resetUI);
      }
      
      private function onWindowMaximized(param1:SimpleWindowEvent) : void
      {
         (window as SimpleWindow).activateModalLayer(true);
         this.resetUI();
      }
      
      private function minimizeWindow(param1:MouseEvent) : void
      {
         (window as SimpleWindow).activateModalLayer(false);
         window.minimize(false,true);
      }
      
      private function resetUI() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelCurrLevel.text = TextFormatter.roundInteger(this._data.levelServer.value);
         this.upgradeLevel = this._data.levelServer.value + 1;
      }
      
      private function onLevelBtnClicked(param1:MouseEvent) : void
      {
         if(param1.target == this._view.btnMinus && this._upgradeLevel.value - 1 > this._data.levelServer.value)
         {
            this.upgradeLevel = this._upgradeLevel.value - 1;
         }
         else if(param1.target == this._view.btnPlus && this._upgradeLevel.value + 1 <= MAX_LEVEL_PURCHASABLE_INDEX)
         {
            this.upgradeLevel = this._upgradeLevel.value + 1;
         }
         else if(param1.target == this._view.btnMax && this._upgradeLevel.value != MAX_LEVEL_PURCHASABLE_INDEX)
         {
            this.upgradeLevel = MAX_LEVEL_PURCHASABLE_INDEX;
         }
      }
      
      private function set upgradeLevel(param1:Number) : void
      {
         this._upgradeLevel.value = param1;
         this._view.labelUpgradeLevel.text = TextFormatter.roundInteger(param1);
         this._view.btnMax.enabled = this._upgradeLevel.value != MAX_LEVEL_PURCHASABLE_INDEX;
         this._view.btnMinus.enabled = this._upgradeLevel.value > this._data.levelServer.value + 1;
         this._view.btnPlus.enabled = this._view.btnMax.isEnabled();
         this.updateCostElement();
      }
      
      private function updateCostElement() : void
      {
         this._upgradeCost = this._data.priceData[this._upgradeLevel.value] - this._data.priceData[this._data.levelServer.value];
         this._view.labelCostRequired.text = TextFormatter.roundInteger(this._upgradeCost);
         this._view.labelCostPlayer.text = TextFormatter.roundInteger(Hero.uridiumAmount);
         this._view.labelCostPlayer.registeredTextStyleName = Hero.uridiumAmount < this._upgradeCost ? "season_pass_popup_cost_item_red" : "season_pass_popup_cost_item";
         this._view.btnUpgrade.enabled = Hero.uridiumAmount >= this._upgradeCost;
      }
      
      private function onUpgradeClick(param1:MouseEvent) : void
      {
         if(Hero.uridiumAmount >= this._upgradeCost)
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SeasonPassLevelPurchaseRequest(this._upgradeLevel.value - this._data.levelServer.value));
         }
         else
         {
            SeasonPassUIPopUpUtils.createPopup(GuiConstants.SEASON_PASS_POPUP_ERROR,null,null,"window_purchaselevel_sp_tab_uridium-error");
         }
         this.minimizeWindow(param1);
      }
      
      private function handleIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.iconUridium);
         var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._view.iconUridium.width;
         _loc2_.height = this._view.iconUridium.height;
         this._view.iconUridium.addChild(_loc2_);
      }
      
      private function handleIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.iconUridium);
      }
   }
}

