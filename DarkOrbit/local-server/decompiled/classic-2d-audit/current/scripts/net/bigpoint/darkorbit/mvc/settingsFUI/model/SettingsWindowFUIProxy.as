package net.bigpoint.darkorbit.mvc.settingsFUI.model
{
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.mvc.settingsFUI.SettingsWindowNotifications;
   import net.bigpoint.darkorbit.settings.BindableSettings;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SettingsWindowFUIProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "SettingsWindowFUIProxy";
      
      private var _backup_model:SettingsWindowFUIVO = null;
      
      public function SettingsWindowFUIProxy(param1:SettingsWindowFUIVO)
      {
         super(NAME,param1);
      }
      
      public function handleSaveSettingsUserRequest(param1:int) : void
      {
         this.preserveUneditedQuality();
         this._backup_model = this.model.clone();
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_SAVE_SETTINGS,this.model);
      }
      
      private function preserveUneditedQuality() : void
      {
         var _loc2_:String = null;
         if(!this._backup_model)
         {
            return;
         }
         var _loc1_:Object = {
            "displaySetting2DqualityBackground":Settings.qualityBackground.value,
            "displaySetting3DqualityBackground":Settings.qualityBackground.value,
            "displaySetting2DqualityZones":Settings.qualityPoizone.value,
            "displaySetting3DqualityZones":Settings.qualityPoizone.value,
            "displaySetting2DqualityShips":Settings.qualityShip.value,
            "displaySetting2DqualityEngines":Settings.qualityEngine.value,
            "displaySetting2DqualityExplosions":Settings.qualityExplosion.value,
            "displaySetting2DqualityResourcesAndBoxes":Settings.qualityCollectable.value
         };
         for(_loc2_ in _loc1_)
         {
            if(this.model[_loc2_] == this._backup_model[_loc2_])
            {
               this.model[_loc2_] = _loc1_[_loc2_];
            }
         }
      }
      
      public function handleCheckBoxValueChangedInWindow(param1:SettingsCheckBoxItemVO) : void
      {
         switch(param1.checkBoxId)
         {
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_ADVANCED:
               if(this.model.advanced != param1.checkBoxSelected)
               {
                  this.model.advanced = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_USE2D:
               if(this.model.use2D != param1.checkBoxSelected)
               {
                  this.model.use2D = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PRELOAD_SHIPS:
               if(this.model.preloadShips != param1.checkBoxSelected)
               {
                  this.model.preloadShips = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_3D_CHECK_BOX_ID_PIXELATION_MODE:
               if(this.model.displaySettingPixelationMode != param1.checkBoxSelected)
               {
                  this.model.displaySettingPixelationMode = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_WEAPONS_UPGRADE:
               if(this.model.autoWeaponsUpgrade != param1.checkBoxSelected)
               {
                  this.model.autoWeaponsUpgrade = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_AMMO_SWITCH:
               if(this.model.autoAmmoSwitch != param1.checkBoxSelected)
               {
                  this.model.autoAmmoSwitch = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_REFINE:
               if(this.model.autoRefine != param1.checkBoxSelected)
               {
                  this.model.autoRefine = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_START_STOP_ATTACKS_QUICKBAR:
               if(this.model.startStopAttacksQuickbar != param1.checkBoxSelected)
               {
                  this.model.startStopAttacksQuickbar = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_LOGIN:
               if(this.model.autoLogin != param1.checkBoxSelected)
               {
                  this.model.autoLogin = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_DOUBLECLICK_ATTACK:
               if(this.model.doubleClickAttack != param1.checkBoxSelected)
               {
                  this.model.doubleClickAttack = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_PURCHASE_GREEN_BOOTYKEYS:
               if(this.model.autoPurchaseGreenBootyKeys != param1.checkBoxSelected)
               {
                  this.model.autoPurchaseGreenBootyKeys = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_BATTLERAY_NOTIFICATIONS:
               if(this.model.showBattlerayNotifcations != param1.checkBoxSelected)
               {
                  this.model.showBattlerayNotifcations = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_LOW_HP_WARNING:
               if(this.model.showLowHpWarnings != param1.checkBoxSelected)
               {
                  this.model.showLowHpWarnings = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_PLAYER_NAMES:
               if(this.model.showPlayerNames != param1.checkBoxSelected)
               {
                  this.model.showPlayerNames = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_RESOURCES:
               if(this.model.showResources != param1.checkBoxSelected)
               {
                  this.model.showResources = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_BONUS_BOXES:
               if(this.model.showBonusBoxes != param1.checkBoxSelected)
               {
                  this.model.showBonusBoxes = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_ASCENDING_HIT_COUNT:
               if(this.model.showAscendingHitCount != param1.checkBoxSelected)
               {
                  this.model.showAscendingHitCount = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_DRONES:
               if(this.model.showDrones != param1.checkBoxSelected)
               {
                  this.model.showDrones = param1.checkBoxSelected;
                  this.model.showMyDrones = param1.checkBoxSelected;
                  Settings.showMyDrones.value = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               Settings.showDrones.value = param1.checkBoxSelected;
               return;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_MY_DRONES:
               if(this.model.showMyDrones != param1.checkBoxSelected)
               {
                  this.model.showMyDrones = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               Settings.showMyDrones.value = param1.checkBoxSelected;
               return;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_CARGO_BOXES:
               if(this.model.showCargoBoxes != param1.checkBoxSelected)
               {
                  this.model.showCargoBoxes = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_CARGO_BOXES_NOT_FREE:
               if(this.model.showCargoBoxesNotFree != param1.checkBoxSelected)
               {
                  this.model.showCargoBoxesNotFree = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_MINIMAP_BACKGROUND:
               if(this.model.showMinimapBackground != param1.checkBoxSelected)
               {
                  this.model.showMinimapBackground = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_DISPLAY_GAME_PERFORMANCE_MESSAGES:
               if(this.model.displayGamePerformanceMessages != param1.checkBoxSelected)
               {
                  this.model.displayGamePerformanceMessages = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_AUTO_QUALITY_REDUCTION:
               if(this.model.autoQualityReduction != param1.checkBoxSelected)
               {
                  this.model.autoQualityReduction = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_HOVER_SHIPS:
               if(this.model.hoverShips != param1.checkBoxSelected)
               {
                  this.model.hoverShips = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_CHAT:
               if(this.model.showChat != param1.checkBoxSelected)
               {
                  this.model.showChat = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_ALWAYS_DRAGGABLE_WINDOWS:
               if(this.model.alwaysDraggableWindows != param1.checkBoxSelected)
               {
                  this.model.alwaysDraggableWindows = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_WINDOW_BACKGROUNDS:
               if(this.model.showWindowBackgrounds != param1.checkBoxSelected)
               {
                  this.model.showWindowBackgrounds = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_DISPLAY_PREMIUM_QUICKSLOT_BAR:
               if(this.model.displayPremiumQuickslotBar != param1.checkBoxSelected)
               {
                  this.model.displayPremiumQuickslotBar = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_ENABLED:
               if(this.model.proActionBarEnabled != param1.checkBoxSelected)
               {
                  this.model.proActionBarEnabled = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_AUTOHIDE_ENABLED:
               if(this.model.proActionBarAutohideEnabled != param1.checkBoxSelected)
               {
                  this.model.proActionBarAutohideEnabled = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PRO_ACTION_BAR_KEYBOARD_INPUT_ENABLED:
               if(this.model.proActionBarKeyboardInputEnabled != param1.checkBoxSelected)
               {
                  this.model.proActionBarKeyboardInputEnabled = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_SHOW_ITEMS_NOT_OWNED:
               if(this.model.showItemsNotOwned != param1.checkBoxSelected)
               {
                  this.model.showItemsNotOwned = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
               break;
            case SettingsCheckBoxItemVO.SETTINGS_CHECK_BOX_ID_PLAY_COMBAT_MUSIC:
               if(this.model.playCombatMusic != param1.checkBoxSelected)
               {
                  this.model.playCombatMusic = param1.checkBoxSelected;
                  sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
               }
         }
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_MODEL_CHANGES,this.model);
      }
      
      private function get model() : SettingsWindowFUIVO
      {
         return super.getData() as SettingsWindowFUIVO;
      }
      
      public function handleDropDownBoxValueChangedInWindow(param1:SettingsDropDownBoxItemVO) : void
      {
         switch(param1.dropDownBoxId)
         {
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_BACKGROUND:
               this.model.displaySetting2DqualityBackground = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_ZONES:
               this.model.displaySetting2DqualityZones = param1.selectedIndex;
               if(param1.selectedIndex == 2)
               {
                  this.model.displaySetting2DqualityZones = Settings.QUALITY_HIGH;
               }
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_SHIPS:
               this.model.displaySetting2DqualityShips = param1.selectedIndex;
               if(param1.selectedIndex == 1)
               {
                  this.model.displaySetting2DqualityShips = Settings.QUALITY_HIGH;
               }
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_ENGINES:
               this.model.displaySetting2DqualityEngines = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_EXPLOSIONS:
               this.model.displaySetting2DqualityExplosions = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_2D_QUALITY_RESOURCES_AND_BOXES:
               this.model.displaySetting2DqualityResourcesAndBoxes = param1.selectedIndex;
               if(param1.selectedIndex == 1)
               {
                  this.model.displaySetting2DqualityResourcesAndBoxes = Settings.QUALITY_HIGH;
               }
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_ANTIALIAS:
               this.model.displaySetting3DqualityAntialias = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_LIGHTS:
               this.model.displaySetting3DqualityLights = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_TEXTURES:
               this.model.displaySetting3DqualityTextures = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_SIZE_TEXTURES:
               this.model.displaySetting3DsizeTextures = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_EFFECTS:
               this.model.displaySetting3DqualityEffects = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_TEXTURE_FILTERING:
               this.model.displaySetting3DtextureFiltering = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_BACKGROUND:
               this.model.displaySetting3DqualityBackground = param1.selectedIndex;
               break;
            case SettingsDropDownBoxItemVO.SETTINGS_DROP_DOWN_BOX_ID_DISPLAY_SETTING_3D_QUALITY_ZONES:
               this.model.displaySetting3DqualityZones = param1.selectedIndex;
         }
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_MODEL_CHANGES,this.model);
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
      }
      
      public function handleSliderNStepsValueChangedInWindow(param1:SettingsSliderNStepsItemVO) : void
      {
         switch(param1.sliderNStepsId)
         {
            case SettingsSliderNStepsItemVO.SETTINGS_SLIDER_N_STEPS_ID_PRESETTINGS:
               this.model.presettingDisplayQuality = param1.sliderValue - 1;
               this.updateModelWithDisplayQualityPresetting();
               break;
            case SettingsSliderNStepsItemVO.SETTINGS_SLIDER_N_STEPS_ID_SOUND_EFFECTS_VOLUME:
               this.model.soundEffectsVolume = param1.sliderValue;
               break;
            case SettingsSliderNStepsItemVO.SETTINGS_SLIDER_N_STEPS_ID_MUSIC_VOLUME:
               this.model.musicVolume = param1.sliderValue;
               break;
            case SettingsSliderNStepsItemVO.SETTINGS_SLIDER_N_STEPS_ID_BOARDCOMPUTER_VOLUME:
               this.model.boardcomputerVolume = param1.sliderValue;
         }
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_MODEL_CHANGES,this.model);
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
      }
      
      private function updateModelWithDisplayQualityPresetting() : void
      {
         switch(this.model.presettingDisplayQuality)
         {
            case Settings.QUALITY_LOW:
               this.model.displaySetting2DqualityBackground = Settings.QUALITY_LOW;
               this.model.displaySetting2DqualityZones = Settings.QUALITY_LOW;
               this.model.displaySetting2DqualityShips = Settings.QUALITY_LOW;
               this.model.displaySetting2DqualityExplosions = Settings.QUALITY_LOW;
               this.model.displaySetting2DqualityEngines = Settings.QUALITY_LOW;
               this.model.displaySetting2DqualityResourcesAndBoxes = Settings.QUALITY_LOW;
               this.model.displaySetting3DqualityAntialias = BindableSettings.LOW;
               this.model.displaySetting3DqualityEffects = BindableSettings.LOW;
               this.model.displaySetting3DqualityLights = BindableSettings.LOW;
               this.model.displaySetting3DqualityTextures = BindableSettings.LOW;
               this.model.displaySetting3DtextureFiltering = BindableSettings.LOW;
               this.model.displaySetting3DsizeTextures = BindableSettings.LOW;
               this.model.displaySetting3DqualityBackground = BindableSettings.LOW;
               this.model.displaySetting3DqualityZones = BindableSettings.LOW;
               break;
            case Settings.QUALITY_MEDIUM:
               this.model.displaySetting2DqualityBackground = Settings.QUALITY_MEDIUM;
               this.model.displaySetting2DqualityZones = Settings.QUALITY_MEDIUM;
               this.model.displaySetting2DqualityShips = Settings.QUALITY_LOW;
               this.model.displaySetting2DqualityExplosions = Settings.QUALITY_MEDIUM;
               this.model.displaySetting2DqualityEngines = Settings.QUALITY_MEDIUM;
               this.model.displaySetting2DqualityResourcesAndBoxes = Settings.QUALITY_LOW;
               this.model.displaySetting3DqualityAntialias = BindableSettings.MEDIUM;
               this.model.displaySetting3DqualityEffects = BindableSettings.MEDIUM;
               this.model.displaySetting3DqualityLights = BindableSettings.MEDIUM;
               this.model.displaySetting3DqualityTextures = BindableSettings.MEDIUM;
               this.model.displaySetting3DtextureFiltering = BindableSettings.MEDIUM;
               this.model.displaySetting3DsizeTextures = BindableSettings.MEDIUM;
               this.model.displaySetting3DqualityBackground = BindableSettings.MEDIUM;
               this.model.displaySetting3DqualityZones = BindableSettings.MEDIUM;
               break;
            case Settings.QUALITY_GOOD:
               this.model.displaySetting2DqualityBackground = Settings.QUALITY_GOOD;
               this.model.displaySetting2DqualityZones = Settings.QUALITY_HIGH;
               this.model.displaySetting2DqualityShips = Settings.QUALITY_HIGH;
               this.model.displaySetting2DqualityExplosions = Settings.QUALITY_MEDIUM;
               this.model.displaySetting2DqualityEngines = Settings.QUALITY_GOOD;
               this.model.displaySetting2DqualityResourcesAndBoxes = Settings.QUALITY_HIGH;
               this.model.displaySetting3DqualityAntialias = BindableSettings.HIGH;
               this.model.displaySetting3DqualityEffects = BindableSettings.HIGH;
               this.model.displaySetting3DqualityLights = BindableSettings.HIGH;
               this.model.displaySetting3DqualityTextures = BindableSettings.HIGH;
               this.model.displaySetting3DtextureFiltering = BindableSettings.HIGH;
               this.model.displaySetting3DsizeTextures = BindableSettings.HIGH;
               this.model.displaySetting3DqualityBackground = BindableSettings.HIGH;
               this.model.displaySetting3DqualityZones = BindableSettings.HIGH;
               break;
            case Settings.QUALITY_HIGH:
               this.model.displaySetting2DqualityBackground = Settings.gpuSupport ? Settings.QUALITY_HIGH : Settings.QUALITY_GOOD;
               this.model.displaySetting2DqualityZones = Settings.QUALITY_HIGH;
               this.model.displaySetting2DqualityShips = Settings.QUALITY_HIGH;
               this.model.displaySetting2DqualityExplosions = Settings.QUALITY_HIGH;
               this.model.displaySetting2DqualityEngines = Settings.QUALITY_HIGH;
               this.model.displaySetting2DqualityResourcesAndBoxes = Settings.QUALITY_HIGH;
               this.model.displaySetting3DqualityAntialias = BindableSettings.ULTRA;
               this.model.displaySetting3DqualityEffects = BindableSettings.ULTRA;
               this.model.displaySetting3DqualityLights = BindableSettings.HIGH;
               this.model.displaySetting3DqualityTextures = BindableSettings.HIGH;
               this.model.displaySetting3DtextureFiltering = BindableSettings.HIGH;
               this.model.displaySetting3DsizeTextures = BindableSettings.HIGH;
               this.model.displaySetting3DqualityBackground = BindableSettings.ULTRA;
               this.model.displaySetting3DqualityZones = BindableSettings.ULTRA;
         }
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_MODEL_CHANGED,this.model);
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_MODEL_CHANGES,this.model);
      }
      
      public function setModelFromCurrentSettings() : void
      {
         this.model.preloadShips = Settings.preloadUserShips;
         this.model.use2D = Settings.FORCE_2D.value;
         this.model.presettingDisplayQuality = Settings.qualityPresetting;
         this.model.advanced = Settings.qualityCustomized;
         this.model.displaySetting2DqualityBackground = Settings.qualityBackground.value;
         this.model.displaySetting2DqualityZones = Settings.qualityPoizone.value;
         this.model.displaySetting2DqualityShips = Settings.qualityShip.value;
         this.model.displaySetting2DqualityEngines = Settings.qualityEngine.value;
         this.model.displaySetting2DqualityExplosions = Settings.qualityExplosion.value;
         this.model.displaySetting2DqualityResourcesAndBoxes = Settings.qualityCollectable.value;
         this.model.displaySetting3DqualityAntialias = Settings.displaySetting3DqualityAntialias.value;
         this.model.displaySetting3DqualityBackground = Settings.qualityBackground.value;
         this.model.displaySetting3DqualityEffects = Settings.displaySetting3DqualityEffects.value;
         this.model.displaySetting3DqualityLights = Settings.displaySetting3DqualityLights.value;
         this.model.displaySetting3DqualityTextures = Settings.displaySetting3DqualityTextures.value;
         this.model.displaySetting3DqualityZones = Settings.qualityPoizone.value;
         this.model.displaySetting3DsizeTextures = Settings.displaySetting3DsizeTextures.value;
         this.model.displaySetting3DtextureFiltering = Settings.displaySetting3DtextureFiltering.value;
         this.model.displaySettingPixelationMode = Settings.displaySettingPixelationMode.value;
         this.model.autoWeaponsUpgrade = Settings.autoBoost;
         this.model.autoAmmoSwitch = Settings.autochangeAmmo;
         this.model.autoRefine = Settings.autoRefinement;
         this.model.startStopAttacksQuickbar = Settings.quickSlotStopAttack;
         this.model.autoLogin = Settings.autoStartEnabled;
         this.model.doubleClickAttack = Settings.doubleclickAttackEnabled;
         this.model.autoPurchaseGreenBootyKeys = Settings.autoBuyBootyKeys;
         this.model.showLowHpWarnings = Settings.showLowHpWarnings;
         this.model.showBattlerayNotifcations = Settings.displayBattlerayNotifications;
         this.model.showPlayerNames = Settings.displayPlayerNames.value;
         this.model.showResources = Settings.displayResources.value;
         this.model.showBonusBoxes = Settings.displayBonusBoxes.value;
         this.model.showAscendingHitCount = Settings.displayHitpointBubbles;
         this.model.showDrones = Settings.showDrones.value;
         this.model.showMyDrones = Settings.showMyDrones.value;
         this.model.showCargoBoxes = Settings.displayFreeCargoBoxes.value;
         this.model.showCargoBoxesNotFree = Settings.displayNotFreeCargoBoxes.value;
         this.model.showMinimapBackground = Settings.displayMiniMapBackgroundImage.value;
         this.model.displayGamePerformanceMessages = Settings.displayNotifications.value;
         this.model.autoQualityReduction = Settings.allowAutoQuality.value;
         this.model.hoverShips = Settings.hoverShips.value;
         this.model.showChat = Settings.displayChat.value;
         this.model.alwaysDraggableWindows = Settings.dragWindowsAlways;
         this.model.showWindowBackgrounds = Settings.displayWindowsBackground.value;
         this.model.displayPremiumQuickslotBar = Settings.showPremiumQuickslotBar;
         this.model.proActionBarEnabled = Settings.proActionBarEnabled.value;
         this.model.proActionBarAutohideEnabled = Settings.proActionBarAutohideEnabled;
         this.model.proActionBarKeyboardInputEnabled = Settings.proActionBarKeyboardInputEnabled;
         this.model.showItemsNotOwned = Settings.showNotOwnedItems;
         this.model.playCombatMusic = Settings.playCombatMusic.value;
         this.model.soundEffectsVolume = Settings.soundVolume;
         this.model.musicVolume = Settings.musicVolume;
         this.model.boardcomputerVolume = Settings.voiceVolume;
         this.importKeybindingsFromKeyboardMapper();
         this._backup_model = this.model.clone();
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_MODEL_CHANGED,this.model);
      }
      
      public function restoreBackupModel() : void
      {
         if(this._backup_model)
         {
            setData(this._backup_model.clone());
            sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_MODEL_CHANGED,this.model);
            sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_MODEL_CHANGES,this.model);
         }
      }
      
      public function handleKeybindingValueChangedInWindow(param1:SettingsKeyBindingItemVO) : void
      {
         this.model.keyBindings[param1.keybindingActionID] = new <int>[param1.boundKeyCode];
         sendNotification(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_ENABLE_SAVE_BUTTON);
      }
      
      public function importKeybindingsFromKeyboardMapper() : void
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:KeyboardMapper = KeyboardMapper.getInstance();
         for(_loc2_ in _loc1_.commandMap)
         {
            _loc3_ = SettingsKeyBindingItemVO.commandNameToActionIds(_loc2_);
            if(Boolean(_loc3_) && _loc3_.length == 1)
            {
               this.model.keyBindings[_loc3_[0]] = _loc1_.getKeysOfCommand(_loc2_);
            }
            else if(Boolean(_loc3_) && _loc3_.length > 1)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_];
                  this.model.keyBindings[_loc5_] = _loc1_.getKeysOfCommandWithParam(_loc2_,new <String>[SettingsKeyBindingItemVO.commandNameToActionIds(_loc2_).indexOf(_loc5_).toString()]);
                  if((this.model.keyBindings[_loc5_] as Vector.<int>).length == 0)
                  {
                     (this.model.keyBindings[_loc5_] as Vector.<int>).push(-1);
                  }
                  _loc4_++;
               }
            }
         }
      }
   }
}

