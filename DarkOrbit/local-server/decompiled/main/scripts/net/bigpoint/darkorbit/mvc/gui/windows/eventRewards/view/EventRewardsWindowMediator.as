package net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.EventRewardConfirmationCommand;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.EventRewardsNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.model.EventRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.model.EventRewardsWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EventRewardsWindowMediator extends SimpleWindowMediator
   {
      
      private var _titleLabel:Label;
      
      private var _placeLabel:Label;
      
      private var _messageLabel:Label;
      
      private var _confirmButton:Button;
      
      private var _eventRewardsWindowView:EventRewardsWindowView;
      
      private var _currentRewardsData:EventRewardsData;
      
      private var _windowId:String = "";
      
      public function EventRewardsWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this._windowId = param1;
      }
      
      override public function loadAndBuildContent(param1:String) : void
      {
         super.loadAndBuildContent(param1);
      }
      
      override public function onRemove() : void
      {
         this.removeEventListeners();
         super.onRemove();
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         this.assignUIComponents();
         this.addEventListeners();
         super.handleLoadAndBuildContentCallback(param1);
         this._eventRewardsWindowView = new EventRewardsWindowView(UIContentContainer);
         this.onContentLoadedUpdateViewComponentFromModel();
      }
      
      private function assignUIComponents() : void
      {
         this._titleLabel = FuiComponentSelectorUtil.selectComponent("root.contentContainer.infoContainer.title",UIContentContainer) as Label;
         this._placeLabel = FuiComponentSelectorUtil.selectComponent("root.contentContainer.infoContainer.place",UIContentContainer) as Label;
         this._messageLabel = FuiComponentSelectorUtil.selectComponent("root.contentContainer.infoContainer.message",UIContentContainer) as Label;
         this._confirmButton = FuiComponentSelectorUtil.selectComponent("root.contentContainer.confirmContainer.confirmBtn",UIContentContainer) as Button;
      }
      
      override protected function mapNotificationsToMethods() : void
      {
         mapNotificationToMethod(EventRewardsNotifications.QUEUE_CHANGED,this.handleQueueChanged);
      }
      
      private function handleQueueChanged(param1:INotification) : void
      {
         if(!this.currentRewardsData)
         {
            this.retrieveNextRewardsData();
         }
      }
      
      private function retrieveNextRewardsData() : void
      {
         var _loc1_:EventRewardsWindowProxy = facade.retrieveProxy(GuiConstants.EVENT_REWARDS_WINDOW) as EventRewardsWindowProxy;
         this.currentRewardsData = _loc1_.getNext();
         if(this.currentRewardsData == null)
         {
            sendNotification(GuiNotifications.DESTROY_SIMPLE_WINDOW,this._windowId);
         }
         else
         {
            this.update();
         }
      }
      
      private function addEventListeners() : void
      {
         this._confirmButton.addEventListener(MouseEvent.CLICK,this.handleConfirmationButtonClick);
      }
      
      private function removeEventListeners() : void
      {
         this._confirmButton.removeEventListener(MouseEvent.CLICK,this.handleConfirmationButtonClick);
      }
      
      private function handleConfirmationButtonClick(param1:Event) : void
      {
         this.retrieveNextRewardsData();
      }
      
      private function onContentLoadedUpdateViewComponentFromModel() : void
      {
         this.update();
      }
      
      public function update() : void
      {
         if(Boolean(this.currentRewardsData) && Boolean(this.currentRewardsData.isValid()) && isUIReady())
         {
            switch(this.currentRewardsData.rewardType)
            {
               case EventRewardConfirmationCommand.REWARDTYPE_HUNT_PLAYER:
                  viewComponent.setTitle("title_event_rewards_window");
                  this._titleLabel.localizedText = "event_rewards_window_headline";
                  this._messageLabel.localizedText = "event_rewards_window_message";
                  break;
               case EventRewardConfirmationCommand.REWARDTYPE_HUNT_CLAN:
                  viewComponent.setTitle("title_event_rewards_window");
                  this._titleLabel.localizedText = "event_rewards_window_headline";
                  this._messageLabel.localizedText = "event_rewards_window_message_clan";
                  break;
               case EventRewardConfirmationCommand.REWARDTYPE_PLUTUS:
                  viewComponent.setTitle("title_event_gop_rewards_window");
                  this._titleLabel.localizedText = "event_gop_rewards_window_headline";
                  this._messageLabel.localizedText = "event_gop_rewards_window_message";
                  break;
               case EventRewardConfirmationCommand.REWARDTYPE_PAYLOAD_ESCORT:
                  viewComponent.setTitle("title_event_mm_rewards_window");
                  this._titleLabel.localizedText = "event_mm_rewards_window_headline";
                  this._messageLabel.localizedText = "event_mm_rewards_window_message";
                  break;
               case EventRewardConfirmationCommand.REWARDTYPE_ETERNAL_BLACKLIGHT:
                  viewComponent.setTitle("title_event_eternal_blacklight_rewards_window");
                  this._titleLabel.localizedText = "event_eternal_blacklight_rewards_window_headline";
                  this._messageLabel.localizedText = "event_eternal_blacklight_rewards_window_message";
                  break;
               case EventRewardConfirmationCommand.REWARDTYPE_TIERED_ARENA_REPUTATION:
                  viewComponent.setTitle("title_event_tieredArena_rewards_window");
                  this._messageLabel.localizedText = "event_tieredArena_rewards_window_headline";
                  this._messageLabel.localizedText = "event_tieredArena_rewards_window_message_rep";
                  break;
               case EventRewardConfirmationCommand.REWARDTYPE_ROGUELITE_ASTRAL_ASCENSION:
                  viewComponent.setTitle("title_event_astral_ascension_rewards_window");
                  this._messageLabel.localizedText = "event_astral_ascension_rewards_window_headline";
                  this._messageLabel.localizedText = "event_astral_ascension_rewards_window_message";
                  break;
               default:
                  viewComponent.setTitle("title_event_rewards_window");
                  this._titleLabel.localizedText = "event_rewards_window_headline";
                  this._messageLabel.localizedText = "event_rewards_window_message";
            }
            this._eventRewardsWindowView.data = this.currentRewardsData.rewardItems;
            if(this.currentRewardsData.place > 0)
            {
               this._placeLabel.text = BPLocale.getItem("event_rewards_window_place").replace("%POSITION%",this.currentRewardsData.place);
            }
            else
            {
               this._placeLabel.text = "";
            }
         }
      }
      
      private function get currentRewardsData() : EventRewardsData
      {
         return this._currentRewardsData;
      }
      
      private function set currentRewardsData(param1:EventRewardsData) : void
      {
         if(this._currentRewardsData)
         {
            this._currentRewardsData.changed.remove(this.update);
         }
         this._currentRewardsData = param1;
         if(this._currentRewardsData)
         {
            this._currentRewardsData.changed.add(this.update);
         }
      }
   }
}

