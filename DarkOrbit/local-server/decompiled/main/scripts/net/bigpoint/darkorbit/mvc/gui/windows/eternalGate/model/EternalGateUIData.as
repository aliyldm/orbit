package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model
{
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.EternalGateBoosterCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateBoosterInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateKeyInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateRankModule;
   import net.bigpoint.darkorbit.com.module.EternalGateSkillPointInfoCommand;
   import net.bigpoint.darkorbit.com.module.EternalGateWaveInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model.vo.EternalGateBoosterVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model.vo.EternalGatePlaceVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class EternalGateUIData extends EventDispatcher
   {
      
      public const BOOSTER_POINTS_TEXTKEY:String = "eternal_gate_tab_boosters_booster_points";
      
      public const changed:ISignal = new Signal();
      
      public const keyCount:BindableInt = new BindableInt(0,0);
      
      private var _currWave:int;
      
      private var _furthestWave:int;
      
      public const boosterPoints:BindableInt = new BindableInt(0,0);
      
      private var _activeBoosters:Vector.<EternalGateBoosterVO> = new Vector.<EternalGateBoosterVO>(0);
      
      private var _boosterOptions:Vector.<EternalGateBoosterVO> = new Vector.<EternalGateBoosterVO>(0);
      
      private var _rewardItems:Vector.<EternalGatePlaceVO> = new Vector.<EternalGatePlaceVO>(0);
      
      private var _topRankers:Vector.<EternalGateRankModule> = new Vector.<EternalGateRankModule>(0);
      
      private var _myRank:EternalGateRankModule = new EternalGateRankModule();
      
      public function EternalGateUIData()
      {
         super();
      }
      
      public function updateInfo(param1:EternalGateInfoCommand) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         this.updateWaveInternal(param1.waveInfo);
         this.updateKeys(param1.keyInfo);
         this.updateBoosters(param1.boosterInfoCommand);
         this._rewardItems.length = 0;
         var _loc3_:int = int(param1.playerRankRanges.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.playerRankRanges[_loc4_];
            this.addPlayerPointRange(_loc2_.from,_loc2_.to);
            _loc4_++;
         }
         this._rewardItems.sort(EternalGatePlaceVO.sort);
         this.updateRanks(param1.rankInfoCommand);
         this.changed.dispatch();
      }
      
      public function updateBoosters(param1:EternalGateBoosterInfoCommand) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < EternalGateBoosterVO.boosterTypes.length)
         {
            this._activeBoosters[_loc2_] = new EternalGateBoosterVO(EternalGateBoosterVO.boosterTypes[_loc2_],0);
            _loc2_++;
         }
         var _loc3_:int = param1.skillPointInfo.skillPoint;
         var _loc4_:Vector.<EternalGateBoosterCommand> = param1.currentBooster;
         if(_loc3_ > -1)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               this._activeBoosters[_loc4_[_loc2_].boosterType].percentage = _loc4_[_loc2_].value;
               _loc2_++;
            }
            this._boosterOptions[0] = new EternalGateBoosterVO(EternalGateBoosterVO.boosterTypes[param1.option1.boosterType],param1.option1.value);
            this._boosterOptions[1] = new EternalGateBoosterVO(EternalGateBoosterVO.boosterTypes[param1.option2.boosterType],param1.option2.value);
            this._boosterOptions[2] = new EternalGateBoosterVO(EternalGateBoosterVO.boosterTypes[param1.option3.boosterType],param1.option3.value);
         }
         this.updateSkillPoints(param1.skillPointInfo);
      }
      
      public function updateSkillPoints(param1:EternalGateSkillPointInfoCommand) : void
      {
         this.boosterPoints.value = param1.skillPoint;
      }
      
      public function updateKeys(param1:EternalGateKeyInfoCommand) : void
      {
         this.keyCount.value = param1.keyCount;
      }
      
      public function updateWave(param1:EternalGateWaveInfoCommand) : void
      {
         this.updateWaveInternal(param1);
         this.changed.dispatch();
      }
      
      private function updateWaveInternal(param1:EternalGateWaveInfoCommand) : void
      {
         this._currWave = param1.currentWave;
         this._furthestWave = param1.furthestWave;
      }
      
      public function get currWave() : int
      {
         return this._currWave;
      }
      
      public function get furthestWave() : int
      {
         return this._furthestWave;
      }
      
      public function get activeBoosters() : Vector.<EternalGateBoosterVO>
      {
         return this._activeBoosters;
      }
      
      public function get boosterOptions() : Vector.<EternalGateBoosterVO>
      {
         return this._boosterOptions;
      }
      
      public function get rewardItems() : Vector.<EternalGatePlaceVO>
      {
         return this._rewardItems;
      }
      
      public function addPlayerPointRange(param1:int, param2:int) : void
      {
         var _loc3_:EternalGatePlaceVO = new EternalGatePlaceVO();
         _loc3_.min = param1;
         _loc3_.max = param2;
         _loc3_.playerRewards = new Vector.<RewardContentModule>();
         this._rewardItems.push(_loc3_);
      }
      
      public function updatePlayerReward(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:EternalGatePlaceVO = null;
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
      
      public function updateRanking(param1:EternalGateRankInfoCommand) : void
      {
         this.updateRanks(param1);
         this.changed.dispatch();
      }
      
      private function updateRanks(param1:EternalGateRankInfoCommand) : void
      {
         this._topRankers = param1.topRankers;
         this._myRank = param1.myRank;
      }
      
      public function get topRankers() : Vector.<EternalGateRankModule>
      {
         return this._topRankers;
      }
      
      public function get ownRank() : EternalGateRankModule
      {
         return this._myRank;
      }
   }
}

