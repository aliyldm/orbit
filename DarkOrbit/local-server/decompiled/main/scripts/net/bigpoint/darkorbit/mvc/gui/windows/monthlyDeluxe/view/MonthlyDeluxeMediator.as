package net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.view
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeClaimRequest;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.model.MonthlyDeluxeUIData;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class MonthlyDeluxeMediator extends SimpleWindowMediator
   {
      
      public static const RED_DOT_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.MONTHLY_DELUXE,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT);
      
      private var _window:SimpleWindow;
      
      private var _data:MonthlyDeluxeUIData;
      
      private var _view:MonthlyDeluxeView;
      
      private var _isClaming:Boolean;
      
      public function MonthlyDeluxeMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this._window = param2 as SimpleWindow;
         param2.setSize(580,600);
         this._isClaming = false;
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new MonthlyDeluxeView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as MonthlyDeluxeUIData;
         this.addListeners();
      }
      
      public function set data(param1:MonthlyDeluxeUIData) : void
      {
         if(this._data)
         {
            this._data.timer.changed.remove(this.updateTimer);
            this._data.claimable.changed.remove(this.updateRedDotHighlighter);
            this._data.hasPass.changed.remove(this.update);
            this._data.claimable.changed.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.timer.changed.add(this.updateTimer);
            this._data.claimable.changed.add(this.updateRedDotHighlighter);
            this._data.hasPass.changed.add(this.update);
            this._data.claimable.changed.add(this.update);
            this.update();
         }
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this.updateRewardList();
            this.updateTimerText();
            this.updateTimer();
            this.updateClaimButtonVisibility();
            this.updateOverlay();
         }
      }
      
      private function updateTimer() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.timer.value > 0)
            {
               this._view.timer.text = TimeFormatter.getSmartFormatedTime(this._data.timer.value);
               this._view.timer.visible = true;
            }
            else
            {
               this._view.timer.text = "";
               this._view.timer.visible = false;
            }
         }
      }
      
      private function updateTimerText() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.timerText.text = this._view.timerText.text.replace("%VALUE%","");
            if(this._data.timer.value > 0)
            {
               this._view.timerText.visible = true;
            }
            else
            {
               this._view.timerText.visible = false;
            }
         }
      }
      
      private function addListeners() : void
      {
         this._view.claimBtn.addEventListener(MouseEvent.CLICK,this.handleClaimReward);
         this._view.buyBtn.addEventListener(MouseEvent.CLICK,this.handlePaymentLink);
      }
      
      private function removeListeners() : void
      {
         this._view.claimBtn.removeEventListener(MouseEvent.CLICK,this.handleClaimReward);
         this._view.buyBtn.removeEventListener(MouseEvent.CLICK,this.handlePaymentLink);
      }
      
      private function updateRedDotHighlighter() : void
      {
         if(this._data)
         {
            if(this._data.claimable.value)
            {
               sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
            }
            else
            {
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
            }
         }
      }
      
      private function updateClaimButtonVisibility() : void
      {
         this._view.claimBtn.visible = this._data.hasPass.value;
         this._view.claimBtn.enabled = this._data.claimable.value;
         this._view.buyBtn.visible = !this._data.hasPass.value;
      }
      
      private function updateRewardList() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.rewardList.length <= 0)
            {
               this._view.rewardList.visible = false;
            }
            else
            {
               this._view.rewardList.visible = true;
               this._view.rewardList.clearList();
               this._view.rewardList.list = new VectorCollection(this._data.rewardList);
            }
         }
      }
      
      private function updateOverlay() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.rewardList.visible = false;
            this._view.rewardList.visible = true;
            this._view.overlayBg.visible = !this._data.hasPass.value;
            this._view.overlayBg.alpha = 0.8;
            this._view.overlayText.visible = !this._data.hasPass.value;
         }
      }
      
      private function handleClaimReward(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         if(this._isClaming)
         {
            return;
         }
         this._isClaming = true;
         setTimeout(function():void
         {
            _isClaming = false;
         },5000);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new MonthlyDeluxeClaimRequest());
      }
      
      private function handlePaymentLink(param1:MouseEvent) : void
      {
         JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials",null);
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP,["MonthlyDeluxe"]);
      }
   }
}

