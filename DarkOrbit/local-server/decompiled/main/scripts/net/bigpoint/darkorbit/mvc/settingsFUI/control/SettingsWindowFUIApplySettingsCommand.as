package net.bigpoint.darkorbit.mvc.settingsFUI.control
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.AudioSettingsModule;
   import net.bigpoint.darkorbit.gui.KeyboardSendComponent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyValuePair;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper;
   import net.bigpoint.darkorbit.managers.keyboardManager.parser.SettingsWindowKeyboardParser;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsKeyBindingItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIVO;
   import net.bigpoint.darkorbit.net.netty.handlers.settings.AudioSettingsHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SettingsWindowFUIApplySettingsCommand extends DOAbstractSimpleCommand
   {
      
      private const DISPLAY_SETTINGS_TAB:int = 0;
      
      private const GAMEPLAY_SETTINGS_TAB:int = 1;
      
      private const INTERFACE_SETTINGS_TAB:int = 2;
      
      private const SOUND_SETTINGS_TAB:int = 3;
      
      private const KEYBOARD_SETTINGS_TAB:int = 4;
      
      private var applySettingsFunctionDict:Dictionary = new Dictionary();
      
      public function SettingsWindowFUIApplySettingsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.applySettingsFunctionDict[this.DISPLAY_SETTINGS_TAB] = this.applyDisplaySettingsTab;
         this.applySettingsFunctionDict[this.GAMEPLAY_SETTINGS_TAB] = this.applyGameplaySettingsTab;
         this.applySettingsFunctionDict[this.INTERFACE_SETTINGS_TAB] = this.applyInterfaceSettingsTab;
         this.applySettingsFunctionDict[this.SOUND_SETTINGS_TAB] = this.applySoundSettingsTab;
         this.applySettingsFunctionDict[this.KEYBOARD_SETTINGS_TAB] = this.applyKeyboardSettingsTab;
         var _loc2_:SettingsWindowFUIVO = param1.getBody() as SettingsWindowFUIVO;
         this.applySettingsFunctionDict[this.DISPLAY_SETTINGS_TAB](_loc2_);
         this.applySettingsFunctionDict[this.GAMEPLAY_SETTINGS_TAB](_loc2_);
         this.applySettingsFunctionDict[this.INTERFACE_SETTINGS_TAB](_loc2_);
         this.applySettingsFunctionDict[this.SOUND_SETTINGS_TAB](_loc2_);
         this.applySettingsFunctionDict[this.KEYBOARD_SETTINGS_TAB](_loc2_);
      }
      
      private function applyDisplaySettingsTab(param1:SettingsWindowFUIVO) : void
      {
         if(Settings.FORCE_2D.value || !Settings.gpuSupport)
         {
            Settings.qualityBackground.value = param1.displaySetting2DqualityBackground;
            Settings.qualityPoizone.value = param1.displaySetting2DqualityZones;
            Settings.qualityShip.value = param1.displaySetting2DqualityShips;
            Settings.qualityEngine.value = param1.displaySetting2DqualityEngines;
            Settings.qualityExplosion.value = param1.displaySetting2DqualityExplosions;
            Settings.qualityCollectable.value = param1.displaySetting2DqualityResourcesAndBoxes;
         }
         else
         {
            Settings.displaySetting3DqualityAntialias.value = param1.displaySetting3DqualityAntialias;
            Settings.qualityBackground.value = param1.displaySetting3DqualityBackground;
            Settings.displaySetting3DqualityEffects.value = param1.displaySetting3DqualityEffects;
            Settings.displaySetting3DqualityLights.value = param1.displaySetting3DqualityLights;
            Settings.displaySetting3DqualityTextures.value = param1.displaySetting3DqualityTextures;
            Settings.qualityPoizone.value = param1.displaySetting3DqualityZones;
            Settings.displaySetting3DsizeTextures.value = param1.displaySetting3DsizeTextures;
            Settings.displaySetting3DtextureFiltering.value = param1.displaySetting3DtextureFiltering;
         }
         Settings.displaySettingPixelationMode.value = param1.displaySettingPixelationMode;
         Settings.preloadUserShips = param1.preloadShips;
         Settings.qualityCustomized = param1.advanced;
         Settings.qualityPresetting = param1.presettingDisplayQuality;
      }
      
      private function applyGameplaySettingsTab(param1:SettingsWindowFUIVO) : void
      {
         Settings.autoBoost = param1.autoWeaponsUpgrade;
         Settings.autochangeAmmo = param1.autoAmmoSwitch;
         Settings.autoRefinement = param1.autoRefine;
         Settings.quickSlotStopAttack = param1.startStopAttacksQuickbar;
         Settings.autoStartEnabled = param1.autoLogin;
         Settings.doubleclickAttackEnabled = param1.doubleClickAttack;
         Settings.autoBuyBootyKeys = param1.autoPurchaseGreenBootyKeys;
         Settings.displayBattlerayNotifications = param1.showBattlerayNotifcations;
         Settings.showLowHpWarnings = param1.showLowHpWarnings;
      }
      
      private function applyInterfaceSettingsTab(param1:SettingsWindowFUIVO) : void
      {
         Settings.displayPlayerNames.value = param1.showPlayerNames;
         Settings.displayResources.value = param1.showResources;
         Settings.displayBonusBoxes.value = param1.showBonusBoxes;
         Settings.displayHitpointBubbles = param1.showAscendingHitCount;
         Settings.showDrones.value = param1.showDrones;
         Settings.showMyDrones.value = param1.showMyDrones;
         Settings.displayFreeCargoBoxes.value = param1.showCargoBoxes;
         Settings.displayNotFreeCargoBoxes.value = param1.showCargoBoxesNotFree;
         Settings.displayMiniMapBackgroundImage.value = param1.showMinimapBackground;
         Settings.displayNotifications.value = param1.displayGamePerformanceMessages;
         Settings.allowAutoQuality.value = param1.autoQualityReduction;
         Settings.hoverShips.value = param1.hoverShips;
         Settings.displayChat.value = param1.showChat;
         Settings.dragWindowsAlways = param1.alwaysDraggableWindows;
         this.applyWindowsAlwaysDraggable();
         Settings.displayWindowsBackground.value = param1.showWindowBackgrounds;
         this.applyDisplayWindowsBackgroundUpdate();
         Settings.showPremiumQuickslotBar = param1.displayPremiumQuickslotBar;
         Settings.showNotOwnedItems = param1.showItemsNotOwned;
         Settings.proActionBarEnabled.value = param1.proActionBarEnabled;
         Settings.proActionBarAutohideEnabled = param1.proActionBarAutohideEnabled;
         Settings.proActionBarKeyboardInputEnabled = param1.proActionBarKeyboardInputEnabled;
      }
      
      private function applySoundSettingsTab(param1:SettingsWindowFUIVO) : void
      {
         AudioSettingsHandler.run(new AudioSettingsModule(false,param1.soundEffectsVolume,param1.musicVolume,param1.boardcomputerVolume,param1.playCombatMusic),true);
      }
      
      private function applyKeyboardSettingsTab(param1:SettingsWindowFUIVO) : void
      {
         var _loc5_:String = null;
         var _loc6_:KeyValuePair = null;
         var _loc2_:KeyboardMapper = KeyboardMapper.getInstance();
         _loc2_.cleanup();
         var _loc3_:SettingsWindowKeyboardParser = new SettingsWindowKeyboardParser();
         var _loc4_:KeyboardSendComponent = new KeyboardSendComponent(guiManager.getMain().getConnectionManager());
         for(_loc5_ in param1.keyBindings)
         {
            _loc6_ = new KeyValuePair();
            _loc6_.name = SettingsKeyBindingItemVO.actionIDToCommandName(int(_loc5_));
            _loc6_.keys = param1.keyBindings[int(_loc5_)] as Vector.<int>;
            _loc6_.args = new Vector.<String>();
            if(SettingsKeyBindingItemVO.commandNameToActionIds(_loc6_.name).indexOf(_loc5_) != -1)
            {
               _loc6_.args.push(SettingsKeyBindingItemVO.commandNameToActionIds(_loc6_.name).indexOf(_loc5_));
            }
            else
            {
               _loc6_.args.push("0");
            }
            _loc3_.addFullKeyValuePair(_loc6_);
            _loc4_.addAddKey(_loc6_);
         }
         _loc2_.addKeys(_loc3_);
         _loc4_.addKeys();
         _loc3_.reset();
      }
      
      private function applyDisplayWindowsBackgroundUpdate() : void
      {
         var _loc2_:Object = null;
         var _loc3_:SimpleWindow = null;
         var _loc1_:Dictionary = guiManager.windows;
         for(_loc2_ in _loc1_)
         {
            _loc3_ = _loc1_[_loc2_] as SimpleWindow;
            if(Settings.displayWindowsBackground.value)
            {
               _loc3_.removeListeners();
               _loc3_.fadeInWindow();
            }
            else
            {
               _loc3_.setListeners();
               _loc3_.fadeOutWindow();
            }
         }
      }
      
      private function applyWindowsAlwaysDraggable() : void
      {
         var _loc2_:Object = null;
         var _loc3_:SimpleWindow = null;
         var _loc1_:Dictionary = guiManager.windows;
         for(_loc2_ in _loc1_)
         {
            _loc3_ = _loc1_[_loc2_] as SimpleWindow;
            _loc3_.updateDraggerButtonMode();
         }
      }
   }
}

