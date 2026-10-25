package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.view
{
   import net.bigpoint.darkorbit.com.module.porting.shop.exchange.ExchangeShopRequest;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.CreatePopupView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.ViewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopData;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopItemVO;
   
   public class StrikeAndExitShopMediator extends SimpleWindowMediator implements ViewData
   {
      
      private var _view:StrikeAndExitShopView;
      
      private var _viewData:StrikeAndExitShopData;
      
      public function StrikeAndExitShopMediator(param1:String, param2:SimpleWindow, param3:StrikeAndExitShopData)
      {
         super(param1,param2);
         this._viewData = param3;
         this._viewData.changed.add(this.updateView);
      }
      
      public function refreshData() : void
      {
         var _loc1_:ExchangeShopRequest = new ExchangeShopRequest();
         _loc1_.action = ExchangeShopRequest.ACTION_shops;
         _loc1_.eventName = "StrikeAndExit";
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      public function setView(param1:StrikeAndExitShopView) : void
      {
         this._view = param1;
         IconVOLoader.getInstance().loadIcon(this._view.banner,null,"background25",AssetsProxy.EVENTS);
         this.updateView();
      }
      
      public function updateView() : void
      {
         if(this._view)
         {
            this.removeExchangeButtonsListener();
            this._view.updateList(this._viewData.items);
            if(this._viewData.assets.length > 0)
            {
               this._view.updateAssets(this._viewData.assets[0].itemVO,this._viewData.assets[0].amount);
            }
            this.addExchangeButtonsListener();
         }
      }
      
      private function addExchangeButtonsListener() : void
      {
         var _loc1_:StrikeAndExitShopItemVO = null;
         for each(_loc1_ in this._viewData.items)
         {
            _loc1_.requestExchange.add(this.sendExchangeConfirmationRequest);
         }
      }
      
      private function removeExchangeButtonsListener() : void
      {
         var _loc1_:StrikeAndExitShopItemVO = null;
         for each(_loc1_ in this._viewData.items)
         {
            _loc1_.requestExchange.remove(this.sendExchangeConfirmationRequest);
         }
      }
      
      private function sendExchangeConfirmationRequest(param1:StrikeAndExitShopItemVO) : void
      {
         var sendRequest:Function;
         var targetItem:StrikeAndExitShopItemVO = param1;
         var assets:Number = this._viewData.assets[0].amount;
         if(assets < targetItem.costAmount || targetItem.limit <= 0)
         {
            CreatePopupView.getInstance().createPopup(null,"");
            return;
         }
         sendRequest = function():void
         {
            var _loc1_:ExchangeShopRequest = new ExchangeShopRequest();
            _loc1_.action = ExchangeShopRequest.ACTION_buy;
            _loc1_.eventName = "StrikeAndExit";
            _loc1_.eId = targetItem.id;
            _loc1_.shopId = targetItem.shopID;
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
         };
         CreatePopupView.getInstance().createPopup(sendRequest,targetItem.exchangeDescription);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
      }
   }
}

