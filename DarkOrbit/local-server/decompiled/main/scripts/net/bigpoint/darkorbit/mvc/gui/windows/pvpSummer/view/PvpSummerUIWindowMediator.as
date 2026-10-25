package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.time.TimeVo;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.RankRewardRequest;
   import net.bigpoint.darkorbit.com.module.RewardContentRequest;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.PvpSummerUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view.components.PvpSummerMilestoneRewardsToolTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view.components.PvpSummerRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view.components.event.PvpSummerEvent;
   
   public class PvpSummerUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:PvpSummerUIData;
      
      private var _view:PvpSummerRootView;
      
      public function PvpSummerUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(360,267);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this.data = null;
      }
      
      public function set data(param1:PvpSummerUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.overviewData.countdown.changed.remove(this.updateCountdown);
            this._data.overviewData.changed.remove(this.updateReputation);
            this._data.overviewData.changed.remove(this.updateRepPerKill);
            this._data.overviewData.changed.remove(this.updateNextRepMilestone);
            this._data.overviewData.tooltipChanged.remove(this.updateNextRepMilestoneRewards);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.overviewData.countdown.changed.add(this.updateCountdown);
            this._data.overviewData.changed.add(this.updateReputation);
            this._data.overviewData.changed.add(this.updateRepPerKill);
            this._data.overviewData.changed.add(this.updateNextRepMilestone);
            this._data.overviewData.tooltipChanged.add(this.updateNextRepMilestoneRewards);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new PvpSummerRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as PvpSummerUIData;
         this.addListeners();
         this.prepareNextMilestoneBtn();
      }
      
      private function addListeners() : void
      {
         this._view.rewards.list.addEventListener(PvpSummerEvent.REQUEST_REP_DATA,this.loadRepRewards);
         this._view.rewards.list.addEventListener(PvpSummerEvent.REQUEST_REP_PER_KILL_DATA,this.loadRepPerKillRewards);
         this._view.overView.nextRepMilestoneBtn.addEventListener(MouseEvent.MOUSE_OVER,this.loadNextMilestoneRewards);
      }
      
      private function removeListeners() : void
      {
         this._view.rewards.list.removeEventListener(PvpSummerEvent.REQUEST_REP_DATA,this.loadRepRewards);
         this._view.rewards.list.removeEventListener(PvpSummerEvent.REQUEST_REP_PER_KILL_DATA,this.loadRepPerKillRewards);
         this._view.overView.nextRepMilestoneBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.loadNextMilestoneRewards);
      }
      
      private function prepareNextMilestoneBtn() : void
      {
         this._view.overView.nextRepMilestoneBtn.tooltipTemplateID = "pvpsummerOverviewToolTip";
         this._view.overView.nextRepMilestoneBtn.tooltipDataAssigner = new PvpSummerMilestoneRewardsToolTipAssigner();
      }
      
      private function loadRepRewards(param1:PvpSummerEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RankRewardRequest(param1.vo.repMin,RankRewardRequest.RANKTYPE_PVP_SUMMER_EVENT_REPUTATION));
      }
      
      private function loadRepPerKillRewards(param1:PvpSummerEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RankRewardRequest(param1.vo.repPerKillMin,RankRewardRequest.RANKTYPE_PVP_SUMMER_EVENT_REPUTATION_PER_KILL));
      }
      
      private function loadNextMilestoneRewards(param1:MouseEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RewardContentRequest(RewardContentRequest.REWARDTYPE_PVP_SUMMER_EVENT_MILESTONE));
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this._view.rewards.list.list = new VectorCollection(this._data.rewardItems);
            this.updateCountdown();
            this.updateReputation();
            this.updateRepPerKill();
            this.updateNextRepMilestone();
         }
      }
      
      private function updateCountdown() : void
      {
         var _loc1_:TimeVo = null;
         if(Boolean(this._data) && Boolean(this._view))
         {
            _loc1_ = TimeFormatter.getSeparatedTimeValues(this._data.overviewData.countdown.value,false,false);
            this._view.overView.countdown.text = TimeFormatter.alz(_loc1_.minutesVal) + ":" + TimeFormatter.alz(_loc1_.secondsVal);
         }
      }
      
      private function updateReputation() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.reputation.text = TextFormatter.roundInteger(this._data.overviewData.rep);
         }
      }
      
      private function updateRepPerKill() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.repPerKill.text = TextFormatter.roundInteger(this._data.overviewData.repPerKill);
         }
      }
      
      private function updateNextRepMilestone() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.nextRepMilestone.text = TextFormatter.roundInteger(this._data.overviewData.nextRepMilestone);
         }
      }
      
      private function updateNextRepMilestoneRewards() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.nextRepMilestoneBtn.tooltipData = this._data.overviewData.nextRepMilestoneRewards;
         }
      }
   }
}

