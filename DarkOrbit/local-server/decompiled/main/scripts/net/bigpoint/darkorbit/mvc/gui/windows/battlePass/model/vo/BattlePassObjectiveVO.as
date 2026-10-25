package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo
{
   import net.bigpoint.darkorbit.com.module.QuestAcceptabilityStatusModule;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.questfm.Quest;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BattlePassObjectiveVO
   {
      
      public const changed:ISignal = new Signal();
      
      public const questChanged:ISignal = new Signal();
      
      public const battlePassChanged:ISignal = new Signal();
      
      private var _sortOrder:int;
      
      private var _objectiveTitle:String;
      
      private var _questId:int;
      
      private var _objectiveModule:QuestDefinitionModule;
      
      private var _statusModule:QuestAcceptabilityStatusModule;
      
      private var _questReward:BattlePassRewardVO;
      
      private var _bpReward:BattlePassRewardVO;
      
      private var _hasBattlePass:Boolean;
      
      private var _toCollect:Boolean = false;
      
      private var _quest:Quest;
      
      public function BattlePassObjectiveVO()
      {
         super();
      }
      
      public static function sort(param1:BattlePassObjectiveVO, param2:BattlePassObjectiveVO) : int
      {
         if(!param1.statusModule)
         {
            return 0;
         }
         if(param1.statusModule.type == param2.statusModule.type)
         {
            return param1.sortOrder - param2.sortOrder;
         }
         if(param1.statusModule.type == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED && param2.statusModule.type != QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED)
         {
            return 1;
         }
         if(param2.statusModule.type == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED && param1.statusModule.type != QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED)
         {
            return -1;
         }
         return 0;
      }
      
      public function get objectiveTitle() : String
      {
         return this._objectiveTitle;
      }
      
      public function set objectiveTitle(param1:String) : void
      {
         this._objectiveTitle = param1;
         this.changed.dispatch();
      }
      
      public function get questId() : int
      {
         return this._questId;
      }
      
      public function set questId(param1:int) : void
      {
         this._questId = param1;
         this.changed.dispatch();
      }
      
      public function get questReward() : BattlePassRewardVO
      {
         return this._questReward;
      }
      
      public function set questReward(param1:BattlePassRewardVO) : void
      {
         this._questReward = param1;
         this.changed.dispatch();
      }
      
      public function get bpReward() : BattlePassRewardVO
      {
         return this._bpReward;
      }
      
      public function set bpReward(param1:BattlePassRewardVO) : void
      {
         this._bpReward = param1;
         this.changed.dispatch();
      }
      
      public function get objectiveModule() : QuestDefinitionModule
      {
         return this._objectiveModule;
      }
      
      public function set objectiveModule(param1:QuestDefinitionModule) : void
      {
         this._objectiveModule = param1;
      }
      
      public function get quest() : Quest
      {
         return this._quest;
      }
      
      public function set quest(param1:Quest) : void
      {
         this._quest = param1;
         this.questChanged.dispatch();
      }
      
      public function get hasBattlePass() : Boolean
      {
         return this._hasBattlePass;
      }
      
      public function set hasBattlePass(param1:Boolean) : void
      {
         this._hasBattlePass = param1;
         this.battlePassChanged.dispatch();
      }
      
      public function get statusModule() : QuestAcceptabilityStatusModule
      {
         return this._statusModule;
      }
      
      public function set statusModule(param1:QuestAcceptabilityStatusModule) : void
      {
         this._statusModule = param1;
         this.questChanged.dispatch();
      }
      
      public function get toCollect() : Boolean
      {
         return this._toCollect;
      }
      
      public function set toCollect(param1:Boolean) : void
      {
         this._toCollect = param1;
         this.questChanged.dispatch();
      }
      
      public function get sortOrder() : int
      {
         return this._sortOrder;
      }
      
      public function set sortOrder(param1:int) : void
      {
         this._sortOrder = param1;
      }
   }
}

