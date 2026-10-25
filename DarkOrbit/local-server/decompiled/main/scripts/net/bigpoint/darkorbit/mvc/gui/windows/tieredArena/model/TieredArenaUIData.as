package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model
{
   import flash.events.EventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.com.module.TieredArenaEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.TieredArenaEventScheduleInfoCommand;
   import net.bigpoint.darkorbit.com.module.TieredArenaEventSelfReputationUpdateCommand;
   import net.bigpoint.darkorbit.com.module.TieredArenaEventTierUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.vo.TieredArenaOverviewVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.vo.TieredArenaParticipationRewardsToolTipVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.vo.TieredArenaPlaceVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TieredArenaUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      private var _titleLocaKey:String = "title_tieredArena";
      
      private var _overviewData:TieredArenaOverviewVO = new TieredArenaOverviewVO();
      
      private var _rewardItems:Vector.<TieredArenaPlaceVO> = new Vector.<TieredArenaPlaceVO>(0);
      
      protected var _timeout:uint;
      
      public function TieredArenaUIData()
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
      
      public function get titleLocaKey() : String
      {
         return this._titleLocaKey;
      }
      
      public function get overviewData() : TieredArenaOverviewVO
      {
         return this._overviewData;
      }
      
      public function get rewardItems() : Vector.<TieredArenaPlaceVO>
      {
         return this._rewardItems;
      }
      
      public function addRepPointRange(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:TieredArenaPlaceVO = null;
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
            _loc4_ = new TieredArenaPlaceVO();
            _loc4_.repMin = param1;
            _loc4_.repMax = param2;
            _loc4_.repRewards = new Vector.<RewardContentModule>();
            this._rewardItems.push(_loc4_);
         }
      }
      
      public function updateRepRewards(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:TieredArenaPlaceVO = null;
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
      
      public function updateParticipationRewards(param1:Vector.<RewardContentModule>) : void
      {
         this._overviewData.participationRewards = new TieredArenaParticipationRewardsToolTipVO(param1,this.overviewData.reputationRequired);
      }
      
      public function updateInfo(param1:TieredArenaEventInfoCommand) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.overviewData.rep = param1.reputationUpdateCommand.reputation;
         this.overviewData.reputationRequired = param1.reputationUpdateCommand.participationReputation;
         this._updateUserTier(param1.tieredUpdateCommand);
         _loc4_ = int(param1.reputationRanges.length);
         param1.reputationRanges.sort(this.rangeSorting);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.reputationRanges[_loc3_];
            this.addRepPointRange(_loc2_.from,_loc2_.to,_loc3_);
            _loc3_++;
         }
         this.overviewData.isArenaOpen = param1.timeToArenaClose == 0;
         if(this.overviewData.isArenaOpen)
         {
            this.overviewData.arenaTimeLeft = param1.timeToNextArenaOpen;
         }
         else
         {
            this.overviewData.arenaTimeLeft = param1.timeToArenaClose;
         }
         this.overviewData.eventTimeEnd = param1.timeToEventEnd;
         this._rewardItems.sort(TieredArenaPlaceVO.sort);
         this.changed.dispatch();
      }
      
      public function updateSchedule(param1:TieredArenaEventScheduleInfoCommand) : void
      {
         this.overviewData.isArenaOpen = param1.timeToArenaClose == 0;
         if(this.overviewData.isArenaOpen)
         {
            this.overviewData.arenaTimeLeft = param1.timeToNextArenaOpen;
         }
         else
         {
            this.overviewData.arenaTimeLeft = param1.timeToArenaClose;
         }
         this.changed.dispatch();
      }
      
      public function updateSelfReputation(param1:TieredArenaEventSelfReputationUpdateCommand) : void
      {
         this.overviewData.rep = param1.reputation;
         this.overviewData.reputationRequired = param1.participationReputation;
         this.changed.dispatch();
      }
      
      public function updateUserTier(param1:TieredArenaEventTierUpdateCommand) : void
      {
         this._updateUserTier(param1);
         this.changed.dispatch();
      }
      
      public function _updateUserTier(param1:TieredArenaEventTierUpdateCommand) : void
      {
         switch(param1.playerTier)
         {
            case TieredArenaEventTierUpdateCommand.PLAYERTIER_HIGH:
               this._titleLocaKey = "title_tieredArena_high";
               break;
            case TieredArenaEventTierUpdateCommand.PLAYERTIER_LOW:
               this._titleLocaKey = "title_tieredArena_low";
               break;
            case TieredArenaEventTierUpdateCommand.PLAYERTIER_UNKNOWN:
            default:
               this._titleLocaKey = "title_tieredArena";
         }
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

