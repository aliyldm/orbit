package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model
{
   import net.bigpoint.darkorbit.com.module.PVPSummerEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.PVPSummerEventSelfReputationUpdateCommand;
   import net.bigpoint.darkorbit.com.module.PVPSummerEventShuffleInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.com.module.RewardContentCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class PvpSummerUIWindowProxy extends SimpleWindowProxy
   {
      
      public function PvpSummerUIWindowProxy(param1:String)
      {
         super(param1,new PvpSummerUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : PvpSummerUIData
      {
         return data as PvpSummerUIData;
      }
      
      public function updateRewards(param1:RankRewardCommand) : void
      {
         if(param1.rankType == RankRewardCommand.RANKTYPE_PVP_SUMMER_EVENT_REPUTATION)
         {
            this.viewData.updateRepRewards(param1.rewardRange.from,param1.rewardRange.to,param1.rewardContentModuleList);
         }
         else if(param1.rankType)
         {
            this.viewData.updateRepPerKillRewards(param1.rewardRange.from,param1.rewardRange.to,param1.rewardContentModuleList);
         }
      }
      
      public function updateNextMilestoneRewards(param1:RewardContentCommand) : void
      {
         this.viewData.updateNextMilestoneRewards(param1.rewardContentModuleList);
      }
      
      public function updateInfo(param1:PVPSummerEventInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateSelfReputation(param1:PVPSummerEventSelfReputationUpdateCommand) : void
      {
         this.viewData.updateSelfReputation(param1);
      }
      
      public function updateShuffleInfo(param1:PVPSummerEventShuffleInfoCommand) : void
      {
         this.viewData.updateShuffleInfo(param1);
      }
   }
}

