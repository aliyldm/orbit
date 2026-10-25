package net.bigpoint.darkorbit.gui.windows
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.core.IFlexDisplayObject;
   import mx.events.FlexEvent;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.arena.view.ArenaTournamentWindow;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.BattleStationBuildWindowView;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithActivationButton;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithConfirmButton;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithCountdownTimer;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithErrorMessage;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithSelectionSlider;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components.PopUpWithInventoryFilter;
   import net.bigpoint.darkorbit.mvc.common.view.components.DODowngradeWindow;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.components.LeaveGamePopUp;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.view.components.CompanyHierarchyWindowView;
   import net.bigpoint.darkorbit.mvc.countdownStatus.view.CountdownStatusWindowView;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.configurationModePopup.components.ConfigModePopup;
   import net.bigpoint.darkorbit.mvc.helpwindow.view.HelpVideoPopUp;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.JackpotArenaMatchResultWindow;
   import net.bigpoint.darkorbit.mvc.questWindow.view.components.QuestGiverWindowView;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlLobbyWindow;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups.SectorControlDraftConfirmationPopUp;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups.SectorControlLeaveQueuePopUp;
   import net.bigpoint.darkorbit.mvc.soundTool.view.SoundConfigWindow;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbywindow;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.TDMMatchResultWindow;
   import net.bigpoint.darkorbit.mvc.tdm.popups.view.TeamDeathMatchErrorPopup;
   import net.bigpoint.darkorbit.mvc.tdm.popups.view.TeamDeathMatchLevelRequirementPopup;
   import net.bigpoint.darkorbit.mvc.tdm.popups.view.TeamDeathMatchParticipationPopup;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.view.WordPuzzleWindowView;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.TitleWindow;
   
   public class FlexWindowManager extends EventDispatcher
   {
      
      private static var _instance:FlexWindowManager;
      
      public static const ARENA_TOURNAMENT_WINDOW:String = "window.ArenaTournament";
      
      public static const QUEST_GIVER_WINDOW:String = "window.QuestGiver";
      
      public static const BATTLE_STATION_BUILD_WINDOW:String = "window.BattleStationBuild";
      
      public static const COMPANY_HIERARCHY_WINDOW:String = "window.CompanyHierarchy";
      
      public static const WORD_PUZZLE:String = "window.WordPuzzle";
      
      public static const COUNTDOWN_STATUS:String = "window.CountDownStatus";
      
      public static const LEAVEMATCH_POPUP:String = "window.LeaveMatchPopUp";
      
      public static const BS_POP_UP_CONFIRM_MODULE_REMOVAL:String = "window.BSConfirmModuleRemovalPopUp";
      
      public static const BS_POP_UP_WITH_SELECTION_SLIDER:String = "window.BSPopUpWithSelectionSlider";
      
      public static const BS_POP_UP_WITH_PROGRESS_BAR:String = "window.BSPopUpWithProgressBar";
      
      public static const BS_POP_UP_WITH_ERROR_MESSAGE:String = "window.BSPopUpWithErrorMessage";
      
      public static const BS_POP_UP_WITH_COUNTDOWN_TIMER:String = "window.BSPopUpWithCountdownTimer";
      
      public static const BS_POP_UP_WITH_ACTIVATION:String = "window.BSPopUpWithActivation";
      
      public static const BS_POP_UP_WITH_NO_CLAN_MESSAGE:String = "window.BSPopUpWithNoClanMessage";
      
      public static const BS_POP_UP_WITH_INVENTORY_FILTER:String = "window.BSPopUpWithInventoryFiltere";
      
      public static const MENU_CONFIG_MODE_POPUP:String = "window.menuConfigModePopup";
      
      public static const SECTORCONTROL_LOBBY_WINDOW:String = "window.SectorControlLobbyWindow";
      
      public static const SECTORCONTROL_PARTICIPATION_POPUP:String = "window.SectorControlParticipationPopUp";
      
      public static const SECTORCONTROL_LEAVEQUEUE_POPUP:String = "window.SectorControlLeaveQueuePopUp";
      
      public static const SOUND_CONFIG_VIEW:String = "window.SoundConfing";
      
      public static const TEAMDEATHMATCH_LOBBY_WINDOW:String = "window.TeamDeathMatchLobbyWindow";
      
      public static const TEAMDEATHMATCH_RESULT_WINDOW:String = "window.TeamDeathMatchResultWindow";
      
      public static const TEAMDEATHMATCH_LEVELREQUIREMENT_POPUP:String = "window.TeamDeathMatchPlayerRequirementPopup";
      
      public static const TEAMDEATHMATCH_MATCH_PARTICIPATION_POPUP:String = "window.TeamDeathMatchMatchParticipationPopup";
      
      public static const TEAMDEATHMATCH_MATCH_ERROR_POPUP:String = "window.TeamDeathMatchMatchErrorPopup";
      
      public static const JACKPOT_MATCH_RRESULT_WINDOW:String = "window.JackpotArenaMatchResultWindow";
      
      public static const HELP_VIDEO_POPUP:String = "window.HelpVideoPopup";
      
      public static const WINDOW_CENTERED:String = "windowCentered";
      
      public static const WINDOW_LEFT_ALIGNED:String = "windowLeftAligned";
      
      public static const WINDOW_RIGHT_ALIGNED:String = "windowRightAligned";
      
      private var _windowContainer:SkinnableContainer;
      
      private var popupContainer:SkinnableContainer;
      
      private var _windowList:Dictionary = new Dictionary();
      
      private var windowTypeLookup:Dictionary = new Dictionary();
      
      private var windowMediatorLookup:Dictionary = new Dictionary();
      
      private var downGradeWindowLayer:SkinnableContainer = new SkinnableContainer();
      
      public function FlexWindowManager(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("FlexWindowManager is a Singleton and can only be accessed through FlexWindowManager.getInstance()");
         }
      }
      
      public static function getInstance() : FlexWindowManager
      {
         if(_instance == null)
         {
            _instance = new FlexWindowManager(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      public function init(param1:SkinnableContainer) : void
      {
         this._windowContainer = param1;
         this.popupContainer = this.popupContainer;
         param1.addElement(this.downGradeWindowLayer);
         this.windowTypeLookup[ARENA_TOURNAMENT_WINDOW] = ArenaTournamentWindow;
         this.windowTypeLookup[QUEST_GIVER_WINDOW] = QuestGiverWindowView;
         this.windowTypeLookup[COMPANY_HIERARCHY_WINDOW] = CompanyHierarchyWindowView;
         this.windowTypeLookup[WORD_PUZZLE] = WordPuzzleWindowView;
         this.windowTypeLookup[COUNTDOWN_STATUS] = CountdownStatusWindowView;
         this.windowTypeLookup[BATTLE_STATION_BUILD_WINDOW] = BattleStationBuildWindowView;
         this.windowTypeLookup[BS_POP_UP_CONFIRM_MODULE_REMOVAL] = PopUpWithConfirmButton;
         this.windowTypeLookup[BS_POP_UP_WITH_SELECTION_SLIDER] = PopUpWithSelectionSlider;
         this.windowTypeLookup[BS_POP_UP_WITH_ERROR_MESSAGE] = PopUpWithErrorMessage;
         this.windowTypeLookup[BS_POP_UP_WITH_COUNTDOWN_TIMER] = PopUpWithCountdownTimer;
         this.windowTypeLookup[BS_POP_UP_WITH_ACTIVATION] = PopUpWithActivationButton;
         this.windowTypeLookup[BS_POP_UP_WITH_NO_CLAN_MESSAGE] = PopUpWithConfirmButton;
         this.windowTypeLookup[BS_POP_UP_WITH_INVENTORY_FILTER] = PopUpWithInventoryFilter;
         this.windowTypeLookup[MENU_CONFIG_MODE_POPUP] = ConfigModePopup;
         this.windowTypeLookup[SECTORCONTROL_LOBBY_WINDOW] = SectorControlLobbyWindow;
         this.windowTypeLookup[SECTORCONTROL_PARTICIPATION_POPUP] = SectorControlDraftConfirmationPopUp;
         this.windowTypeLookup[LEAVEMATCH_POPUP] = LeaveGamePopUp;
         this.windowTypeLookup[SECTORCONTROL_LEAVEQUEUE_POPUP] = SectorControlLeaveQueuePopUp;
         this.windowTypeLookup[TEAMDEATHMATCH_LOBBY_WINDOW] = TeamDeathMatchLobbywindow;
         this.windowTypeLookup[TEAMDEATHMATCH_RESULT_WINDOW] = TDMMatchResultWindow;
         this.windowTypeLookup[TEAMDEATHMATCH_LEVELREQUIREMENT_POPUP] = TeamDeathMatchLevelRequirementPopup;
         this.windowTypeLookup[TEAMDEATHMATCH_MATCH_PARTICIPATION_POPUP] = TeamDeathMatchParticipationPopup;
         this.windowTypeLookup[TEAMDEATHMATCH_MATCH_ERROR_POPUP] = TeamDeathMatchErrorPopup;
         this.windowTypeLookup[HELP_VIDEO_POPUP] = HelpVideoPopUp;
         this.windowTypeLookup[JACKPOT_MATCH_RRESULT_WINDOW] = JackpotArenaMatchResultWindow;
         this.windowTypeLookup[SOUND_CONFIG_VIEW] = SoundConfigWindow;
      }
      
      public function createWindow(param1:String, param2:String = "windowCentered", param3:Object = null, param4:Boolean = true) : DOWindow
      {
         if(this.windowList[param1])
         {
            return this.windowList[param1];
         }
         var _loc5_:Class = this.windowTypeLookup[param1];
         var _loc6_:DOWindow = new _loc5_();
         this.windowList[param1] = _loc6_;
         DOWindow(_loc6_).windowType = param1;
         if(param4)
         {
            this.windowContainer.addElement(_loc6_);
            _loc6_.alignment = param2;
            _loc6_.addEventListener(FlexEvent.CREATION_COMPLETE,this.handleWindowCreated);
         }
         return _loc6_;
      }
      
      private function handleWindowCreated(param1:FlexEvent) : void
      {
         var _loc2_:DOWindow = param1.target as DOWindow;
         if(_loc2_)
         {
            _loc2_.removeEventListener(FlexEvent.CREATION_COMPLETE,this.handleWindowCreated);
            switch(_loc2_.alignment)
            {
               case WINDOW_CENTERED:
                  _loc2_.x = ScreenManager.halfScreenWidth - _loc2_.width / 2;
                  _loc2_.y = ScreenManager.halfScreenHeight - _loc2_.height / 2;
                  break;
               case WINDOW_LEFT_ALIGNED:
                  _loc2_.x = ScreenManager.halfScreenWidth * 2 + (_loc2_.width + 20);
                  _loc2_.y = ScreenManager.halfScreenHeight - _loc2_.height / 2;
                  break;
               case WINDOW_RIGHT_ALIGNED:
                  _loc2_.x = ScreenManager.halfScreenWidth * 2 - (_loc2_.width + 20);
                  _loc2_.y = ScreenManager.halfScreenHeight - _loc2_.height / 2;
            }
         }
      }
      
      public function createDownGradedWindow(param1:String, param2:SimpleWindow) : TitleWindow
      {
         var _loc3_:DODowngradeWindow = this.createWindow(param1,WINDOW_CENTERED,null,false) as DODowngradeWindow;
         this.downGradeWindowLayer.addElementAt(_loc3_,0);
         _loc3_.x = 1;
         _loc3_.y = 0;
         _loc3_.baseWindow = param2;
         _loc3_.title = param2.getTitle();
         param2.getRootContainer().removeChildAt(0);
         param2.getRootContainer().addChild(_loc3_);
         _loc3_.closeButton.visible = false;
         Label(_loc3_.titleDisplay).setStyle("left",33);
         Label(_loc3_.titleDisplay).setStyle("top",7);
         param2.getWindow().visible = false;
         if(param1 != COUNTDOWN_STATUS)
         {
            this.removeWindowFromList(param1);
         }
         return _loc3_;
      }
      
      public function destroyWindow(param1:String) : void
      {
         if(this.windowList[param1])
         {
            if(param1 == COUNTDOWN_STATUS)
            {
               if(ScreenManager.getInstance().map != null)
               {
                  TooltipControl.getInstance().removeStickyToolTip(GuiManager.instance.getWindow(GuiConstants.CURCUBITOR_COUNTDOWN_STATUS_WINDOW));
                  GuiManager.instance.destroyWindow(GuiConstants.CURCUBITOR_COUNTDOWN_STATUS_WINDOW);
               }
            }
            else
            {
               this.windowContainer.removeElement(this.windowList[param1]);
            }
            this.removeWindowFromList(param1);
         }
      }
      
      private function removeWindowFromList(param1:String) : void
      {
         delete this.windowList[param1];
      }
      
      public function destroyAllWindows() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.windowList)
         {
            if(_loc1_ == COUNTDOWN_STATUS)
            {
               this.destroyWindow(COUNTDOWN_STATUS);
            }
            else if(_loc1_ == WORD_PUZZLE)
            {
               this.destroyWindow(WORD_PUZZLE);
            }
            else
            {
               this.windowContainer.removeElement(this.windowList[_loc1_]);
               delete this.windowList[_loc1_];
            }
         }
      }
      
      public function getWindowByType(param1:String) : IFlexDisplayObject
      {
         if(this.windowList[param1])
         {
            return this.windowList[param1];
         }
         return null;
      }
      
      public function get windowList() : Dictionary
      {
         return this._windowList;
      }
      
      public function get windowContainer() : SkinnableContainer
      {
         return this._windowContainer;
      }
   }
}

