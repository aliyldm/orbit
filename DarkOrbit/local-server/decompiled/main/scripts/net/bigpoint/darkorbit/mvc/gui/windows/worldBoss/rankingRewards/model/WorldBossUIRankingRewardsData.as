package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRankReward;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIRankingRewardsData extends EventDispatcher
   {
      
      private var _dailyRankRewards:Vector.<WorldBossUIRankingRewardsVO> = new Vector.<WorldBossUIRankingRewardsVO>(0);
      
      private var _eventRankRewards:Vector.<WorldBossUIRankingRewardsVO> = new Vector.<WorldBossUIRankingRewardsVO>(0);
      
      public const changed:ISignal = new Signal();
      
      public function WorldBossUIRankingRewardsData()
      {
         super();
      }
      
      public function updateInfo(param1:Vector.<PublicWorldBossRankReward>) : void
      {
         this.updateRankingRewardList(param1);
         this.changed.dispatch();
      }
      
      public function get rankDailyRewards() : Vector.<WorldBossUIRankingRewardsVO>
      {
         return this._dailyRankRewards;
      }
      
      public function get eventRankRewards() : Vector.<WorldBossUIRankingRewardsVO>
      {
         return this._eventRankRewards;
      }
      
      private function updateRankingRewardList(param1:Vector.<PublicWorldBossRankReward>) : void
      {
         var _loc2_:PublicWorldBossRankReward = null;
         this._eventRankRewards = new Vector.<WorldBossUIRankingRewardsVO>(0);
         for each(_loc2_ in param1)
         {
            this._eventRankRewards.push(new WorldBossUIRankingRewardsVO(_loc2_));
         }
         this._eventRankRewards.sort(WorldBossUIRankingRewardsVO.sort);
      }
   }
}

