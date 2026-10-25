package net.bigpoint.darkorbit.mvc.questWindow.model
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.utils.Dictionary;
   import mx.collections.ArrayList;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.QuestAcceptRequest;
   import net.bigpoint.darkorbit.com.module.QuestAcceptabilityStatusModule;
   import net.bigpoint.darkorbit.com.module.QuestCancelRequest;
   import net.bigpoint.darkorbit.com.module.QuestChallengeRatingModule;
   import net.bigpoint.darkorbit.com.module.QuestIconModule;
   import net.bigpoint.darkorbit.com.module.QuestInfoCommand;
   import net.bigpoint.darkorbit.com.module.QuestInfoRequest;
   import net.bigpoint.darkorbit.com.module.QuestListCommand;
   import net.bigpoint.darkorbit.com.module.QuestListRequest;
   import net.bigpoint.darkorbit.com.module.QuestLocalizationModule;
   import net.bigpoint.darkorbit.com.module.QuestRequirementModule;
   import net.bigpoint.darkorbit.com.module.QuestSlimInfoModule;
   import net.bigpoint.darkorbit.com.module.QuestTypeModule;
   import net.bigpoint.darkorbit.managers.QuestManager;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.HighscoreVO;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.QuestFilterType;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.QuestListItemVO;
   import net.bigpoint.darkorbit.mvc.questWindow.view.QuestGiverWindowMediator;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.questfm.ICondition;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestLocale;
   import net.bigpoint.darkorbit.questfm.QuestParser;
   import net.bigpoint.darkorbit.questfm.QuestStock;
   import net.bigpoint.darkorbit.questfm.QuestType;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class QuestProxy extends Proxy implements IProxy
   {
      
      public static const questIconMap:Dictionary = new Dictionary();
      
      public static const questIconTooltipMap:Dictionary = new Dictionary();
      
      public static const QUEST_GIVER_ICON_APPEARS_SOUND:int = 103;
      
      public static const QUEST_GIVER_WINDOW_OPEN_SOUND:int = 104;
      
      public static const QUEST_FINSIHED_SOUND:int = 105;
      
      public static const QUEST_FAILED_SOUND:int = 106;
      
      public static const QUEST_SUBQUEST_FINISHED_SOUND:int = 107;
      
      public static const NAME:String = "QuestProxy";
      
      private var questListByID:Dictionary = new Dictionary();
      
      private var _missionList:ArrayList = new ArrayList();
      
      private var _challengesList:ArrayList = new ArrayList();
      
      private var _dailyMissionList:ArrayList = new ArrayList();
      
      private var _eventMissionList:ArrayList = new ArrayList();
      
      private var _weeklyMissionList:ArrayList = new ArrayList();
      
      private var connMan:ConnectionManager;
      
      private var parser:QuestParser;
      
      private var questManager:QuestManager;
      
      private var questStock:QuestStock;
      
      private var _selectedQuestListItemVO:QuestListItemVO;
      
      private var _selectedQuest:Quest;
      
      public var questGiverWindowOpen:Boolean = false;
      
      public var playerTriedToOpenWindow:Boolean = false;
      
      private var _maxAcceptedQuests:int = -1;
      
      private var _maxAcceptedEventQuests:int = -1;
      
      private var activeFilters:Vector.<QuestFilterType> = new Vector.<QuestFilterType>();
      
      private var _lastSelectedTab:int = QuestGiverWindowMediator.TAB_NONE_OR_INIT;
      
      private var _onlyStarterQuestsActive:Boolean = false;
      
      public function QuestProxy(param1:String = null, param2:Object = null)
      {
         this.questListByID = new Dictionary();
         this.activeFilters.push(new QuestFilterType(QuestFilterType.AVAILABLE));
         this.activeFilters.push(new QuestFilterType(QuestFilterType.ATTEMPTED));
         this.activeFilters.push(new QuestFilterType(QuestFilterType.UNATTEMPTED));
         super(param1,param2);
         this.parser = QuestParser.instance;
         this._lastSelectedTab = QuestGiverWindowMediator.TAB_NONE_OR_INIT;
         questIconMap[QuestIconModule.ICONTYPE_TIME] = "questType_time";
         questIconMap[QuestIconModule.ICONTYPE_PVP] = "questType_pvp";
         questIconMap[QuestIconModule.ICONTYPE_KILL] = "questType_kill";
         questIconMap[QuestIconModule.ICONTYPE_DISCOVER] = "questType_discovery";
         questIconMap[QuestIconModule.ICONTYPE_COLLECT] = "questType_collect";
         questIconMap[QuestIconModule.ICONTYPE_SUMMERGAMES3] = "questType_collect";
         questIconMap[QuestIconModule.ICONTYPE_WINTERGAMES09] = "questType_collect";
         questIconMap[QuestIconModule.ICONTYPE_EPIC] = "questType_epic";
         questIconMap[QuestIconModule.ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_EASY] = "questType_daily1";
         questIconMap[QuestIconModule.ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_MEDIUM] = "questType_daily2";
         questIconMap[QuestIconModule.ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_HARD] = "questType_daily3";
         questIconTooltipMap[QuestIconModule.ICONTYPE_TIME] = "ttip_questwin_icon_TIME";
         questIconTooltipMap[QuestIconModule.ICONTYPE_PVP] = "ttip_questwin_icon_PVP";
         questIconTooltipMap[QuestIconModule.ICONTYPE_KILL] = "ttip_questwin_icon_KILL";
         questIconTooltipMap[QuestIconModule.ICONTYPE_DISCOVER] = "ttip_questwin_icon_DISCOVER";
         questIconTooltipMap[QuestIconModule.ICONTYPE_COLLECT] = "ttip_questwin_icon_COLLECT";
         questIconTooltipMap[QuestIconModule.ICONTYPE_SUMMERGAMES3] = "ttip_questwin_icon_SUMMERGAMES3";
         questIconTooltipMap[QuestIconModule.ICONTYPE_WINTERGAMES09] = "ttip_questwin_icon_WINTERGAMES09";
         questIconTooltipMap[QuestIconModule.ICONTYPE_EPIC] = "ttip_questwin_icon_EPIC";
         questIconTooltipMap[QuestIconModule.ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_EASY] = "ttip_questwin_icon_daily1";
         questIconTooltipMap[QuestIconModule.ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_MEDIUM] = "ttip_questwin_icon_daily2";
         questIconTooltipMap[QuestIconModule.ICONTYPE_DAILY_QUEST_DIFFICULTY_LEVEL_HARD] = "ttip_questwin_icon_daily3";
      }
      
      public function createQuestLists(param1:QuestListCommand) : void
      {
         var _loc2_:QuestSlimInfoModule = null;
         var _loc4_:QuestListItemVO = null;
         var _loc5_:QuestIconModule = null;
         var _loc6_:QuestRequirementModule = null;
         var _loc7_:QuestListItemVO = null;
         this._maxAcceptedQuests = param1.maxQuests;
         this._maxAcceptedEventQuests = param1.maxEventQuests;
         this._missionList = new ArrayList();
         this._challengesList = new ArrayList();
         this._dailyMissionList = new ArrayList();
         this._weeklyMissionList = new ArrayList();
         this._eventMissionList = new ArrayList();
         this._onlyStarterQuestsActive = param1.onlyStarter;
         var _loc3_:int = 0;
         while(_loc3_ < param1.list.length)
         {
            _loc2_ = param1.list[_loc3_];
            _loc4_ = new QuestListItemVO(_loc2_.textKeyFoundation);
            _loc4_.questID = _loc2_.questId;
            _loc4_.questPrio = _loc2_.priority;
            _loc4_.rootCaseID = _loc2_.rootCaseId;
            _loc4_.minLevel = _loc2_.minLevel;
            _loc4_.types = _loc2_.types;
            _loc4_.acceptable = _loc2_.acceptabilityStatus.type == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_NOT_STARTED || _loc2_.acceptabilityStatus.type == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED && _loc4_.type.hasQuestType(QuestTypeModule.QUESTTYPE_CHALLENGE);
            _loc4_.completed = _loc2_.acceptabilityStatus.type == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_COMPLETED;
            _loc4_.setQuestActive(_loc2_.acceptabilityStatus.type == QuestAcceptabilityStatusModule.ACCEPTABILITYTYPE_RUNNING);
            _loc5_ = _loc2_.icon;
            _loc4_.questMainTypeIcon = questIconMap[_loc5_.icon];
            if(this.questListByID[_loc4_.rootCaseID] != null)
            {
               _loc4_.ratings = (this.questListByID[_loc4_.rootCaseID] as QuestListItemVO).ratings;
               _loc4_.questSubTypeList = (this.questListByID[_loc4_.rootCaseID] as QuestListItemVO).questSubTypeList;
            }
            this.questListByID[_loc4_.rootCaseID] = _loc4_;
            if(this._selectedQuestListItemVO)
            {
               if(this._selectedQuestListItemVO.questID == _loc4_.questID)
               {
                  _loc4_.setSelected(true);
                  this._selectedQuestListItemVO = _loc4_;
               }
            }
            if(!_loc4_.acceptable)
            {
               _loc4_.notAcceptableReasons = "";
               for each(_loc6_ in _loc2_.missingAcceptRequirements)
               {
                  _loc4_.notAcceptableReasons += this.getStringFromNonAcceptableReason(_loc6_) + "\n\n";
               }
            }
            if(_loc4_.type.hasQuestType(QuestTypeModule.QUESTTYPE_CHALLENGE))
            {
               if(_loc4_.type.hasQuestType(QuestTypeModule.QUESTTYPE_MISSION))
               {
                  _loc4_.types = new <QuestTypeModule>[new QuestTypeModule(QuestTypeModule.QUESTTYPE_MISSION)];
                  this.missionList.addItem(_loc4_);
                  if(_loc4_.completed)
                  {
                     _loc7_ = _loc4_.clone();
                     _loc7_.types = new <QuestTypeModule>[new QuestTypeModule(QuestTypeModule.QUESTTYPE_CHALLENGE)];
                     _loc7_.extraInfo = "attempted";
                     this.challengesList.addItem(_loc7_);
                  }
               }
               else
               {
                  if(_loc4_.completed)
                  {
                     _loc4_.extraInfo = "attempted";
                  }
                  this.challengesList.addItem(_loc4_);
               }
            }
            else if(_loc4_.type.hasQuestType(QuestTypeModule.QUESTTYPE_EVENT))
            {
               this.eventMissionList.addItem(_loc4_);
            }
            else if(_loc4_.type.hasQuestType(QuestTypeModule.QUESTTYPE_DAILY))
            {
               this.dailyMissionList.addItem(_loc4_);
            }
            else if(_loc4_.type.hasQuestType(QuestTypeModule.QUESTTYPE_WEEKLY))
            {
               this.weeklyMissionList.addItem(_loc4_);
            }
            else
            {
               this.missionList.addItem(_loc4_);
            }
            _loc3_++;
         }
         this.sortLists();
         this.handleUpdateCurrentTabRequest();
         if(!this.questGiverWindowOpen)
         {
            this.recheckQuestsAvailable(QuestGiverWindowMediator.TAB_MISSIONS);
         }
         if(this.playerTriedToOpenWindow)
         {
            this.playerTriedToOpenWindow = false;
            this.setQuestWindowOpenStats(true);
            AudioManager.playSoundEffect(QuestProxy.QUEST_GIVER_WINDOW_OPEN_SOUND);
         }
         this.handleFiltersChangedRequest();
      }
      
      public function sortAndUpdateLists() : void
      {
         this.sortLists();
         this.handleUpdateCurrentTabRequest();
      }
      
      private function sortLists() : void
      {
         this.missionList.source.sort(this.superSpecialQuestSort);
         this.challengesList.source.sort(this.superSpecialQuestSort);
         this.dailyMissionList.source.sort(this.superSpecialQuestSort);
         this.weeklyMissionList.source.sort(this.superSpecialQuestSort);
         this.eventMissionList.source.sort(this.superSpecialQuestSort);
      }
      
      public function handleUpdateCurrentTabRequest() : void
      {
         this.handleUpdateTabRequest(this._lastSelectedTab);
      }
      
      public function handleUpdateTabRequest(param1:int) : void
      {
         var _loc7_:QuestListItemVO = null;
         var _loc2_:Boolean = this._lastSelectedTab != param1;
         this._lastSelectedTab = param1;
         var _loc3_:ArrayList = new ArrayList();
         var _loc4_:ArrayList = new ArrayList();
         var _loc5_:Boolean = false;
         switch(param1)
         {
            case QuestGiverWindowMediator.TAB_MISSIONS:
               _loc3_ = this.missionList;
               break;
            case QuestGiverWindowMediator.TAB_CHALLENGES:
               _loc3_ = this.challengesList;
               _loc5_ = true;
               break;
            case QuestGiverWindowMediator.TAB_EVENT_MISSIONS:
               _loc3_ = this.eventMissionList;
               break;
            case QuestGiverWindowMediator.TAB_DAILY_MISSIONS:
               _loc3_ = this.dailyMissionList;
               break;
            case QuestGiverWindowMediator.TAB_WEEKLY_MISSIONS:
               _loc3_ = this.weeklyMissionList;
         }
         var _loc6_:QuestListItemVO = null;
         if(this._onlyStarterQuestsActive)
         {
            for each(_loc6_ in _loc3_.source)
            {
               if(_loc6_.type.hasQuestType(QuestTypeModule.QUESTTYPE_STARTER) && (this.isFilterActive(new QuestFilterType(QuestFilterType.AVAILABLE)) && _loc6_.acceptable || _loc6_.getQuestActive() || this.isFilterActive(new QuestFilterType(QuestFilterType.UNAVAILABLE)) && _loc6_.notAcceptableReasons.length > 0 || this.isFilterActive(new QuestFilterType(QuestFilterType.COMPLETED)) && _loc6_.completed))
               {
                  _loc4_.addItem(_loc6_);
               }
            }
         }
         else if(!_loc5_)
         {
            for each(_loc6_ in _loc3_.source)
            {
               if(this.isFilterActive(new QuestFilterType(QuestFilterType.AVAILABLE)) && (_loc6_.acceptable || _loc6_.getQuestActive()) || this.isFilterActive(new QuestFilterType(QuestFilterType.UNAVAILABLE)) && _loc6_.notAcceptableReasons.length > 0 || this.isFilterActive(new QuestFilterType(QuestFilterType.COMPLETED)) && _loc6_.completed)
               {
                  _loc4_.addItem(_loc6_);
               }
            }
         }
         else
         {
            for each(_loc7_ in _loc3_.source)
            {
               if(this.isFilterActive(new QuestFilterType(QuestFilterType.ATTEMPTED)) && (_loc7_.extraInfo != null && _loc7_.extraInfo.indexOf("attempted") != -1) || this.isFilterActive(new QuestFilterType(QuestFilterType.UNATTEMPTED)) && (_loc7_.extraInfo == null || _loc7_.extraInfo.indexOf("attempted") == -1))
               {
                  _loc4_.addItem(_loc7_);
               }
            }
         }
         if(param1 == QuestGiverWindowMediator.TAB_MISSIONS || param1 == QuestGiverWindowMediator.TAB_CHALLENGES)
         {
            sendNotification(QuestGiverWindowNotification.UPDATE_QUEST_LIST,[_loc4_,this._maxAcceptedQuests,this._onlyStarterQuestsActive]);
         }
         else if(param1 == QuestGiverWindowMediator.TAB_EVENT_MISSIONS)
         {
            sendNotification(QuestGiverWindowNotification.UPDATE_QUEST_LIST,[_loc4_,this._maxAcceptedEventQuests,this._onlyStarterQuestsActive]);
         }
         else
         {
            sendNotification(QuestGiverWindowNotification.UPDATE_QUEST_LIST,[_loc4_,this._maxAcceptedQuests,this._onlyStarterQuestsActive]);
         }
         this.recheckQuestsAvailable(param1,_loc2_,_loc4_);
      }
      
      private function recheckQuestsAvailable(param1:int, param2:Boolean = false, param3:ArrayList = null) : void
      {
         var _loc4_:ArrayList = null;
         switch(param1)
         {
            case QuestGiverWindowMediator.TAB_MISSIONS:
               _loc4_ = this.missionList;
               break;
            case QuestGiverWindowMediator.TAB_CHALLENGES:
               _loc4_ = this.challengesList;
               break;
            case QuestGiverWindowMediator.TAB_EVENT_MISSIONS:
               _loc4_ = this.eventMissionList;
               break;
            case QuestGiverWindowMediator.TAB_DAILY_MISSIONS:
               _loc4_ = this.dailyMissionList;
               break;
            case QuestGiverWindowMediator.TAB_WEEKLY_MISSIONS:
               _loc4_ = this.weeklyMissionList;
         }
         if(_loc4_ == null)
         {
            return;
         }
         if(Boolean(param3) && param3.length > 0)
         {
            if(param2 || this._selectedQuestListItemVO == null || param3.source.indexOf(this._selectedQuestListItemVO) == -1)
            {
               this.requestDetailedQuestInfo((param3.source[0] as QuestListItemVO).questID,(param3.source[0] as QuestListItemVO).rootCaseID);
            }
         }
         else if(param2)
         {
            this._selectedQuestListItemVO = null;
            this._selectedQuest = null;
            sendNotification(QuestGiverWindowNotification.EMPTY_QUEST_DETAILS);
         }
         if(_loc4_.length > 0)
         {
            sendNotification(QuestGiverWindowNotification.QUESTS_AVAILABILITY_UPDATE,false);
         }
         else
         {
            sendNotification(QuestGiverWindowNotification.QUESTS_AVAILABILITY_UPDATE,true);
         }
      }
      
      private function getStringFromNonAcceptableReason(param1:QuestRequirementModule) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         switch(param1.requirementType)
         {
            case QuestRequirementModule.QUESTREQUIREMENTTYPE_NUMBER_OF_QUESTS_ACCEPTED:
               _loc2_ = BPLocale.getItem("ttip_questwin_notacceptable_TOOMANY").replace("%AMOUNT%",param1.maxValue + 1);
               break;
            case QuestRequirementModule.QUESTREQUIREMENTTYPE_LEVEL:
               _loc2_ = BPLocale.getItem("ttip_questwin_notacceptable_TOOLOWLEVEL").replace("%AMOUNT%",param1.minValue);
               break;
            case QuestRequirementModule.QUESTREQUIREMENTTYPE_DATE:
               _loc3_ = 60000;
               _loc2_ = BPLocale.getItem("ttip_questwin_notacceptable_DATE").replace(/%BEGIN%/,TimeFormatter.formatTimeValueFromMinutes(Math.ceil(param1.minValue / _loc3_),true)).replace(/%TIME%/,TimeFormatter.formatTimeValueFromMinutes(Math.ceil((param1.maxValue - param1.minValue) / _loc3_),true));
               break;
            case QuestRequirementModule.QUESTREQUIREMENTTYPE_PRE_QUEST:
               _loc2_ = this.createPreQuestRequirementText(param1);
               break;
            case QuestRequirementModule.QUESTREQUIREMENTTYPE_EVENT:
               _loc2_ = BPLocale.getItem("ttip_questwin_notacceptable_EVENT");
               break;
            case QuestRequirementModule.QUESTREQUIREMENTTYPE_EXCLUSIVE_POOL_QUEST_RUNNING:
               _loc2_ = BPLocale.getItem("ttip_questwin_weekly_mission_exclude_explanation");
               break;
            case QuestRequirementModule.QUESTREQUIREMENTTYPE_HOURS_AFTER_QUEST:
               _loc2_ = this.createHoursAfterQuestRequirementText(param1);
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_;
      }
      
      private function createPreQuestRequirementText(param1:QuestRequirementModule) : String
      {
         var _loc3_:QuestLocalizationModule = null;
         var _loc4_:QuestLocalizationModule = null;
         var _loc2_:String = "";
         _loc2_ += BPLocale.getItem("ttip_questwin_notacceptable_PRE_QUEST").replace(/%MIN%/,HtmlTextUtils.coloriseText(1506307,param1.minValue.toString())).replace(/%MAX%/,HtmlTextUtils.coloriseText(16719904,param1.maxValue.toString()));
         for each(_loc3_ in param1.matches)
         {
            _loc2_ += HtmlTextUtils.BR + HtmlTextUtils.coloriseText(1506307,QuestLocale.getTitleEx(_loc3_.questId,_loc3_.textKeyFoundation));
         }
         for each(_loc4_ in param1.missingMatches)
         {
            _loc2_ += HtmlTextUtils.BR + HtmlTextUtils.coloriseText(16719904,QuestLocale.getTitleEx(_loc4_.questId,_loc4_.textKeyFoundation));
         }
         return _loc2_;
      }
      
      private function createHoursAfterQuestRequirementText(param1:QuestRequirementModule) : String
      {
         var _loc3_:QuestLocalizationModule = null;
         var _loc2_:String = "";
         if(param1.maxValue)
         {
            _loc2_ += BPLocale.getItem("ttip_questwin_notacceptable_HOURS_AFTER_QUEST_COMPLETE");
         }
         else
         {
            _loc2_ += BPLocale.getItem("ttip_questwin_notacceptable_HOURS_AFTER_QUEST_ACCEPT");
         }
         _loc2_.replace("%HOURS%",param1.minValue);
         for each(_loc3_ in param1.missingMatches)
         {
            _loc2_ += HtmlTextUtils.BR + HtmlTextUtils.coloriseText(16719904,QuestLocale.getTitleEx(_loc3_.questId,_loc3_.textKeyFoundation));
         }
         return _loc2_;
      }
      
      public function get missionList() : ArrayList
      {
         return this._missionList;
      }
      
      public function get challengesList() : ArrayList
      {
         return this._challengesList;
      }
      
      public function get dailyMissionList() : ArrayList
      {
         return this._dailyMissionList;
      }
      
      public function get weeklyMissionList() : ArrayList
      {
         return this._weeklyMissionList;
      }
      
      public function get eventMissionList() : ArrayList
      {
         return this._eventMissionList;
      }
      
      public function requestDetailedQuestInfo(param1:int, param2:int) : void
      {
         var _loc6_:QuestListItemVO = null;
         var _loc3_:Boolean = false;
         if((this._lastSelectedTab == QuestGiverWindowMediator.TAB_MISSIONS || this._lastSelectedTab == QuestGiverWindowMediator.TAB_CHALLENGES) && this._maxAcceptedQuests == 0)
         {
            _loc3_ = true;
         }
         else if(this._lastSelectedTab == QuestGiverWindowMediator.TAB_EVENT_MISSIONS && this._maxAcceptedEventQuests == 0)
         {
            _loc3_ = true;
         }
         var _loc4_:Quest = this.questStock.getQuestByID(param1);
         if(_loc4_ != null && _loc4_.description != null && _loc4_.description != "")
         {
            if(this._selectedQuestListItemVO)
            {
               this._selectedQuestListItemVO.setSelected(false);
            }
            _loc6_ = this.questListByID[param2];
            this._selectedQuestListItemVO = _loc6_;
            this._selectedQuestListItemVO.setSelected(true);
            this._selectedQuest = _loc4_;
            sendNotification(QuestGiverWindowNotification.SHOW_DETAILED_QUEST_INFO,[_loc4_,_loc6_,_loc3_]);
            return;
         }
         var _loc5_:QuestInfoRequest = new QuestInfoRequest();
         _loc5_.questId = param1;
         this.connMan.sendRequest(_loc5_);
      }
      
      public function setConnectionManager(param1:ConnectionManager) : void
      {
         this.connMan = param1;
      }
      
      private function isQuestSlotLimitReached() : Boolean
      {
         var _loc1_:Boolean = false;
         if((this._lastSelectedTab == QuestGiverWindowMediator.TAB_MISSIONS || this._lastSelectedTab == QuestGiverWindowMediator.TAB_CHALLENGES) && this._maxAcceptedQuests == 0)
         {
            _loc1_ = true;
         }
         else if(this._lastSelectedTab == QuestGiverWindowMediator.TAB_EVENT_MISSIONS && this._maxAcceptedEventQuests == 0)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function addNewQuestInfo(param1:QuestInfoCommand) : void
      {
         var _loc5_:QuestChallengeRatingModule = null;
         var _loc2_:Boolean = this.isQuestSlotLimitReached();
         this._selectedQuest = this.parser.parseDefinition(param1.definition);
         if(this._selectedQuestListItemVO != null)
         {
            this._selectedQuestListItemVO.setSelected(false);
         }
         var _loc3_:QuestListItemVO = this.questListByID[this._selectedQuest.getCase().id];
         this._selectedQuestListItemVO = _loc3_;
         this._selectedQuestListItemVO.setSelected(true);
         _loc3_.questSubTypeList = param1.definition.icons;
         var _loc4_:ArrayList = new ArrayList();
         for each(_loc5_ in param1.ratings)
         {
            _loc4_.addItem(new HighscoreVO(_loc5_.rank,_loc5_.name,_loc5_.rating,true,_loc5_.diffToFirst,_loc5_.epppLink,false));
         }
         if(param1.playersRating.name != null && param1.playersRating.name != "")
         {
            _loc4_.addItem(new HighscoreVO(param1.playersRating.rank,param1.playersRating.name,param1.playersRating.rating,true,param1.playersRating.diffToFirst,param1.playersRating.epppLink,true));
         }
         _loc4_.source.sort(this.compareHighScoreVOs);
         _loc3_.ratings = _loc4_;
         sendNotification(QuestGiverWindowNotification.SHOW_DETAILED_QUEST_INFO,[this._selectedQuest,_loc3_,_loc2_]);
         this.questListByID[this._selectedQuest.getCase().id] = _loc3_;
         this.setQuest(this._selectedQuest,this._selectedQuest.id);
      }
      
      public function refreshCurrentlySelectedQuestDetails() : void
      {
         if(Boolean(this._selectedQuest) && Boolean(this._selectedQuestListItemVO))
         {
            sendNotification(QuestGiverWindowNotification.SHOW_DETAILED_QUEST_INFO,[this._selectedQuest,this._selectedQuestListItemVO,this.isQuestSlotLimitReached()]);
         }
      }
      
      public function sendAcceptQuestRequest(param1:int) : void
      {
         var _loc2_:QuestAcceptRequest = new QuestAcceptRequest();
         _loc2_.questId = param1;
         this.connMan.sendRequest(_loc2_);
      }
      
      public function sendAbortQuestRequest(param1:int) : void
      {
         var _loc2_:QuestCancelRequest = new QuestCancelRequest();
         _loc2_.questId = param1;
         this.connMan.sendRequest(_loc2_);
      }
      
      public function tryToPopulateQuestGiverWindow() : void
      {
         if(this.missionList.length > 0)
         {
            if(!this.questGiverWindowOpen)
            {
               this.setQuestWindowOpenStats(true);
               AudioManager.playSoundEffect(QuestProxy.QUEST_GIVER_WINDOW_OPEN_SOUND);
            }
            this.requestDetailedQuestInfo((this.missionList.source[0] as QuestListItemVO).questID,(this.missionList.source[0] as QuestListItemVO).rootCaseID);
            sendNotification(QuestGiverWindowNotification.UPDATE_QUEST_LIST,[this.missionList,this._maxAcceptedQuests,this._onlyStarterQuestsActive]);
            sendNotification(QuestGiverWindowNotification.QUESTS_AVAILABILITY_UPDATE,false);
         }
         else
         {
            this.connMan.sendRequest(new QuestListRequest());
            this.playerTriedToOpenWindow = true;
         }
      }
      
      public function setQuestWindowOpenStats(param1:Boolean) : void
      {
         this.questGiverWindowOpen = param1;
      }
      
      public function updateQuestObjectives(param1:int, param2:Number, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:ICondition = null;
         var _loc9_:int = 0;
         var _loc10_:ICondition = null;
         if(this._selectedQuest)
         {
            if(this._selectedQuest.flatConditions[param1] != null)
            {
               _loc5_ = param2;
               _loc6_ = param3;
               _loc7_ = param4;
               _loc8_ = ICondition(this._selectedQuest.flatConditions[param1]);
               _loc8_.current = _loc5_;
               _loc8_.runstate = _loc6_;
               _loc8_.completed = _loc7_;
               if(_loc8_.children.length > 0)
               {
                  _loc9_ = 0;
                  while(_loc9_ < _loc8_.children.length)
                  {
                     _loc10_ = _loc8_.children[_loc9_] as ICondition;
                     _loc10_.runstate = _loc6_;
                     _loc10_.completed = _loc7_;
                     _loc9_++;
                  }
               }
               sendNotification(QuestGiverWindowNotification.REFRESH_OBJECTIVE_TREE,this._selectedQuest);
            }
         }
      }
      
      public function setQuestActive(param1:Quest) : void
      {
         var _loc2_:QuestListItemVO = this.questListByID[param1.getCase().id];
         if(_loc2_ != null)
         {
            if(this._selectedQuest != null && this._selectedQuest.id == param1.id)
            {
               this._selectedQuest = param1;
               this._selectedQuestListItemVO = _loc2_;
            }
            _loc2_.setQuestActive(true);
            sendNotification(QuestGiverWindowNotification.REFRESH_VIEW_AFTER_QUEST_ACTIVE_STATUS_CHANGE,_loc2_);
            sendNotification(QuestGiverWindowNotification.REFRESH_OBJECTIVE_TREE,param1);
            this.sortLists();
            this.handleUpdateTabRequest(this._lastSelectedTab);
         }
      }
      
      public function setQuestInactive(param1:int) : void
      {
         var _loc2_:QuestListItemVO = this.questListByID[param1];
         if(_loc2_ != null)
         {
            _loc2_.setQuestActive(false);
            sendNotification(QuestGiverWindowNotification.REFRESH_VIEW_AFTER_QUEST_ACTIVE_STATUS_CHANGE,_loc2_);
            if(this._selectedQuestListItemVO != null && this._selectedQuestListItemVO.rootCaseID == param1)
            {
               this.requestDetailedQuestInfo(_loc2_.questID,_loc2_.rootCaseID);
            }
            this.sortLists();
            this.refreshCurrentlySelectedQuestDetails();
         }
      }
      
      public function setQuest(param1:Quest, param2:int) : void
      {
         this.questStock.addQuest(param1,param2);
      }
      
      public function setQuestManager(param1:QuestManager) : void
      {
         this.questManager = param1;
         this.questStock = param1.questStock;
      }
      
      public function questAccomplished(param1:int, param2:int) : void
      {
         this._selectedQuest = null;
         this._selectedQuestListItemVO = null;
         sendNotification(QuestGiverWindowNotification.EMPTY_QUEST_DETAILS);
         this.questGiverWindowOpen = false;
         if(this.questListByID[param2])
         {
            (this.questListByID[param2] as QuestListItemVO).completed = true;
            this.setQuestInactive(param2);
         }
         this.sortLists();
         this.handleFiltersChangedRequest();
      }
      
      private function compareHighScoreVOs(param1:HighscoreVO, param2:HighscoreVO) : int
      {
         if(param1.isHero)
         {
            return 1;
         }
         if(param2.isHero)
         {
            return -1;
         }
         if(param1.position > param2.position)
         {
            return 1;
         }
         if(param1.position < param2.position)
         {
            return -1;
         }
         return 0;
      }
      
      public function handleFiltersChangedRequest() : void
      {
         this.activeFilters = new Vector.<QuestFilterType>();
         if(Settings.questsAvailableFilter == true)
         {
            this.activeFilters.push(new QuestFilterType(QuestFilterType.AVAILABLE));
         }
         if(Settings.questsUnavailableFilter == true)
         {
            this.activeFilters.push(new QuestFilterType(QuestFilterType.UNAVAILABLE));
         }
         if(Settings.questsCompletedFilter == true)
         {
            this.activeFilters.push(new QuestFilterType(QuestFilterType.COMPLETED));
         }
         if(Settings.questsLevelOrderDescending == true)
         {
            this.activeFilters.push(new QuestFilterType(QuestFilterType.INLEVELRANGE));
         }
         if(Settings.challengesUnattemptedFilter == true)
         {
            this.activeFilters.push(new QuestFilterType(QuestFilterType.UNATTEMPTED));
         }
         if(Settings.challengesAttemptedFilter == true)
         {
            this.activeFilters.push(new QuestFilterType(QuestFilterType.ATTEMPTED));
         }
         this.handleUpdateTabRequest(this._lastSelectedTab);
      }
      
      private function isFilterActive(param1:QuestFilterType) : Boolean
      {
         var _loc2_:QuestFilterType = null;
         for each(_loc2_ in this.activeFilters)
         {
            if(param1.value == _loc2_.value)
            {
               return true;
            }
         }
         return false;
      }
      
      private function superSpecialQuestSort(param1:QuestListItemVO, param2:QuestListItemVO) : Number
      {
         var _loc3_:int = 0;
         _loc3_ = param2.questPrio - param1.questPrio;
         if(_loc3_ != 0)
         {
            return _loc3_;
         }
         if(param1.minLevel != param2.minLevel)
         {
            if(Settings.questsLevelOrderDescending)
            {
               return param1.minLevel - param2.minLevel;
            }
            return param2.minLevel - param1.minLevel;
         }
         _loc3_ = this.extractMainSortPrio(param1) - this.extractMainSortPrio(param2);
         if(_loc3_ != 0)
         {
            return _loc3_;
         }
         return param1.questID - param2.questID;
      }
      
      private function extractMainSortPrio(param1:QuestListItemVO) : int
      {
         if(param1.type.hasQuestType(QuestType.CLIENT_QUEST_HONOUR))
         {
            return 0;
         }
         if(param1.getQuestActive())
         {
            return 1;
         }
         if(param1.type.hasQuestType(QuestTypeModule.QUESTTYPE_STARTER) && !param1.completed)
         {
            return 2;
         }
         if(param1.completed)
         {
            return 5;
         }
         if(!param1.acceptable)
         {
            return 4;
         }
         return 3;
      }
      
      public function get selectedQuest() : Quest
      {
         return this._selectedQuest;
      }
   }
}

