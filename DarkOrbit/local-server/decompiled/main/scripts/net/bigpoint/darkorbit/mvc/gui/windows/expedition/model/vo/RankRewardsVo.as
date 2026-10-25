package net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo
{
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   
   public class RankRewardsVo
   {
      
      private var _index:Number;
      
      private var _config:RankRewardCommand;
      
      public function RankRewardsVo(param1:RankRewardCommand)
      {
         super();
         this._config = param1;
         this._index = (param1.rewardRange.from + param1.rewardRange.to) / 2;
      }
      
      public function get index() : Number
      {
         return this._index;
      }
      
      public function get rewardListData() : Vector.<RewardContentModule>
      {
         return this._config.rewardContentModuleList;
      }
      
      public function get rankText() : String
      {
         if(this._config.rewardRange.from == this._config.rewardRange.to)
         {
            return this._config.rewardRange.from + "";
         }
         if(this._config.rewardRange.to == 999999999)
         {
            return this._config.rewardRange.from - 1 + "+";
         }
         return this._config.rewardRange.from + "-" + this._config.rewardRange.to;
      }
   }
}

