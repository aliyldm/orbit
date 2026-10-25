package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.RankRewardRequest;
   import net.bigpoint.darkorbit.com.module.RewardContentRequest;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.TieredArenaUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view.components.TieredArenaParticipationRewardsToolTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view.components.TieredArenaRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view.components.event.TieredArenaEvent;
   
   public class TieredArenaUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:TieredArenaUIData;
      
      private var _view:TieredArenaRootView;
      
      public function TieredArenaUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(360,267);
      }
      
      private static function formatTimerText(param1:Label, param2:Number) : void
      {
         if(param2 > 0)
         {
            param1.text = TimeFormatter.getSmartFormatedTime(param2);
         }
         else
         {
            param1.text = "-";
         }
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:TieredArenaUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.overviewData.changed.remove(this.updateReputation);
            this._data.overviewData.changed.remove(this.updateRepParticipation);
            this._data.overviewData.tooltipChanged.remove(this.updateRepParticipationRewards);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.overviewData.changed.add(this.updateReputation);
            this._data.overviewData.changed.add(this.updateRepParticipation);
            this._data.overviewData.tooltipChanged.add(this.updateRepParticipationRewards);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new TieredArenaRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as TieredArenaUIData;
         this.addListeners();
         this.prepareReputationRequiredInfoBtn();
      }
      
      private function addListeners() : void
      {
         this._view.tabChanged.add(this.resizeWindow);
         this._view.rewards.list.addEventListener(TieredArenaEvent.REQUEST_REP_DATA,this.loadRepRewards);
         this._view.rewards.repRequiredInfoBtn.addEventListener(MouseEvent.MOUSE_OVER,this.loadRepParticipationRewards);
         this._data.overviewData.arenaTimeLeftChanged = this.updateTimeArenaLeft;
         this._data.overviewData.arenaTimeEndChanged = this.updateTimeArenaEnd;
      }
      
      private function removeListeners() : void
      {
         this._view.tabChanged.remove(this.resizeWindow);
         this._view.rewards.list.removeEventListener(TieredArenaEvent.REQUEST_REP_DATA,this.loadRepRewards);
         this._view.rewards.repRequiredInfoBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.loadRepParticipationRewards);
         this._data.overviewData.arenaTimeLeftChanged = null;
         this._data.overviewData.arenaTimeEndChanged = null;
      }
      
      private function prepareReputationRequiredInfoBtn() : void
      {
         this._view.rewards.repRequiredInfoBtn.tooltipTemplateID = "tiered_arenaRewardsToolTip";
         this._view.rewards.repRequiredInfoBtn.tooltipDataAssigner = new TieredArenaParticipationRewardsToolTipAssigner();
      }
      
      private function loadRepRewards(param1:TieredArenaEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RankRewardRequest(param1.vo.repMin,RankRewardRequest.RANKTYPE_TIERED_ARENA_EVENT_REPUTATION));
      }
      
      private function loadRepParticipationRewards(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RewardContentRequest(RewardContentRequest.REWARDTYPE_TIERED_ARENA_EVENT_PARTICIPATION));
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this._view.rewards.list.list = new VectorCollection(this._data.rewardItems);
            this.updateTitle();
            this.updateReputation();
            this.updateRepParticipation();
            this.updateTimer();
         }
         this.resizeWindow();
      }
      
      private function updateTitle() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         window.setTitle(this._data.titleLocaKey);
      }
      
      private function updateTimer() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         if(this._data.overviewData.isArenaOpen)
         {
            this._view.overview.arenaTimeLeftText.text = BPLocale.getItem("tieredArena_tab_overview_arena_open");
         }
         else
         {
            this._view.overview.arenaTimeLeftText.text = BPLocale.getItem("tieredArena_tab_overview_arena_close");
         }
         this.updateTimeArenaLeft();
         this.updateTimeArenaEnd();
      }
      
      private function updateTimeArenaLeft() : void
      {
         formatTimerText(this._view.overview.arenaTimeLeft,this._data.overviewData.arenaTimeLeft);
      }
      
      private function updateTimeArenaEnd() : void
      {
         formatTimerText(this._view.overview.arenaTimeEnd,this._data.overviewData.eventTimeEnd);
      }
      
      private function updateReputation() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.overview.reputation.text = TextFormatter.roundInteger(this._data.overviewData.rep);
      }
      
      private function updateRepParticipation() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.rewards.repRequired.text = TextFormatter.roundInteger(this._data.overviewData.reputationRequired);
      }
      
      private function updateRepParticipationRewards() : void
      {
         if(!this._data || !this._view)
         {
            return;
         }
         this._view.rewards.repRequiredInfoBtn.tooltipData = this._data.overviewData.participationRewards;
      }
      
      private function resizeWindow() : void
      {
         if(this._view.overview.tabRoot.visible)
         {
            window.setSize(window.width - 20,this._view.overview.tabRoot.y + this._view.overview.tabRoot.marginTop + this._view.overview.tabRoot.height);
         }
         else
         {
            window.setSize(window.width - 20,this._view.rewards.tabRoot.y + this._view.rewards.tabRoot.marginTop + this._view.rewards.tabRoot.height);
         }
      }
   }
}

