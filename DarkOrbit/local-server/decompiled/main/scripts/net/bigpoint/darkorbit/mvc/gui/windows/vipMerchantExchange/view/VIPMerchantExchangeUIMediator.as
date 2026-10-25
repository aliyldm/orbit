package net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.view
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeBuyRequest;
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model.VIPMerchantExchangeUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model.VIPMerchantExchangeVO;
   
   public class VIPMerchantExchangeUIMediator extends SimpleWindowMediator
   {
      
      private var _data:VIPMerchantExchangeUIData;
      
      private var _view:VIPMerchantExchangeUIView;
      
      public function VIPMerchantExchangeUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:VIPMerchantExchangeUIData) : void
      {
         if(this._data)
         {
            this._data.countdownTimer.changed.remove(this.updateTimer);
            this._data.eligible.changed.remove(this.onPackageBoughtUpdate);
            this._data.infoUpdated.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.countdownTimer.changed.add(this.updateTimer);
            this._data.eligible.changed.add(this.onPackageBoughtUpdate);
            this._data.infoUpdated.add(this.update);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new VIPMerchantExchangeUIView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as VIPMerchantExchangeUIData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.packList = this._data.packList;
         this.updateExchangeList();
         this.updateTimer();
         this._view.showContainer = this._data.eligible.value;
      }
      
      private function updateExchangeList() : void
      {
         this.removeExchangeButtonsListener();
         if(!this._data.eligible.value)
         {
            this._view.unavailableExchangeList = this._data.exchangeList;
            this._view.availableExchangeList = new Vector.<VIPMerchantExchangeVO>();
         }
         else
         {
            this._view.unavailableExchangeList = new Vector.<VIPMerchantExchangeVO>();
            this._view.availableExchangeList = this._data.exchangeList;
         }
         this.addExchangeButtonsListener();
      }
      
      private function addListeners() : void
      {
         this._view.buyBtn.addEventListener(MouseEvent.CLICK,this.onBuyBtnClicked);
      }
      
      private function removeListeners() : void
      {
         this._view.buyBtn.removeEventListener(MouseEvent.CLICK,this.onBuyBtnClicked);
      }
      
      private function onBuyBtnClicked(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new VIPMerchantExchangeBuyRequest());
      }
      
      private function updateTimer() : void
      {
         var _loc1_:String = BPLocale.getItem("window_vip-exchange_timing");
         if(this._data.countdownTimer.value > 0)
         {
            this._view.unavailableTimer.text = _loc1_.replace("%VALUE%",TimeFormatter.getSmartFormatedTime(this._data.countdownTimer.value) + " ");
            this._view.availableTimer.text = this._view.unavailableTimer.text;
         }
         else
         {
            this._view.unavailableTimer.text = _loc1_.replace("%VALUE%","- ");
            this._view.availableTimer.text = this._view.unavailableTimer.text;
         }
      }
      
      private function onPackageBoughtUpdate() : void
      {
         this.update();
      }
      
      private function addExchangeButtonsListener() : void
      {
         var _loc1_:VIPMerchantExchangeVO = null;
         for each(_loc1_ in this._data.exchangeList)
         {
            _loc1_.requestExchange.add(this.sendExchangeConfirmationRequest);
         }
      }
      
      private function removeExchangeButtonsListener() : void
      {
         var _loc1_:VIPMerchantExchangeVO = null;
         for each(_loc1_ in this._data.exchangeList)
         {
            _loc1_.requestExchange.remove(this.sendExchangeConfirmationRequest);
         }
      }
      
      private function sendExchangeConfirmationRequest(param1:VIPMerchantExchangeVO) : void
      {
         var sendRequest:Function;
         var targetItem:VIPMerchantExchangeVO = param1;
         if(!targetItem.isExchangeable || !targetItem.hasResource)
         {
            this._view.createPopup(null,"");
            return;
         }
         sendRequest = function():void
         {
            sendExchangeRequest(targetItem);
         };
         this._view.createPopup(sendRequest,targetItem.exchangeDescription);
      }
      
      private function sendExchangeRequest(param1:VIPMerchantExchangeVO) : void
      {
         if(!param1 || !param1.hasResource)
         {
            this._view.createPopup(null,"");
            return;
         }
         var _loc2_:VIPMerchantExchangeRequest = new VIPMerchantExchangeRequest(param1.itemVO.lootID);
         var _loc3_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc3_.sendNettyRequest(_loc2_);
      }
   }
}

