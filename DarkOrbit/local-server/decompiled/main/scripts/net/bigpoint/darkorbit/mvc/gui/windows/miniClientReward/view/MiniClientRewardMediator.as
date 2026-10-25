package net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.view
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.com.module.MiniClientRewardClaimRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model.MiniClientRewardUIData;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class MiniClientRewardMediator extends SimpleWindowMediator
   {
      
      public static const RED_DOT_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.MINICLIENT_REWARD,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT);
      
      private var _window:SimpleWindow;
      
      private var _view:MiniClientRewardView;
      
      private var _data:MiniClientRewardUIData;
      
      public function MiniClientRewardMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this._window = param2 as SimpleWindow;
         this._window.setSize(570,360);
      }
      
      public function set data(param1:MiniClientRewardUIData) : void
      {
         if(this._data)
         {
            this._data.timer.changed.remove(this.updateTimer);
            this._data.claimable.changed.remove(this.updateRedDotHighlighter);
            this._data.claimable.changed.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.timer.changed.add(this.updateTimer);
            this._data.claimable.changed.add(this.updateRedDotHighlighter);
            this._data.claimable.changed.add(this.update);
            this.update();
         }
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
         this._view = new MiniClientRewardView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as MiniClientRewardUIData;
         this.addListeners();
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
            this.updateRedDotHighlighter();
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
         }
      }
      
      private function addListeners() : void
      {
         this._view.claimBtn.addEventListener(MouseEvent.CLICK,this.handleClaimReward);
         this._view.downloadBtn.addEventListener(MouseEvent.CLICK,this.handleDownloadLink);
      }
      
      private function removeListeners() : void
      {
         this._view.claimBtn.removeEventListener(MouseEvent.CLICK,this.handleClaimReward);
         this._view.downloadBtn.removeEventListener(MouseEvent.CLICK,this.handleDownloadLink);
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
         var _loc1_:* = undefined;
         _loc1_ = Settings.platform != Settings.platformTypeClient;
         this._view.claimBtn.visible = !_loc1_;
         this._view.claimBtn.enabled = this._data.claimable.value;
         this._view.downloadBtn.visible = _loc1_;
      }
      
      private function updateRewardList() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._window.setSize(570,this._view.renderRewards(this._data.rewardList));
         }
      }
      
      private function updateOverlay() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overlayBg.visible = Settings.platform != Settings.platformTypeClient;
            this._view.overlayBg.alpha = 0.8;
            this._view.overlayText.visible = Settings.platform != Settings.platformTypeClient;
         }
      }
      
      private function handleClaimReward(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new MiniClientRewardClaimRequest());
      }
      
      private function handleDownloadLink(param1:MouseEvent) : void
      {
         JavascriptProxy.referToURL("download",null);
      }
   }
}

