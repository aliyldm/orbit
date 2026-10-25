package net.bigpoint.darkorbit.mvc.battlestationswindow.model
{
   import mx.collections.ArrayCollection;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.AsteroidProgressCommand;
   import net.bigpoint.darkorbit.com.module.AvailableModulesCommand;
   import net.bigpoint.darkorbit.com.module.BattleStationBuildingStateCommand;
   import net.bigpoint.darkorbit.com.module.BattleStationStatusCommand;
   import net.bigpoint.darkorbit.com.module.BuildStationRequest;
   import net.bigpoint.darkorbit.com.module.DeflectorShieldStatusChangeRequest;
   import net.bigpoint.darkorbit.com.module.EmergencyRepairRequest;
   import net.bigpoint.darkorbit.com.module.EquipModuleRequest;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.StationModuleModule;
   import net.bigpoint.darkorbit.com.module.UnequipModuleRequest;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationViewNotifications;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithCountdownTimer;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class BattleStationProxy extends Proxy implements IProxy, IFrameObserver
   {
      
      public static var clanLookup:Array;
      
      public static const NAME:String = "BattleStationProxy";
      
      private static const UPDATE_INTERVAL:int = 1;
      
      public var connMan:ConnectionManager;
      
      private var _uiIsOpen:Boolean = false;
      
      private var _availableModules:ArrayCollection;
      
      private var _battleStationVO:BattleStationVO;
      
      private var _addedFrameObserver:Boolean;
      
      private var _deflectorStatusVO:DeflectorStatusVO;
      
      private var _buildMinMaxIncrement:MinMaxIncrementVO;
      
      private var _deflectorMinMaxIncrement:MinMaxIncrementVO;
      
      private var _inventoryFilterOptions:Vector.<InventoryFilterOptionVO>;
      
      private var _filterInventoryDelegate:Boolean = false;
      
      public function BattleStationProxy()
      {
         clanLookup = [];
         clanLookup[FactionModule.FACTION_NONE] = "factionLogoNeutral";
         clanLookup[FactionModule.FACTION_EIC] = "factionLogoEIC";
         clanLookup[FactionModule.FACTION_MMO] = "factionLogoMMO";
         clanLookup[FactionModule.FACTION_VRU] = "factionLogoVRU";
         super(NAME);
      }
      
      public static function randomWithinRange(param1:Number, param2:Number) : Number
      {
         return Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
      }
      
      public function initPlayerModulesModel(param1:AvailableModulesCommand) : void
      {
         if(this._availableModules == null || this._availableModules.length == 0)
         {
            this.updateBattleStationModuleModel(param1);
         }
      }
      
      public function updateBattleStationModuleModel(param1:AvailableModulesCommand) : void
      {
         var _loc3_:StationModuleModule = null;
         var _loc4_:ModuleVO = null;
         this._filterInventoryDelegate = false;
         this._availableModules = new ArrayCollection();
         var _loc2_:int = 0;
         while(_loc2_ < param1.modules.length)
         {
            _loc3_ = param1.modules[_loc2_];
            _loc4_ = new ModuleVO();
            _loc4_.init(_loc3_);
            this._availableModules.addItem(_loc4_);
            _loc2_++;
         }
         if(this._uiIsOpen)
         {
            sendNotification(BattleStationNotification.FILTER_INVENTORY);
         }
      }
      
      public function initManagementUIModelForBattleStation(param1:BattleStationStatusCommand, param2:String = null, param3:Boolean = true) : void
      {
         this._battleStationVO = new BattleStationVO();
         this._battleStationVO.battleStationName = param2;
         this._battleStationVO.state = BattleStationVO.BATTLE_STATION_STATE;
         this._battleStationVO.initAllModules(param1.equipment);
         this._battleStationVO.mapAssetId = param1.mapAssetId;
         this._battleStationVO.battleStationId = param1.battleStationId;
         this._battleStationVO.deflectorShieldActive = param1.deflectorShieldActive;
         this._battleStationVO.deflectorShieldRate = param1.deflectorShieldRate;
         this._battleStationVO.attackRating = param1.attackRating;
         this._battleStationVO.defenceRating = param1.defenceRating;
         this._battleStationVO.repairRating = param1.repairRating;
         this._battleStationVO.honorBoosterRating = param1.honorBoosterRating;
         this._battleStationVO.experienceBoosterRating = param1.experienceBoosterRating;
         this._battleStationVO.damageBoosterRating = param1.damageBoosterRating;
         this._deflectorStatusVO = new DeflectorStatusVO(param1.deflectorShieldActive,param1.deflectorShieldSeconds,param1.deflectorShieldSecondsMax,param1.deflectorShieldRate);
         this._battleStationVO.deflectorStatusVO = this._deflectorStatusVO;
         this._battleStationVO.oreTradeAvailable = param1.isOreTradeAvailable;
         this.startDeflectorShieldCountdown();
         if(this._uiIsOpen)
         {
            if(param3)
            {
               sendNotification(BattleStationNotification.INIT_BATTLE_STATION_MANAGEMENT_WINDOW,this._battleStationVO);
            }
            else
            {
               sendNotification(BattleStationNotification.UPDATE_INSTALLED_MODULES,this._battleStationVO);
            }
         }
      }
      
      public function initBuildingUIModelForAsteroid(param1:int, param2:int, param3:String, param4:AsteroidProgressCommand) : void
      {
         this._battleStationVO = new BattleStationVO();
         this._battleStationVO.state = BattleStationVO.ASTEROID_STATE;
         this._battleStationVO.mapAssetId = param1;
         this._battleStationVO.battleStationId = param2;
         this._battleStationVO.battleStationName = param3;
         this.initAsteroidInstallProgress(param4);
         if(this._uiIsOpen)
         {
            sendNotification(BattleStationNotification.INIT_BATTLE_STATION_BUILD_WINDOW,this._battleStationVO);
         }
      }
      
      public function initAsteroidInstallProgress(param1:AsteroidProgressCommand) : void
      {
         if(this._battleStationVO == null)
         {
            return;
         }
         this._battleStationVO.initAllModules(param1.state);
         this._battleStationVO.ownProgress = param1.ownProgress;
         this._battleStationVO.owningClanName = param1.ownClanName;
         this._battleStationVO.bestProgress = param1.bestProgress;
         this._battleStationVO.bestProgressClanName = param1.bestProgressClanName;
         this._battleStationVO.buildable = param1.buildButtonActive;
         if(this._uiIsOpen)
         {
            sendNotification(BattleStationNotification.INIT_BATTLE_STATION_BUILD_WINDOW,this._battleStationVO);
         }
      }
      
      public function requestUnEquipModuleFromAsteroid(param1:Array) : void
      {
         this._filterInventoryDelegate = true;
         var _loc2_:int = int(param1[0]);
         var _loc3_:int = int(param1[1]);
         var _loc4_:UnequipModuleRequest = new UnequipModuleRequest();
         _loc4_.battleStationId = _loc2_;
         _loc4_.itemId = _loc3_;
         this.connMan.sendRequest(_loc4_);
      }
      
      public function requestEquipModuleToAsteroid(param1:Array) : void
      {
         if(this._filterInventoryDelegate)
         {
            return;
         }
         var _loc2_:int = int(param1[0]);
         var _loc3_:int = int(param1[1]);
         var _loc4_:int = int(param1[2]);
         var _loc5_:Boolean = Boolean(param1[3]);
         var _loc6_:EquipModuleRequest = new EquipModuleRequest();
         _loc6_.battleStationId = _loc2_;
         _loc6_.itemId = _loc4_;
         _loc6_.slotId = _loc3_;
         _loc6_.replace = _loc5_;
         this.connMan.sendRequest(_loc6_);
      }
      
      public function updateBattleStationEquippedModules(param1:Array = null, param2:Array = null) : void
      {
      }
      
      public function setBattleStationUIClosed() : void
      {
         this._uiIsOpen = false;
      }
      
      public function handleEquipModuleError(param1:uint) : void
      {
         sendNotification(BattleStationNotification.DISPLAY_ERROR_MESSAGE,param1);
      }
      
      public function requestBeginBuildBattleStation(param1:Array) : void
      {
         var _loc2_:BuildStationRequest = new BuildStationRequest();
         _loc2_.battleStationId = param1[0] as int;
         _loc2_.buildTimeInMinutes = param1[1] as int;
         this.connMan.sendRequest(_loc2_);
      }
      
      public function requestDeactivateDeflector(param1:Array) : void
      {
         var _loc2_:DeflectorShieldStatusChangeRequest = new DeflectorShieldStatusChangeRequest();
         _loc2_.battleStationId = param1[0] as int;
         _loc2_.minutes = param1[1] as int;
         this.connMan.sendRequest(_loc2_);
      }
      
      public function setBattleStationToBuildState(param1:BattleStationBuildingStateCommand) : void
      {
         if(this._battleStationVO == null)
         {
            this._battleStationVO = new BattleStationVO();
            this._battleStationVO.battleStationId = param1.battleStationId;
            this._battleStationVO.mapAssetId = param1.mapAssetId;
         }
         this._battleStationVO.state = BattleStationVO.BUILD_IN_PROGRESS_STATE;
         this._battleStationVO.owningClanFaction = param1.affiliatedFaction.faction;
         this._battleStationVO.owningClanName = param1.ownerClan;
         this._battleStationVO.buildTimeLeft = param1.secondsLeft;
         this._battleStationVO.startBuildProgressCountdown(this._battleStationVO.buildTimeLeft);
         this._battleStationVO.startBuildProgressCountdown(param1.secondsLeft);
         if(this._uiIsOpen)
         {
            this.closeBattleStationWindows();
            this.displayBuildProgressWindow(this._battleStationVO);
         }
         sendNotification(BattleStationViewNotifications.OPEN_BUILDING_UI_BUBBLE,this._battleStationVO.mapAssetId);
      }
      
      public function displayBuildProgressWindow(param1:BattleStationVO) : void
      {
         var _loc2_:PopUpWithCountdownTimer = PopUpWithCountdownTimer(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_COUNTDOWN_TIMER));
         _loc2_.title = param1.battleStationName;
         _loc2_.setPopupText(BPLocale.getItem("popup_bswin_message_battle_station_build_time"),BPLocale.getItem("popup_bswin_title_battle_station_build_time"),param1.owningClanName);
         _loc2_.setClanImage(param1.owningClanFactionStyle);
         _loc2_.setProgressBarProgress(param1.timeLeft,0);
      }
      
      public function requestModuleRepair(param1:Array) : void
      {
         var _loc2_:EmergencyRepairRequest = new EmergencyRepairRequest();
         _loc2_.battleStationId = param1[0] as int;
         _loc2_.slotId = param1[1] as int;
         this.connMan.sendRequest(_loc2_);
      }
      
      public function updateTimer(param1:Number) : void
      {
         this._deflectorStatusVO.summedTpf += param1;
         var _loc2_:int = 1000 * UPDATE_INTERVAL;
         while(this._deflectorStatusVO.summedTpf > _loc2_)
         {
            this._deflectorStatusVO.summedTpf -= _loc2_;
            if(this._deflectorStatusVO.deflectorShieldSeconds <= 0)
            {
               ScreenManager.removeObserver(this);
            }
            else if(this._deflectorStatusVO.deflectorShieldActive)
            {
               this._deflectorStatusVO.decreaseeDeflectorShieldSeconds(1);
            }
            else
            {
               this._deflectorStatusVO.increaseDeflectorShieldSeconds(this._deflectorStatusVO.deflectorShieldRate / 60 * UPDATE_INTERVAL);
            }
         }
         if(this._deflectorStatusVO.summedTpf < 0)
         {
            return;
         }
         sendNotification(BattleStationNotification.UPDATE_DEFLECTOR_TIME_PROGRESS,this._deflectorStatusVO);
      }
      
      public function startDeflectorShieldCountdown() : void
      {
         if(!this._addedFrameObserver)
         {
            ScreenManager.addObserver(this);
            this._addedFrameObserver = true;
         }
      }
      
      public function get availableModules() : ArrayCollection
      {
         return this._availableModules;
      }
      
      public function get buildMinMaxIncrement() : MinMaxIncrementVO
      {
         return this._buildMinMaxIncrement;
      }
      
      public function set buildMinMaxIncrement(param1:MinMaxIncrementVO) : void
      {
         this._buildMinMaxIncrement = param1;
      }
      
      public function get deflectorMinMaxIncrement() : MinMaxIncrementVO
      {
         return this._deflectorMinMaxIncrement;
      }
      
      public function set deflectorMinMaxIncrement(param1:MinMaxIncrementVO) : void
      {
         this._deflectorMinMaxIncrement = param1;
      }
      
      public function updateInstalledModulesStats(param1:ModuleStatusVO) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ModuleVO = null;
         if(this._battleStationVO)
         {
            if(param1.asteroidId == this._battleStationVO.battleStationId)
            {
               _loc2_ = 0;
               while(_loc2_ != this._battleStationVO.modules.length)
               {
                  if(this._battleStationVO.modules[_loc2_].slotOccupying == param1.slotId)
                  {
                     _loc3_ = this._battleStationVO.modules[_loc2_].clone();
                     _loc3_.currentHitpoints = param1.hitpoints;
                     _loc3_.maxHitpoints = param1.hitpointsMax;
                     _loc3_.currentShield = param1.shield;
                     _loc3_.maxShield = param1.shieldMax;
                     _loc3_.emergencyRepairSecondsLeft = param1.emergencyRepairSecondsLeft;
                     _loc3_.emergencyRepairSecondsTotal = param1.emergencyRepairSecondsTotal;
                     _loc3_.installationSecondsLeft = param1.installationSecondsLeft;
                     this._battleStationVO.modules[_loc2_] = _loc3_;
                     sendNotification(BattleStationNotification.UPDATE_MODULE_HITPOINTS_AND_SHIELD,_loc3_);
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      public function closeBattleStationWindows() : void
      {
         this._uiIsOpen = false;
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BS_POP_UP_CONFIRM_MODULE_REMOVAL);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BS_POP_UP_WITH_SELECTION_SLIDER);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BS_POP_UP_WITH_ERROR_MESSAGE);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BS_POP_UP_WITH_COUNTDOWN_TIMER);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BS_POP_UP_WITH_ACTIVATION);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BS_POP_UP_WITH_NO_CLAN_MESSAGE);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BATTLE_STATION_BUILD_WINDOW);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BS_POP_UP_WITH_INVENTORY_FILTER);
      }
      
      public function get battleStationVO() : BattleStationVO
      {
         return this._battleStationVO;
      }
      
      public function get uiIsOpen() : Boolean
      {
         return this._uiIsOpen;
      }
      
      public function set uiIsOpen(param1:Boolean) : void
      {
         this._uiIsOpen = param1;
      }
      
      public function updateInventoryFilterOption(param1:InventoryFilterOptionVO) : void
      {
         var _loc2_:InventoryFilterOptionVO = null;
         for each(_loc2_ in this._inventoryFilterOptions)
         {
            if(_loc2_.category == param1.category)
            {
               _loc2_.selected = _loc2_.selected;
            }
         }
      }
      
      public function get inventoryFilterOptions() : Vector.<InventoryFilterOptionVO>
      {
         if(!this._inventoryFilterOptions)
         {
            this._inventoryFilterOptions = new <InventoryFilterOptionVO>[new InventoryFilterOptionVO(BattleStationConstants.HULL_CATEGORY),new InventoryFilterOptionVO(BattleStationConstants.DEFLECTOR_CATEGORY),new InventoryFilterOptionVO(BattleStationConstants.ENGINEERING_BAY_CATEGORY),new InventoryFilterOptionVO(BattleStationConstants.LASERS_CATEGORY),new InventoryFilterOptionVO(BattleStationConstants.ROCKETS_CATEGORY),new InventoryFilterOptionVO(BattleStationConstants.BOOSTERS_CATEGORY),new InventoryFilterOptionVO(BattleStationConstants.SHOW_ALL)];
         }
         return this._inventoryFilterOptions;
      }
      
      public function get isAnyFilterOptionUnselected() : Boolean
      {
         var _loc1_:int = int(this.inventoryFilterOptions.length);
         var _loc2_:int = 0;
         while(_loc2_ != _loc1_)
         {
            if(!this.inventoryFilterOptions[_loc2_].selected)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}

