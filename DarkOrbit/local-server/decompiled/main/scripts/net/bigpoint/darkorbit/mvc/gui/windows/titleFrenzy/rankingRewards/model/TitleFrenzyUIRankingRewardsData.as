package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model
{
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.com.module.TitleFrenzyInfoCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TitleFrenzyUIRankingRewardsData extends EventDispatcher
   {
      
      private var _rankRewards:Vector.<TitleFrenzyUIRankingRewardsVO> = new Vector.<TitleFrenzyUIRankingRewardsVO>(0);
      
      public const changed:ISignal = new Signal();
      
      public function TitleFrenzyUIRankingRewardsData()
      {
         super();
      }
      
      public function updateInfo(param1:TitleFrenzyInfoCommand) : void
      {
         this.updateRankingRewardList(param1);
         this.changed.dispatch();
      }
      
      public function get rankRewards() : Vector.<TitleFrenzyUIRankingRewardsVO>
      {
         return this._rankRewards;
      }
      
      private function updateRankingRewardList(param1:TitleFrenzyInfoCommand) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         this._rankRewards = new Vector.<TitleFrenzyUIRankingRewardsVO>(0);
         for each(_loc2_ in param1.rankRewards)
         {
            this._rankRewards.push(new TitleFrenzyUIRankingRewardsVO(new BindableInt(_loc2_.from,_loc2_.from,_loc2_.to)));
         }
         this._rankRewards.sort(TitleFrenzyUIRankingRewardsVO.sort);
      }
      
      public function updateRankingRewardsPackage(param1:BindableInt, param2:Vector.<RewardContentModule>) : *
      {
         var _loc3_:TitleFrenzyUIRankingRewardsVO = null;
         for each(_loc3_ in this._rankRewards)
         {
            if(_loc3_.min == param1.minValue && _loc3_.max == param1.maxValue)
            {
               _loc3_.rewards = param2;
            }
         }
      }
   }
}

