package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.view
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model.TitleFrenzyUIRankingRewardsVO;
   
   public class TitleFrenzyUIRankingRewardsEvent extends Event
   {
      
      public static const REQUEST_RANK_REWARD_INFO:String = "TitleFrenzyUIRankingRewardsEvent.REQUEST_RANK_REWARD_INFO";
      
      private var _vo:TitleFrenzyUIRankingRewardsVO;
      
      public function TitleFrenzyUIRankingRewardsEvent(param1:String, param2:TitleFrenzyUIRankingRewardsVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get VO() : TitleFrenzyUIRankingRewardsVO
      {
         return this._vo;
      }
   }
}

