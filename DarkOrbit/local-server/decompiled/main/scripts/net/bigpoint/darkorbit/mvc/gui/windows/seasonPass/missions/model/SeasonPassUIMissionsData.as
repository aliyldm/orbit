package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.com.module.QuestTypeModule;
   import net.bigpoint.darkorbit.com.module.SeasonPassMissionInfoCommand;
   import net.bigpoint.darkorbit.com.module.SeasonPassMissionStatusModule;
   import net.bigpoint.darkorbit.com.module.liveops.seasonpass.RefreshQuestInfo;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.vo.SeasonPassMissionVO;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestParser;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SeasonPassUIMissionsData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const missionCompleted:ISignal = new Signal();
      
      private var _missionItems:Vector.<SeasonPassMissionVO>;
      
      private var _dailyMissionItems:Vector.<SeasonPassMissionVO>;
      
      private var _weeklyMissionItems:Vector.<SeasonPassMissionVO>;
      
      private var _seasonMissionItems:Vector.<SeasonPassMissionVO>;
      
      private var _refreshInfo:RefreshQuestInfo;
      
      private var _curMaxCount:int;
      
      private var _curUsedCount:int;
      
      public function SeasonPassUIMissionsData()
      {
         super();
         this._missionItems = new Vector.<SeasonPassMissionVO>(0);
         this._dailyMissionItems = new Vector.<SeasonPassMissionVO>(0);
         this._weeklyMissionItems = new Vector.<SeasonPassMissionVO>(0);
         this._seasonMissionItems = new Vector.<SeasonPassMissionVO>(0);
         this._refreshInfo = new RefreshQuestInfo();
      }
      
      public function updateMissionInfo(param1:SeasonPassMissionInfoCommand) : void
      {
         var _loc3_:QuestDefinitionModule = null;
         var _loc4_:SeasonPassMissionVO = null;
         var _loc5_:Quest = null;
         if(param1.missionInfoType == SeasonPassMissionInfoCommand.MISSIONINFOTYPE_REPLACE)
         {
            this._missionItems = new Vector.<SeasonPassMissionVO>(0);
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.missionItems.length)
         {
            _loc3_ = param1.missionItems[_loc2_].questDefinitionModule;
            _loc4_ = new SeasonPassMissionVO();
            _loc4_.objectiveModule = _loc3_;
            _loc4_.missionStatus = param1.missionItems[_loc2_].missionStatus;
            _loc5_ = QuestParser.instance.parseDefinition(_loc3_);
            _loc4_.quest = _loc5_;
            this._missionItems.push(_loc4_);
            _loc2_++;
         }
         this._refreshInfo = param1.refreshInfo;
         this.sortData();
         this.changed.dispatch();
      }
      
      public function updateMissionCondition(param1:int, param2:Number, param3:Boolean, param4:Boolean) : Boolean
      {
         var _loc5_:SeasonPassMissionVO = this.getVOByConditionID(param1);
         if(_loc5_ == null)
         {
            return false;
         }
         _loc5_.quest.updateCondition(param1,param2,param4,param3);
         _loc5_.missionChanged.dispatch();
         return true;
      }
      
      public function updateGoldPassStatus(param1:Boolean) : void
      {
         var _loc3_:SeasonPassMissionVO = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._missionItems.length)
         {
            if(this._missionItems[_loc2_].quest != null)
            {
               _loc3_ = this._missionItems[_loc2_];
               _loc3_.goldLocked = param1;
            }
            _loc2_++;
         }
      }
      
      public function completeMission(param1:int) : void
      {
         var _loc2_:SeasonPassMissionVO = this.getVOByMissionID(param1);
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.missionStatus.type == SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_RUNNING)
         {
            _loc2_.missionStatus.type = SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_COMPLETED;
         }
         else if(_loc2_.missionStatus.type == SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_LOCKED_INCOMPLETE)
         {
            _loc2_.missionStatus.type = SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_GOLD_LOCKED_COMPLETE;
         }
         else
         {
            _loc2_.missionStatus.type = SeasonPassMissionStatusModule.MISSIONSTATUSTYPE_NORMAL_COMPLETED;
         }
         _loc2_.missionChanged.dispatch();
         this.missionCompleted.dispatch();
      }
      
      public function get CurMaxCount() : int
      {
         return this._curMaxCount;
      }
      
      public function get CurUsedCount() : int
      {
         return this._curUsedCount;
      }
      
      public function set CurMaxCount(param1:int) : void
      {
         this._curMaxCount = param1;
      }
      
      public function set CurUsedCount(param1:int) : void
      {
         this._curUsedCount = param1;
      }
      
      public function get missionItems() : Vector.<SeasonPassMissionVO>
      {
         return this._missionItems;
      }
      
      public function get dailyMissionItems() : Vector.<SeasonPassMissionVO>
      {
         return this._dailyMissionItems;
      }
      
      public function get weeklyMissionItems() : Vector.<SeasonPassMissionVO>
      {
         return this._weeklyMissionItems;
      }
      
      public function get seasonMissionItems() : Vector.<SeasonPassMissionVO>
      {
         return this._seasonMissionItems;
      }
      
      public function get dailyMaxCount() : int
      {
         return this._refreshInfo.dailyCount;
      }
      
      public function get dailyUsedCount() : int
      {
         return this._refreshInfo.dailyLeft;
      }
      
      public function get weeklyMaxCount() : int
      {
         return this._refreshInfo.weeklyCount;
      }
      
      public function get weeklyUsedCount() : int
      {
         return this._refreshInfo.weeklyLeft;
      }
      
      public function get dailyUridiumCost() : int
      {
         return this._refreshInfo.nextDailyUridium;
      }
      
      public function get weeklyUridiumCost() : int
      {
         return this._refreshInfo.nextWeeklyUridium;
      }
      
      private function getVOByConditionID(param1:int) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._missionItems.length)
         {
            if(this._missionItems[_loc2_].quest != null)
            {
               if(this._missionItems[_loc2_].quest.flatConditions[param1] != null)
               {
                  return this._missionItems[_loc2_];
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      private function getVOByMissionID(param1:int) : *
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._missionItems.length)
         {
            if(this._missionItems[_loc2_].quest != null)
            {
               if(this._missionItems[_loc2_].quest.id == param1)
               {
                  return this._missionItems[_loc2_];
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      private function getMissionVOsByMissionType(param1:int) : Vector.<SeasonPassMissionVO>
      {
         var _loc2_:Vector.<SeasonPassMissionVO> = new Vector.<SeasonPassMissionVO>(0);
         var _loc3_:int = 0;
         while(_loc3_ < this._missionItems.length)
         {
            if(this._missionItems[_loc3_].quest.type.hasQuestType(param1))
            {
               _loc2_.push(this._missionItems[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function sortData() : void
      {
         this._missionItems.sort(SeasonPassMissionVO.sort);
         this._dailyMissionItems = this.getMissionVOsByMissionType(QuestTypeModule.QUESTTYPE_DAILY);
         this._weeklyMissionItems = this.getMissionVOsByMissionType(QuestTypeModule.QUESTTYPE_WEEKLY);
         this._seasonMissionItems = this.getMissionVOsByMissionType(QuestTypeModule.QUESTTYPE_SEASONPASS);
      }
   }
}

