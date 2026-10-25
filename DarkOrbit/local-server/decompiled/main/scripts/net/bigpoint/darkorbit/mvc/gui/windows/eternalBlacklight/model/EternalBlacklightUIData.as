package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model
{
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightBoosterCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightBoosterInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightCpuInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightRankModule;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightRankingEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightSkillPointInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalBlacklightWaveInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model.vo.EternalBlacklightBoosterVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model.vo.EternalBlacklightPlaceVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class EternalBlacklightUIData extends EventDispatcher
   {
      
      public const BOOSTER_POINTS_TEXTKEY:String = "eternal_blacklight_tab_boosters_booster_points";
      
      public const changed:ISignal = new Signal();
      
      public const boosterChanged:ISignal = new Signal();
      
      public const cpuCount:BindableInt = new BindableInt(0,0);
      
      public var currWave:BindableInt = new BindableInt(0,0);
      
      private var _furthestWave:int;
      
      public var boosterPoints:int;
      
      private var _activeBoosters:Vector.<EternalBlacklightBoosterVO> = new Vector.<EternalBlacklightBoosterVO>(0);
      
      private var _boosterOptions:Vector.<EternalBlacklightBoosterVO> = new Vector.<EternalBlacklightBoosterVO>(0);
      
      private var _rewardItems:Vector.<EternalBlacklightPlaceVO> = new Vector.<EternalBlacklightPlaceVO>(0);
      
      private var _topRankers:Vector.<EternalBlacklightRankModule> = new Vector.<EternalBlacklightRankModule>(0);
      
      private var _myRank:EternalBlacklightRankModule = new EternalBlacklightRankModule();
      
      private var _eventEnabled:Boolean = false;
      
      public function EternalBlacklightUIData()
      {
         super();
      }
      
      public function updateInfo(param1:EternalBlacklightInfoCommand) : void
      {
         this.updateWaveInternal(param1.waveInfo);
         this.updateCpus(param1.cpuInfoCommand);
         this.updateBoosters(param1.boosterInfoCommand);
      }
      
      public function updateBoosters(param1:EternalBlacklightBoosterInfoCommand) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < EternalBlacklightBoosterVO.boosterTypes.length)
         {
            this._activeBoosters[_loc2_] = new EternalBlacklightBoosterVO(EternalBlacklightBoosterVO.boosterTypes[_loc2_],0);
            _loc2_++;
         }
         var _loc3_:int = param1.skillPointInfo.skillPoint;
         var _loc4_:Vector.<EternalBlacklightBoosterCommand> = param1.currentBooster;
         if(_loc3_ > -1)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               this._activeBoosters[_loc4_[_loc2_].boosterType].percentage = _loc4_[_loc2_].value;
               _loc2_++;
            }
            this._boosterOptions[0] = new EternalBlacklightBoosterVO(EternalBlacklightBoosterVO.boosterTypes[param1.option1.boosterType],param1.option1.value);
            this._boosterOptions[1] = new EternalBlacklightBoosterVO(EternalBlacklightBoosterVO.boosterTypes[param1.option2.boosterType],param1.option2.value);
            this._boosterOptions[2] = new EternalBlacklightBoosterVO(EternalBlacklightBoosterVO.boosterTypes[param1.option3.boosterType],param1.option3.value);
         }
         this.updateSkillPoints(param1.skillPointInfo);
         this.boosterChanged.dispatch();
      }
      
      public function updateSkillPoints(param1:EternalBlacklightSkillPointInfoCommand) : void
      {
         this.boosterPoints = param1.skillPoint;
      }
      
      public function updateCpus(param1:EternalBlacklightCpuInfoCommand) : void
      {
         this.cpuCount.value = param1.cpuCount;
      }
      
      public function updateWave(param1:EternalBlacklightWaveInfoCommand) : void
      {
         this.updateWaveInternal(param1);
         this.changed.dispatch();
      }
      
      private function updateWaveInternal(param1:EternalBlacklightWaveInfoCommand) : void
      {
         this.currWave.value = param1.currentWave;
         this._furthestWave = param1.furthestWave;
      }
      
      public function get furthestWave() : int
      {
         return this._furthestWave;
      }
      
      public function get activeBoosters() : Vector.<EternalBlacklightBoosterVO>
      {
         return this._activeBoosters;
      }
      
      public function get boosterOptions() : Vector.<EternalBlacklightBoosterVO>
      {
         return this._boosterOptions;
      }
      
      public function get rewardItems() : Vector.<EternalBlacklightPlaceVO>
      {
         return this._rewardItems;
      }
      
      public function addPlayerPointRange(param1:int, param2:int) : void
      {
         var _loc3_:EternalBlacklightPlaceVO = new EternalBlacklightPlaceVO();
         _loc3_.min = param1;
         _loc3_.max = param2;
         _loc3_.playerRewards = new Vector.<RewardContentModule>();
         this._rewardItems.push(_loc3_);
      }
      
      public function updatePlayerReward(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:EternalBlacklightPlaceVO = null;
         var _loc4_:int = int(this._rewardItems.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._rewardItems[_loc6_];
            if(_loc5_.min == param1 || _loc5_.max == param2)
            {
               _loc5_.playerRewards = param3;
            }
            _loc6_++;
         }
      }
      
      public function updateRanking(param1:EternalBlacklightRankInfoCommand) : void
      {
         this.updateRanks(param1);
         this.changed.dispatch();
      }
      
      public function updateRankingInfo(param1:EternalBlacklightRankingEventInfoCommand) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         this._rewardItems.length = 0;
         var _loc3_:int = int(param1.playerRankRanges.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.playerRankRanges[_loc4_];
            this.addPlayerPointRange(_loc2_.from,_loc2_.to);
            _loc4_++;
         }
         this.updateRanks(param1.rankInfoCommand);
         this._eventEnabled = param1.isEventEnabled;
         this._rewardItems.sort(EternalBlacklightPlaceVO.sort);
         this.changed.dispatch();
      }
      
      private function updateRanks(param1:EternalBlacklightRankInfoCommand) : void
      {
         this._topRankers = param1.topRankers;
         this._myRank = param1.myRank;
      }
      
      public function get topRankers() : Vector.<EternalBlacklightRankModule>
      {
         return this._topRankers;
      }
      
      public function get ownRank() : EternalBlacklightRankModule
      {
         return this._myRank;
      }
      
      public function get eventEnabled() : Boolean
      {
         return this._eventEnabled;
      }
   }
}

