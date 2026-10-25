package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model
{
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.RewardTitleModule;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRankReward;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIRankingRewardsVO
   {
      
      public var rewardListChanged:ISignal = new Signal();
      
      private var _rewardList:Vector.<RewardModule> = new Vector.<RewardModule>(0);
      
      private var _titleList:Vector.<RewardTitleModule> = new Vector.<RewardTitleModule>(0);
      
      private var _from:int;
      
      private var _to:int;
      
      public function WorldBossUIRankingRewardsVO(param1:PublicWorldBossRankReward)
      {
         super();
         this._from = param1.from;
         this._to = param1.to;
         this._rewardList = param1.rewards;
         this._titleList.push(param1.rewardTitleModule);
      }
      
      public static function sort(param1:WorldBossUIRankingRewardsVO, param2:WorldBossUIRankingRewardsVO) : int
      {
         return param1._from - param2._from;
      }
      
      public function get titleList() : Vector.<RewardTitleModule>
      {
         return this._titleList;
      }
      
      public function get rewards() : Vector.<RewardModule>
      {
         return this._rewardList;
      }
      
      public function set rewards(param1:Vector.<RewardModule>) : void
      {
         this._rewardList = param1;
         this.rewardListChanged.dispatch();
      }
      
      public function get title() : String
      {
         if(this._from == this._to)
         {
            return this._from.toString();
         }
         if(this._to > 1000)
         {
            return this._from + "+";
         }
         return this._from + " - " + this._to;
      }
   }
}

