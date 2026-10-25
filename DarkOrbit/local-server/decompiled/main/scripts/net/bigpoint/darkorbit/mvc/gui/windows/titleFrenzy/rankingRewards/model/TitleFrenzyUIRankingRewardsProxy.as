package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model
{
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class TitleFrenzyUIRankingRewardsProxy extends SimpleWindowProxy
   {
      
      public function TitleFrenzyUIRankingRewardsProxy(param1:String)
      {
         super(param1,new TitleFrenzyUIRankingRewardsData());
      }
      
      public function get viewData() : TitleFrenzyUIRankingRewardsData
      {
         return data as TitleFrenzyUIRankingRewardsData;
      }
      
      public function updateRankingRewardsInfo(param1:TitleFrenzyInfoCommand) : *
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateRankingRewardsPackage(param1:RankRewardCommand) : void
      {
         this.viewData.updateRankingRewardsPackage(new BindableInt(param1.rewardRange.from,param1.rewardRange.from,param1.rewardRange.to),param1.rewardContentModuleList);
      }
   }
}

