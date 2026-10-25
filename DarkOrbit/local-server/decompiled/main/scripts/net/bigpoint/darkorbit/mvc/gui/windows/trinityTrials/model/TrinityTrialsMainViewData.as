package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model
{
   import net.bigpoint.darkorbit.com.module.porting.TupleTwoModule;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsDropLevelCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsGateWindowCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsPassCommand;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsRewardDescriptionCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TrinityTrialsMainViewData
   {
      
      public var dataChange:ISignal = new Signal();
      
      private var _dropLevel:int = 49;
      
      private var _rewardData:TrinityTrialsPassCommand;
      
      private var _upLevelData:TrinityTrialsDropLevelCommand;
      
      private var _dropInfoData:TrinityTrialsRewardDescriptionCommand;
      
      private var _gateData:TrinityTrialsGateWindowCommand;
      
      public function TrinityTrialsMainViewData()
      {
         super();
      }
      
      public function updateReward(param1:TrinityTrialsPassCommand) : void
      {
         this._rewardData = param1;
         this.dataChange.dispatch(TrinityTrialsConst.TAB_1);
      }
      
      public function getPassItems() : Vector.<PassItemVo>
      {
         var _loc3_:PassItemVo = null;
         var _loc1_:Vector.<PassItemVo> = new Vector.<PassItemVo>();
         var _loc2_:int = 0;
         while(_loc2_ < this._rewardData.normalItemList.length)
         {
            _loc3_ = new PassItemVo();
            _loc3_.normalItem = this._rewardData.normalItemList[_loc2_];
            _loc3_.vipItem = this._rewardData.vipItemList[_loc2_];
            _loc3_.index = _loc2_ + 1;
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function updateLevel(param1:TrinityTrialsDropLevelCommand) : void
      {
         this._upLevelData = param1;
         this.dataChange.dispatch(TrinityTrialsConst.TAB_2);
      }
      
      public function getUpLevelItems(param1:String) : Vector.<DropLevelVo>
      {
         var _loc5_:DropLevelVo = null;
         var _loc2_:Vector.<DropLevelVo> = new Vector.<DropLevelVo>();
         var _loc3_:Vector.<TupleTwoModule> = this._upLevelData[param1] as Vector.<TupleTwoModule>;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = new DropLevelVo();
            _loc5_.level = _loc4_ + 1;
            _loc5_.desc = _loc3_[_loc4_].param0;
            _loc5_.value = _loc3_[_loc4_].param1;
            _loc2_.push(_loc5_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function updateDropInfoData(param1:TrinityTrialsRewardDescriptionCommand) : void
      {
         this._dropInfoData = param1;
         this.dataChange.dispatch(TrinityTrialsConst.TAB_3);
      }
      
      public function get dropLevel() : int
      {
         return this._dropLevel;
      }
      
      public function updateGateData(param1:TrinityTrialsGateWindowCommand) : void
      {
         this._gateData = param1;
         this.dataChange.dispatch(TrinityTrialsConst.DIFFICULTY_SELECT);
      }
      
      public function get rewardData() : TrinityTrialsPassCommand
      {
         return this._rewardData;
      }
      
      public function get upLevelData() : TrinityTrialsDropLevelCommand
      {
         return this._upLevelData;
      }
      
      public function get dropInfoData() : TrinityTrialsRewardDescriptionCommand
      {
         return this._dropInfoData;
      }
      
      public function get gateCommand() : TrinityTrialsGateWindowCommand
      {
         return this._gateData;
      }
   }
}

