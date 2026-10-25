package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model
{
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossTier;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class WorldBossUIRewardsProxy extends SimpleWindowProxy
   {
      
      public function WorldBossUIRewardsProxy(param1:String)
      {
         super(param1,new WorldBossUIRewardsData());
      }
      
      public function get viewData() : WorldBossUIRewardsData
      {
         return data as WorldBossUIRewardsData;
      }
      
      public function updateRewardInfo(param1:Vector.<PublicWorldBossTier>, param2:int = 0) : void
      {
         this.viewData.updateInfo(param1);
         this.viewData.currTier = param2;
      }
      
      public function updateTier(param1:int) : *
      {
         this.viewData.currTier = param1;
      }
   }
}

