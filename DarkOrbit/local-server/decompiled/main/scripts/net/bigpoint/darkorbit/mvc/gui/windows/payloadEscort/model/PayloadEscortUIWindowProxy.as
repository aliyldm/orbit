package net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model
{
   import net.bigpoint.darkorbit.com.module.PayloadEscortInfoCommand;
   import net.bigpoint.darkorbit.com.module.PayloadEscortKeyInfoCommand;
   import net.bigpoint.darkorbit.com.module.PayloadEscortScoreCommand;
   import net.bigpoint.darkorbit.com.module.PayloadEscortTimeInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class PayloadEscortUIWindowProxy extends SimpleWindowProxy
   {
      
      public function PayloadEscortUIWindowProxy(param1:String)
      {
         super(param1,new PayloadEscortUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : PayloadEscortUIData
      {
         return data as PayloadEscortUIData;
      }
      
      public function updateInfo(param1:PayloadEscortInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateTimer(param1:PayloadEscortTimeInfoCommand) : void
      {
         this.viewData.updateTimer(param1);
      }
      
      public function updateKeys(param1:PayloadEscortKeyInfoCommand) : void
      {
         this.viewData.updateKeys(param1);
      }
      
      public function updateRunScore(param1:PayloadEscortScoreCommand) : void
      {
         this.viewData.updateRunScore(param1);
      }
      
      public function updateRewards(param1:RankRewardCommand) : void
      {
         this.viewData.updatePlayerReward(param1.rewardRange.from,param1.rewardRange.to,param1.rewardContentModuleList);
      }
   }
}

