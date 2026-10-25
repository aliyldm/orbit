package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.view
{
   import net.bigpoint.darkorbit.com.module.RankRewardRequest;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model.TitleFrenzyUIRankingRewardsData;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TitleFrenzyUIRankingRewardsMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:TitleFrenzyUIRankingRewardsData;
      
      private var _view:TitleFrenzyUIRankingRewardsView;
      
      public function TitleFrenzyUIRankingRewardsMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:TitleFrenzyUIRankingRewardsData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new TitleFrenzyUIRankingRewardsView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as TitleFrenzyUIRankingRewardsData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
         this._view.placementItemList.addEventListener(TitleFrenzyUIRankingRewardsEvent.REQUEST_RANK_REWARD_INFO,this.onHoverRankingRewardInfoBtn);
      }
      
      private function removeListeners() : void
      {
         this._view.placementItemList.removeEventListener(TitleFrenzyUIRankingRewardsEvent.REQUEST_RANK_REWARD_INFO,this.onHoverRankingRewardInfoBtn);
      }
      
      public function manualLoad(param1:TitleFrenzyUIRankingRewardsView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as TitleFrenzyUIRankingRewardsData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.list = this._data.rankRewards;
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
      }
      
      private function onHoverRankingRewardInfoBtn(param1:TitleFrenzyUIRankingRewardsEvent) : void
      {
         var _loc2_:int = RankRewardRequest.RANKTYPE_TITLE_FRENZY;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new RankRewardRequest(param1.VO.min,_loc2_));
      }
   }
}

