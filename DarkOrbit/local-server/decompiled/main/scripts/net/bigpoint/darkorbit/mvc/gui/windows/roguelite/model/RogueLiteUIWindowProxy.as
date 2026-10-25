package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model
{
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteCashOutCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteCpuInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteInventoryCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteRankEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteScoreInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteSelectRewardCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class RogueLiteUIWindowProxy extends SimpleWindowProxy
   {
      
      public function RogueLiteUIWindowProxy(param1:String)
      {
         super(param1,new RogueLiteUIData());
      }
      
      public function get viewData() : RogueLiteUIData
      {
         return data as RogueLiteUIData;
      }
      
      public function updateScore(param1:RogueLiteScoreInfoCommand) : void
      {
         this.viewData.updateScore(param1);
      }
      
      public function updateInfo(param1:RogueLiteInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateKeyCount(param1:RogueLiteCpuInfoCommand) : void
      {
         this.viewData.updateKeyCount(param1);
      }
      
      public function updateRewardsCashout(param1:RogueLiteCashOutCommand) : void
      {
         this.viewData.updateRewardsCashout(param1);
      }
      
      public function updateRewards(param1:RogueLiteSelectRewardCommand) : void
      {
         this.viewData.updateRewards(param1);
      }
      
      public function updateInventory(param1:RogueLiteInventoryCommand) : void
      {
         this.viewData.updateInventory(param1);
      }
      
      public function disableEquipping() : void
      {
         this.viewData.canEquip.value = false;
      }
      
      public function updateRankingInfo(param1:RogueLiteRankEventInfoCommand) : void
      {
         this.viewData.updateRankingInfo(param1);
      }
      
      public function updateRankingRewards(param1:RankRewardCommand) : void
      {
         this.viewData.updateRankingRewardsPackage(new BindableInt(param1.rewardRange.from,param1.rewardRange.from,param1.rewardRange.to),param1.rewardContentModuleList);
      }
      
      public function updateRanking(param1:RogueLiteRankInfoCommand) : void
      {
         this.viewData.updateRanking(param1);
      }
   }
}

