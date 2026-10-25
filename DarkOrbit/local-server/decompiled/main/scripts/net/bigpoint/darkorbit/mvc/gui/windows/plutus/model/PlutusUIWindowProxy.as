package net.bigpoint.darkorbit.mvc.gui.windows.plutus.model
{
   import net.bigpoint.darkorbit.com.module.PlutusInfoCommand;
   import net.bigpoint.darkorbit.com.module.PlutusPointsUpdateCommand;
   import net.bigpoint.darkorbit.com.module.PlutusStatusCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class PlutusUIWindowProxy extends SimpleWindowProxy
   {
      
      public function PlutusUIWindowProxy(param1:String)
      {
         super(param1,new PlutusUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : PlutusUIData
      {
         return data as PlutusUIData;
      }
      
      public function updateRewards(param1:RankRewardCommand) : void
      {
         this.viewData.updatePlayerReward(param1.rewardRange.from,param1.rewardRange.to,param1.rewardContentModuleList);
      }
      
      public function updateInfo(param1:PlutusInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateStatus(param1:PlutusStatusCommand) : void
      {
         this.viewData.updateStatus(param1);
      }
      
      public function updatePoints(param1:PlutusPointsUpdateCommand) : void
      {
         this.viewData.updatePoints(param1);
      }
   }
}

