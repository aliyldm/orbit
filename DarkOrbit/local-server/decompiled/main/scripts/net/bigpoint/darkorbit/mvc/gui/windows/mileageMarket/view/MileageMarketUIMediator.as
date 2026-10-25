package net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.MileageMarketEventBuyRequest;
   import net.bigpoint.darkorbit.com.module.MileageMarketExchangeRequest;
   import net.bigpoint.darkorbit.com.module.MileageMarketPackageBuyRequest;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.model.MileageMarketUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.model.MileageMarketVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class MileageMarketUIMediator extends SimpleWindowMediator
   {
      
      private var _data:MileageMarketUIData;
      
      private var _view:MileageMarketUIView;
      
      public function MileageMarketUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:MileageMarketUIData) : void
      {
         if(this._data)
         {
            this._data.countdownTimer.changed.remove(this.onTimerUpdate);
            this._data.coins.changed.remove(this.onCoinsUpdate);
            this._data.infoUpdated.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.countdownTimer.changed.add(this.onTimerUpdate);
            this._data.coins.changed.add(this.onCoinsUpdate);
            this._data.infoUpdated.add(this.update);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new MileageMarketUIView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as MileageMarketUIData;
         this.addListeners();
         this.setCoinStaticInfo();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.packList = this._data.packList;
         this.updateBundleList();
         this.onTimerUpdate();
         this.onCoinsUpdate();
      }
      
      private function updateBundleList() : void
      {
         this.removeVOButtonsListener();
         this._view.bundleList = this._data.bundleList;
         this.addVOButtonsListener();
      }
      
      private function addListeners() : void
      {
         this._view.buyBtn.addEventListener(MouseEvent.CLICK,this.onBuyBtnClicked);
      }
      
      private function removeListeners() : void
      {
         this._view.buyBtn.removeEventListener(MouseEvent.CLICK,this.onBuyBtnClicked);
      }
      
      private function setCoinStaticInfo() : void
      {
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem("resource_collectable_mileage-coin");
         this._view.coinNameLabel.text = _loc1_.fullname;
         this._view.coinIcon.loadResource(_loc1_.getLoot30x30(),this.handleOnCoinIconLoaded,this.handleOnCoinIconLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleOnCoinIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.coinIcon);
         var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._view.coinIcon.width;
         _loc2_.height = this._view.coinIcon.height;
         this._view.coinIcon.addChild(_loc2_);
      }
      
      private function handleOnCoinIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.coinIcon);
      }
      
      private function onBuyBtnClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new MileageMarketEventBuyRequest());
      }
      
      private function onTimerUpdate() : void
      {
         var _loc1_:String = BPLocale.getItem("window_vip-exchange_timing");
         var _loc2_:String = this._data.countdownTimer.value > 0 ? TimeFormatter.getSmartFormatedTime(this._data.countdownTimer.value) : "-";
         this._view.timerLabel.text = _loc1_.replace("%VALUE%",_loc2_ + " ");
      }
      
      private function onCoinsUpdate() : void
      {
         var _loc1_:MileageMarketVO = null;
         this._view.coinLabel.text = TextFormatter.roundInteger(this._data.coins.value);
         for each(_loc1_ in this._data.bundleList)
         {
            if(!_loc1_.bought && _loc1_.claimedDiscountSteps == 0)
            {
               _loc1_.coinUpdated(this._data.coins.value);
            }
         }
      }
      
      private function addVOButtonsListener() : void
      {
         var _loc1_:MileageMarketVO = null;
         for each(_loc1_ in this._data.bundleList)
         {
            _loc1_.requestApply.add(this.sendApplyConfirmationRequest);
            _loc1_.requestBuy.add(this.sendBuyRequest);
         }
      }
      
      private function removeVOButtonsListener() : void
      {
         var _loc1_:MileageMarketVO = null;
         for each(_loc1_ in this._data.bundleList)
         {
            _loc1_.requestApply.remove(this.sendApplyConfirmationRequest);
            _loc1_.requestBuy.remove(this.sendBuyRequest);
         }
      }
      
      private function sendApplyConfirmationRequest(param1:MileageMarketVO, param2:int) : void
      {
         var prompt:String;
         var handleOk:Function;
         var handleCancel:Function;
         var bundleVO:MileageMarketVO = param1;
         var step:int = param2;
         if(bundleVO == null || bundleVO.bundleId == "" || step == 0)
         {
            return;
         }
         prompt = BPLocale.getItem("mileage-market_apply_confirmation");
         prompt = prompt.replace("%VALUE%",step);
         handleOk = function():void
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new MileageMarketExchangeRequest(bundleVO.bundleId,step));
         };
         handleCancel = function():void
         {
            bundleVO.requestApplyCancel.dispatch();
         };
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON,handleOk,handleCancel,prompt,FuiPopUpUtils.POPUP_ICON_SKIN_QUESTION);
      }
      
      private function sendBuyRequest(param1:String) : void
      {
         if(param1 == "")
         {
            return;
         }
         var _loc2_:MileageMarketPackageBuyRequest = new MileageMarketPackageBuyRequest(param1);
         var _loc3_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc3_.sendNettyRequest(_loc2_);
      }
   }
}

