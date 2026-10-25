package net.bigpoint.darkorbit.mvc.gui.windows.uridiumbank.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.com.module.UridiumBankClaimRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.global.notifications.GameNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.UpdateHighlightItemModel;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.uridiumbank.model.UridiumBankUIData;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UridiumBankMediator extends SimpleWindowMediator
   {
      
      public static const PROGRESS_BAR_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.URIDIUM_BANK,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_PROGRESS_BAR);
      
      public static const FLASH_WINDOW_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.URIDIUM_BANK,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_FLASH,0.3,5);
      
      public static const RED_DOT_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.URIDIUM_BANK,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT);
      
      private var _window:SimpleWindow;
      
      private var _data:UridiumBankUIData;
      
      private var _view:UridiumBankView;
      
      public function UridiumBankMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this._window = param2 as SimpleWindow;
         param2.setSize(220,300);
         mapNotificationToMethod(GameNotifications.HERO_INIT,this.refreshProgressBarHighlighter);
      }
      
      override public function onRemove() : void
      {
         sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,PROGRESS_BAR_HIGHLIGHTER);
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:UridiumBankUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.timer.changed.remove(this.updateTimer);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.timer.changed.add(this.updateTimer);
            this.update();
         }
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this.updateBanner();
            this.updateDescription();
            this.updateCurrentValue();
            this.updateTimer();
            this.updateProgressBar();
            this.updateProgressBarHighlighter();
            this.updateFlashingWindowHighlighter();
            this.updateRedDotHighlighter();
            this.updateButtonVisibility();
         }
      }
      
      private function updateBanner() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.imgKey)
            {
               this._view.banner.registeredSkinName = this._data.imgKey;
            }
            else
            {
               this._view.banner.registeredSkinName = "uridium_bank_banner";
            }
         }
      }
      
      private function updateDescription() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.textKey)
            {
               this._view.uridiumBankDescription.text = BPLocale.getItem(this._data.textKey);
            }
            else
            {
               this._view.uridiumBankDescription.text = BPLocale.getItem("uridium_bank_description");
            }
         }
      }
      
      private function updateButtonVisibility() : void
      {
         var _loc1_:String = null;
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.currentValue >= this._data.maxValue)
            {
               this._view.purchaseBtn.visible = true;
               _loc1_ = BPLocale.getItem("uridium_bank_price");
               this._view.purchaseBtn.text = _loc1_.replace("%PRICE%",this._data.price);
            }
            else
            {
               this._view.purchaseBtn.visible = false;
            }
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new UridiumBankView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as UridiumBankUIData;
         this.addListeners();
      }
      
      private function addListeners() : void
      {
         this._view.purchaseBtn.addEventListener(MouseEvent.CLICK,this.handleClaimUridiumBank);
      }
      
      private function removeListeners() : void
      {
         this._view.purchaseBtn.removeEventListener(MouseEvent.CLICK,this.handleClaimUridiumBank);
      }
      
      private function updateCurrentValue() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.uridiumValue.text = TextFormatter.roundInteger(this._data.currentValue) + "/" + TextFormatter.roundInteger(this._data.maxValue);
         }
      }
      
      private function updateProgressBar() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.progressBar().currentValue = this._data.currentValue / this._data.maxValue;
         }
      }
      
      private function updateProgressBarHighlighter() : void
      {
         if(this._data)
         {
            sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,PROGRESS_BAR_HIGHLIGHTER);
            sendNotification(HighLightItemNotification.UPDATE_HIGHLIGHT,new UpdateHighlightItemModel(PROGRESS_BAR_HIGHLIGHTER,this._data.currentValue / this._data.maxValue));
         }
      }
      
      private function updateFlashingWindowHighlighter() : void
      {
         if(this._data)
         {
            if(this._data.currentValue >= this._data.maxValue && !this._window.maximized)
            {
               sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,FLASH_WINDOW_HIGHLIGHTER);
            }
         }
      }
      
      private function updateRedDotHighlighter() : void
      {
         if(this._data)
         {
            if(this._data.currentValue >= this._data.maxValue)
            {
               sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
            }
            else
            {
               sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
            }
         }
      }
      
      private function updateTimer() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.timer.value > 0)
            {
               this._view.timer.text = BPLocale.getItem("uridium_bank_countdown") + " " + TimeFormatter.formatTime(this._data.timer.value);
               this._view.timer.visible = true;
               window.setSize(220,310);
            }
            else
            {
               this._view.timer.text = "";
               this._view.timer.visible = false;
               window.setSize(220,300);
            }
         }
      }
      
      private function refreshProgressBarHighlighter(param1:INotification) : void
      {
         if(this._data)
         {
            sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,PROGRESS_BAR_HIGHLIGHTER);
            this.updateProgressBarHighlighter();
            sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
            this.updateRedDotHighlighter();
         }
      }
      
      private function handleClaimUridiumBank(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new UridiumBankClaimRequest());
      }
   }
}

