package net.bigpoint.darkorbit.mvc.gui.windows.plutus.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableCounter;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.PlutusInfoCommand;
   import net.bigpoint.darkorbit.com.module.PlutusPointsUpdateCommand;
   import net.bigpoint.darkorbit.com.module.PlutusScoreEntryModule;
   import net.bigpoint.darkorbit.com.module.PlutusStatusCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.vo.PlutusOverviewVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.vo.PlutusRecordVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PlutusUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const timerDown:BindableCountDown = new BindableCountDown();
      
      public const timerUp:BindableCounter = new BindableCounter(Number.NaN);
      
      private var _overviewData:PlutusOverviewVO = new PlutusOverviewVO();
      
      private var _rewardItems:Vector.<PlutusPlaceVO> = new Vector.<PlutusPlaceVO>(0);
      
      private var _recordItems:Vector.<PlutusRecordVO> = new Vector.<PlutusRecordVO>(0);
      
      public function PlutusUIData()
      {
         super();
      }
      
      public function isValid() : Boolean
      {
         var _loc1_:Boolean = false;
         if(Boolean(this._overviewData) && Boolean(this._rewardItems) && Boolean(this._recordItems))
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function get overviewData() : PlutusOverviewVO
      {
         return this._overviewData;
      }
      
      public function get rewardItems() : Vector.<PlutusPlaceVO>
      {
         return this._rewardItems;
      }
      
      public function get recordItems() : Vector.<PlutusRecordVO>
      {
         return this._recordItems;
      }
      
      public function addPlayerPointRange(param1:int, param2:int) : void
      {
         var _loc3_:PlutusPlaceVO = new PlutusPlaceVO();
         _loc3_.min = param1;
         _loc3_.max = param2;
         _loc3_.playerRewards = new Vector.<RewardContentModule>();
         this._rewardItems.push(_loc3_);
      }
      
      public function addPlayerRecord(param1:int, param2:int) : void
      {
         var _loc3_:PlutusRecordVO = new PlutusRecordVO();
         _loc3_.score = param1;
         _loc3_.timeInSeconds = param2;
         this._recordItems.push(_loc3_);
      }
      
      public function updatePlayerReward(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:PlutusPlaceVO = null;
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
      
      public function updateInfo(param1:PlutusInfoCommand) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:RankRewardRangeModule = null;
         var _loc6_:PlutusScoreEntryModule = null;
         this.updateStatus(param1.status);
         this.overviewData.playerPoints = param1.playerPoints;
         this._recordItems.length = 0;
         var _loc2_:Vector.<PlutusScoreEntryModule> = param1.scoreEntriesList;
         _loc3_ = int(param1.scoreEntriesList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = _loc2_[_loc4_];
            this.addPlayerRecord(_loc6_.score,_loc6_.timeInSeconds);
            _loc4_++;
         }
         this._recordItems.sort(PlutusRecordVO.sort);
         this._rewardItems.length = 0;
         _loc3_ = int(param1.playerRanges.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.playerRanges[_loc4_];
            this.addPlayerPointRange(_loc5_.from,_loc5_.to);
            _loc4_++;
         }
         this._rewardItems.sort(PlutusPlaceVO.sort);
         this.changed.dispatch();
      }
      
      public function updateStatus(param1:PlutusStatusCommand) : void
      {
         switch(param1.mode)
         {
            case PlutusStatusCommand.MODE_DONE:
            case PlutusStatusCommand.MODE_FAIL:
               this.overviewData.description = "plutus_tab_overview_status_completed";
               this.timerUp.stop();
               this.timerDown.value = param1.timeLeft / 1000;
               break;
            case PlutusStatusCommand.MODE_RUNNING:
               this.overviewData.description = "plutus_tab_overview_status_available";
               this.timerUp.stop();
               this.timerDown.value = param1.timeLeft / 1000;
               break;
            case PlutusStatusCommand.MODE_INSIDE:
               this.overviewData.description = "plutus_tab_overview_status_spent";
               this.timerDown.stop();
               this.timerUp.value = param1.timeLeft / 1000;
               break;
            case PlutusStatusCommand.MODE_LASTDAY_FINISHED:
               this.overviewData.description = "plutus_tab_overview_status_end";
               this.timerUp.stop();
               this.timerDown.value = param1.timeLeft / 1000;
         }
         this.overviewData.playerLives = param1.lifes;
      }
      
      public function updatePoints(param1:PlutusPointsUpdateCommand) : void
      {
         var _loc4_:* = undefined;
         this._overviewData.playerPoints = param1.score;
         this._recordItems.splice(0,this._recordItems.length);
         var _loc2_:int = int(param1.scoreEntriesList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.scoreEntriesList[_loc3_];
            this.addPlayerRecord(_loc4_.score,_loc4_.timeInSeconds);
            _loc3_++;
         }
         this._recordItems.sort(PlutusRecordVO.sort);
         this.changed.dispatch();
      }
   }
}

