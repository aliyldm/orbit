package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model
{
   import net.bigpoint.darkorbit.com.module.EternalGateBoosterInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateKeyInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateSkillPointInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateWaveInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class EternalGateUIWindowProxy extends SimpleWindowProxy
   {
      
      public function EternalGateUIWindowProxy(param1:String)
      {
         super(param1,new EternalGateUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : EternalGateUIData
      {
         return data as EternalGateUIData;
      }
      
      public function updateInfo(param1:EternalGateInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateWave(param1:EternalGateWaveInfoCommand) : void
      {
         this.viewData.updateWave(param1);
      }
      
      public function updateKeys(param1:EternalGateKeyInfoCommand) : void
      {
         this.viewData.updateKeys(param1);
      }
      
      public function updateBoosters(param1:EternalGateBoosterInfoCommand) : void
      {
         this.viewData.updateBoosters(param1);
      }
      
      public function updateSkillPoints(param1:EternalGateSkillPointInfoCommand) : void
      {
         this.viewData.updateSkillPoints(param1);
      }
      
      public function updateRewards(param1:RankRewardCommand) : void
      {
         this.viewData.updatePlayerReward(param1.rewardRange.from,param1.rewardRange.to,param1.rewardContentModuleList);
      }
      
      public function updateRanking(param1:EternalGateRankInfoCommand) : void
      {
         this.viewData.updateRanking(param1);
      }
   }
}

