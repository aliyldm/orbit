package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model
{
   import net.bigpoint.darkorbit.com.module.porting.events.LootProbabilityModule;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersGateStarRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersGateWindowCommand;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersPassCommand;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.PassItemVo;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SingularityDrivePassViewData
   {
      
      public var dataChange:ISignal = new Signal();
      
      private var _rewardData:VoyagersPassCommand;
      
      private var _gateData:VoyagersGateWindowCommand;
      
      private var _curLevel:int = 1;
      
      public function SingularityDrivePassViewData()
      {
         super();
      }
      
      public function updateReward(param1:VoyagersPassCommand) : void
      {
         this._rewardData = param1;
         this.dataChange.dispatch(GuiConstants.SINGULARITYDRIVE_PASS);
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
      
      public function updateGateData(param1:VoyagersGateWindowCommand) : void
      {
         this._gateData = param1;
         this.dataChange.dispatch(GuiConstants.SINGULARITYDRIVE_DIFFICULTY_SELECT);
      }
      
      public function get gateCommand() : VoyagersGateWindowCommand
      {
         return this._gateData;
      }
      
      public function get gateIsFree() : Boolean
      {
         return this._gateData.maxFreeNum - this._gateData.freeChallengedNum > 0;
      }
      
      public function get rewardData() : VoyagersPassCommand
      {
         return this._rewardData;
      }
      
      public function getGateRewardTipDataByIndex(param1:int) : String
      {
         var _loc3_:Vector.<LootProbabilityModule> = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:LootProbabilityModule = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(this._gateData.starRewardLoots.length == 0)
         {
            return "null" + ":" + 0;
         }
         var _loc2_:VoyagersGateStarRewardCommand = this.getGateCurLevelDrop();
         if(_loc2_)
         {
            _loc3_ = _loc2_["star" + (param1 + 1) + "Loots"];
            if(_loc3_)
            {
               _loc4_ = "";
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc6_ = _loc3_[_loc5_];
                  _loc7_ = _loc6_.lootId;
                  _loc8_ = ItemDataProviderHelper.getItem(_loc7_).fullname;
                  if(_loc6_.minLootAmount == _loc6_.maxLootAmount)
                  {
                     _loc4_ += _loc8_ + " x" + _loc6_.maxLootAmount + " " + _loc6_.probabilityPercentage + "%";
                  }
                  else
                  {
                     _loc4_ += _loc8_ + " x" + _loc6_.minLootAmount + "-" + _loc6_.maxLootAmount + " " + _loc6_.probabilityPercentage + "%";
                  }
                  if(_loc5_ < _loc3_.length)
                  {
                     _loc4_ += "\n";
                  }
                  _loc5_++;
               }
               return _loc4_;
            }
         }
         return param1 + "_null" + ":" + 0;
      }
      
      private function getGateCurLevelDrop() : VoyagersGateStarRewardCommand
      {
         var _loc2_:VoyagersGateStarRewardCommand = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._gateData.starRewardLoots.length)
         {
            _loc2_ = this._gateData.starRewardLoots[_loc1_];
            if(_loc2_.instanceLevel == this._curLevel)
            {
               return _loc2_;
            }
            _loc1_++;
         }
         return null;
      }
      
      public function get curLevel() : int
      {
         return this._curLevel;
      }
      
      public function set curLevel(param1:int) : void
      {
         this._curLevel = param1;
      }
   }
}

