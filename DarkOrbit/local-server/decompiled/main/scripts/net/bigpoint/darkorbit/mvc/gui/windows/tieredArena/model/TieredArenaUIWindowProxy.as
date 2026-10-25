package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model
{
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.com.module.RewardContentCommand;
   import net.bigpoint.darkorbit.com.module.TieredArenaEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.TieredArenaEventScheduleInfoCommand;
   import net.bigpoint.darkorbit.com.module.TieredArenaEventSelfReputationUpdateCommand;
   import net.bigpoint.darkorbit.com.module.TieredArenaEventTierUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class TieredArenaUIWindowProxy extends SimpleWindowProxy
   {
      
      public function TieredArenaUIWindowProxy(param1:String)
      {
         super(param1,new TieredArenaUIData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function get viewData() : TieredArenaUIData
      {
         return data as TieredArenaUIData;
      }
      
      public function updateRewards(param1:RankRewardCommand) : void
      {
         if(param1.rankType == RankRewardCommand.RANKTYPE_TIERED_ARENA_EVENT_REPUTATION)
         {
            this.viewData.updateRepRewards(param1.rewardRange.from,param1.rewardRange.to,param1.rewardContentModuleList);
         }
      }
      
      public function updateParticipationRewards(param1:RewardContentCommand) : void
      {
         this.viewData.updateParticipationRewards(param1.rewardContentModuleList);
      }
      
      public function updateInfo(param1:TieredArenaEventInfoCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateSchedule(param1:TieredArenaEventScheduleInfoCommand) : void
      {
         this.viewData.updateSchedule(param1);
      }
      
      public function updateSelfReputation(param1:TieredArenaEventSelfReputationUpdateCommand) : void
      {
         this.viewData.updateSelfReputation(param1);
      }
      
      public function updateUserTier(param1:TieredArenaEventTierUpdateCommand) : void
      {
         this.viewData.updateUserTier(param1);
      }
   }
}

