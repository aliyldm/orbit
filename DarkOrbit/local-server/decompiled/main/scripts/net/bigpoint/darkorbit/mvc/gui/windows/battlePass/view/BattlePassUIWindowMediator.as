package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.BattlePassCollectRequest;
   import net.bigpoint.darkorbit.com.module.BattlePassKeyExchangeRequest;
   import net.bigpoint.darkorbit.com.module.BattlePassSetFilterRequest;
   import net.bigpoint.darkorbit.com.module.BattlePassWindowSettingsModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterViewController;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.BattlePassUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo.BattlePassExchangeVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components.BattlePassRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class BattlePassUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:BattlePassUIData;
      
      private var _view:BattlePassRootView;
      
      private var _window:SimpleWindow;
      
      private var _videoURL:String;
      
      private var _filterUpdatePointer:uint;
      
      public function BattlePassUIWindowMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
         param2.setSize(443,490);
         this._window = param2;
         this._window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onMaximized);
         this._window.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.onMinimized);
      }
      
      private function onMinimized(param1:SimpleWindowEvent) : void
      {
         if(Boolean(this._view) && Boolean(this._view.objectives))
         {
            this._view.objectives.video.stop();
         }
      }
      
      private function onMaximized(param1:SimpleWindowEvent) : void
      {
         if(this._window.maximized)
         {
            this.playVideo();
         }
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:BattlePassUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.exchangeCreated.remove(this.createExchangeList);
            this._data.exchangekey.changed.remove(this.updateExchangeKeyAmount);
            this._data.exchangeUpdated.remove(this.handleFilterChange);
            this._data.filterChanged.remove(this.handleFilterChange);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.exchangeCreated.add(this.createExchangeList);
            param1.exchangekey.changed.add(this.updateExchangeKeyAmount);
            this._data.exchangeUpdated.add(this.handleFilterChange);
            this._data.filterChanged.add(this.handleFilterChange);
            this.update();
            this.createExchangeList();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new BattlePassRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as BattlePassUIData;
         this._videoURL = ItemsDataUtility.getVideoURLbyLootId(this._data.videoLootID);
         if(this._window.maximized)
         {
            this.playVideo();
         }
         this.addListeners();
         this.handleFilterChange();
      }
      
      private function updateDescription() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(!this._data.battlePassStatus)
            {
               this._view.objectives.descriptionTitle.localizedText = this._data.titleKeyBeforePurchase;
               this._view.objectives.descriptionBody.localizedText = this._data.descriptionKeyBeforePurchase;
               this._view.objectives.purchaseButton.visible = true;
               this._view.objectives.collectButton.visible = false;
            }
            else
            {
               this._view.objectives.purchaseButton.visible = false;
               if(this._data.hasRewardsToCollect)
               {
                  this._view.objectives.descriptionTitle.localizedText = this._data.titleKeyBeforePurchase;
                  this._view.objectives.descriptionBody.localizedText = this._data.descriptionKeyCollect;
                  this._view.objectives.collectButton.visible = true;
               }
               else
               {
                  this._view.objectives.descriptionTitle.localizedText = this._data.titleKeyAfterPurchase;
                  this._view.objectives.descriptionBody.localizedText = this._data.descriptionKeyAfterPurchase;
                  this._view.objectives.collectButton.visible = false;
               }
            }
         }
      }
      
      private function updateOverallProgress() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.objectives.overallProgress.text = this._data.numCompletedObjectives + "/" + this._data.numTotalObjectives;
         }
      }
      
      private function addListeners() : void
      {
         this._view.objectives.collectButton.addEventListener(MouseEvent.CLICK,this.handleCollectRewards);
         this._view.objectives.purchaseButton.addEventListener(MouseEvent.CLICK,this.handlePurchaseBattlePass);
         this._view.keyExchange.filterController.addEventListener(ItemFilterViewController.SETTINGS_CHANGED_EVENT,this.handleFilterSettingsChangedEvent);
      }
      
      private function removeListeners() : void
      {
         this._view.objectives.collectButton.removeEventListener(MouseEvent.CLICK,this.handleCollectRewards);
         this._view.objectives.purchaseButton.removeEventListener(MouseEvent.CLICK,this.handlePurchaseBattlePass);
         this._view.keyExchange.filterController.addEventListener(ItemFilterViewController.SETTINGS_CHANGED_EVENT,this.handleFilterSettingsChangedEvent);
      }
      
      private function handlePurchaseBattlePass(param1:MouseEvent) : void
      {
         JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials",null);
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP,["battlePass"]);
      }
      
      private function handleCollectRewards(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new BattlePassCollectRequest());
      }
      
      private function playVideo() : void
      {
         if(this._view)
         {
            if(this._videoURL)
            {
               this._view.objectives.video.playURL(this._videoURL);
            }
            else
            {
               this._view.objectives.video.clear();
            }
         }
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this._view.objectives.list.list = new VectorCollection(this._data.objectiveItems);
            this.updateDescription();
            this.updateOverallProgress();
         }
      }
      
      private function createExchangeList() : void
      {
         this.removeExchangeButtonsListener();
         this.addExchangeButtonsListener();
         this.handleFilterChange();
         this.updateExchangeKeyAmount();
      }
      
      public function updateExchangeKeyAmount() : *
      {
         if(Boolean(this._data) && isUIReady())
         {
            this._view.keyExchange.keyAmount.text = this._data.exchangekey.value.toString();
         }
      }
      
      private function handleFilterSettingsChangedEvent(param1:Event) : void
      {
         clearTimeout(this._filterUpdatePointer);
         this._filterUpdatePointer = setTimeout(this.saveFilter,100);
      }
      
      private function saveFilter() : void
      {
         var _loc1_:Vector.<String> = this._view.keyExchange.filterController.itemFilterSettings.getAllSelectedCategoriesAsVector();
         this._data.itemFilter = _loc1_;
         this.saveBattlePassFilterSettings(_loc1_);
      }
      
      private function saveBattlePassFilterSettings(param1:Vector.<String>) : void
      {
         var _loc2_:BattlePassWindowSettingsModule = new BattlePassWindowSettingsModule();
         _loc2_.battlePassItemFilters = param1;
         var _loc3_:BattlePassSetFilterRequest = new BattlePassSetFilterRequest(_loc2_);
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc4_.sendNettyRequest(_loc3_);
      }
      
      private function handleFilterChange() : void
      {
         this._view.keyExchange.itemFilterSettings.setFilterSelectionByCategories(this._data.itemFilter);
         this.onFilterChange(this._data.itemFilter);
      }
      
      private function onFilterChange(param1:Vector.<String>) : void
      {
         var _loc2_:Vector.<BattlePassExchangeVO> = new Vector.<BattlePassExchangeVO>(0);
         var _loc3_:int = int(this._data.exchangeItems.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1.indexOf(this._data.exchangeItems[_loc4_].category) != -1)
            {
               _loc2_.push(this._data.exchangeItems[_loc4_]);
            }
            _loc4_++;
         }
         this._view.keyExchange.list.list = new VectorCollection(_loc2_);
      }
      
      private function addExchangeButtonsListener() : void
      {
         var _loc1_:int = int(this._data.exchangeItems.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._data.exchangeItems[_loc2_].requestClaim.add(this.sendClaimRequest);
            _loc2_++;
         }
      }
      
      private function removeExchangeButtonsListener() : void
      {
         var _loc1_:int = int(this._data.exchangeItems.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._data.exchangeItems[_loc2_].requestClaim.remove(this.sendClaimRequest);
            _loc2_++;
         }
      }
      
      private function sendClaimRequest(param1:BattlePassExchangeVO) : void
      {
         if(param1.claimCount >= param1.limit || this._data.exchangekey.value < param1.cost)
         {
            return;
         }
         var _loc2_:BattlePassKeyExchangeRequest = new BattlePassKeyExchangeRequest(param1.rewardName);
         var _loc3_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc3_.sendNettyRequest(_loc2_);
      }
   }
}

