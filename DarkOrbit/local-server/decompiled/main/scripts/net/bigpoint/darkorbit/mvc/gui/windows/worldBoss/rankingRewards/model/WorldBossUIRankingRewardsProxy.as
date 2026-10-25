package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model
{
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRankReward;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class WorldBossUIRankingRewardsProxy extends SimpleWindowProxy
   {
      
      public function WorldBossUIRankingRewardsProxy(param1:String)
      {
         super(param1,new WorldBossUIRankingRewardsData());
      }
      
      public function get viewData() : WorldBossUIRankingRewardsData
      {
         return data as WorldBossUIRankingRewardsData;
      }
      
      public function updateRankingRewardInfo(param1:Vector.<PublicWorldBossRankReward>) : void
      {
         this.viewData.updateInfo(param1);
      }
   }
}

