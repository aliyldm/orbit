package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.time.TimeVo;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.EventProgressCollectRequest;
   import net.bigpoint.darkorbit.com.module.EventProgressResetRequest;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.radio.RadioButton;
   import net.bigpoint.darkorbit.fui.components.buttons.radio.RadioButtonGroupEvent;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.video.VideoChainPlayer;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.EventProgressConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.EventProgressNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.EventProgressRemainingCountDownTimer;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.vo.EventProgressVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.vo.EventRewardVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view.components.EventProgressBar;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view.components.EventProgressBarBuilder;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view.components.EventProgressBarEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EventProgressWindowMediator extends SimpleWindowMediator
   {
      
      private var _progress:Number = -1;
      
      private var _finalRewardBackgroundProgressValue:Number;
      
      private var _eventProgressVO:EventProgressVO;
      
      private var _remainingTimer:EventProgressRemainingCountDownTimer;
      
      private var _remainingTime:Number;
      
      private var _statusCode:uint = 0;
      
      private var isCollectButtonVisible:Boolean = false;
      
      private var isResetButtonVisible:Boolean = false;
      
      public var _tabarProgressButton:RadioButton;
      
      private var _tabarSourceButton:RadioButton;
      
      private var _explanationContainer:Container;
      
      private var _progressContainer:Container;
      
      private var _tabbarLabelProgress:Label;
      
      private var _tabbarLabelSource:Label;
      
      private var _infoLabel:Label;
      
      private var _infoScrollContainer:ScrollContainer;
      
      private var _infoScrollbar:Scrollbar;
      
      private var _nextLabelRewardLabel:Label;
      
      private var _timeLeftLabel:Label;
      
      private var _eventProgressBar:EventProgressBar;
      
      private var _finalRewardVideoPlayer:VideoChainPlayer;
      
      private var _finalRewardBackground:Coreponent;
      
      private var _finalRewardBackground_Progress:Coreponent;
      
      private var _finalRewardBackground_ProgressMask:Coreponent;
      
      private var _finalRewardBackground_Selected:Coreponent;
      
      private var _confirmationCollectButtton:Button;
      
      private var _confirmationResetButton:Button;
      
      private var _confirmationResetLabel:Label;
      
      private var _sourceLabel:Label;
      
      public function EventProgressWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this.registerComponents();
      }
      
      private function registerComponents() : void
      {
         xmlUIBuilder.register(EventProgressConstants.EVENT_PROGRESSBAR_COMPONENT,new EventProgressBarBuilder().create);
      }
      
      override protected function mapNotificationsToMethods() : void
      {
         mapNotificationToMethod(EventProgressNotifications.EVENT_PROGRESS_DATA_CHANGED,this.handleEventProgressDataChanged);
         mapNotificationToMethod(EventProgressNotifications.UPDATE_PROGRESS,this.handleProgressValueChanged);
      }
      
      override public function loadAndBuildContent(param1:String) : void
      {
         super.loadAndBuildContent(param1);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         this._remainingTimer = new EventProgressRemainingCountDownTimer();
         this._remainingTimer.timer.changed.add(this.handleTimerValueChanged);
         if(this._remainingTime > 0)
         {
            this.remainingTime = this._remainingTime;
         }
         this.assignUIComponents();
         this.setFinalRewardPercentage(0);
         this.addEventListeners();
         this._tabarProgressButton._selectRadioButton();
         super.handleLoadAndBuildContentCallback(param1);
         if(this._eventProgressVO)
         {
            this.assignEventProgressData(this._eventProgressVO);
         }
         this.assignProgress(this._progress);
         this.updateCollectedStatus(this._statusCode);
      }
      
      private function assignUIComponents() : void
      {
         this._tabarProgressButton = FuiComponentSelectorUtil.selectComponent("contentContainer.tabBarContainer.tabbarbuttonProgress.progress",UIContentContainer) as RadioButton;
         this._tabarSourceButton = FuiComponentSelectorUtil.selectComponent("contentContainer.tabBarContainer.tabbarbuttonSource.source",UIContentContainer) as RadioButton;
         this._explanationContainer = FuiComponentSelectorUtil.selectComponent("contentContainer.explanationContainer",UIContentContainer) as Container;
         this._progressContainer = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer",UIContentContainer) as Container;
         this._tabbarLabelProgress = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.tabBarContainer.tabbarbuttonProgress.label",UIContentContainer) as Label;
         this._tabbarLabelSource = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.tabBarContainer.tabbarbuttonSource.label",UIContentContainer) as Label;
         this._infoLabel = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.descriptionContainer.eventProgressScrollContainer.content",UIContentContainer) as Label;
         this._infoScrollContainer = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.descriptionContainer.eventProgressScrollContainer",UIContentContainer) as ScrollContainer;
         this._infoScrollbar = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.descriptionContainer.eventProgressScrollbar",UIContentContainer) as Scrollbar;
         this._sourceLabel = FuiComponentSelectorUtil.selectComponent("contentContainer.explanationContainer.source",UIContentContainer) as Label;
         this._nextLabelRewardLabel = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.progressBarContainer.progressLayoutContainer.labelContainer.labelReward",UIContentContainer) as Label;
         this._timeLeftLabel = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.progressBarContainer.progressLayoutContainer.labelContainer.labelTime",UIContentContainer) as Label;
         this._eventProgressBar = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.progressBarContainer.progressLayoutContainer.progressContainer.progressbar",UIContentContainer) as EventProgressBar;
         this._finalRewardVideoPlayer = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.progressBarContainer.progressLayoutContainer.progressContainer.videoplayer",UIContentContainer) as VideoChainPlayer;
         this._finalRewardBackground = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.progressBarContainer.progressLayoutContainer.progressContainer.finalRewardBgnd",UIContentContainer) as Coreponent;
         this._finalRewardBackground_Selected = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.progressBarContainer.progressLayoutContainer.progressContainer.finalRewardBgnd_selected",UIContentContainer) as Coreponent;
         this._finalRewardBackground_Progress = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.progressBarContainer.progressLayoutContainer.progressContainer.finalRewardBgnd_progress",UIContentContainer) as Coreponent;
         this._finalRewardBackground_ProgressMask = FuiComponentSelectorUtil.selectComponent("contentContainer.progressContainer.progressBarContainer.progressLayoutContainer.progressContainer.finalRewardBgnd_progressmask",UIContentContainer) as Coreponent;
         this._finalRewardBackground_ProgressMask.cacheAsBitmap = true;
         this._finalRewardBackground_Progress.cacheAsBitmap = true;
         this._finalRewardBackground_Progress.mask = this._finalRewardBackground_ProgressMask;
         this._confirmationCollectButtton = FuiComponentSelectorUtil.selectComponent("contentContainer.confirmationContainer.collectButton",UIContentContainer) as Button;
         this._confirmationResetButton = FuiComponentSelectorUtil.selectComponent("contentContainer.confirmationContainer.resetButton",UIContentContainer) as Button;
         this._confirmationResetLabel = FuiComponentSelectorUtil.selectComponent("contentContainer.confirmationContainer.resetLabel",UIContentContainer) as Label;
      }
      
      private function setFinalRewardPercentage(param1:Number) : void
      {
         if(this._finalRewardBackgroundProgressValue != param1)
         {
            this._finalRewardBackgroundProgressValue = param1;
            this._finalRewardBackground_ProgressMask.scaleX = param1;
         }
      }
      
      private function addEventListeners() : void
      {
         this._tabarProgressButton.group.addEventListener(RadioButtonGroupEvent.EVENT_SELECTION_CHANGED,this.handleTabbarSelectionChangedEvent);
         this._confirmationCollectButtton.addEventListener(MouseEvent.CLICK,this.handleConfirmationCollectButtonClickEvent);
         this._confirmationResetButton.addEventListener(MouseEvent.CLICK,this.handleConfirmationResetButtonClickEvent);
         this._eventProgressBar.addEventListener(EventProgressBarEvent.EVENT_UPDATE_REWARD_PROGRESS,this.handleUpdateFinalRewardProgressEvent);
         this._eventProgressBar.addEventListener(EventProgressBarEvent.EVENT_COLLECTABLE_ITEM_AVAILABLE,this.handleCollectableItemsAvailableEvent);
         this._eventProgressBar.addEventListener(EventProgressBarEvent.EVENT_UPDATE_FINAL_REWARD_TOOLTIP,this.handleUpdateFinalRewardTooltip);
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleWindowMaximized);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleWindowMinimized);
         window.addEventListener(SimpleWindowEvent.WIDTH_CHANGED,this.handleWindowWidthChangedEvent);
      }
      
      private function removeEventListeners() : void
      {
         this._tabarProgressButton.group.removeEventListener(RadioButtonGroupEvent.EVENT_SELECTION_CHANGED,this.handleTabbarSelectionChangedEvent);
         this._eventProgressBar.removeEventListener(EventProgressBarEvent.EVENT_UPDATE_REWARD_PROGRESS,this.handleUpdateFinalRewardProgressEvent);
         this._eventProgressBar.removeEventListener(EventProgressBarEvent.EVENT_COLLECTABLE_ITEM_AVAILABLE,this.handleCollectableItemsAvailableEvent);
         this._eventProgressBar.removeEventListener(EventProgressBarEvent.EVENT_UPDATE_FINAL_REWARD_TOOLTIP,this.handleUpdateFinalRewardTooltip);
         this._confirmationCollectButtton.removeEventListener(MouseEvent.CLICK,this.handleConfirmationCollectButtonClickEvent);
         this._confirmationResetButton.removeEventListener(MouseEvent.CLICK,this.handleConfirmationResetButtonClickEvent);
         window.removeEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleWindowMaximized);
         window.removeEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleWindowMinimized);
         window.removeEventListener(SimpleWindowEvent.WIDTH_CHANGED,this.handleWindowWidthChangedEvent);
      }
      
      private function handleUpdateFinalRewardProgressEvent(param1:EventProgressBarEvent) : void
      {
         var _loc2_:String = BPLocale.getItem("window_event_progress_label_nextreward");
         _loc2_ += " " + param1.absoluteProgress + "/" + param1.nextRewardAbsolute;
         this._nextLabelRewardLabel.text = _loc2_;
         this._nextLabelRewardLabel.text = _loc2_;
         this.setFinalRewardPercentage(param1.progress);
         this._finalRewardBackground_Selected.visible = param1.select;
      }
      
      private function handleCollectableItemsAvailableEvent(param1:EventProgressBarEvent) : void
      {
         this._confirmationCollectButtton.enabled = param1.collectableItemsAvailable();
         if(!param1.collectableItemsAvailable() && param1.maxProgressReached())
         {
            this.isCollectButtonVisible = false;
            this.isResetButtonVisible = this._eventProgressVO.resetPrice > 0;
         }
         else
         {
            this.isCollectButtonVisible = true;
            this.isResetButtonVisible = false;
         }
         var _loc2_:Number = 0.3;
         if(this.isCollectButtonVisible)
         {
            TweenLite.to(this._confirmationCollectButtton,_loc2_,{"autoAlpha":1});
         }
         else
         {
            TweenLite.to(this._confirmationCollectButtton,_loc2_,{"autoAlpha":0});
         }
         if(this.isResetButtonVisible)
         {
            TweenLite.to(this._confirmationResetButton,_loc2_,{"autoAlpha":1});
            TweenLite.to(this._confirmationResetLabel,_loc2_,{"autoAlpha":1});
         }
         else
         {
            TweenLite.to(this._confirmationResetButton,_loc2_,{"autoAlpha":0});
            TweenLite.to(this._confirmationResetLabel,_loc2_,{"autoAlpha":0});
         }
      }
      
      private function handleUpdateFinalRewardTooltip(param1:EventProgressBarEvent) : *
      {
         this._finalRewardBackground.mouseEnabled = true;
         TooltipControl.getInstance().addToolTip(this._finalRewardBackground,param1.finalRewardTooltip());
      }
      
      private function handleTabbarSelectionChangedEvent(param1:RadioButtonGroupEvent) : void
      {
         var _loc2_:Number = 0.25;
         var _loc3_:String = param1.selectedRadioButton.name;
         if(_loc3_ == this._tabarSourceButton.name)
         {
            TweenLite.to(this._explanationContainer,_loc2_,{"autoAlpha":1});
            TweenLite.to(this._progressContainer,_loc2_,{"autoAlpha":0});
            TweenLite.to(this._confirmationResetButton,_loc2_,{
               "autoAlpha":0,
               "x":25
            });
            TweenLite.to(this._confirmationResetLabel,_loc2_,{
               "autoAlpha":0,
               "x":55
            });
            TweenLite.to(this._confirmationCollectButtton,_loc2_,{
               "autoAlpha":0,
               "x":25
            });
         }
         else if(_loc3_ == this._tabarProgressButton.name)
         {
            TweenLite.to(this._explanationContainer,_loc2_,{"autoAlpha":0});
            TweenLite.to(this._progressContainer,_loc2_,{"autoAlpha":1});
            TweenLite.to(this._confirmationResetButton,_loc2_,{
               "autoAlpha":(this.isResetButtonVisible ? 1 : 0),
               "x":0
            });
            TweenLite.to(this._confirmationResetLabel,_loc2_,{
               "autoAlpha":(this.isResetButtonVisible ? 1 : 0),
               "x":0
            });
            TweenLite.to(this._confirmationCollectButtton,_loc2_,{
               "autoAlpha":(this.isCollectButtonVisible ? 1 : 0),
               "x":0
            });
         }
      }
      
      private function handleWindowMinimized(param1:Event) : void
      {
         if(this._finalRewardVideoPlayer)
         {
            this._finalRewardVideoPlayer.stop();
         }
      }
      
      private function handleWindowMaximized(param1:Event) : void
      {
         if(this._finalRewardVideoPlayer)
         {
            this._finalRewardVideoPlayer.restart();
         }
      }
      
      private function handleConfirmationCollectButtonClickEvent(param1:Event) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new EventProgressCollectRequest());
      }
      
      private function handleConfirmationResetButtonClickEvent(param1:Event) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new EventProgressResetRequest());
      }
      
      private function handleWindowWidthChangedEvent(param1:SimpleWindowEvent) : void
      {
      }
      
      private function handleTimerValueChanged() : void
      {
         var _loc1_:String = null;
         var _loc2_:TimeVo = null;
         if(this._timeLeftLabel)
         {
            _loc1_ = "";
            _loc2_ = TimeFormatter.getSeparatedTimeValues(this._remainingTimer.timer.value);
            if(_loc2_.daysVal > 0)
            {
               _loc1_ = BPLocale.getItem("abbreviation_days");
               _loc1_ = _loc1_.replace("%VALUE%",_loc2_.daysVal);
            }
            else
            {
               _loc1_ = TimeFormatter.formatTime(this._remainingTimer.timer.value);
            }
            this._timeLeftLabel.text = BPLocale.getItem("window_event_progress_label_event_ends") + " " + _loc1_;
         }
      }
      
      private function handleEventProgressDataChanged(param1:INotification) : void
      {
         var _loc2_:EventProgressVO = param1.getBody() as EventProgressVO;
         if(_loc2_ == this._eventProgressVO)
         {
            return;
         }
         this._eventProgressVO = _loc2_;
         if(isUIReady())
         {
            this.assignEventProgressData(this._eventProgressVO);
         }
      }
      
      private function handleProgressValueChanged(param1:INotification) : void
      {
         var _loc2_:Number = param1.getBody() as Number;
         if(this._progress != _loc2_)
         {
            this._progress = _loc2_;
            if(isUIReady())
            {
               this.assignProgress(this._progress);
            }
            return;
         }
      }
      
      private function assignEventProgressData(param1:EventProgressVO) : void
      {
         this.setTitle(param1.title);
         this.setDescription(param1.description);
         this.setResetPriceTooltip(param1);
         this.setSourceText(param1.source);
         this.loadVideo(param1);
         this._eventProgressBar.list = param1.rewards;
      }
      
      private function setSourceText(param1:String) : void
      {
         this._sourceLabel.text = BPLocale.getItem(param1);
      }
      
      private function setResetPriceTooltip(param1:EventProgressVO) : void
      {
         var _loc2_:String = "";
         if(param1.isResetPriceCurrencyCredits())
         {
            _loc2_ = "pricetag_credits";
         }
         else if(param1.isResetPriceCurrencyUridium())
         {
            _loc2_ = "pricetag_uridium";
         }
         var _loc3_:String = BPLocale.getItem(_loc2_);
         _loc3_ = _loc3_.replace("%VALUE%",param1.resetPrice);
         this._confirmationResetLabel.text = _loc3_;
      }
      
      private function loadVideo(param1:EventProgressVO) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:EventRewardVO = param1.rewards[param1.rewards.length - 1];
         var _loc3_:Array = [];
         var _loc4_:Array = _loc2_.getPackageItemIDs();
         if(_loc2_.lootID)
         {
            _loc3_.push(ItemsDataUtility.getVideoURLbyLootId(_loc2_.lootID));
         }
         else if(_loc4_.length > 0)
         {
            _loc5_ = int(_loc4_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               _loc3_.push(ItemsDataUtility.getVideoURLbyLootId(_loc7_));
               _loc6_++;
            }
         }
         this._finalRewardVideoPlayer.play(_loc3_);
      }
      
      private function setTitle(param1:String) : void
      {
         this.simpleWindow.setTitle(param1);
      }
      
      private function setDescription(param1:String) : void
      {
         this._infoLabel.text = BPLocale.getItem(param1);
      }
      
      private function assignProgress(param1:Number) : void
      {
         if(!isNaN(param1))
         {
            this._eventProgressBar.updateProgress(param1);
         }
      }
      
      public function set remainingTime(param1:Number) : void
      {
         this._remainingTime = param1;
         if(this._remainingTimer)
         {
            this._remainingTimer.start(this._remainingTime);
         }
      }
      
      public function updateCollectedStatus(param1:int) : void
      {
         this._statusCode = param1;
         if(this._eventProgressBar)
         {
            this._eventProgressBar.updateCollectedStatus = this._statusCode;
         }
      }
   }
}

