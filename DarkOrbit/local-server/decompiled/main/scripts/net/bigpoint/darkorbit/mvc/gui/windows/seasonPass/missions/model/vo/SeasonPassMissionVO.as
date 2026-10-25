package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.vo
{
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.com.module.SeasonPassMissionStatusModule;
   import net.bigpoint.darkorbit.questfm.Quest;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SeasonPassMissionVO
   {
      
      public const missionChanged:ISignal = new Signal();
      
      private var _isGoldMission:Boolean;
      
      private var _goldLocked:Boolean;
      
      private var _objectiveModule:QuestDefinitionModule;
      
      private var _quest:Quest;
      
      private var _missionStatus:SeasonPassMissionStatusModule;
      
      public var oncePreMission:Boolean = false;
      
      public function SeasonPassMissionVO()
      {
         super();
      }
      
      public static function sort(param1:SeasonPassMissionVO, param2:SeasonPassMissionVO) : int
      {
         if(param1.missionStatus.type == param2.missionStatus.type)
         {
            return param1.quest.id < param2.quest.id ? -1 : 1;
         }
         return param1.missionStatus.type < param2.missionStatus.type ? -1 : 1;
      }
      
      public function get missionStatus() : SeasonPassMissionStatusModule
      {
         return this._missionStatus;
      }
      
      public function set missionStatus(param1:SeasonPassMissionStatusModule) : void
      {
         this._missionStatus = param1;
         if(SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_NORMAL_COMPLETED == this._missionStatus.type || SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_NORMAL_RUNNING == this._missionStatus.type)
         {
            this._isGoldMission = false;
         }
         else
         {
            this._isGoldMission = true;
         }
      }
      
      public function set goldLocked(param1:Boolean) : void
      {
         if(!this._isGoldMission || this._goldLocked == param1)
         {
            return;
         }
         if(param1)
         {
            if(this.missionStatus.type == SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_LOCKED_INCOMPLETE)
            {
               this.missionStatus.type = SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_RUNNING;
            }
            else if(this.missionStatus.type == SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_LOCKED_COMPLETE)
            {
               this.missionStatus.type = SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_COMPLETED;
            }
         }
         else if(this.missionStatus.type == SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_RUNNING)
         {
            this.missionStatus.type = SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_LOCKED_INCOMPLETE;
         }
         else if(this.missionStatus.type == SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_COMPLETED)
         {
            this.missionStatus.type = SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_LOCKED_COMPLETE;
         }
         this._goldLocked = param1;
         this.missionChanged.dispatch();
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
      }
   }
}

