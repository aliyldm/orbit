package net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.PayloadEscortInfoCommand;
   import net.bigpoint.darkorbit.com.module.PayloadEscortKeyInfoCommand;
   import net.bigpoint.darkorbit.com.module.PayloadEscortScoreCommand;
   import net.bigpoint.darkorbit.com.module.PayloadEscortTimeInfoCommand;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model.vo.PayloadEscortPlaceVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PayloadEscortUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      private var _topDescription:String;
      
      public const escortKeys:BindableInt = new BindableInt();
      
      private var _totalScore:Number = 0;
      
      private var _runScore:Number = 0;
      
      private var _rewardItems:Vector.<PayloadEscortPlaceVO> = new Vector.<PayloadEscortPlaceVO>(0);
      
      public var isInEventMap:BindableBoolean = new BindableBoolean();
      
      private var _topDescriptionInEventMap:String = BPLocale.getItem("mimesis_mutiny_status_escorting");
      
      public function PayloadEscortUIData()
      {
         super();
      }
      
      public function updateInfo(param1:PayloadEscortInfoCommand) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         this._totalScore = param1.totalScore;
         this.isInEventMap.value = param1.isInSession;
         this._rewardItems.length = 0;
         var _loc3_:int = int(param1.playerRankRanges.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.playerRankRanges[_loc4_];
            this.addPlayerPointRange(_loc2_.from,_loc2_.to);
            _loc4_++;
         }
         this._rewardItems.sort(PayloadEscortPlaceVO.sort);
         this.updateTimer(param1.timeInfoCommand);
         this.updateKeys(param1.keyInfoCommand);
      }
      
      public function updateTimer(param1:PayloadEscortTimeInfoCommand) : void
      {
         if(param1.timeToGateClose > 0)
         {
            this._topDescription = BPLocale.getItem("mimesis_mutiny_status_open");
            this.timer.value = param1.timeToGateClose;
         }
         else if(param1.timeToNextSpawn > 0)
         {
            this._topDescription = BPLocale.getItem("mimesis_mutiny_status_closed");
            this.timer.value = param1.timeToNextSpawn;
         }
         else
         {
            this._topDescription = BPLocale.getItem("mimesis_mutiny_status_ended");
            this.timer.value = 0;
         }
         this.changed.dispatch();
      }
      
      public function updateKeys(param1:PayloadEscortKeyInfoCommand) : void
      {
         this.escortKeys.value = param1.keyCount;
         this.changed.dispatch();
      }
      
      public function updateRunScore(param1:PayloadEscortScoreCommand) : void
      {
         this._runScore = param1.runScore < 0 ? 0 : param1.runScore;
         this._totalScore = param1.totalScore;
         this.isInEventMap.value = true;
         this.changed.dispatch();
      }
      
      public function get rewardItems() : Vector.<PayloadEscortPlaceVO>
      {
         return this._rewardItems;
      }
      
      public function addPlayerPointRange(param1:int, param2:int) : void
      {
         var _loc3_:PayloadEscortPlaceVO = new PayloadEscortPlaceVO();
         _loc3_.permanentPointsMin = param1;
         _loc3_.permanentPointsMax = param2;
         _loc3_.permanentPointsRewards = new Vector.<RewardContentModule>();
         this._rewardItems.push(_loc3_);
      }
      
      public function updatePlayerReward(param1:int, param2:int, param3:Vector.<RewardContentModule>) : void
      {
         var _loc5_:PayloadEscortPlaceVO = null;
         var _loc4_:int = int(this._rewardItems.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = this._rewardItems[_loc6_];
            if(_loc5_.permanentPointsMin == param1 || _loc5_.permanentPointsMax == param2)
            {
               _loc5_.permanentPointsRewards = param3;
            }
            _loc6_++;
         }
      }
      
      public function get topDescription() : String
      {
         return this._topDescription;
      }
      
      public function get inEventMap() : Boolean
      {
         return this.isInEventMap.value;
      }
      
      public function get topDescriptionInEventMap() : String
      {
         return this._topDescriptionInEventMap;
      }
      
      public function get runScore() : Number
      {
         return this._runScore;
      }
      
      public function get totalScore() : Number
      {
         return this._totalScore;
      }
   }
}

