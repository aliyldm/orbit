package net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionRankUserInfoCommand;
   import org.osflash.signals.Signal;
   
   public class ExpeditionViewData
   {
      
      private var _cmd:ExpeditionInfoCommand;
      
      public var availabled:Boolean;
      
      private var _rewardRange:Vector.<RankRewardsVo> = null;
      
      public var change:Signal;
      
      private var _boxReward:Vector.<BoxesVo> = new Vector.<BoxesVo>();
      
      public function ExpeditionViewData()
      {
         super();
         this.change = new Signal();
      }
      
      public function update(param1:ExpeditionInfoCommand) : void
      {
         this._cmd = param1;
         this.availabled = true;
         this.formatRewardRange();
      }
      
      public function get infoCommand() : ExpeditionInfoCommand
      {
         return this._cmd;
      }
      
      private function formatRewardRange() : void
      {
         var i:int;
         var temp:RankRewardCommand = null;
         var viewReward:RankRewardsVo = null;
         this._rewardRange = new Vector.<RankRewardsVo>();
         i = 0;
         while(i < this._cmd.rankRewards.length)
         {
            temp = this._cmd.rankRewards[i];
            viewReward = new RankRewardsVo(temp);
            this._rewardRange.push(viewReward);
            i++;
         }
         this._rewardRange = this.rewardRange.sort(function(param1:*, param2:*):*
         {
            return param1.index - param2.index;
         });
         this.change.dispatch();
      }
      
      public function get rewardRange() : Vector.<RankRewardsVo>
      {
         return this._rewardRange;
      }
      
      public function get overviewReward() : Vector.<OverViewVo>
      {
         var _loc2_:int = 0;
         var _loc3_:OverViewVo = null;
         var _loc1_:Vector.<OverViewVo> = new Vector.<OverViewVo>();
         _loc2_ = 0;
         while(_loc2_ < this._cmd.firstRewards.length)
         {
            _loc3_ = new OverViewVo();
            _loc3_.amount = this._cmd.firstRewards[_loc2_].amount;
            _loc3_.lootId = this._cmd.firstRewards[_loc2_].lootId;
            _loc3_.isFirst = true;
            _loc3_.isReceived = this._cmd.curLevel <= this._cmd.maxLevel;
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._cmd.normalRewards.length)
         {
            _loc3_ = new OverViewVo();
            _loc3_.amount = this._cmd.normalRewards[_loc2_].amount;
            _loc3_.lootId = this._cmd.normalRewards[_loc2_].lootId;
            _loc3_.isFirst = false;
            _loc3_.isReceived = false;
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getBoxesReward() : Vector.<BoxesVo>
      {
         return this._boxReward;
      }
      
      public function setBoxesReward(param1:String) : void
      {
         var _loc3_:XML = null;
         var _loc4_:BoxesVo = null;
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc2_:XML = new XML(param1);
         this._boxReward = new Vector.<BoxesVo>();
         for each(_loc3_ in _loc2_.rate)
         {
            _loc4_ = new BoxesVo();
            _loc4_.rateId = _loc3_.@rateId;
            this._boxReward.push(_loc4_);
            for each(_loc5_ in _loc3_.rewardLoot)
            {
               _loc6_ = _loc5_.@lootId;
               _loc4_.add(_loc6_);
            }
         }
      }
      
      public function getRankByUser() : ExpeditionRankUserInfoCommand
      {
         var _loc1_:int = 0;
         if(this._cmd)
         {
            _loc1_ = 0;
            while(_loc1_ < this._cmd.ranks.length)
            {
               if(this._cmd.ranks[_loc1_].userId == Hero.userID)
               {
                  return this._cmd.ranks[_loc1_];
               }
               _loc1_++;
            }
         }
         return null;
      }
   }
}

