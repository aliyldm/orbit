package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.vanguardMart.view
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.shop.exchange.ExchangeShopRequest;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.CreatePopupView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopData;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopItemVO;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class StrikeAndExitVanguardMartMediator extends SimpleWindowMediator
   {
      
      private var _view:StrikeAndExitVanguardMartView;
      
      private var _viewData:StrikeAndExitShopData;
      
      private var vipBuyButton:Button;
      
      private var unVipBuyButton:Button;
      
      private var countdownTimer:Label;
      
      private var _vip:Boolean;
      
      public const attemptsLeft:BindableCountDown = new BindableCountDown();
      
      public function StrikeAndExitVanguardMartMediator(param1:SimpleWindow, param2:StrikeAndExitShopData)
      {
         super(GuiConstants.STRIKE_AND_EXIT_VANGUARD_MART,param1);
         this._viewData = param2;
         this._viewData.changed.add(this.updateView);
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
      
      public function refreshData() : void
      {
         var _loc1_:ExchangeShopRequest = new ExchangeShopRequest();
         _loc1_.action = ExchangeShopRequest.ACTION_shops;
         _loc1_.eventName = "StrikeAndExitVIP";
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      public function setView(param1:StrikeAndExitVanguardMartView) : void
      {
         this._view = param1;
         var _loc2_:Array = BPLocale.getItem("strikeandexit_mart_info").split("/br");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this._view.vipInfo.text += _loc2_[_loc3_] + "\n";
            _loc3_++;
         }
         this.vipBuyButton = this._view.vipBuyButton;
         this.vipBuyButton.enabled = false;
         this.vipBuyButton.visible = false;
         this.unVipBuyButton = this._view.unVipBuyButton;
         this.unVipBuyButton.visible = false;
         this.countdownTimer = this._view.countdownTimer;
         this.countdownTimer.visible = false;
      }
      
      public function get vip() : Boolean
      {
         return this._vip;
      }
      
      public function set vip(param1:Boolean) : void
      {
         this._vip = param1;
         this.unVipBuyButton.visible = param1;
         this._view.mainMart.visible = param1;
         this.vipBuyButton.enabled = !param1;
         this.vipBuyButton.visible = !param1;
         this._view.unavailableMart.visible = !param1;
      }
      
      private function onVipBuyButtonClick(param1:MouseEvent) : void
      {
         this.vipBuyButton.removeEventListener(MouseEvent.CLICK,this.onVipBuyButtonClick);
         this.vipBuyButton.enabled = false;
         this.sendBuyVIP();
      }
      
      public function updateView() : void
      {
         if(this._view)
         {
            this.attemptsLeft.changed.remove(this.onAttemptsUpdated);
            this.countdownTimer.visible = false;
            this.removeExchangeButtonsListener();
            this._view.updateList(this._viewData.items);
            if(this._viewData.assets.length > 0)
            {
               this._view.updateAssets(this._viewData.assets[0].itemVO,this._viewData.assets[0].amount);
            }
            this.vip = this._viewData.isVIP;
            if(this.vipBuyButton.visible)
            {
               this.vipBuyButton.addEventListener(MouseEvent.CLICK,this.onVipBuyButtonClick);
               this.vipBuyButton.enabled = true;
            }
            this.addExchangeButtonsListener();
            this.attemptsLeft.value = this._viewData.vipEndSeconds;
            this.onAttemptsUpdated();
            this.attemptsLeft.changed.add(this.onAttemptsUpdated);
            this.countdownTimer.visible = true;
         }
      }
      
      private function onAttemptsUpdated() : void
      {
         if(Boolean(this._view) && this._view.visible)
         {
            if(this.attemptsLeft.value > 0)
            {
               this.countdownTimer.text = BPLocale.getItem("strikeandexit_mart_period").replace("%VALUE%",TimeFormatter.getSmartFormatedTime(this.attemptsLeft.value));
            }
            else
            {
               this.attemptsLeft.changed.remove(this.onAttemptsUpdated);
               this.countdownTimer.text = "";
            }
         }
         else
         {
            this.attemptsLeft.changed.remove(this.onAttemptsUpdated);
            this.countdownTimer.text = "";
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
            _loc1_.eventName = "StrikeAndExitVIP";
            _loc1_.eId = targetItem.id;
            _loc1_.shopId = targetItem.shopID;
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
         };
         CreatePopupView.getInstance().createPopup(sendRequest,targetItem.exchangeDescription);
      }
      
      private function sendBuyVIP() : void
      {
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP,["Vanguard"]);
      }
   }
}

