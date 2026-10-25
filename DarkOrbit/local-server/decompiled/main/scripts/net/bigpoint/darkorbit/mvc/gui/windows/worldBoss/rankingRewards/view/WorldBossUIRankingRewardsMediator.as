package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.view
{
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model.WorldBossUIRankingRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model.WorldBossUIRankingRewardsVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIRankingRewardsMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:WorldBossUIRankingRewardsData;
      
      private var _view:WorldBossUIRankingRewardsView;
      
      public function WorldBossUIRankingRewardsMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:WorldBossUIRankingRewardsData) : void
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
         this._view = new WorldBossUIRankingRewardsView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as WorldBossUIRankingRewardsData;
         this.buildCompleted.dispatch(this._view);
      }
      
      public function manualLoad(param1:WorldBossUIRankingRewardsView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as WorldBossUIRankingRewardsData;
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.list = this._view.filterBox.currentEntry == WorldBossUIRankingRewardsView.FILTER_INDEX_DAILY ? this._data.rankDailyRewards : this._data.eventRankRewards;
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
      }
   }
}

