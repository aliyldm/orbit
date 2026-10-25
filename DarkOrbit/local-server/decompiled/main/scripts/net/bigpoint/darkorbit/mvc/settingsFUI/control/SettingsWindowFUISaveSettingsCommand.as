package net.bigpoint.darkorbit.mvc.settingsFUI.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.AudioSettingsModule;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.window.PopupWindow;
   import net.bigpoint.darkorbit.gui.KeyboardSendComponent;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyValuePair;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper;
   import net.bigpoint.darkorbit.managers.keyboardManager.commands.LogoutKeyboardCommand;
   import net.bigpoint.darkorbit.managers.keyboardManager.parser.SettingsWindowKeyboardParser;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsKeyBindingItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIVO;
   import net.bigpoint.darkorbit.net.netty.handlers.settings.AudioSettingsHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SettingsWindowFUISaveSettingsCommand extends DOAbstractSimpleCommand
   {
      
      private var _popupWindow:IWindow;
      
      public function SettingsWindowFUISaveSettingsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SettingsWindowFUIVO = null;
         if(param1.getBody() is SettingsWindowFUIVO)
         {
            _loc2_ = param1.getBody() as SettingsWindowFUIVO;
            this.saveDisplaySettingsTab(_loc2_);
            this.saveGameplaySettingsTab(_loc2_);
            this.saveInterfaceSettingsTab(_loc2_);
            this.saveSoundSettingsTab(_loc2_);
            this.saveKeyboardSettingsTab(_loc2_);
         }
      }
      
      private function popupCreated(param1:SimpleWindow, param2:DisplayObjectContainer) : void
      {
         this._popupWindow = param1;
         param1.maximize();
         (param1 as SimpleWindow).autoSize();
         var _loc3_:PopupWindow = new PopupWindow(param1,param2,this.handleRestartClientOk,this.handleRestartClientCancel);
      }
      
      private function handleRestartClientCancel() : void
      {
      }
      
      private function handleRestartClientOk() : void
      {
         new LogoutKeyboardCommand().execute(null,null);
      }
      
      private function saveDisplaySettingsTab(param1:SettingsWindowFUIVO) : void
      {
         var _loc2_:SimpleWindow = null;
         var _loc3_:SimpleContainer = null;
         var _loc4_:DisplayObjectContainer = null;
         if(Settings.FORCE_2D.value != param1.use2D)
         {
            _loc2_ = (guiManager.getWindow(GuiConstants.CONFIRMATION_POPUP) ? guiManager.getWindow(GuiConstants.CONFIRMATION_POPUP) : guiManager.createWindow(GuiConstants.CONFIRMATION_POPUP,new SimpleWindowCreationVO(GuiConstants.CONFIRMATION_POPUP,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
            _loc3_ = _loc2_.getContainer(0);
            _loc3_.removeAllElements();
            _loc4_ = new Sprite();
            _loc3_.addElement(_loc4_);
            EventStreamClient.track("switch_view",{"use2D":(param1.use2D ? 1 : 0)});
            UISystem.getInstance().loadAndBuildWithResKey("confirmationPopup",_loc4_,this.popupCreated,[_loc2_,_loc4_]);
         }
         Settings.FORCE_2D.value = param1.use2D;
         if(param1.use2D)
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
         guiManager.saveQualitySettings();
      }
      
      private function saveGameplaySettingsTab(param1:SettingsWindowFUIVO) : void
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
         guiManager.saveGameplaySettings();
      }
      
      private function saveInterfaceSettingsTab(param1:SettingsWindowFUIVO) : void
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
         Settings.proActionBarKeyboardInputEnabled = param1.proActionBarKeyboardInputEnabled;
         Settings.proActionBarAutohideEnabled = param1.proActionBarAutohideEnabled;
         guiManager.saveDisplaySettings();
      }
      
      private function saveSoundSettingsTab(param1:SettingsWindowFUIVO) : void
      {
         AudioSettingsHandler.run(new AudioSettingsModule(false,param1.soundEffectsVolume,param1.musicVolume,param1.boardcomputerVolume,param1.playCombatMusic),true);
         guiManager.saveAudioSettings();
      }
      
      private function saveKeyboardSettingsTab(param1:SettingsWindowFUIVO) : void
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

