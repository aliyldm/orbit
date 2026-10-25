package net.bigpoint.darkorbit.mvc.settingsFUI.model
{
   import flash.utils.Dictionary;
   
   public class SettingsWindowFUIVO
   {
      
      private var _preloadShips:Boolean;
      
      private var _use2D:Boolean;
      
      private var _advanced:Boolean;
      
      private var _presettingDisplayQuality:int;
      
      private var _displaySetting2DqualityBackground:int;
      
      private var _displaySetting2DqualityZones:int;
      
      private var _displaySetting2DqualityShips:int;
      
      private var _displaySetting2DqualityEngines:int;
      
      private var _displaySetting2DqualityExplosions:int;
      
      private var _displaySetting2DqualityResourcesAndBoxes:int;
      
      private var _displaySetting3DqualityAntialias:int;
      
      private var _displaySetting3DqualityLights:int;
      
      private var _displaySetting3DqualityTextures:int;
      
      private var _displaySetting3DsizeTextures:int;
      
      private var _displaySetting3DqualityEffects:int;
      
      private var _displaySetting3DtextureFiltering:int;
      
      private var _displaySetting3DqualityBackground:int;
      
      private var _displaySetting3DqualityZones:int;
      
      private var _displaySettingPixelationMode:Boolean;
      
      private var _autoWeaponsUpgrade:Boolean;
      
      private var _autoAmmoSwitch:Boolean;
      
      private var _autoRefine:Boolean;
      
      private var _startStopAttacksQuickbar:Boolean;
      
      private var _autoLogin:Boolean;
      
      private var _doubleClickAttack:Boolean;
      
      private var _autoPurchaseGreenBootyKeys:Boolean;
      
      private var _showBattlerayNotifcations:Boolean;
      
      private var _showLowHpWarnings:Boolean;
      
      private var _showPlayerNames:Boolean;
      
      private var _showResources:Boolean;
      
      private var _showBonusBoxes:Boolean;
      
      private var _showAscendingHitCount:Boolean;
      
      public var showDrones:Boolean;
      
      public var showMyDrones:Boolean;
      
      private var _showCargoBoxes:Boolean;
      
      private var _showCargoBoxesNotFree:Boolean;
      
      private var _showMinimapBackground:Boolean;
      
      private var _displayGamePerformanceMessages:Boolean;
      
      private var _autoQualityReduction:Boolean;
      
      private var _hoverShips:Boolean;
      
      private var _showChat:Boolean;
      
      private var _alwaysDraggableWindows:Boolean;
      
      private var _showWindowBackgrounds:Boolean;
      
      private var _displayPremiumQuickslotBar:Boolean;
      
      private var _showItemsNotOwned:Boolean;
      
      private var _proActionBarAutohideEnabled:Boolean;
      
      private var _proActionBarKeyboardInputEnabled:Boolean;
      
      private var _proActionBarEnabled:Boolean;
      
      private var _playCombatMusic:Boolean;
      
      private var _soundEffectsVolume:int;
      
      private var _musicVolume:int;
      
      private var _boardcomputerVolume:int;
      
      private var _keyBindings:Dictionary = new Dictionary();
      
      public function SettingsWindowFUIVO()
      {
         super();
      }
      
      public function set autoWeaponsUpgrade(param1:Boolean) : void
      {
         this._autoWeaponsUpgrade = param1;
      }
      
      public function get autoAmmoSwitch() : Boolean
      {
         return this._autoAmmoSwitch;
      }
      
      public function set autoAmmoSwitch(param1:Boolean) : void
      {
         this._autoAmmoSwitch = param1;
      }
      
      public function get autoRefine() : Boolean
      {
         return this._autoRefine;
      }
      
      public function set autoRefine(param1:Boolean) : void
      {
         this._autoRefine = param1;
      }
      
      public function get startStopAttacksQuickbar() : Boolean
      {
         return this._startStopAttacksQuickbar;
      }
      
      public function set startStopAttacksQuickbar(param1:Boolean) : void
      {
         this._startStopAttacksQuickbar = param1;
      }
      
      public function get autoLogin() : Boolean
      {
         return this._autoLogin;
      }
      
      public function set autoLogin(param1:Boolean) : void
      {
         this._autoLogin = param1;
      }
      
      public function get doubleClickAttack() : Boolean
      {
         return this._doubleClickAttack;
      }
      
      public function set doubleClickAttack(param1:Boolean) : void
      {
         this._doubleClickAttack = param1;
      }
      
      public function get autoPurchaseGreenBootyKeys() : Boolean
      {
         return this._autoPurchaseGreenBootyKeys;
      }
      
      public function set autoPurchaseGreenBootyKeys(param1:Boolean) : void
      {
         this._autoPurchaseGreenBootyKeys = param1;
      }
      
      public function get showBattlerayNotifcations() : Boolean
      {
         return this._showBattlerayNotifcations;
      }
      
      public function set showBattlerayNotifcations(param1:Boolean) : void
      {
         this._showBattlerayNotifcations = param1;
      }
      
      public function get showLowHpWarnings() : Boolean
      {
         return this._showLowHpWarnings;
      }
      
      public function set showLowHpWarnings(param1:Boolean) : void
      {
         this._showLowHpWarnings = param1;
      }
      
      public function get playCombatMusic() : Boolean
      {
         return this._playCombatMusic;
      }
      
      public function set playCombatMusic(param1:Boolean) : void
      {
         this._playCombatMusic = param1;
      }
      
      public function get autoWeaponsUpgrade() : Boolean
      {
         return this._autoWeaponsUpgrade;
      }
      
      public function get showPlayerNames() : Boolean
      {
         return this._showPlayerNames;
      }
      
      public function set showPlayerNames(param1:Boolean) : void
      {
         this._showPlayerNames = param1;
      }
      
      public function get showResources() : Boolean
      {
         return this._showResources;
      }
      
      public function set showResources(param1:Boolean) : void
      {
         this._showResources = param1;
      }
      
      public function get showBonusBoxes() : Boolean
      {
         return this._showBonusBoxes;
      }
      
      public function set showBonusBoxes(param1:Boolean) : void
      {
         this._showBonusBoxes = param1;
      }
      
      public function get showAscendingHitCount() : Boolean
      {
         return this._showAscendingHitCount;
      }
      
      public function set showAscendingHitCount(param1:Boolean) : void
      {
         this._showAscendingHitCount = param1;
      }
      
      public function get showCargoBoxes() : Boolean
      {
         return this._showCargoBoxes;
      }
      
      public function set showCargoBoxes(param1:Boolean) : void
      {
         this._showCargoBoxes = param1;
      }
      
      public function get showCargoBoxesNotFree() : Boolean
      {
         return this._showCargoBoxesNotFree;
      }
      
      public function set showCargoBoxesNotFree(param1:Boolean) : void
      {
         this._showCargoBoxesNotFree = param1;
      }
      
      public function get showMinimapBackground() : Boolean
      {
         return this._showMinimapBackground;
      }
      
      public function set showMinimapBackground(param1:Boolean) : void
      {
         this._showMinimapBackground = param1;
      }
      
      public function get displayGamePerformanceMessages() : Boolean
      {
         return this._displayGamePerformanceMessages;
      }
      
      public function set displayGamePerformanceMessages(param1:Boolean) : void
      {
         this._displayGamePerformanceMessages = param1;
      }
      
      public function get autoQualityReduction() : Boolean
      {
         return this._autoQualityReduction;
      }
      
      public function set autoQualityReduction(param1:Boolean) : void
      {
         this._autoQualityReduction = param1;
      }
      
      public function get hoverShips() : Boolean
      {
         return this._hoverShips;
      }
      
      public function set hoverShips(param1:Boolean) : void
      {
         this._hoverShips = param1;
      }
      
      public function get showChat() : Boolean
      {
         return this._showChat;
      }
      
      public function set showChat(param1:Boolean) : void
      {
         this._showChat = param1;
      }
      
      public function get alwaysDraggableWindows() : Boolean
      {
         return this._alwaysDraggableWindows;
      }
      
      public function set alwaysDraggableWindows(param1:Boolean) : void
      {
         this._alwaysDraggableWindows = param1;
      }
      
      public function get showWindowBackgrounds() : Boolean
      {
         return this._showWindowBackgrounds;
      }
      
      public function set showWindowBackgrounds(param1:Boolean) : void
      {
         this._showWindowBackgrounds = param1;
      }
      
      public function get displayPremiumQuickslotBar() : Boolean
      {
         return this._displayPremiumQuickslotBar;
      }
      
      public function set displayPremiumQuickslotBar(param1:Boolean) : void
      {
         this._displayPremiumQuickslotBar = param1;
      }
      
      public function get showItemsNotOwned() : Boolean
      {
         return this._showItemsNotOwned;
      }
      
      public function set showItemsNotOwned(param1:Boolean) : void
      {
         this._showItemsNotOwned = param1;
      }
      
      public function set proActionBarAutohideEnabled(param1:Boolean) : void
      {
         this._proActionBarAutohideEnabled = param1;
      }
      
      public function get proActionBarAutohideEnabled() : Boolean
      {
         return this._proActionBarAutohideEnabled;
      }
      
      public function set proActionBarKeyboardInputEnabled(param1:Boolean) : void
      {
         this._proActionBarKeyboardInputEnabled = param1;
      }
      
      public function get proActionBarKeyboardInputEnabled() : Boolean
      {
         return this._proActionBarKeyboardInputEnabled;
      }
      
      public function set proActionBarEnabled(param1:Boolean) : void
      {
         this._proActionBarEnabled = param1;
      }
      
      public function get proActionBarEnabled() : Boolean
      {
         return this._proActionBarEnabled;
      }
      
      public function get use2D() : Boolean
      {
         return this._use2D;
      }
      
      public function set use2D(param1:Boolean) : void
      {
         this._use2D = param1;
      }
      
      public function get preloadShips() : Boolean
      {
         return this._preloadShips;
      }
      
      public function set preloadShips(param1:Boolean) : void
      {
         this._preloadShips = param1;
      }
      
      public function get advanced() : Boolean
      {
         return this._advanced;
      }
      
      public function set advanced(param1:Boolean) : void
      {
         this._advanced = param1;
      }
      
      public function get displaySetting2DqualityBackground() : int
      {
         return this._displaySetting2DqualityBackground;
      }
      
      public function set displaySetting2DqualityBackground(param1:int) : void
      {
         this._displaySetting2DqualityBackground = param1;
      }
      
      public function get displaySetting2DqualityZones() : int
      {
         return this._displaySetting2DqualityZones;
      }
      
      public function set displaySetting2DqualityZones(param1:int) : void
      {
         this._displaySetting2DqualityZones = param1;
      }
      
      public function get displaySetting2DqualityShips() : int
      {
         return this._displaySetting2DqualityShips;
      }
      
      public function set displaySetting2DqualityShips(param1:int) : void
      {
         this._displaySetting2DqualityShips = param1;
      }
      
      public function get displaySetting2DqualityEngines() : int
      {
         return this._displaySetting2DqualityEngines;
      }
      
      public function set displaySetting2DqualityEngines(param1:int) : void
      {
         this._displaySetting2DqualityEngines = param1;
      }
      
      public function get displaySetting2DqualityExplosions() : int
      {
         return this._displaySetting2DqualityExplosions;
      }
      
      public function set displaySetting2DqualityExplosions(param1:int) : void
      {
         this._displaySetting2DqualityExplosions = param1;
      }
      
      public function get displaySetting2DqualityResourcesAndBoxes() : int
      {
         return this._displaySetting2DqualityResourcesAndBoxes;
      }
      
      public function set displaySetting2DqualityResourcesAndBoxes(param1:int) : void
      {
         this._displaySetting2DqualityResourcesAndBoxes = param1;
      }
      
      public function get displaySetting3DqualityAntialias() : int
      {
         return this._displaySetting3DqualityAntialias;
      }
      
      public function set displaySetting3DqualityAntialias(param1:int) : void
      {
         this._displaySetting3DqualityAntialias = param1;
      }
      
      public function get displaySetting3DqualityLights() : int
      {
         return this._displaySetting3DqualityLights;
      }
      
      public function set displaySetting3DqualityLights(param1:int) : void
      {
         this._displaySetting3DqualityLights = param1;
      }
      
      public function get displaySetting3DqualityTextures() : int
      {
         return this._displaySetting3DqualityTextures;
      }
      
      public function set displaySetting3DqualityTextures(param1:int) : void
      {
         this._displaySetting3DqualityTextures = param1;
      }
      
      public function get displaySetting3DsizeTextures() : int
      {
         return this._displaySetting3DsizeTextures;
      }
      
      public function set displaySetting3DsizeTextures(param1:int) : void
      {
         this._displaySetting3DsizeTextures = param1;
      }
      
      public function get displaySetting3DqualityEffects() : int
      {
         return this._displaySetting3DqualityEffects;
      }
      
      public function set displaySetting3DqualityEffects(param1:int) : void
      {
         this._displaySetting3DqualityEffects = param1;
      }
      
      public function get displaySetting3DtextureFiltering() : int
      {
         return this._displaySetting3DtextureFiltering;
      }
      
      public function set displaySetting3DtextureFiltering(param1:int) : void
      {
         this._displaySetting3DtextureFiltering = param1;
      }
      
      public function get displaySetting3DqualityBackground() : int
      {
         return this._displaySetting3DqualityBackground;
      }
      
      public function set displaySetting3DqualityBackground(param1:int) : void
      {
         this._displaySetting3DqualityBackground = param1;
      }
      
      public function get displaySetting3DqualityZones() : int
      {
         return this._displaySetting3DqualityZones;
      }
      
      public function set displaySetting3DqualityZones(param1:int) : void
      {
         this._displaySetting3DqualityZones = param1;
      }
      
      public function get displaySettingPixelationMode() : Boolean
      {
         return this._displaySettingPixelationMode;
      }
      
      public function set displaySettingPixelationMode(param1:Boolean) : void
      {
         this._displaySettingPixelationMode = param1;
      }
      
      public function get presettingDisplayQuality() : int
      {
         return this._presettingDisplayQuality;
      }
      
      public function set presettingDisplayQuality(param1:int) : void
      {
         this._presettingDisplayQuality = param1;
      }
      
      public function get soundEffectsVolume() : int
      {
         return this._soundEffectsVolume;
      }
      
      public function set soundEffectsVolume(param1:int) : void
      {
         this._soundEffectsVolume = param1;
      }
      
      public function get musicVolume() : int
      {
         return this._musicVolume;
      }
      
      public function set musicVolume(param1:int) : void
      {
         this._musicVolume = param1;
      }
      
      public function get boardcomputerVolume() : int
      {
         return this._boardcomputerVolume;
      }
      
      public function set boardcomputerVolume(param1:int) : void
      {
         this._boardcomputerVolume = param1;
      }
      
      public function get keyBindings() : Dictionary
      {
         return this._keyBindings;
      }
      
      public function set keyBindings(param1:Dictionary) : void
      {
         this._keyBindings = param1;
      }
      
      public function clone() : SettingsWindowFUIVO
      {
         var _loc2_:String = null;
         var _loc1_:SettingsWindowFUIVO = new SettingsWindowFUIVO();
         _loc1_.advanced = this.advanced;
         _loc1_.alwaysDraggableWindows = this.alwaysDraggableWindows;
         _loc1_.autoAmmoSwitch = this.autoAmmoSwitch;
         _loc1_.autoLogin = this.autoLogin;
         _loc1_.autoPurchaseGreenBootyKeys = this.autoPurchaseGreenBootyKeys;
         _loc1_.autoQualityReduction = this.autoQualityReduction;
         _loc1_.autoRefine = this.autoRefine;
         _loc1_.autoWeaponsUpgrade = this.autoWeaponsUpgrade;
         _loc1_.boardcomputerVolume = this.boardcomputerVolume;
         _loc1_.displayGamePerformanceMessages = this.displayGamePerformanceMessages;
         _loc1_.displayPremiumQuickslotBar = this.displayPremiumQuickslotBar;
         _loc1_.displaySetting2DqualityBackground = this.displaySetting2DqualityBackground;
         _loc1_.displaySetting2DqualityEngines = this.displaySetting2DqualityEngines;
         _loc1_.displaySetting2DqualityExplosions = this.displaySetting2DqualityExplosions;
         _loc1_.displaySetting2DqualityResourcesAndBoxes = this.displaySetting2DqualityResourcesAndBoxes;
         _loc1_.displaySetting2DqualityShips = this.displaySetting2DqualityShips;
         _loc1_.displaySetting2DqualityZones = this.displaySetting2DqualityZones;
         _loc1_.displaySetting3DqualityAntialias = this.displaySetting3DqualityAntialias;
         _loc1_.displaySetting3DqualityEffects = this.displaySetting3DqualityEffects;
         _loc1_.displaySetting3DqualityLights = this.displaySetting3DqualityLights;
         _loc1_.displaySetting3DqualityTextures = this.displaySetting3DqualityTextures;
         _loc1_.displaySetting3DsizeTextures = this.displaySetting3DsizeTextures;
         _loc1_.displaySetting3DtextureFiltering = this.displaySetting3DtextureFiltering;
         _loc1_.displaySetting3DqualityBackground = this.displaySetting3DqualityBackground;
         _loc1_.displaySetting3DqualityZones = this.displaySetting3DqualityZones;
         _loc1_.displaySettingPixelationMode = this.displaySettingPixelationMode;
         _loc1_.doubleClickAttack = this.doubleClickAttack;
         _loc1_.hoverShips = this.hoverShips;
         _loc1_.keyBindings = new Dictionary();
         for(_loc2_ in this.keyBindings)
         {
            _loc1_.keyBindings[_loc2_] = (this.keyBindings[_loc2_] as Vector.<int>).concat();
         }
         _loc1_.musicVolume = this.musicVolume;
         _loc1_.playCombatMusic = this.playCombatMusic;
         _loc1_.preloadShips = this.preloadShips;
         _loc1_.presettingDisplayQuality = this.presettingDisplayQuality;
         _loc1_.showAscendingHitCount = this.showAscendingHitCount;
         _loc1_.showBattlerayNotifcations = this.showBattlerayNotifcations;
         _loc1_.showLowHpWarnings = this.showLowHpWarnings;
         _loc1_.showBonusBoxes = this.showBonusBoxes;
         _loc1_.showCargoBoxes = this.showCargoBoxes;
         _loc1_.showCargoBoxesNotFree = this.showCargoBoxesNotFree;
         _loc1_.showChat = this.showChat;
         _loc1_.showDrones = this.showDrones;
         _loc1_.showMyDrones = this.showMyDrones;
         _loc1_.showItemsNotOwned = this.showItemsNotOwned;
         _loc1_.proActionBarEnabled = this.proActionBarEnabled;
         _loc1_.proActionBarAutohideEnabled = this.proActionBarAutohideEnabled;
         _loc1_.proActionBarKeyboardInputEnabled = this.proActionBarKeyboardInputEnabled;
         _loc1_.showMinimapBackground = this.showMinimapBackground;
         _loc1_.showPlayerNames = this.showPlayerNames;
         _loc1_.showResources = this.showResources;
         _loc1_.showWindowBackgrounds = this.showWindowBackgrounds;
         _loc1_.soundEffectsVolume = this.soundEffectsVolume;
         _loc1_.startStopAttacksQuickbar = this.startStopAttacksQuickbar;
         _loc1_.use2D = this.use2D;
         return _loc1_;
      }
   }
}

