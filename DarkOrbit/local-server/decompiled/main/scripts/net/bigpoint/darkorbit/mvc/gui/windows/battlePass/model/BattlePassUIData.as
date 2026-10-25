package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model
{
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.BattlePassInfoCommand;
   import net.bigpoint.darkorbit.com.module.BattlePassKeyExchangeInfoCommand;
   import net.bigpoint.darkorbit.com.module.BattlePassKeyExchangeUpdateCommand;
   import net.bigpoint.darkorbit.com.module.QuestAcceptabilityStatusModule;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo.BattlePassExchangeVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo.BattlePassObjectiveVO;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestParser;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BattlePassUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      private var _objectiveItems:Vector.<BattlePassObjectiveVO> = new Vector.<BattlePassObjectiveVO>(0);
      
      private var _objectives:Vector.<Quest> = new Vector.<Quest>(0);
      
      private var _battlePassStatus:Boolean;
      
      private var _videoLootID:String;
      
      private var _hasRewardsToCollect:Boolean;
      
      private var _numCompletedObjectives:int;
      
      private var _numTotalObjectives:int;
      
      private var _titleKeyBeforePurchase:String;
      
      private var _descriptionKeyBeforePurchase:String;
      
      private var _descriptionKeyCollect:String;
      
      private var _titleKeyAfterPurchase:String;
      
      private var _descriptionKeyAfterPurchase:String;
      
      public const exchangeCreated:ISignal = new Signal();
      
      public const exchangeUpdated:ISignal = new Signal();
      
      public const filterChanged:ISignal = new Signal();
      
      private var _itemFilter:Vector.<String> = new Vector.<String>();
      
      private var _exchangeItems:Vector.<BattlePassExchangeVO> = new Vector.<BattlePassExchangeVO>(0);
      
      private var _exchangekey:BindableInt = new BindableInt(0);
      
      protected var _timeout:uint;
      
      public function BattlePassUIData()
      {
         super();
      }
      
      public function get objectiveItems() : Vector.<BattlePassObjectiveVO>
      {
         return this._objectiveItems;
      }
      
      public function get exchangeItems() : Vector.<BattlePassExchangeVO>
      {
         return this._exchangeItems;
      }
      
      private function invalidate() : void
      {
         clearTimeout(this._timeout);
         this._timeout = setTimeout(this.changed.dispatch,1);
      }
      
      public function updateInfo(param1:BattlePassInfoCommand) : void
      {
         var _loc2_:QuestDefinitionModule = null;
         var _loc3_:QuestAcceptabilityStatusModule = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this._battlePassStatus = param1.statusCommand.purchased;
         this._numCompletedObjectives = 0;
         this._numTotalObjectives = 0;
         _loc5_ = int(param1.battlePassQuestModuleList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = param1.battlePassQuestModuleList[_loc4_].questDefinition;
            _loc3_ = param1.battlePassQuestModuleList[_loc4_].acceptabilityStatus;
            this.addObjectiveCondition(_loc2_,_loc3_);
            ++this._numTotalObjectives;
            if(_loc3_.type == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED)
            {
               ++this._numCompletedObjectives;
            }
            _loc4_++;
         }
         this._objectiveItems.sort(BattlePassObjectiveVO.sort);
      }
      
      public function addObjectiveCondition(param1:QuestDefinitionModule, param2:QuestAcceptabilityStatusModule) : void
      {
         var _loc4_:BattlePassObjectiveVO = null;
         var _loc6_:QuestParser = null;
         var _loc7_:Quest = null;
         this.invalidate();
         var _loc3_:int = int(this._objectiveItems.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._objectiveItems[_loc5_];
            if(_loc4_.questId == param1.id)
            {
               _loc4_.objectiveModule = param1;
               _loc4_.statusModule = param2;
               _loc4_.hasBattlePass = this._battlePassStatus;
               _loc6_ = QuestParser.instance;
               _loc7_ = _loc6_.parseDefinition(param1);
               _loc4_.quest = _loc7_;
               this._objectives.push(_loc7_);
               return;
            }
            _loc5_++;
         }
      }
      
      public function updateObjectiveCondition(param1:int, param2:Number, param3:Boolean, param4:Boolean) : Boolean
      {
         var _loc6_:BattlePassObjectiveVO = null;
         var _loc5_:int = this.getQuestIDByConditionID(param1);
         if(_loc5_ > -1)
         {
            _loc6_ = this.getVOByQuestID(_loc5_);
            if(_loc6_)
            {
               _loc6_.quest.updateCondition(param1,param2,param4,param3);
               _loc6_.questChanged.dispatch();
               return true;
            }
         }
         return false;
      }
      
      public function completeObjective(param1:int) : void
      {
         var _loc2_:BattlePassObjectiveVO = this.getVOByQuestID(param1);
         if(_loc2_)
         {
            _loc2_.statusModule.type = QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED;
            _loc2_.questChanged.dispatch();
            ++this._numCompletedObjectives;
            this._objectiveItems.sort(BattlePassObjectiveVO.sort);
         }
      }
      
      private function getQuestIDByConditionID(param1:int) : int
      {
         var _loc3_:Quest = null;
         var _loc2_:int = -1;
         for each(_loc3_ in this._objectives)
         {
            if(_loc3_.flatConditions[param1] != null)
            {
               _loc2_ = int(_loc3_.id);
            }
         }
         return _loc2_;
      }
      
      private function getVOByQuestID(param1:int) : BattlePassObjectiveVO
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._objectiveItems.length)
         {
            if(param1 == this._objectiveItems[_loc2_].questId)
            {
               return this._objectiveItems[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function updateBattlePassStatus(param1:Boolean, param2:Vector.<int>) : void
      {
         var _loc3_:BattlePassObjectiveVO = null;
         this._battlePassStatus = param1;
         if(param2.length > 0)
         {
            this._hasRewardsToCollect = true;
         }
         else
         {
            this._hasRewardsToCollect = false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._objectiveItems.length)
         {
            _loc3_ = this._objectiveItems[_loc4_];
            _loc3_.hasBattlePass = param1;
            if(param2.indexOf(_loc3_.questId) != -1)
            {
               _loc3_.toCollect = true;
            }
            else
            {
               _loc3_.toCollect = false;
            }
            _loc4_++;
         }
      }
      
      public function get videoLootID() : String
      {
         return this._videoLootID;
      }
      
      public function set videoLootID(param1:String) : void
      {
         this._videoLootID = param1;
      }
      
      public function get battlePassStatus() : Boolean
      {
         return this._battlePassStatus;
      }
      
      public function get hasRewardsToCollect() : Boolean
      {
         return this._hasRewardsToCollect;
      }
      
      public function get numCompletedObjectives() : int
      {
         return this._numCompletedObjectives;
      }
      
      public function get numTotalObjectives() : int
      {
         return this._numTotalObjectives;
      }
      
      public function get titleKeyBeforePurchase() : String
      {
         return this._titleKeyBeforePurchase;
      }
      
      public function set titleKeyBeforePurchase(param1:String) : void
      {
         this._titleKeyBeforePurchase = param1;
      }
      
      public function get descriptionKeyBeforePurchase() : String
      {
         return this._descriptionKeyBeforePurchase;
      }
      
      public function set descriptionKeyBeforePurchase(param1:String) : void
      {
         this._descriptionKeyBeforePurchase = param1;
      }
      
      public function get descriptionKeyCollect() : String
      {
         return this._descriptionKeyCollect;
      }
      
      public function set descriptionKeyCollect(param1:String) : void
      {
         this._descriptionKeyCollect = param1;
      }
      
      public function get titleKeyAfterPurchase() : String
      {
         return this._titleKeyAfterPurchase;
      }
      
      public function set titleKeyAfterPurchase(param1:String) : void
      {
         this._titleKeyAfterPurchase = param1;
      }
      
      public function get descriptionKeyAfterPurchase() : String
      {
         return this._descriptionKeyAfterPurchase;
      }
      
      public function set descriptionKeyAfterPurchase(param1:String) : void
      {
         this._descriptionKeyAfterPurchase = param1;
      }
      
      public function createExchangeList(param1:BattlePassKeyExchangeInfoCommand) : void
      {
         this._exchangekey.value = param1.numOfKeys;
         this._exchangeItems.length = 0;
         var _loc2_:int = int(param1.rewardList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.exchangeItems.push(new BattlePassExchangeVO(param1.rewardList[_loc3_],this._exchangekey.value));
            _loc3_++;
         }
         this._exchangeItems.sort(BattlePassExchangeVO.sort);
         this.exchangeCreated.dispatch();
      }
      
      public function updateExchangeList(param1:BattlePassKeyExchangeUpdateCommand) : void
      {
         this._exchangekey.value = param1.numOfKeys;
         var _loc2_:int = int(this.exchangeItems.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.exchangeItems[_loc3_].rewardName == param1.exchangeReward)
            {
               this.exchangeItems[_loc3_].claimCount = param1.claimCount;
            }
            this.exchangeItems[_loc3_].currentTotalKey = param1.numOfKeys;
            _loc3_++;
         }
         this._exchangeItems.sort(BattlePassExchangeVO.sort);
         this.exchangeUpdated.dispatch();
      }
      
      public function set itemFilter(param1:Vector.<String>) : void
      {
         this._itemFilter = new Vector.<String>();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._itemFilter.push(param1[_loc2_]);
            _loc2_++;
         }
         this.filterChanged.dispatch();
      }
      
      public function get itemFilter() : Vector.<String>
      {
         return this._itemFilter;
      }
      
      public function get exchangekey() : BindableInt
      {
         return this._exchangekey;
      }
   }
}

