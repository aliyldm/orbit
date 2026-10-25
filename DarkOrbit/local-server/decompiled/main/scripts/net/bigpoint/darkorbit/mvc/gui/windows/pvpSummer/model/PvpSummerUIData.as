package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model
{
   import flash.events.EventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.PVPSummerEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.PVPSummerEventSelfReputationUpdateCommand;
   import net.bigpoint.darkorbit.com.module.PVPSummerEventShuffleInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo.PvPSummerMilestoneRewardsToolTipVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo.PvpSummerOverviewVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo.PvpSummerPlaceVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PvpSummerUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      private var _overviewData:PvpSummerOverviewVO = new PvpSummerOverviewVO();
      
      private var _rewardItems:Vector.<PvpSummerPlaceVO> = new Vector.<PvpSummerPlaceVO>(0);
      
      protected var _timeout:uint;
      
      public function PvpSummerUIData()
      {
         super();
      }
      
      public function isValid() : Boolean
      {
         var _loc1_:Boolean = false;
         if(Boolean(this._overviewData) && Boolean(this._rewardItems))
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function get overviewData() : PvpSummerOverviewVO
      {
         return this._overviewData;
      }
      
      public function get rewardItems() : Vector.<PvpSummerPlaceVO>
      {
         return this._rewardItems;
      }
      
      public function addRepPointRange(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PvpSummerPlaceVO = null;
         this.invalidate();
         if(param3 < this._rewardItems.length)
         {
            _loc4_ = this._rewardItems[param3];
            _loc4_.repMin = param1;
            _loc4_.repMax = param2;
            _loc4_.repRewards = new Vector.<RewardContentModule>();
         }
         else
         {
            _loc4_ = new PvpSummerPlaceVO();
            _loc4_.repMin = param1;
            _loc4_.repMax = param2;
            _loc4_.repRewards = new Vector.<RewardContentModule>();
            this._rewardItems.push(_loc4_);
         }
      }
      
      public function addRepPerKillPointRange(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PvpSummerPlaceVO = null;
         this.invalidate();
         if(param3 < this._rewardItems.length)
         {
            _loc4_ = this._rewardItems[param3];
            _loc4_.repPerKillMin = param1;
            _loc4_.repPerKillMax = param2;
            _loc4_.repPerKillRewards = new Vector.<RewardContentModule>();
         }
         else
         {
            _loc4_ = new PvpSummerPlaceVO();
            _loc4_.repPerKillMin = param1;
            _loc4_.repPerKillMax = param2;
            _loc4_.repPerKillRewards = new Vector.<RewardContentModule>();
            this._rewardItems.push(_loc4_);
         }
      }
      
      public function updateRepRewards(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:PvpSummerPlaceVO = null;
         var _loc4_:int = int(this._rewardItems.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._rewardItems[_loc6_];
            if(_loc5_.repMin == param1 || _loc5_.repMax == param2)
            {
               _loc5_.repRewards = param3;
            }
            _loc6_++;
         }
      }
      
      public function updateRepPerKillRewards(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:PvpSummerPlaceVO = null;
         var _loc4_:int = int(this._rewardItems.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._rewardItems[_loc6_];
            if(_loc5_.repPerKillMin == param1 || _loc5_.repPerKillMax == param2)
            {
               _loc5_.repPerKillRewards = param3;
            }
            _loc6_++;
         }
      }
      
      public function updateNextMilestoneRewards(param1:Vector.<RewardContentModule>) : void
      {
         this._overviewData.nextRepMilestoneRewards = new PvPSummerMilestoneRewardsToolTipVO(param1,this.overviewData.nextRepMilestone);
      }
      
      public function updateInfo(param1:PVPSummerEventInfoCommand) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.overviewData.countdown.value = param1.shuffleInfoCommand.timeToNextShuffle;
         this.overviewData.rep = param1.reputationUpdateCommand.reputation;
         this.overviewData.repPerKill = param1.reputationUpdateCommand.repPerKill;
         this.overviewData.nextRepMilestone = param1.reputationUpdateCommand.nextMilestone;
         _loc4_ = int(param1.reputationRanges.length);
         param1.reputationRanges.sort(this.rangeSorting);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.reputationRanges[_loc3_];
            this.addRepPointRange(_loc2_.from,_loc2_.to,_loc3_);
            _loc3_++;
         }
         _loc4_ = int(param1.perKillRanges.length);
         param1.perKillRanges.sort(this.rangeSorting);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.perKillRanges[_loc3_];
            this.addRepPerKillPointRange(_loc2_.from,_loc2_.to,_loc3_);
            _loc3_++;
         }
         this._rewardItems.sort(PvpSummerPlaceVO.sort);
         this.changed.dispatch();
      }
      
      public function updateSelfReputation(param1:PVPSummerEventSelfReputationUpdateCommand) : void
      {
         this.overviewData.rep = param1.reputation;
         this.overviewData.repPerKill = param1.repPerKill;
         this.overviewData.nextRepMilestone = param1.nextMilestone;
         this.changed.dispatch();
      }
      
      public function updateShuffleInfo(param1:PVPSummerEventShuffleInfoCommand) : void
      {
         this.overviewData.countdown.value = param1.timeToNextShuffle;
      }
      
      private function invalidate() : void
      {
         clearTimeout(this._timeout);
         this._timeout = setTimeout(this.changed.dispatch,1);
      }
      
      private function rangeSorting(param1:RankRewardRangeModule, param2:RankRewardRangeModule) : int
      {
         return param1.from - param2.from;
      }
   }
}

