package net.bigpoint.darkorbit.mvc.settingsFUI.view
{
   import com.greensock.TweenNano;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import flash.system.System;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Mouse;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.com.module.ResetSettingsRequest;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.bars.SliderNStepsEvent;
   import net.bigpoint.darkorbit.fui.components.bars.TabBarEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxEvent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBoxEvent;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.configurationModePopup.ConfigModePopupMediator;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.configurationModePopup.components.ConfigModePopup;
   import net.bigpoint.darkorbit.mvc.settingsFUI.SettingsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsCheckBoxItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsDropDownBoxItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsKeyBindingItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsSliderNStepsItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIVO;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.patterns.observer.Notification;
   
   public class SettingsWindowFUIMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "SettingsWindowFUIMediator";
      
      private var _window:SimpleWindow;
      
      private var _updatingView:Boolean = false;
      
      public function SettingsWindowFUIMediator(param1:SettingsWindowFUI, param2:SimpleWindow)
      {
         super(NAME,param1);
         this._window = param2;
         this._window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.handleWindowMinimizedEvent);
         this.view.tabbar.addEventListener(TabBarEvent.EVENT_SELECTION_CHANGED,this.handleSelectedTabChanged);
         this.view.saveSettingsButton.addEventListener(MouseEvent.CLICK,this.handleSaveCurrentSettingsClicked);
         this.view.cancelSettingsButton.addEventListener(MouseEvent.CLICK,this.handleCancelSettingsClicked);
         this.view.resetSettingsButton.addEventListener(MouseEvent.CLICK,this.handleResetSettingsClicked);
         this.view.use2D.addEventListener(MouseEvent.CLICK,this.handleUse2Dchanged);
         this.view.advanced.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleAdvancedChanged);
         this.view.presettingQuality.addEventListener(SliderNStepsEvent.SLIDER_VALUE_CHANGED,this.handlePresettingSliderValueChanged);
         this.view.displaySetting2DQualityBackground.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting2DQualityBackgroundChanged);
         this.view.displaySetting2DQualityBackground.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting2DQualityZones.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting2DQualityZonesChanged);
         this.view.displaySetting2DQualityZones.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting2DQualityShips.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting2DQualityShipsChanged);
         this.view.displaySetting2DQualityShips.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting2DQualityEngines.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting2DQualityEnginesChanged);
         this.view.displaySetting2DQualityEngines.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting2DQualityExplosions.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting2DQualityExplosionsChanged);
         this.view.displaySetting2DQualityExplosions.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting2DQualityResourcesAndBoxes.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting2DQualityResourcesAndBoxesChanged);
         this.view.displaySetting2DQualityResourcesAndBoxes.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting3dQualityAntialias.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting3DQualityAntialiasChanged);
         this.view.displaySetting3dQualityAntialias.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting3dQualityLights.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting3DQualityLightsChanged);
         this.view.displaySetting3dQualityLights.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting3dQualityTextures.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting3DQualityTexturesChanged);
         this.view.displaySetting3dQualityTextures.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting3dSizeTextures.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting3DSizeTexturesChanged);
         this.view.displaySetting3dSizeTextures.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting3dQualityEffects.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting3DQualityEffectsChanged);
         this.view.displaySetting3dQualityEffects.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting3dTextureFiltering.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting3DTextureFilteringChanged);
         this.view.displaySetting3dTextureFiltering.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting3dQualityBackground.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting3DQualityBackgroundChanged);
         this.view.displaySetting3dQualityBackground.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySetting3dQualityZones.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.handleDisplaySetting3DQualityZonesChanged);
         this.view.displaySetting3dQualityZones.addEventListener(DropDownBoxEvent.DROPPED_DOWN,this.handleDisplaySettingDropDownBoxDroppedDown);
         this.view.displaySettingPixelationMode.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleDisplaySetting3DPixelationModeChanged);
         this.view.autoWeaponsUpgrade.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleAutoWeaponsUpgradeChanged);
         this.view.autoAmmoSwitch.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleAutoAmmoSwitchChanged);
         this.view.autoRefine.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleAutoRefineChanged);
         this.view.startStopAttacksQuickBar.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleStartStopAttacksQuickBarChanged);
         this.view.autoLogin.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleAutoLoginChanged);
         this.view.doubleClickAttack.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleDoubleClickAttackChanged);
         this.view.autoPurchaseGreenBootyKeys.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleAutoPurchaseGreenBootyKeysChanged);
         this.view.showBattlerayNotifications.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleShowBattlerayNotificationsChanged);
         this.view.showLowHpWarning.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleShowLowHpWarningChanged);
         this.view.interfaceSettingsItemList.addEventListener(SettingsWindowEvent.LISTED_CHECKBOX_CHANGED,this.handleListedInterfaceCheckboxChanged);
         this.view.interfaceConfigureButton.addEventListener(MouseEvent.CLICK,this.handleInterfaceConfigureButtonClicked);
         this.view.playCombatMusic.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handlePlayCombatMusicChanged);
         this.view.soundEffectVolume.addEventListener(SliderNStepsEvent.SLIDER_VALUE_CHANGED,this.handleSoundEffectsVolumeSliderValueChanged);
         this.view.musicVolume.addEventListener(SliderNStepsEvent.SLIDER_VALUE_CHANGED,this.handleMusicVolumeSliderValueChanged);
         this.view.boardcomputerVolume.addEventListener(SliderNStepsEvent.SLIDER_VALUE_CHANGED,this.handleBoardcomputerVolumeSliderValueChanged);
         this.view.keyboardSettingsItemList.addEventListener(SettingsWindowEvent.LISTED_KEYBINDING_CHANGED,this.handleListedKeybindingChanged);
         this.view.keyboardSettingsItemList.addEventListener(SettingsWindowEvent.NOW_LISTENING_FOR_KEYBINDING,this.handleListeningToKeybinding);
         this.updateUse2Dvisibility();
         this.handleSelectedTabChanged();
         mapNotificationToMethod(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_MODEL_CHANGED,this.updateViewWithChangedModel);
         mapNotificationToMethod(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON,this.enableSaveButton);
      }
      
      private function handleWindowMinimizedEvent(param1:SimpleWindowEvent) : void
      {
         GuiManager.instance.saveAudioSettings(null);
      }
      
      private function enableSaveButton(param1:Notification) : void
      {
         this.view.saveSettingsButton.enabled = true;
      }
      
      private function handleListeningToKeybinding(param1:SettingsWindowEvent) : void
      {
         this.view.keyboardSettingsDescriptionLabel.visible = true;
      }
      
      public function startBusyAnimation() : void
      {
         this.view.busyMC.visible = true;
         this.view.baseCorepontent.filters = [new BlurFilter()];
         TweenNano.delayedCall(1,this.endBusyAnim);
      }
      
      private function endBusyAnim() : void
      {
         this.view.baseCorepontent.filters = [];
         this.view.busyMC.visible = false;
      }
      
      private function handleCancelSettingsClicked(param1:Event) : void
      {
         this.handleCancelled();
         this.view.saveSettingsButton.enabled = false;
         this.startBusyAnimation();
      }
      
      private function handleCancelled(param1:Event = null) : void
      {
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_CANCEL_SETTINGS);
      }
      
      private function handleResetSettingsClicked(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = null;
         var _loc3_:SimpleContainer = null;
         var _loc6_:TextField = null;
         _loc2_ = guiManager.createWindow(GuiConstants.RESET_PROMPT_WINDOW,new SimpleWindowCreationVO(GuiConstants.RESET_PROMPT_WINDOW,null,SimpleWindow.OPEN_STRATEGY_LAYER_2)) as SimpleWindow;
         guiManager.getMain().screenManager.getWindowLayer2().addChild(_loc2_);
         _loc3_ = new SimpleContainer(guiManager,SimpleContainer.CLASS_PROMPT);
         var _loc4_:TextFieldElement = new TextFieldElement(280,80,new TextFormat(),"");
         var _loc5_:TextFormat = new TextFormat(Styles.plainBigFmt.font,Styles.plainBigFontHeight,16777215);
         _loc5_.align = TextFormatAlign.CENTER;
         _loc6_ = _loc4_.textField;
         _loc6_.defaultTextFormat = _loc5_;
         _loc6_.embedFonts = Styles.plainBigEmbed;
         _loc6_.antiAliasType = AntiAliasType.ADVANCED;
         _loc6_.autoSize = TextFieldAutoSize.CENTER;
         _loc6_.wordWrap = true;
         _loc6_.multiline = true;
         _loc6_.width = 280;
         _loc6_.text = BPLocale.getItem("resetSettings");
         _loc3_.addElement(_loc4_);
         _loc3_.x = 16;
         _loc3_.y = 32;
         var _loc7_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc8_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_OK,BPLocale.getItem("dest_ok"),_loc7_.getEmbeddedMovieClip("button1"));
         _loc8_.addEventListener(MouseEvent.CLICK,this.handleConfirmResetSettingsButtonClick);
         _loc3_.addElement(_loc8_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc8_.x -= _loc8_.width;
         var _loc9_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_CANCEL,BPLocale.getItem("btn_cancel"),_loc7_.getEmbeddedMovieClip("button1"));
         _loc9_.addEventListener(MouseEvent.CLICK,this.handleResetSettingsCancel);
         _loc3_.addElement(_loc9_,SimpleContainer.ALIGN_HORIZONTAL);
         _loc2_.addContainer(_loc3_);
         _loc2_.activateModalLayer(true);
      }
      
      private function handleConfirmResetSettingsButtonClick(param1:MouseEvent) : void
      {
         guiManager.getMain().getConnectionManager().sendRequest(new ResetSettingsRequest());
         JavascriptProxy.call(JavascriptProxy.FUNCTION_CLOSE_CHILD_WINDOW,[false],System.exit,[0]);
      }
      
      private function closeResetSettingsWindow() : void
      {
         var _loc5_:SimpleElement = null;
         var _loc6_:ButtonElement = null;
         var _loc1_:SimpleWindow = guiManager.getWindow(GuiConstants.RESET_PROMPT_WINDOW);
         var _loc2_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_PROMPT);
         var _loc3_:Array = _loc2_.getAllElements();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.getID() == SimpleElement.TYPE_SIMPLE_BUTTON)
            {
               _loc6_ = ButtonElement(_loc5_);
               if(_loc6_.getID() == ButtonElementTypes.TYPE_OK)
               {
                  _loc6_.removeEventListener(MouseEvent.CLICK,this.handleConfirmResetSettingsButtonClick);
               }
               if(_loc6_.getID() == ButtonElementTypes.TYPE_CANCEL)
               {
                  _loc6_.removeEventListener(MouseEvent.CLICK,this.handleResetSettingsCancel);
               }
            }
            _loc4_++;
         }
         guiManager.closeWindow(_loc1_);
      }
      
      private function handleResetSettingsCancel(param1:MouseEvent) : void
      {
         this.closeResetSettingsWindow();
      }
      
      private function notifyUserSettingChanged(param1:Object) : void
      {
         if(!this._updatingView)
         {
            sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_SETTING_CHANGED,param1);
         }
      }
      
      private function updateViewWithChangedModel(param1:Notification) : void
      {
         var interfaceListEntries:Vector.<SettingsCheckBoxItemVO> = null;
         var keybindingListEntries:Vector.<SettingsKeyBindingItemVO> = null;
         var notification:Notification = param1;
         var model:SettingsWindowFUIVO = notification.getBody() as SettingsWindowFUIVO;
         var wasUpdating:Boolean = this._updatingView;
         this._updatingView = true;
         try
         {
            this.view.use2D.selection = model.use2D;
            this.view.advanced.selection = model.advanced;
            this.view.presettingQuality.currentStep = model.presettingDisplayQuality + 1;
            this.view.displaySetting2DQualityBackground.currentEntry = model.displaySetting2DqualityBackground;
            this.view.displaySetting2DQualityZones.currentEntry = Math.min(2,model.displaySetting2DqualityZones);
            this.view.displaySetting2DQualityShips.currentEntry = Math.min(1,model.displaySetting2DqualityShips);
            this.view.displaySetting2DQualityEngines.currentEntry = model.displaySetting2DqualityEngines;
            this.view.displaySetting2DQualityExplosions.currentEntry = model.displaySetting2DqualityExplosions;
            this.view.displaySetting2DQualityResourcesAndBoxes.currentEntry = Math.min(2,model.displaySetting2DqualityResourcesAndBoxes);
            this.view.displaySetting3dQualityAntialias.currentEntry = model.displaySetting3DqualityAntialias;
            this.view.displaySetting3dQualityLights.currentEntry = model.displaySetting3DqualityLights;
            this.view.displaySetting3dQualityTextures.currentEntry = model.displaySetting3DqualityTextures;
            this.view.displaySetting3dSizeTextures.currentEntry = model.displaySetting3DsizeTextures;
            this.view.displaySetting3dQualityEffects.currentEntry = model.displaySetting3DqualityEffects;
            this.view.displaySetting3dTextureFiltering.currentEntry = model.displaySetting3DtextureFiltering;
            this.view.displaySetting3dQualityBackground.currentEntry = model.displaySetting3DqualityBackground;
            this.view.displaySetting3dQualityZones.currentEntry = model.displaySetting3DqualityZones;
            this.view.displaySettingPixelationMode.selection = model.displaySettingPixelationMode;
            this.view.autoWeaponsUpgrade.selection = model.autoWeaponsUpgrade;
            this.view.autoAmmoSwitch.selection = model.autoAmmoSwitch;
            this.view.autoRefine.selection = model.autoRefine;
            this.view.startStopAttacksQuickBar.selection = model.startStopAttacksQuickbar;
            this.view.autoLogin.selection = model.autoLogin;
            this.view.doubleClickAttack.selection = model.doubleClickAttack;
            this.view.autoPurchaseGreenBootyKeys.selection = model.autoPurchaseGreenBootyKeys;
            this.view.showBattlerayNotifications.selection = model.showBattlerayNotifcations;
            this.view.showLowHpWarning.selection = model.showLowHpWarnings;
            interfaceListEntries = new Vector.<SettingsCheckBoxItemVO>();
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_PLAYER_NAMES,model.showPlayerNames,"sett_setting5",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_RESOURCES,model.showResources,"sett_setting8",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_BONUS_BOXES,model.showBonusBoxes,"sett_setting9",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_ASCENDING_HIT_COUNT,model.showAscendingHitCount,"sett_setting12",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_DRONES,model.showDrones,"sett_setting18",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_MY_DRONES,model.showMyDrones,"sett_show_my_drones",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_CARGO_BOXES,model.showCargoBoxes,"sett_setting20",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_CARGO_BOXES_NOT_FREE,model.showCargoBoxesNotFree,"sett_setting21",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_MINIMAP_BACKGROUND,model.showMinimapBackground,"setting_minimap_background_image",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_DISPLAY_GAME_PERFORMANCE_MESSAGES,model.displayGamePerformanceMessages,"setting_displayNotifications",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_QUALITY_REDUCTION,model.autoQualityReduction,"setting_allow_auto_quality","ttip_setting_allow_auto_quality"));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_HOVER_SHIPS,model.hoverShips,"setting_hover_ships","ttip_setting_hover_ships"));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_CHAT,model.showChat,"sett_setting14",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_ALWAYS_DRAGGABLE_WINDOWS,model.alwaysDraggableWindows,"setting_alwaysDraggableWindows",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_WINDOW_BACKGROUNDS,model.showWindowBackgrounds,"setting_displayWindowsBackground",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_DISPLAY_PREMIUM_QUICKSLOT_BAR,model.displayPremiumQuickslotBar,"setting_display_premium_quickslot","ttip_setting_premium_quickslot"));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_ITEMS_NOT_OWNED,model.showItemsNotOwned,"setting_show_not_owned_items",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_ENABLED,model.proActionBarEnabled,"setting_pro_action_bar_enabled",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_AUTOHIDE_ENABLED,model.proActionBarAutohideEnabled,"setting_auto_hide_pro_action_bar_enabled",null));
            interfaceListEntries.push(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_KEYBOARD_INPUT_ENABLED,model.proActionBarKeyboardInputEnabled,"pro_action_bar_keyboard_input_enabled",null));
            this.view.interfaceSettingsItemList.list = new VectorCollection(interfaceListEntries);
            this.view.playCombatMusic.selection = model.playCombatMusic;
            this.view.soundEffectVolume.currentStep = model.soundEffectsVolume;
            this.view.musicVolume.currentStep = model.musicVolume;
            this.view.boardcomputerVolume.currentStep = model.boardcomputerVolume;
            keybindingListEntries = new Vector.<SettingsKeyBindingItemVO>();
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_1,"keyboard_action_activate_slot",1));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_2,"keyboard_action_activate_slot",2));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_3,"keyboard_action_activate_slot",3));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_4,"keyboard_action_activate_slot",4));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_5,"keyboard_action_activate_slot",5));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_6,"keyboard_action_activate_slot",6));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_7,"keyboard_action_activate_slot",7));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_8,"keyboard_action_activate_slot",8));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_9,"keyboard_action_activate_slot",9));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_QUICKSLOT_0,"keyboard_action_activate_slot",0));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_1,"keyboard_action_activate_premium_slot",1));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_2,"keyboard_action_activate_premium_slot",2));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_3,"keyboard_action_activate_premium_slot",3));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_4,"keyboard_action_activate_premium_slot",4));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_5,"keyboard_action_activate_premium_slot",5));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_6,"keyboard_action_activate_premium_slot",6));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_7,"keyboard_action_activate_premium_slot",7));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_8,"keyboard_action_activate_premium_slot",8));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_9,"keyboard_action_activate_premium_slot",9));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PREMIUM_QUICKSLOT_0,"keyboard_action_activate_premium_slot",0));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_ACTIVATE_JUMP_GATE,"keyboard_action_activate_jump_gate"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_SWITCH_CONFIG,"keyboard_action_toggle_config"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_LASER_ATTACK,"keyboard_action_laser_attack"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_ROCKET_ATTACK,"keyboard_action_rocket_attack"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PET_ACTIVATE,"keyboard_action_activate_pet"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PET_GUARD_MODE,"keyboard_action_guard_mode"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_PET_REPAIR_SHIP,"keyboard_action_combo_repair_mode"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_LOGOUT,"keyboard_action_logout"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_MINIMIZE_MAXIMIZE_ALL_WINDOWS,"keyboard_action_toggle_windows"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_TOGGLE_DISPLAY_FPS,"keyboard_action_toggle_monitoring"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_ZOOM_IN,"keyboard_action_zoom_in"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_ZOOM_OUT,"keyboard_action_zoom_out"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_FOCUS_CHAT,"keyboard_action_focus_chat"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_CATEGORY_BAR,"keyboard_action_toggle_category_bar"));
            keybindingListEntries.push(this.getKeyBiVO(model,SettingsKeyBindingItemVO.SETTINGS_KEYBINDING_ID_SHOW_PRO_ACTION_BAR,"keyboard_action_show_pro_action_bar"));
            this.view.keyboardSettingsItemList.list = new VectorCollection(keybindingListEntries);
            this.updateUse2Dvisibility();
            this.view.saveSettingsButton.enabled = false;
         }
         finally
         {
            this._updatingView = wasUpdating;
         }
      }
      
      private function getKeyBiVO(param1:SettingsWindowFUIVO, param2:int, param3:String, param4:int = -1) : SettingsKeyBindingItemVO
      {
         if(param1.keyBindings[param2] is int)
         {
            return new SettingsKeyBindingItemVO(param2,param3,param1.keyBindings[param2],param4);
         }
         var _loc5_:Vector.<int> = param1.keyBindings[param2] as Vector.<int>;
         if((Boolean(_loc5_)) && _loc5_.length > 0)
         {
            return new SettingsKeyBindingItemVO(param2,param3,_loc5_[0],param4);
         }
         return new SettingsKeyBindingItemVO(param2,param3,-1,param4);
      }
      
      private function handleInterfaceConfigureButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:ConfigModePopup = ConfigModePopup(FlexWindowManager.getInstance().createWindow(FlexWindowManager.MENU_CONFIG_MODE_POPUP,FlexWindowManager.WINDOW_CENTERED));
         if(!facade.hasMediator(ConfigModePopupMediator.NAME))
         {
            facade.registerMediator(new ConfigModePopupMediator(_loc2_));
         }
         sendNotification(GuiNotifications.MANAGE_MENUS_CONFIG_MODE,true);
         sendNotification(GuiNotifications.MINIMIZE_WINDOW_BY_ID,GuiConstants.SETTINGS_WINDOW);
      }
      
      private function handleDisplaySettingDropDownBoxDroppedDown(param1:DropDownBoxEvent) : void
      {
         var _loc2_:DropDownBox = null;
         for each(_loc2_ in this.view.displayDropDownBoxesVector)
         {
            if(_loc2_ != param1.target)
            {
               _loc2_.forceCollapse();
            }
         }
      }
      
      private function handleDisplaySetting2DQualityBackgroundChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_BACKGROUND,param1.index));
      }
      
      private function handleDisplaySetting2DQualityZonesChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_ZONES,param1.index));
      }
      
      private function handleDisplaySetting2DQualityShipsChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_SHIPS,param1.index));
      }
      
      private function handleDisplaySetting2DQualityEnginesChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_ENGINES,param1.index));
      }
      
      private function handleDisplaySetting2DQualityExplosionsChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_EXPLOSIONS,param1.index));
      }
      
      private function handleDisplaySetting2DQualityResourcesAndBoxesChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_RESOURCES_AND_BOXES,param1.index));
      }
      
      private function handleDisplaySetting3DQualityAntialiasChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_ANTIALIAS,param1.index));
      }
      
      private function handleDisplaySetting3DQualityLightsChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_LIGHTS,param1.index));
      }
      
      private function handleDisplaySetting3DQualityTexturesChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_TEXTURES,param1.index));
      }
      
      private function handleDisplaySetting3DSizeTexturesChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_SIZE_TEXTURES,param1.index));
      }
      
      private function handleDisplaySetting3DQualityEffectsChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_EFFECTS,param1.index));
      }
      
      private function handleDisplaySetting3DTextureFilteringChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_TEXTURE_FILTERING,param1.index));
      }
      
      private function handleDisplaySetting3DQualityBackgroundChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_BACKGROUND,param1.index));
      }
      
      private function handleDisplaySetting3DQualityZonesChanged(param1:DropDownBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsDropDownBoxItemVO(SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_ZONES,param1.index));
      }
      
      private function handleDisplaySetting3DPixelationModeChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_3D_CHECK_BOX_ID_PIXELATION_MODE,this.view.displaySettingPixelationMode.selection));
      }
      
      private function handlePresettingSliderValueChanged(param1:SliderNStepsEvent) : void
      {
         var _loc4_:Vector.<String> = null;
         var _loc2_:int = param1.value;
         var _loc3_:int = param1.maxValue;
         if(!this.view.advanced.selection)
         {
            _loc4_ = new <String>["quality_low","quality_medium","quality_good","quality_high"];
            this.view.presettingQualityLabel.text = BPLocale.getItem(_loc4_[_loc2_ - 1]);
         }
         else
         {
            this.view.presettingQualityLabel.text = BPLocale.getItem("quality_custom");
         }
         this.notifyUserSettingChanged(new SettingsSliderNStepsItemVO(SettingsSliderNStepsItemVO.SETTINGS_SLIDER_N_STEPS_ID_PRESETTINGS,_loc2_,_loc3_));
      }
      
      private function handleSoundEffectsVolumeSliderValueChanged(param1:SliderNStepsEvent) : void
      {
         var _loc2_:int = param1.value;
         var _loc3_:int = param1.maxValue;
         this.notifyUserSettingChanged(new SettingsSliderNStepsItemVO(SettingsSliderNStepsItemVO.SETTINGS_SLIDER_N_STEPS_ID_SOUND_EFFECTS_VOLUME,_loc2_,_loc3_));
      }
      
      private function handleMusicVolumeSliderValueChanged(param1:SliderNStepsEvent) : void
      {
         var _loc2_:int = param1.value;
         var _loc3_:int = param1.maxValue;
         this.notifyUserSettingChanged(new SettingsSliderNStepsItemVO(SettingsSliderNStepsItemVO.SETTINGS_SLIDER_N_STEPS_ID_MUSIC_VOLUME,_loc2_,_loc3_));
      }
      
      private function handleBoardcomputerVolumeSliderValueChanged(param1:SliderNStepsEvent) : void
      {
         var _loc2_:int = param1.value;
         var _loc3_:int = param1.maxValue;
         this.notifyUserSettingChanged(new SettingsSliderNStepsItemVO(SettingsSliderNStepsItemVO.SETTINGS_SLIDER_N_STEPS_ID_BOARDCOMPUTER_VOLUME,_loc2_,_loc3_));
      }
      
      override public function onRegister() : void
      {
         this.updateUse2Dvisibility();
         this._window.addEventListener(SimpleWindowEvent.ON_MINIMIZED,this.handleCancelled);
      }
      
      private function updateUse2Dvisibility() : void
      {
         if(Settings.has3DCapabilities)
         {
            this.view.use2D.visible = true;
            this.view.use2DLabel.visible = true;
         }
         else
         {
            this.view.use2D.enabled = false;
            this.view.use2D.mouseEnabled = true;
            this.view.use2D.tooltipTemplateID = "commonui_tooltip_simple";
            this.view.use2D.tooltipDataAssigner = new DefaultTooltipDataAssigner();
            this.view.use2D.tooltipData = BPLocale.getItem("ttip_3d_not_available");
            this.view.use2D.addEventListener(MouseEvent.ROLL_OVER,this.show3DnotAvailableTooltip);
            this.view.use2DLabel.localizedText = "setting_use3D";
         }
         if(this.view.advanced.selection)
         {
            this.view.displaySettings2DContainer.visible = !this.view.use2D.visible || this.view.use2D.selection;
            this.view.displaySettings3DContainer.visible = !this.view.displaySettings2DContainer.visible;
         }
         else
         {
            this.view.displaySettings2DContainer.visible = false;
            this.view.displaySettings3DContainer.visible = false;
            this.view.displaySettingPixelationModeLabel.visible = false;
         }
         this.view.displaySettingPixelationMode.visible = this.view.advanced.selection;
         this.view.displaySettingPixelationModeLabel.visible = this.view.advanced.selection;
      }
      
      private function show3DnotAvailableTooltip(param1:MouseEvent) : void
      {
         Mouse.cursor = "arrow";
         UISystem.getInstance().tooltipManager.assignTooltipTemplateID(this.view.use2D.tooltipTemplateID,this.view.use2D);
      }
      
      private function handleUse2Dchanged(param1:MouseEvent = null) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_USE2D,this.view.use2D.selection));
      }
      
      private function handleAdvancedChanged(param1:CheckBoxEvent = null) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_ADVANCED,this.view.advanced.selection));
         this.updateUse2Dvisibility();
      }
      
      private function handleAutoWeaponsUpgradeChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_WEAPONS_UPGRADE,this.view.autoWeaponsUpgrade.selection));
      }
      
      private function handleAutoAmmoSwitchChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_AMMO_SWITCH,this.view.autoAmmoSwitch.selection));
      }
      
      private function handleAutoRefineChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_REFINE,this.view.autoRefine.selection));
      }
      
      private function handleStartStopAttacksQuickBarChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_START_STOP_ATTACKS_QUICKBAR,this.view.startStopAttacksQuickBar.selection));
      }
      
      private function handleAutoLoginChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_LOGIN,this.view.autoLogin.selection));
      }
      
      private function handleDoubleClickAttackChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_DOUBLECLICK_ATTACK,this.view.doubleClickAttack.selection));
      }
      
      private function handleAutoPurchaseGreenBootyKeysChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_PURCHASE_GREEN_BOOTYKEYS,this.view.autoPurchaseGreenBootyKeys.selection));
      }
      
      private function handleShowBattlerayNotificationsChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_BATTLERAY_NOTIFICATIONS,this.view.showBattlerayNotifications.selection));
      }
      
      private function handleShowLowHpWarningChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_LOW_HP_WARNING,this.view.showLowHpWarning.selection));
      }
      
      private function handleListedInterfaceCheckboxChanged(param1:SettingsWindowEvent) : void
      {
         this.notifyUserSettingChanged(param1.data);
      }
      
      private function handleListedKeybindingChanged(param1:SettingsWindowEvent) : void
      {
         var _loc4_:SettingsKeyBindingItemVO = null;
         this.view.keyboardSettingsDescriptionLabel.visible = false;
         var _loc2_:SettingsKeyBindingItemVO = param1.data as SettingsKeyBindingItemVO;
         var _loc3_:int = 0;
         while(_loc3_ < this.view.keyboardSettingsItemList.list.length)
         {
            _loc4_ = this.view.keyboardSettingsItemList.list.getItemAt(_loc3_) as SettingsKeyBindingItemVO;
            if(_loc2_.boundKeyCode == _loc4_.boundKeyCode && _loc2_.keybindingActionID != _loc4_.keybindingActionID)
            {
               _loc4_.boundKeyCode = -1;
               this.view.keyboardSettingsItemList.forceRedraw(InvalidationType.FILLITEMS);
               this.notifyUserSettingChanged(_loc4_);
            }
            _loc3_++;
         }
         this.notifyUserSettingChanged(param1.data);
      }
      
      private function handlePlayCombatMusicChanged(param1:CheckBoxEvent) : void
      {
         this.notifyUserSettingChanged(new SettingsCheckBoxItemVO(SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PLAY_COMBAT_MUSIC,this.view.playCombatMusic.selection));
      }
      
      private function handleSelectedTabChanged(param1:TabBarEvent = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.view.tabContainersVector.length)
         {
            this.view.tabContainersVector[_loc2_].visible = this.view.tabbar.currentlyActiveTab == _loc2_;
            _loc2_++;
         }
         this.view.keyboardSettingsItemList.dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.TAB_SWITCHED,null));
         this.view.keyboardSettingsDescriptionLabel.visible = false;
      }
      
      private function handleSaveCurrentSettingsClicked(param1:MouseEvent) : void
      {
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_SAVE_SETTINGS_USER_REQUEST,this.view.tabbar.currentlyActiveTab);
         this.view.saveSettingsButton.enabled = false;
         this.startBusyAnimation();
      }
      
      private function get view() : SettingsWindowFUI
      {
         return viewComponent as SettingsWindowFUI;
      }
   }
}

