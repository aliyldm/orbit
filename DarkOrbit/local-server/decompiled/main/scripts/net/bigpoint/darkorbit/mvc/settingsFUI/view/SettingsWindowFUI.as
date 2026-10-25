package net.bigpoint.darkorbit.mvc.settingsFUI.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.bars.SliderNSteps;
   import net.bigpoint.darkorbit.fui.components.bars.TabBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBox;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.BindingsUtils;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SettingsWindowFUI extends Sprite
   {
      
      private var _tabbar:TabBar;
      
      private var _displaySettingsContainer:Coreponent;
      
      private var _advanced:CheckBox;
      
      private var _use2D:CheckBox;
      
      private var _use2DLabel:Label;
      
      private var _presettingQuality:SliderNSteps;
      
      private var _presettingQualityLabel:Label;
      
      private var _displaySettings2DContainer:Coreponent;
      
      private var _displaySetting2DQualityBackground:DropDownBox;
      
      private var _displaySetting2DQualityZones:DropDownBox;
      
      private var _displaySetting2DQualityShips:DropDownBox;
      
      private var _displaySetting2DQualityEngines:DropDownBox;
      
      private var _displaySetting2DQualityExplosions:DropDownBox;
      
      private var _displaySetting2DQualityResourcesAndBoxes:DropDownBox;
      
      private var _displaySettings3DContainer:Coreponent;
      
      private var _displaySetting3dQualityAntialias:DropDownBox;
      
      private var _displaySetting3dQualityLights:DropDownBox;
      
      private var _displaySetting3dQualityTextures:DropDownBox;
      
      private var _displaySetting3dSizeTextures:DropDownBox;
      
      private var _displaySetting3dQualityEffects:DropDownBox;
      
      private var _displaySetting3dTextureFiltering:DropDownBox;
      
      private var _displaySetting3dQualityBackground:DropDownBox;
      
      private var _displaySetting3dQualityZones:DropDownBox;
      
      private var _displaySettingPixelationMode:CheckBox;
      
      private var _displaySettingPixelationModeLabel:Label;
      
      private var _gameplaySettingsContainer:Coreponent;
      
      private var _autoWeaponsUpgrade:CheckBox;
      
      private var _autoAmmoSwitch:CheckBox;
      
      private var _autoRefine:CheckBox;
      
      private var _startStopAttacksQuickBar:CheckBox;
      
      private var _autoLogin:CheckBox;
      
      private var _doubleClickAttack:CheckBox;
      
      private var _autoPurchaseGreenBootyKeys:CheckBox;
      
      private var _showBattlerayNotifications:CheckBox;
      
      private var _showLowHpWarning:CheckBox;
      
      private var _autoEquip:CheckBox;
      
      private var _interfaceSettingsContainer:Coreponent;
      
      private var _interfaceSettingsItemList:ItemList;
      
      private var _interfaceSettingsScrollbar:Scrollbar;
      
      private var _interfaceConfigureButton:Button;
      
      private var _soundSettingsContainer:Coreponent;
      
      private var _playCombatMusic:CheckBox;
      
      private var _soundEffectVolume:SliderNSteps;
      
      private var _musicVolume:SliderNSteps;
      
      private var _boardcomputerVolume:SliderNSteps;
      
      private var _keyboardSettingsContainer:Coreponent;
      
      private var _keyboardSettingsItemList:ItemList;
      
      private var _keyboardSettingsScrollbar:Scrollbar;
      
      private var _keyboardSettingsDescriptionLabel:Label;
      
      private var _tabContainersVector:Vector.<Coreponent>;
      
      private var _displayDropDownBoxesVector:Vector.<DropDownBox>;
      
      private var _saveSettingsButton:Button;
      
      private var _cancelSettingsButton:Button;
      
      private var _resetSettingsButton:Button;
      
      private var _busyMC:Coreponent;
      
      private var _baseCorepontent:Coreponent;
      
      public function SettingsWindowFUI(param1:Coreponent)
      {
         super();
         this._baseCorepontent = param1;
         this._tabbar = (param1.getChildByName("tabBarContainer") as Coreponent).getChildByName("settingsBar") as TabBar;
         this._displaySettingsContainer = param1.getChildByName("displaySettingsContainer") as Coreponent;
         var _loc2_:Coreponent = this._displaySettingsContainer.getChildByName("firstLineLayout") as Coreponent;
         this._use2D = _loc2_.getChildByName("use2D") as CheckBox;
         this._use2DLabel = _loc2_.getChildByName("use2DLabel") as Label;
         this._advanced = this.displaySettingsContainer.getChildByName("advancedMode") as CheckBox;
         this._presettingQuality = this.displaySettingsContainer.getChildByName("sliderDisplayQuality") as SliderNSteps;
         this._presettingQualityLabel = this.displaySettingsContainer.getChildByName("graphicsQualityValueLabel") as Label;
         this._displayDropDownBoxesVector = new Vector.<DropDownBox>();
         this._displaySettings2DContainer = this.displaySettingsContainer.getChildByName("advancedSettingsContainer2D") as Coreponent;
         this._displaySetting2DQualityBackground = this.displaySettings2DContainer.getChildByName("qualityBackground") as DropDownBox;
         this._displaySettingPixelationMode = this.displaySettingsContainer.getChildByName("pixelationMode") as CheckBox;
         this._displaySettingPixelationModeLabel = this.displaySettingsContainer.getChildByName("pixelationModeLabel") as Label;
         if(Settings.gpuSupport)
         {
            this._displaySetting2DQualityBackground.updateAvailableEntries(new <String>["quality_no","quality_medium","quality_good","quality_high"]);
         }
         else
         {
            this._displaySetting2DQualityBackground.updateAvailableEntries(new <String>["quality_no","quality_medium","quality_good"]);
         }
         this._displayDropDownBoxesVector.push(this.displaySetting2DQualityBackground);
         this._displaySetting2DQualityZones = this.displaySettings2DContainer.getChildByName("qualityZones") as DropDownBox;
         this._displaySetting2DQualityZones.updateAvailableEntries(new <String>["quality_low","quality_medium","quality_high"]);
         this._displayDropDownBoxesVector.push(this.displaySetting2DQualityZones);
         this._displaySetting2DQualityShips = this.displaySettings2DContainer.getChildByName("qualityShips") as DropDownBox;
         this._displaySetting2DQualityShips.updateAvailableEntries(new <String>["quality_low","quality_high"]);
         this._displayDropDownBoxesVector.push(this.displaySetting2DQualityShips);
         this._displaySetting2DQualityEngines = this.displaySettings2DContainer.getChildByName("qualityEngines") as DropDownBox;
         this._displayDropDownBoxesVector.push(this.displaySetting2DQualityEngines);
         this._displaySetting2DQualityExplosions = this.displaySettings2DContainer.getChildByName("qualityExplosions") as DropDownBox;
         this._displaySetting2DQualityExplosions.updateAvailableEntries(new <String>["quality_no","quality_medium","quality_good","quality_high"]);
         this._displayDropDownBoxesVector.push(this.displaySetting2DQualityExplosions);
         this._displaySetting2DQualityResourcesAndBoxes = this.displaySettings2DContainer.getChildByName("resourcesBoxes") as DropDownBox;
         this._displaySetting2DQualityResourcesAndBoxes.updateAvailableEntries(new <String>["quality_low","quality_high"]);
         this._displayDropDownBoxesVector.push(this.displaySetting2DQualityResourcesAndBoxes);
         this._displaySettings3DContainer = this.displaySettingsContainer.getChildByName("advancedSettingsContainer3D") as Coreponent;
         this._displaySetting3dQualityAntialias = this.displaySettings3DContainer.getChildByName("qualityAntialias") as DropDownBox;
         this._displayDropDownBoxesVector.push(this.displaySetting3dQualityAntialias);
         this._displaySetting3dQualityLights = this.displaySettings3DContainer.getChildByName("qualityLights") as DropDownBox;
         this._displaySetting3dQualityLights.updateAvailableEntries(new <String>["quality_low","quality_medium","quality_high"]);
         this._displayDropDownBoxesVector.push(this.displaySetting3dQualityLights);
         this._displaySetting3dQualityTextures = this.displaySettings3DContainer.getChildByName("qualityTextures") as DropDownBox;
         this._displaySetting3dQualityTextures.updateAvailableEntries(new <String>["quality_low","quality_medium","quality_high"]);
         this._displayDropDownBoxesVector.push(this.displaySetting3dQualityTextures);
         this._displaySetting3dSizeTextures = this.displaySettings3DContainer.getChildByName("sizeTextures") as DropDownBox;
         this._displaySetting3dSizeTextures.updateAvailableEntries(new <String>["quality_low","quality_medium","quality_high"]);
         this._displayDropDownBoxesVector.push(this.displaySetting3dSizeTextures);
         this._displaySetting3dQualityEffects = this.displaySettings3DContainer.getChildByName("qualityEffects") as DropDownBox;
         this._displayDropDownBoxesVector.push(this.displaySetting3dQualityEffects);
         this._displaySetting3dTextureFiltering = this.displaySettings3DContainer.getChildByName("textureFiltering") as DropDownBox;
         this._displaySetting3dTextureFiltering.updateAvailableEntries(new <String>["quality_low","quality_medium","quality_high"]);
         this._displayDropDownBoxesVector.push(this.displaySetting3dTextureFiltering);
         this._displaySetting3dQualityBackground = this.displaySettings3DContainer.getChildByName("qualityBackground3D") as DropDownBox;
         this._displayDropDownBoxesVector.push(this.displaySetting3dQualityBackground);
         this._displaySetting3dQualityZones = this.displaySettings3DContainer.getChildByName("qualityZones3D") as DropDownBox;
         this._displayDropDownBoxesVector.push(this.displaySetting3dQualityZones);
         this._gameplaySettingsContainer = param1.getChildByName("gameplaySettingsContainer") as Coreponent;
         this._autoWeaponsUpgrade = this.gameplaySettingsContainer.getChildByName("autoWeaponBoost") as CheckBox;
         this._autoAmmoSwitch = this.gameplaySettingsContainer.getChildByName("autoAmmoChange") as CheckBox;
         this._autoRefine = this.gameplaySettingsContainer.getChildByName("autoMaterialRefinement") as CheckBox;
         this._startStopAttacksQuickBar = this.gameplaySettingsContainer.getChildByName("toggleAttackQuickbar") as CheckBox;
         this._autoLogin = this.gameplaySettingsContainer.getChildByName("autoLogin") as CheckBox;
         this._doubleClickAttack = this.gameplaySettingsContainer.getChildByName("doubleClickAttack") as CheckBox;
         this._autoPurchaseGreenBootyKeys = this.gameplaySettingsContainer.getChildByName("autoBuyBootyKeys") as CheckBox;
         this._showBattlerayNotifications = this.gameplaySettingsContainer.getChildByName("showBattlerayNotifications") as CheckBox;
         this._showLowHpWarning = this.gameplaySettingsContainer.getChildByName("showLowHpWarning") as CheckBox;
         this._autoEquip = this.gameplaySettingsContainer.getChildByName("autoEquip") as CheckBox;
         this._interfaceSettingsContainer = param1.getChildByName("interfaceSettingsContainer") as Coreponent;
         this._interfaceSettingsItemList = this.interfaceSettingsContainer.getChildByName("interfaceSettingsItemlist") as ItemList;
         this._interfaceSettingsItemList.itemDataAssigner = SettingsListItemDataAssigner;
         this._interfaceSettingsScrollbar = this.interfaceSettingsContainer.getChildByName("interfaceSettingsScrollbar") as Scrollbar;
         BindingsUtils.bindScrollComponents(this._interfaceSettingsItemList,this._interfaceSettingsScrollbar);
         this._interfaceSettingsItemList.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleInterfaceItemlistMouseWheelEvent);
         this._interfaceConfigureButton = this.interfaceSettingsContainer.getChildByName("configButton") as Button;
         this._soundSettingsContainer = param1.getChildByName("soundSettingsContainer") as Coreponent;
         this._playCombatMusic = this.soundSettingsContainer.getChildByName("playCombatMusic") as CheckBox;
         this._soundEffectVolume = this.soundSettingsContainer.getChildByName("sliderSoundVolume") as SliderNSteps;
         this._musicVolume = this.soundSettingsContainer.getChildByName("sliderMusicVolume") as SliderNSteps;
         this._boardcomputerVolume = this.soundSettingsContainer.getChildByName("sliderBoardcomputerVolume") as SliderNSteps;
         this._keyboardSettingsContainer = param1.getChildByName("keyboardSettingsContainer") as Coreponent;
         this._keyboardSettingsItemList = this.keyboardSettingsContainer.getChildByName("keyboardSettingsItemlist") as ItemList;
         this._keyboardSettingsItemList.itemDataAssigner = KeybindingListItemDataAssigner;
         this._keyboardSettingsScrollbar = this.keyboardSettingsContainer.getChildByName("keyboardSettingsScrollbar") as Scrollbar;
         this._keyboardSettingsScrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleKeyboardScrollbarPositionChangeEvent);
         this._keyboardSettingsItemList.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleKeyboardItemlistMouseWheelEvent);
         this._keyboardSettingsDescriptionLabel = this._keyboardSettingsContainer.getChildByName("keyboardPressKeyToBind") as Label;
         this._tabContainersVector = new Vector.<Coreponent>();
         this._tabContainersVector.push(this.displaySettingsContainer);
         this._tabContainersVector.push(this.gameplaySettingsContainer);
         this._tabContainersVector.push(this.interfaceSettingsContainer);
         this._tabContainersVector.push(this.soundSettingsContainer);
         this._tabContainersVector.push(this.keyboardSettingsContainer);
         this._saveSettingsButton = param1.getChildByName("saveButton") as Button;
         this._cancelSettingsButton = param1.getChildByName("cancelButton") as Button;
         this._resetSettingsButton = param1.getChildByName("resetButton") as Button;
         this._busyMC = param1.getChildByName("busyMC") as Coreponent;
      }
      
      private function handleKeyboardItemlistMouseWheelEvent(param1:MouseEvent) : void
      {
         if(this._keyboardSettingsScrollbar)
         {
            this._keyboardSettingsScrollbar.updateScrollPositionByScrollDelta(param1.delta);
         }
      }
      
      private function handleKeyboardScrollbarPositionChangeEvent(param1:ScrollEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._keyboardSettingsScrollbar)
         {
            _loc2_ = this._keyboardSettingsScrollbar.getScrollPositionInPercent();
            this.keyboardSettingsItemList.setScrollPositionInPercent(_loc2_);
         }
      }
      
      private function handleInterfaceItemlistMouseWheelEvent(param1:MouseEvent) : void
      {
         if(this._interfaceSettingsScrollbar)
         {
            this._interfaceSettingsScrollbar.updateScrollPositionByScrollDelta(param1.delta);
         }
      }
      
      public function get tabbar() : TabBar
      {
         return this._tabbar;
      }
      
      public function get displaySettingsContainer() : Coreponent
      {
         return this._displaySettingsContainer;
      }
      
      public function get advanced() : CheckBox
      {
         return this._advanced;
      }
      
      public function get use2D() : CheckBox
      {
         return this._use2D;
      }
      
      public function get use2DLabel() : Label
      {
         return this._use2DLabel;
      }
      
      public function get presettingQuality() : SliderNSteps
      {
         return this._presettingQuality;
      }
      
      public function get displaySettings2DContainer() : Coreponent
      {
         return this._displaySettings2DContainer;
      }
      
      public function get displaySetting2DQualityBackground() : DropDownBox
      {
         return this._displaySetting2DQualityBackground;
      }
      
      public function get displaySetting2DQualityZones() : DropDownBox
      {
         return this._displaySetting2DQualityZones;
      }
      
      public function get displaySetting2DQualityShips() : DropDownBox
      {
         return this._displaySetting2DQualityShips;
      }
      
      public function get displaySetting2DQualityEngines() : DropDownBox
      {
         return this._displaySetting2DQualityEngines;
      }
      
      public function get displaySetting2DQualityExplosions() : DropDownBox
      {
         return this._displaySetting2DQualityExplosions;
      }
      
      public function get displaySetting2DQualityResourcesAndBoxes() : DropDownBox
      {
         return this._displaySetting2DQualityResourcesAndBoxes;
      }
      
      public function get displaySettings3DContainer() : Coreponent
      {
         return this._displaySettings3DContainer;
      }
      
      public function get displaySetting3dQualityAntialias() : DropDownBox
      {
         return this._displaySetting3dQualityAntialias;
      }
      
      public function get displaySetting3dQualityLights() : DropDownBox
      {
         return this._displaySetting3dQualityLights;
      }
      
      public function get displaySetting3dQualityTextures() : DropDownBox
      {
         return this._displaySetting3dQualityTextures;
      }
      
      public function get displaySetting3dSizeTextures() : DropDownBox
      {
         return this._displaySetting3dSizeTextures;
      }
      
      public function get displaySetting3dQualityEffects() : DropDownBox
      {
         return this._displaySetting3dQualityEffects;
      }
      
      public function get displaySetting3dTextureFiltering() : DropDownBox
      {
         return this._displaySetting3dTextureFiltering;
      }
      
      public function get displaySetting3dQualityBackground() : DropDownBox
      {
         return this._displaySetting3dQualityBackground;
      }
      
      public function get displaySetting3dQualityZones() : DropDownBox
      {
         return this._displaySetting3dQualityZones;
      }
      
      public function get displaySettingPixelationMode() : CheckBox
      {
         return this._displaySettingPixelationMode;
      }
      
      public function get displaySettingPixelationModeLabel() : Label
      {
         return this._displaySettingPixelationModeLabel;
      }
      
      public function get gameplaySettingsContainer() : Coreponent
      {
         return this._gameplaySettingsContainer;
      }
      
      public function get autoWeaponsUpgrade() : CheckBox
      {
         return this._autoWeaponsUpgrade;
      }
      
      public function get autoAmmoSwitch() : CheckBox
      {
         return this._autoAmmoSwitch;
      }
      
      public function get autoRefine() : CheckBox
      {
         return this._autoRefine;
      }
      
      public function get startStopAttacksQuickBar() : CheckBox
      {
         return this._startStopAttacksQuickBar;
      }
      
      public function get autoLogin() : CheckBox
      {
         return this._autoLogin;
      }
      
      public function get doubleClickAttack() : CheckBox
      {
         return this._doubleClickAttack;
      }
      
      public function get autoPurchaseGreenBootyKeys() : CheckBox
      {
         return this._autoPurchaseGreenBootyKeys;
      }
      
      public function get showBattlerayNotifications() : CheckBox
      {
         return this._showBattlerayNotifications;
      }
      
      public function get showLowHpWarning() : CheckBox
      {
         return this._showLowHpWarning;
      }
      
      public function get autoEquip() : CheckBox
      {
         return this._autoEquip;
      }
      
      public function get interfaceSettingsContainer() : Coreponent
      {
         return this._interfaceSettingsContainer;
      }
      
      public function get interfaceSettingsItemList() : ItemList
      {
         return this._interfaceSettingsItemList;
      }
      
      public function get interfaceConfigureButton() : Button
      {
         return this._interfaceConfigureButton;
      }
      
      public function get soundSettingsContainer() : Coreponent
      {
         return this._soundSettingsContainer;
      }
      
      public function get playCombatMusic() : CheckBox
      {
         return this._playCombatMusic;
      }
      
      public function get soundEffectVolume() : SliderNSteps
      {
         return this._soundEffectVolume;
      }
      
      public function get musicVolume() : SliderNSteps
      {
         return this._musicVolume;
      }
      
      public function get boardcomputerVolume() : SliderNSteps
      {
         return this._boardcomputerVolume;
      }
      
      public function get keyboardSettingsContainer() : Coreponent
      {
         return this._keyboardSettingsContainer;
      }
      
      public function get keyboardSettingsItemList() : ItemList
      {
         return this._keyboardSettingsItemList;
      }
      
      public function get tabContainersVector() : Vector.<Coreponent>
      {
         return this._tabContainersVector;
      }
      
      public function get displayDropDownBoxesVector() : Vector.<DropDownBox>
      {
         return this._displayDropDownBoxesVector;
      }
      
      public function get saveSettingsButton() : Button
      {
         return this._saveSettingsButton;
      }
      
      public function get cancelSettingsButton() : Button
      {
         return this._cancelSettingsButton;
      }
      
      public function get resetSettingsButton() : Button
      {
         return this._resetSettingsButton;
      }
      
      public function get presettingQualityLabel() : Label
      {
         return this._presettingQualityLabel;
      }
      
      public function get keyboardSettingsDescriptionLabel() : Label
      {
         return this._keyboardSettingsDescriptionLabel;
      }
      
      public function get busyMC() : Coreponent
      {
         return this._busyMC;
      }
      
      public function get baseCorepontent() : Coreponent
      {
         return this._baseCorepontent;
      }
   }
}

