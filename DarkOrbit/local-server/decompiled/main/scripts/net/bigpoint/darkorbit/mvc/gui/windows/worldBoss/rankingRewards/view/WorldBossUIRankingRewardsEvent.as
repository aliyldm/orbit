package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.view
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model.WorldBossUIRankingRewardsVO;
   
   public class WorldBossUIRankingRewardsEvent extends Event
   {
      
      public static const REQUEST_RANK_REWARD_INFO:String = "WorldBossUIRankingRewardsEvent.REQUEST_RANK_REWARD_INFO";
      
      private var _vo:WorldBossUIRankingRewardsVO;
      
      public function WorldBossUIRankingRewardsEvent(param1:String, param2:WorldBossUIRankingRewardsVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get VO() : WorldBossUIRankingRewardsVO
      {
         return this._vo;
      }
   }
}

