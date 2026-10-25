package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model
{
   import net.bigpoint.darkorbit.com.module.EternalBlacklightBoosterInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightCpuInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightRankingEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightSkillPointInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightWaveInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class EternalBlacklightUIWindowProxy extends SimpleWindowProxy
   {
      
      public function EternalBlacklightUIWindowProxy(param1:String)
      {
         super(param1,new EternalBlacklightUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : EternalBlacklightUIData
      {
         return data as EternalBlacklightUIData;
      }
      
      public function updateInfo(param1:EternalBlacklightInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateWave(param1:EternalBlacklightWaveInfoCommand) : void
      {
         this.viewData.updateWave(param1);
      }
      
      public function updateCpus(param1:EternalBlacklightCpuInfoCommand) : void
      {
         this.viewData.updateCpus(param1);
      }
      
      public function updateBoosters(param1:EternalBlacklightBoosterInfoCommand) : void
      {
         this.viewData.updateBoosters(param1);
      }
      
      public function updateSkillPoints(param1:EternalBlacklightSkillPointInfoCommand) : void
      {
         this.viewData.updateSkillPoints(param1);
      }
      
      public function updateRewards(param1:RankRewardCommand) : void
      {
         this.viewData.updatePlayerReward(param1.rewardRange.from,param1.rewardRange.to,param1.rewardContentModuleList);
      }
      
      public function updateRanking(param1:EternalBlacklightRankInfoCommand) : void
      {
         this.viewData.updateRanking(param1);
      }
      
      public function updateRankingInfo(param1:EternalBlacklightRankingEventInfoCommand) : void
      {
         this.viewData.updateRankingInfo(param1);
      }
   }
}

