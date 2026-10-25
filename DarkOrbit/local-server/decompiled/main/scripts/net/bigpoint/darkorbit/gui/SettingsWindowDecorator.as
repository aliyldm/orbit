package net.bigpoint.darkorbit.gui
{
   import fl.controls.Slider;
   import fl.events.SliderEvent;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.System;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AudioSettingsModule;
   import net.bigpoint.darkorbit.com.module.ResetSettingsRequest;
   import net.bigpoint.darkorbit.com.module.UserKeyBindingsModule;
   import net.bigpoint.darkorbit.gui.container.ScrollableContainer;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.CheckBoxComponent;
   import net.bigpoint.darkorbit.gui.elements.SettingsField;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.elements.combobox.ComboBoxComponent;
   import net.bigpoint.darkorbit.gui.elements.combobox.ComboboxItem;
   import net.bigpoint.darkorbit.gui.elements.slider.SimpleSliderComponent;
   import net.bigpoint.darkorbit.gui.elements.slider.SliderComponent;
   import net.bigpoint.darkorbit.gui.elements.slider.SliderInterval;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyValuePair;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper;
   import net.bigpoint.darkorbit.managers.keyboardManager.parser.SettingsWindowKeyboardParser;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.configurationModePopup.ConfigModePopupMediator;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.configurationModePopup.components.ConfigModePopup;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.SettingsAssembly;
   import net.bigpoint.darkorbit.net.netty.handlers.settings.AudioSettingsHandler;
   import net.bigpoint.darkorbit.settings.Presetting;
   import net.bigpoint.darkorbit.settings.PresettingItem;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SettingsWindowDecorator
   {
      
      private static var _instance:SettingsWindowDecorator;
      
      private static var settingsAssemblyDict:Dictionary;
      
      private static const locaKeys:Object = new Object();
      
      locaKeys[Keyboard.BACKSPACE] = BPLocale.getItem("keyboard_key_backspace");
      locaKeys[Keyboard.CONTROL] = BPLocale.getItem("keyboard_key_ctrl");
      locaKeys[Keyboard.ESCAPE] = BPLocale.getItem("keyboard_key_esc");
      locaKeys[Keyboard.CAPS_LOCK] = BPLocale.getItem("keyboard_key_capslock");
      locaKeys[Keyboard.DELETE] = BPLocale.getItem("keyboard_key_delete");
      locaKeys[Keyboard.END] = BPLocale.getItem("keyboard_key_end");
      locaKeys[Keyboard.ENTER] = BPLocale.getItem("keyboard_key_enter");
      locaKeys[Keyboard.HOME] = BPLocale.getItem("keyboard_key_home");
      locaKeys[Keyboard.INSERT] = BPLocale.getItem("keyboard_key_insert");
      locaKeys[Keyboard.PAGE_UP] = BPLocale.getItem("keyboard_key_page up");
      locaKeys[Keyboard.PAGE_DOWN] = BPLocale.getItem("keyboard_key_page down");
      locaKeys[Keyboard.SPACE] = BPLocale.getItem("keyboard_key_space");
      locaKeys[Keyboard.SHIFT] = BPLocale.getItem("keyboard_key_key_shift");
      locaKeys[Keyboard.TAB] = BPLocale.getItem("keyboard_key_tab");
      locaKeys[Keyboard.UP] = BPLocale.getItem("keyboard_key_up");
      locaKeys[Keyboard.DOWN] = BPLocale.getItem("keyboard_key_down");
      locaKeys[Keyboard.LEFT] = BPLocale.getItem("keyboard_key_left");
      locaKeys[Keyboard.RIGHT] = BPLocale.getItem("keyboard_key_right");
      locaKeys[144] = BPLocale.getItem("keyboard_key_numpad").split("\n").join(" ");
      locaKeys[145] = BPLocale.getItem("keyboard_key_roll");
      locaKeys[19] = BPLocale.getItem("keyboard_key_pause");
      locaKeys[93] = BPLocale.getItem("keyboard_key_option");
      locaKeys[92] = BPLocale.getItem("keyboard_key_win");
      locaKeys[91] = BPLocale.getItem("keyboard_key_win");
      locaKeys[-1] = BPLocale.getItem("keyboard_key_undefined");
      locaKeys[Keyboard.NUMPAD_0] = locaKeys[144] + " 0";
      locaKeys[Keyboard.NUMPAD_1] = locaKeys[144] + " 1";
      locaKeys[Keyboard.NUMPAD_2] = locaKeys[144] + " 2";
      locaKeys[Keyboard.NUMPAD_3] = locaKeys[144] + " 3";
      locaKeys[Keyboard.NUMPAD_4] = locaKeys[144] + " 4";
      locaKeys[Keyboard.NUMPAD_5] = locaKeys[144] + " 5";
      locaKeys[Keyboard.NUMPAD_6] = locaKeys[144] + " 6";
      locaKeys[Keyboard.NUMPAD_7] = locaKeys[144] + " 7";
      locaKeys[Keyboard.NUMPAD_8] = locaKeys[144] + " 8";
      locaKeys[Keyboard.NUMPAD_9] = locaKeys[144] + " 9";
      locaKeys[Keyboard.NUMPAD_ADD] = locaKeys[144] + " +";
      locaKeys[Keyboard.NUMPAD_SUBTRACT] = locaKeys[144] + " -";
      locaKeys[Keyboard.NUMPAD_MULTIPLY] = locaKeys[144] + " *";
      locaKeys[Keyboard.NUMPAD_DIVIDE] = locaKeys[144] + " /";
      
      private var _selectedTabId:int = -2147483648;
      
      private var scrollContainer:ScrollableContainer;
      
      private var settingsWindowKeyboardParser:SettingsWindowKeyboardParser = new SettingsWindowKeyboardParser();
      
      private var keyboardSendComponent:KeyboardSendComponent;
      
      private var keyboardRows:Vector.<KeyboardRow> = new Vector.<KeyboardRow>();
      
      private var guiManager:GuiManager;
      
      private var uiResources:SWFFinisher;
      
      private var settingTabButtons:Dictionary = new Dictionary();
      
      private var settingTabPages:Dictionary = new Dictionary();
      
      private var qualityPresetting:Presetting;
      
      private var presettingSlider:SliderComponent;
      
      private var simpleSliders:Dictionary;
      
      private var isAdvanced:Boolean = false;
      
      private var advancedBtn:ButtonElement;
      
      private var advancedTxt:TextFieldElement;
      
      public function SettingsWindowDecorator(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
         this.uiResources = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.qualityPresetting = new Presetting(Settings.gpuSupport);
         this.keyboardSendComponent = new KeyboardSendComponent(param1.getMain().getConnectionManager());
         this.simpleSliders = new Dictionary();
         _instance = this;
      }
      
      public static function getInstance() : SettingsWindowDecorator
      {
         return _instance;
      }
      
      public static function getCheckBoxSettingValue(param1:int) : Boolean
      {
         switch(param1)
         {
            case SettingsField.TYPE_DISPLAY_NOTIFICATIONS:
               return Settings.displayNotifications.value;
            case SettingsField.TYPE_SHOW_CHAT:
               return Settings.displayChat.value;
            case SettingsField.TYPE_MUSIC_VOLUME:
               return Settings.playMusic.value;
            case SettingsField.TYPE_SOUND_VOLUME:
               return Settings.playSFX.value;
            case SettingsField.TYPE_VOICE_VOLUME:
               return Settings.playVoice.value;
            case SettingsField.TYPE_PLAY_COMBAT_MUSIC:
               return Settings.playCombatMusic.value;
            case SettingsField.TYPE_SHOW_HITPOINT_BUBBLES:
               return Settings.displayHitpointBubbles;
            case SettingsField.TYPE_SHOW_PLAYERNAMES:
               return Settings.displayPlayerNames.value;
            case SettingsField.TYPE_AUTO_BOOST:
               return Settings.autoBoost;
            case SettingsField.TYPE_SHOW_RESOURCES:
               return Settings.displayResources.value;
            case SettingsField.TYPE_SHOW_BONUS_BOXES:
               return Settings.displayBonusBoxes.value;
            case SettingsField.TYPE_SHOW_FREE_CARGO_BOXES:
               return Settings.displayFreeCargoBoxes.value;
            case SettingsField.TYPE_SHOW_NOT_FREE_CARGO_BOXES:
               return Settings.displayNotFreeCargoBoxes.value;
            case SettingsField.TYPE_SHOW_MINIMAP_BACKGROUND_IMAGE:
               return Settings.displayMiniMapBackgroundImage.value;
            case SettingsField.TYPE_SHOW_DRONES:
               return Settings.showDrones.value;
            case SettingsField.TYPE_SHOW_MY_DRONES:
               return Settings.showMyDrones.value;
            case SettingsField.TYPE_AUTO_AMMUNITION_CHANGE:
               return Settings.autochangeAmmo;
            case SettingsField.TYPE_AUTO_REFINEMENT:
               return Settings.autoRefinement;
            case SettingsField.TYPE_QUICKSLOT_STOP_ATTACK:
               return Settings.quickSlotStopAttack;
            case SettingsField.TYPE_AUTOSTART:
               return Settings.autoStartEnabled;
            case SettingsField.TYPE_DOUBLECLICK_ATTACK:
               return Settings.doubleclickAttackEnabled;
            case SettingsField.TYPE_DISPLAY_BATTLERAY_NOTIFICATIONS:
               return Settings.displayBattlerayNotifications;
            case SettingsField.TYPE_DISPLAY_WINDOW_BACKGROUND:
               return Settings.displayWindowsBackground.value;
            case SettingsField.TYPE_ALWAYS_DRAGGABLE_WINDOWS:
               return Settings.dragWindowsAlways;
            case SettingsField.TYPE_PELOAD_USER_SHIPS:
               return Settings.preloadUserShips;
            case SettingsField.TYPE_ALLOW_AUTO_QUALITY:
               return Settings.allowAutoQuality.value;
            case SettingsField.TYPE_HOVER_SHIPS:
               return Settings.hoverShips.value;
            case SettingsField.TYPE_PREMIUM_QUICKSLOT_VISIBILITY:
               return Settings.showPremiumQuickslotBar;
            case SettingsField.TYPE_AUTO_BUY_BOOTY_KEYS:
               return Settings.autoBuyBootyKeys;
            case SettingsField.TYPE_SHOW_NOT_OWNED_ITEMS:
               return Settings.showNotOwnedItems;
            case SettingsField.TYPE_SHOW_LOW_HP_WARNINGS:
               return Settings.showLowHpWarnings;
            default:
               return false;
         }
      }
      
      public static function getComboBoxSettingValue(param1:int) : int
      {
         switch(param1)
         {
            case SettingsField.TYPE_RESOLUTION:
               return 0;
            case SettingsField.TYPE_QUALITY_BACKGROUND:
               return Settings.qualityBackground.value;
            case SettingsField.TYPE_QUALITY_POIZONE:
               return Settings.qualityPoizone.value;
            case SettingsField.TYPE_QUALITY_SHIP:
               return Settings.qualityShip.value;
            case SettingsField.TYPE_QUALITY_ENGINE:
               return Settings.qualityEngine.value;
            case SettingsField.TYPE_QUALITY_COLLECTABLE:
               return Settings.qualityCollectable.value;
            case SettingsField.TYPE_QUALITY_ATTACK:
               return Settings.qualityAttack.value;
            case SettingsField.TYPE_QUALITY_EFFECT:
               return Settings.qualityEffect.value;
            case SettingsField.TYPE_QUALITY_EXPLOSION:
               return Settings.qualityExplosion.value;
            default:
               return 0;
         }
      }
      
      public static function getSliderSettingValue(param1:int) : int
      {
         switch(param1)
         {
            case SettingsField.TYPE_QUALITY_PRESETTING:
               return Settings.qualityPresetting;
            default:
               return 0;
         }
      }
      
      public static function setSettableSettingValue(param1:int, param2:String) : void
      {
         var _loc3_:Dictionary = getSettingsAssembleDict();
         if(_loc3_[param1] != null)
         {
            SettingsAssembly.getInstance().assembleSetting([_loc3_[param1],param2]);
         }
      }
      
      private static function getSettingsAssembleDict() : Dictionary
      {
         if(settingsAssemblyDict == null)
         {
            settingsAssemblyDict = new Dictionary();
            settingsAssemblyDict[SettingsField.TYPE_SHOW_CHAT] = ServerCommands.SET_DISPLAY_CHAT;
            settingsAssemblyDict[SettingsField.TYPE_DISPLAY_NOTIFICATIONS] = ServerCommands.SET_DISPLAY_NOTIFICATIONS;
            settingsAssemblyDict[SettingsField.TYPE_MUSIC_VOLUME] = ServerCommands.SET_PLAY_MUSIC;
            settingsAssemblyDict[SettingsField.TYPE_PLAY_COMBAT_MUSIC] = ServerCommands.SET_PLAY_COMBAT_MUSIC;
            settingsAssemblyDict[SettingsField.TYPE_SOUND_VOLUME] = ServerCommands.SET_PLAY_SFX;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_HITPOINT_BUBBLES] = ServerCommands.SET_DISPLAY_HITPOINT_BUBBLES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_PLAYERNAMES] = ServerCommands.SET_DISPLAY_PLAYER_NAMES;
            settingsAssemblyDict[SettingsField.TYPE_AUTO_BOOST] = ServerCommands.SET_AUTO_BOOST;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_RESOURCES] = ServerCommands.SET_DISPLAY_ORE;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_BONUS_BOXES] = ServerCommands.SET_DISPLAY_BONUS_BOXES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_FREE_CARGO_BOXES] = ServerCommands.SET_DISPLAY_FREE_CARGO_BOXES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_NOT_FREE_CARGO_BOXES] = ServerCommands.SET_DISPLAY_NOT_FREE_CARGO_BOXES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_MINIMAP_BACKGROUND_IMAGE] = ServerCommands.SET_DISPLAY_MINIMAP_BACKGROUND_IMAGE;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_DRONES] = ServerCommands.SET_SHOW_DRONES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_MY_DRONES] = ServerCommands.SET_SHOW_MY_DRONES;
            settingsAssemblyDict[SettingsField.TYPE_AUTO_AMMUNITION_CHANGE] = ServerCommands.SET_AUTO_AMMO_CHANGE;
            settingsAssemblyDict[SettingsField.TYPE_AUTO_REFINEMENT] = ServerCommands.SET_AUTO_REFINEMENT;
            settingsAssemblyDict[SettingsField.TYPE_QUICKSLOT_STOP_ATTACK] = ServerCommands.SET_QUICKSLOT_STOP_ATTACK;
            settingsAssemblyDict[SettingsField.TYPE_AUTOSTART] = ServerCommands.SET_AUTO_START;
            settingsAssemblyDict[SettingsField.TYPE_DOUBLECLICK_ATTACK] = ServerCommands.SET_DOUBLECLICK_ATTACK;
            settingsAssemblyDict[SettingsField.TYPE_DISPLAY_BATTLERAY_NOTIFICATIONS] = ServerCommands.SET_DISPLAY_BATTLERAY_NOTIFICATIONS;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_LOW_HP_WARNINGS] = ServerCommands.SET_SHOW_LOW_HP_WARNINGS;
            settingsAssemblyDict[SettingsField.TYPE_AUTO_BUY_BOOTY_KEYS] = ServerCommands.SET_AUTO_BUY_BOOTY_KEYS;
            settingsAssemblyDict[SettingsField.TYPE_DISPLAY_WINDOW_BACKGROUND] = ServerCommands.SET_DISPLAY_WINDOW_BACKGROUND;
            settingsAssemblyDict[SettingsField.TYPE_ALWAYS_DRAGGABLE_WINDOWS] = ServerCommands.SET_ALWAYS_DRAGGABLE_WINDOWS;
            settingsAssemblyDict[SettingsField.TYPE_PELOAD_USER_SHIPS] = ServerCommands.SET_PRELOAD_USER_SHIPS;
            settingsAssemblyDict[SettingsField.TYPE_RESOLUTION] = ServerCommands.SET_RESOLUTION;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_PRESETTING] = ServerCommands.SET_QUALITY_PRESETTING;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_CUSTOMIZED] = ServerCommands.SET_QUALITY_CUSTOMIZED;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_BACKGROUND] = ServerCommands.SET_QUALITY_BACKGROUND;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_SHIP] = ServerCommands.SET_QUALITY_SHIP;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_POIZONE] = ServerCommands.SET_QUALITY_POIZONE;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_ENGINE] = ServerCommands.SET_QUALITY_ENGINE;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_COLLECTABLE] = ServerCommands.SET_QUALITY_COLLECTABLE;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_ATTACK] = ServerCommands.SET_QUALITY_ATTACK;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_EFFECT] = ServerCommands.SET_QUALITY_EFFECT;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_EXPLOSION] = ServerCommands.SET_QUALITY_EXPLOSION;
            settingsAssemblyDict[SettingsField.TYPE_ALLOW_AUTO_QUALITY] = ServerCommands.SET_ALLOW_AUTO_QUALITY;
            settingsAssemblyDict[SettingsField.TYPE_HOVER_SHIPS] = ServerCommands.SET_HOVER_SHIPS;
            settingsAssemblyDict[SettingsField.TYPE_PREMIUM_QUICKSLOT_VISIBILITY] = ServerCommands.SET_PREMIUM_QUICKSLOT_VISIBILITY;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_NOT_OWNED_ITEMS] = ServerCommands.SET_DISPLAY_NOT_OWNED_ITEMS;
         }
         return settingsAssemblyDict;
      }
      
      private function get facade() : GameFacade
      {
         return GameFacade.getInstance();
      }
      
      public function decorate(param1:SimpleWindow) : void
      {
         param1.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.handleSettingsWindowRequested);
         var _loc2_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_SETTING_TABS);
         this.createTabButton(ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY,_loc2_,"setting_btn_display_tab",true);
         this.createTabButton(ButtonElementTypes.TYPE_SETTINGS_TAB_GAMEPLAY,_loc2_,"setting_btn_gameplay_tab");
         this.createTabButton(ButtonElementTypes.TYPE_SETTINGS_TAB_INTERFACE,_loc2_,"setting_btn_interface_tab");
         this.createTabButton(ButtonElementTypes.TYPE_SETTINGS_TAB_SOUND,_loc2_,"setting_btn_sound_tab");
         this.createTabButton(ButtonElementTypes.TYPE_SETTINGS_TAB_KEYBOARD,_loc2_,"setting_btn_keyboard_tab");
         this.createTabLine(_loc2_);
         param1.addContainer(_loc2_);
         _loc2_.addPredefinedPosition(new Point(20,45));
         _loc2_.setPredefinedPosition();
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_DISPLAY,ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY,param1,Main.gameXML.settingsDisplay.settingField,true);
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_GAMEPLAY,ButtonElementTypes.TYPE_SETTINGS_TAB_GAMEPLAY,param1,Main.gameXML.settingsGameplay.settingField,false);
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_INTERFACE,ButtonElementTypes.TYPE_SETTINGS_TAB_INTERFACE,param1,Main.gameXML.settingsInterface.settingField,false);
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_SOUND,ButtonElementTypes.TYPE_SETTINGS_TAB_SOUND,param1,Main.gameXML.settingsSound.settingField,false);
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_KEYBOARD,ButtonElementTypes.TYPE_SETTINGS_TAB_KEYBOARD,param1,Main.gameXML.settingsKeyBoard.settingField,false);
         var _loc3_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_SETTING_BUTTONS);
         var _loc4_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_SAVE_SETTINGS,BPLocale.getItem("sett_save"),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc4_.addEventListener(MouseEvent.CLICK,this.handleSaveButtonClick);
         _loc3_.addElement(_loc4_,SimpleContainer.ALIGN_VERTICAL);
         var _loc5_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_CANCEL_SETTINGS,BPLocale.getItem("btn_cancel"),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc5_.addEventListener(MouseEvent.CLICK,this.handleCancelButtonClick);
         _loc3_.addElement(_loc5_,SimpleContainer.ALIGN_HORIZONTAL);
         var _loc6_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_RESET_SETTINGS,BPLocale.getItem("btn_reset"),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc6_.addEventListener(MouseEvent.CLICK,this.handleResetButtonClick);
         _loc3_.addElement(_loc6_,SimpleContainer.ALIGN_HORIZONTAL);
         param1.addContainer(_loc3_);
         _loc3_.addPredefinedPosition(new Point(30,param1.resizeDimension.y - 11));
         _loc3_.setPredefinedPosition();
      }
      
      public function updateAudioSliderValues() : void
      {
         (this.simpleSliders[SettingsField.TYPE_MUSIC_VOLUME] as SimpleSliderComponent).setSliderValue(Settings.musicVolume);
         (this.simpleSliders[SettingsField.TYPE_SOUND_VOLUME] as SimpleSliderComponent).setSliderValue(Settings.soundVolume);
         (this.simpleSliders[SettingsField.TYPE_VOICE_VOLUME] as SimpleSliderComponent).setSliderValue(Settings.voiceVolume);
      }
      
      private function renderTabPage(param1:int, param2:int, param3:SimpleWindow, param4:XMLList, param5:Boolean = true) : SimpleContainer
      {
         var _loc7_:SimpleContainer = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:XML = null;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:ComboBoxComponent = null;
         var _loc22_:CheckBoxComponent = null;
         var _loc23_:TextFieldElement = null;
         var _loc24_:XML = null;
         var _loc25_:SimpleSliderComponent = null;
         var _loc26_:int = 0;
         var _loc27_:KeyboardRow = null;
         var _loc28_:ButtonElement = null;
         var _loc29_:TextFormat = null;
         var _loc30_:TextField = null;
         var _loc6_:int = 0;
         _loc7_ = new SimpleContainer(this.guiManager,param1);
         param3.removeContainerByType(param1);
         param3.addContainer(_loc7_);
         if(param1 == SimpleContainer.CLASS_SETTING_TABPAGE_KEYBOARD)
         {
            this.scrollContainer = new ScrollableContainer(this.guiManager,param1);
            this.scrollContainer.getScrollPane().y = this.scrollContainer.getScrollPane().y + 20;
            this.scrollContainer.getScrollPane().setSize(400,350);
            _loc7_.addChild(this.scrollContainer.getScrollPane());
         }
         _loc7_.addPredefinedPosition(new Point(10,75));
         _loc7_.setPredefinedPosition();
         this.settingTabPages[param2] = _loc7_;
         _loc7_.visible = param5;
         _loc20_ = "noParam";
         for each(_loc24_ in param4)
         {
            _loc8_ = parseInt(_loc24_.@id);
            _loc9_ = _loc24_.@type;
            _loc10_ = _loc24_.@key;
            _loc12_ = _loc24_.@align;
            _loc11_ = _loc24_.@tooltipKey;
            _loc15_ = ParserUtility.parseBooleanFromString(_loc24_.@isAdvanced);
            _loc19_ = _loc24_.@commandID;
            _loc20_ = _loc24_.@param;
            switch(_loc9_)
            {
               case "slider":
                  _loc17_ = [];
                  for each(_loc16_ in _loc24_.item)
                  {
                     _loc13_ = int(_loc16_.@value);
                     _loc14_ = _loc16_.@languageKey;
                     _loc17_[_loc13_] = new SliderInterval(_loc13_,_loc14_);
                  }
                  this.presettingSlider = new SliderComponent(_loc8_,_loc10_,_loc17_);
                  this.presettingSlider.y = _loc6_;
                  _loc7_.addElement(this.presettingSlider,SimpleContainer.NO_ALIGN);
                  _loc6_ += 60;
                  this.presettingSlider.resetSetting();
                  this.presettingSlider.slider.addEventListener(SliderEvent.CHANGE,this.handlePresettingChanged);
                  if(ParserUtility.parseBooleanFromString(_loc24_.@showAdvancedBtn))
                  {
                     this.advancedBtn = new ButtonElement(ButtonElementTypes.TYPE_ADVANCED_SETTINGS,BPLocale.getItem("btn_advanced"),this.uiResources.getEmbeddedMovieClip("button1"));
                     this.advancedBtn.addEventListener(MouseEvent.CLICK,this.handleAdvancedButtonClick);
                     this.advancedBtn.y = _loc6_;
                     _loc7_.addElement(this.advancedBtn,SimpleContainer.NO_ALIGN);
                     _loc6_ += 25;
                     this.advancedTxt = new TextFieldElement(340,40,new TextFormat(),"");
                     _loc29_ = new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFontHeight,16777215);
                     _loc29_.align = TextFormatAlign.LEFT;
                     _loc30_ = this.advancedTxt.textField;
                     _loc30_.defaultTextFormat = _loc29_;
                     this.advancedTxt.updateText(BPLocale.getItem("info_advanced"));
                     this.advancedTxt.y = _loc6_;
                     _loc7_.addElement(this.advancedTxt);
                     _loc6_ += 34;
                  }
                  break;
               case "simpleslider":
                  _loc25_ = new SimpleSliderComponent(_loc8_,_loc10_,this.handleSimpleSliderChanged);
                  _loc25_.y = _loc6_;
                  if(_loc8_ == SettingsField.TYPE_MUSIC_VOLUME)
                  {
                     _loc25_.setSliderValue(Settings.musicVolume);
                  }
                  else if(_loc8_ == SettingsField.TYPE_SOUND_VOLUME)
                  {
                     _loc25_.setSliderValue(Settings.soundVolume);
                  }
                  else if(_loc8_ == SettingsField.TYPE_VOICE_VOLUME)
                  {
                     _loc25_.setSliderValue(Settings.voiceVolume);
                  }
                  this.simpleSliders[_loc8_] = _loc25_;
                  _loc7_.addElement(_loc25_,SimpleContainer.NO_ALIGN);
                  _loc6_ += 60;
                  break;
               case "combobox":
                  _loc17_ = [];
                  for each(_loc16_ in _loc24_.item)
                  {
                     _loc13_ = int(_loc16_.@value);
                     _loc14_ = _loc16_.@languageKey;
                     if(!(_loc10_ == "setting_quality_background" && !Settings.gpuSupport && _loc13_ == Settings.QUALITY_HIGH))
                     {
                        _loc17_.push(new ComboboxItem(_loc13_,BPLocale.getItem(_loc14_)));
                     }
                  }
                  _loc21_ = new ComboBoxComponent(_loc8_,_loc10_,_loc17_,this.getComboBoxTooltipText(_loc11_),_loc15_);
                  switch(_loc12_)
                  {
                     case "right":
                        _loc7_.addElement(_loc21_,SimpleContainer.ALIGN_HORIZONTAL,40);
                        break;
                     case "left":
                     default:
                        _loc21_.y = _loc6_;
                        _loc7_.addElement(_loc21_,SimpleContainer.NO_ALIGN);
                        _loc6_ += 48;
                  }
                  _loc21_.resetSetting();
                  if(_loc15_)
                  {
                     _loc21_.addEventListener(Event.CHANGE,this.handlePresettingOverwritten);
                  }
                  break;
               case "keyboard_row":
                  _loc26_ = 16777215;
                  if(int(_loc19_) == UserKeyBindingsModule.ACTIONTYPE_QUICKSLOT_PREMIUM)
                  {
                     if(!Hero.premium.value)
                     {
                        break;
                     }
                     _loc26_ = 4488066;
                  }
                  _loc27_ = new KeyboardRow(_loc10_,_loc19_,_loc20_,this.handleKeysettingsClick,this.uiResources.getEmbeddedMovieClip("button1"),_loc26_);
                  _loc27_.keyValuePair.keys = new <int>[-1];
                  this.keyboardRows.push(_loc27_);
                  _loc27_.y = _loc6_;
                  this.scrollContainer.addElement(_loc27_);
                  _loc6_ += _loc27_.height + 5;
                  _loc18_++;
                  break;
               case "header":
                  _loc29_ = new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFontHeight + 2,16777215);
                  _loc29_.underline = true;
                  _loc29_.bold = true;
                  _loc23_ = new TextFieldElement(150,20,_loc29_);
                  if(_loc12_ == "right")
                  {
                     _loc23_.x = 400 - _loc23_.width * 0.5 - 10;
                  }
                  else if(_loc12_ == "left")
                  {
                     _loc23_.x = 10;
                  }
                  else if(_loc12_ == "center")
                  {
                     _loc23_.textField.defaultTextFormat.align = TextFormatAlign.CENTER;
                     _loc23_.x = 200 - _loc23_.width * 0.5 + 10;
                  }
                  _loc23_.textField.text = BPLocale.getItem(_loc10_);
                  _loc7_.addElement(_loc23_);
                  break;
               case "button":
                  _loc28_ = new ButtonElement(_loc8_,BPLocale.getItem(_loc10_),this.uiResources.getEmbeddedMovieClip("button1"));
                  _loc28_.addEventListener(MouseEvent.CLICK,this.settingsButtonClickHandler);
                  _loc28_.y = _loc6_;
                  _loc6_ += 25;
                  _loc7_.addElement(_loc28_,SimpleContainer.NO_ALIGN);
                  break;
               case "checkbox":
                  _loc22_ = new CheckBoxComponent(_loc8_,_loc10_,this.guiManager,_loc11_,_loc15_);
                  _loc22_.y = _loc6_;
                  _loc7_.addElement(_loc22_,SimpleContainer.NO_ALIGN);
                  _loc6_ += 25;
                  if(_loc15_)
                  {
                     _loc22_.addEventListener(Event.CHANGE,this.handlePresettingOverwritten);
                  }
            }
         }
         return _loc7_;
      }
      
      private function closePopUp() : void
      {
         var _loc1_:SimpleWindow = this.guiManager.getWindow(GuiConstants.POPUP_WINDOW);
         _loc1_.minimize(false);
         _loc1_.cleanup();
         this.guiManager.destroyWindow(GuiConstants.POPUP_WINDOW);
         this.guiManager.getMain().stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
      }
      
      private function getKeyboardChar(param1:int) : String
      {
         var _loc2_:String = "";
         if(locaKeys[param1])
         {
            _loc2_ = locaKeys[param1];
         }
         else if(param1 > 111 && param1 <= 126)
         {
            _loc2_ = "F" + (param1 - 111).toString();
         }
         else
         {
            _loc2_ = BPLocale.getItem("keyboard_key_" + param1.toString());
            if(!_loc2_ || _loc2_ == "")
            {
               _loc2_ = String.fromCharCode(param1);
            }
         }
         return _loc2_;
      }
      
      private function setKeyToSetting(param1:int, param2:String) : void
      {
         var _loc4_:KeyboardRow = null;
         var _loc3_:String = this.guiManager.getWindow(GuiConstants.POPUP_WINDOW).name;
         var _loc5_:int = 0;
         while(_loc5_ < this.keyboardRows.length)
         {
            _loc4_ = this.keyboardRows[_loc5_];
            if(_loc4_.keyValuePair.keys[0] == param1 && _loc4_.name != _loc3_)
            {
               _loc4_.keyValuePair.keys = new <int>[-1];
               _loc4_.keyText = locaKeys[_loc4_.keyValuePair.keys[0]];
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.keyboardRows.length)
         {
            _loc4_ = this.keyboardRows[_loc5_];
            if(_loc4_.name == _loc3_)
            {
               _loc4_.keyText = param2;
               _loc4_.keyValuePair.keys = new <int>[param1];
            }
            _loc5_++;
         }
      }
      
      private function getKeyboardvalues() : void
      {
         var _loc2_:KeyboardRow = null;
         var _loc3_:Vector.<int> = null;
         var _loc1_:KeyboardMapper = KeyboardMapper.getInstance();
         var _loc4_:int = 0;
         while(_loc4_ < this.keyboardRows.length)
         {
            _loc2_ = this.keyboardRows[_loc4_];
            if(!_loc2_.keyValuePair.args[0] || _loc2_.keyValuePair.args[0] == "")
            {
               _loc3_ = _loc1_.getKeysOfCommand(_loc2_.keyValuePair.name);
            }
            else
            {
               _loc3_ = _loc1_.getKeysOfCommandWithParam(_loc2_.keyValuePair.name,_loc2_.keyValuePair.args);
            }
            if(_loc3_.length > 0)
            {
               _loc2_.keyText = this.getKeyboardChar(_loc3_[0]);
               _loc2_.keyValuePair.keys = _loc3_;
            }
            _loc4_++;
         }
      }
      
      private function checkKeyboardVisibility() : void
      {
         var _loc1_:SimpleWindow = this.guiManager.getWindow(GuiConstants.SETTINGS_WINDOW);
         _loc1_.removeContainerByType(SimpleContainer.CLASS_SETTING_TABPAGE_KEYBOARD);
         var _loc2_:Boolean = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_KEYBOARD;
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_KEYBOARD,ButtonElementTypes.TYPE_SETTINGS_TAB_KEYBOARD,_loc1_,Main.gameXML.settingsKeyBoard.settingField,_loc2_);
      }
      
      private function createTabButton(param1:int, param2:SimpleContainer, param3:String, param4:Boolean = false) : void
      {
         var _loc5_:ButtonElement = new ButtonElement(param1,BPLocale.getItem(param3),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc5_.selected = param4;
         _loc5_.addEventListener(MouseEvent.CLICK,this.handleSettingsTabClick);
         param2.addElement(_loc5_,SimpleContainer.ALIGN_HORIZONTAL);
         this.settingTabButtons[param1] = _loc5_;
      }
      
      private function createTabLine(param1:SimpleContainer) : void
      {
         var _loc2_:SimpleElement = new SimpleElement(SimpleElement.TYPE_DEFAULT_ELEMENT);
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.lineStyle(1,8289918);
         _loc3_.graphics.moveTo(0,0);
         _loc3_.graphics.lineTo(380,0);
         _loc2_.addChild(_loc3_);
         _loc2_.y = 20;
         param1.addElement(_loc2_,SimpleContainer.NO_ALIGN,0);
      }
      
      private function resetAdvancedSettings() : void
      {
         this.showAdvancedSettings(Settings.qualityCustomized);
      }
      
      private function showAdvancedSettings(param1:Boolean) : void
      {
         var _loc4_:SimpleElement = null;
         this.isAdvanced = param1;
         var _loc2_:SimpleContainer = this.settingTabPages[ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY];
         var _loc3_:Array = _loc2_.getAllElements();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getID() == SimpleElement.TYPE_CHECKBOX)
            {
               if(CheckBoxComponent(_loc4_).isAdvanced)
               {
                  CheckBoxComponent(_loc4_).show(param1);
               }
            }
            if(_loc4_.getID() == SimpleElement.TYPE_COMBOBOX)
            {
               if(ComboBoxComponent(_loc4_).isAdvanced)
               {
                  ComboBoxComponent(_loc4_).show(param1);
               }
            }
         }
         if(this.advancedBtn)
         {
            if(param1)
            {
               this.advancedBtn.labelText = BPLocale.getItem("btn_simple");
               this.advancedTxt.updateText(BPLocale.getItem("info_simple"));
            }
            else
            {
               this.advancedBtn.labelText = BPLocale.getItem("btn_advanced");
               this.advancedTxt.updateText(BPLocale.getItem("info_advanced"));
            }
         }
      }
      
      private function openMenuConfigModePopup() : void
      {
         var _loc1_:ConfigModePopup = ConfigModePopup(FlexWindowManager.getInstance().createWindow(FlexWindowManager.MENU_CONFIG_MODE_POPUP,FlexWindowManager.WINDOW_CENTERED));
         if(!this.facade.hasMediator(ConfigModePopupMediator.NAME))
         {
            this.facade.registerMediator(new ConfigModePopupMediator(_loc1_));
         }
         this.facade.sendNotification(GuiNotifications.MANAGE_MENUS_CONFIG_MODE,true);
      }
      
      private function closeResetSettingsWindow() : void
      {
         var _loc5_:SimpleElement = null;
         var _loc6_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.guiManager.getWindow(GuiConstants.RESET_PROMPT_WINDOW);
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
         this.guiManager.closeWindow(_loc1_);
      }
      
      private function saveKeyboardSettings() : void
      {
         var _loc1_:KeyValuePair = null;
         var _loc2_:KeyboardRow = null;
         KeyboardMapper.getInstance().cleanup();
         for each(_loc2_ in this.keyboardRows)
         {
            _loc1_ = _loc2_.keyValuePair;
            this.settingsWindowKeyboardParser.addKeyValuePair(_loc1_.keys[0],_loc1_.args,_loc1_.name);
            this.keyboardSendComponent.addAddKey(_loc1_);
         }
         this.keyboardSendComponent.addKeys();
         KeyboardMapper.getInstance().addKeys(this.settingsWindowKeyboardParser);
         this.settingsWindowKeyboardParser.reset();
      }
      
      private function getComboBoxTooltipText(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case "ttip_setting_quality_background":
               if(!Settings.gpuSupport)
               {
                  _loc2_ = BPLocale.getItem("ttip_setting_quality_background") + "\n" + BPLocale.getItem("ttip_setting_quality_high_option_unsupported_gpu");
               }
               else
               {
                  _loc2_ = BPLocale.getItem(param1);
               }
               break;
            case "":
               break;
            default:
               _loc2_ = BPLocale.getItem(param1);
         }
         return _loc2_;
      }
      
      private function resetSettingFields() : void
      {
         var _loc1_:SimpleContainer = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:SimpleElement = null;
         for each(_loc1_ in this.settingTabPages)
         {
            _loc2_ = _loc1_.getAllElements();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_];
               if(_loc4_.getID() == SimpleElement.TYPE_SLIDER)
               {
                  SliderComponent(_loc4_).resetSetting();
               }
               if(_loc4_.getID() == SimpleElement.TYPE_CHECKBOX)
               {
                  CheckBoxComponent(_loc4_).resetSetting();
               }
               if(_loc4_.getID() == SimpleElement.TYPE_COMBOBOX)
               {
                  ComboBoxComponent(_loc4_).resetSetting();
               }
               _loc3_++;
            }
         }
         this.resetAdvancedSettings();
      }
      
      private function settingsButtonClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ButtonElement = param1.currentTarget as ButtonElement;
         switch(_loc2_.getType())
         {
            case SettingsField.TYPE_OPEN_CONFIG_MODE_POPUP:
               this.openMenuConfigModePopup();
               this.handleCancelButtonClick();
               break;
            case SettingsField.TYPE_SWITCH_TO_3D:
               this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_DISPLAY,ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY,this.guiManager.getWindow(GuiConstants.SETTINGS_WINDOW),Main.gameXML.settingsDisplay3D.settingField,true);
         }
      }
      
      private function handleKeysettingsClick(param1:MouseEvent) : void
      {
         var _loc2_:KeyboardRow = param1.currentTarget as KeyboardRow;
         this.guiManager.createKeyboardPopUp(this.handleKeyDown,this.onClosePopUp);
         var _loc3_:SimpleWindow = this.guiManager.getWindow(GuiConstants.POPUP_WINDOW);
         _loc3_.name = _loc2_.name;
      }
      
      private function onClosePopUp(param1:MouseEvent) : void
      {
         this.closePopUp();
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:String = this.getKeyboardChar(param1.keyCode);
         this.setKeyToSetting(param1.keyCode,_loc2_);
         this.closePopUp();
      }
      
      private function handlePresettingOverwritten(param1:Event) : void
      {
         if(!Settings.qualityCustomized)
         {
            setSettableSettingValue(SettingsField.TYPE_QUALITY_CUSTOMIZED,String(1));
         }
         this.presettingSlider.setCurrentValueText("quality_custom");
      }
      
      private function handlePresettingChanged(param1:SliderEvent) : void
      {
         var _loc6_:SimpleElement = null;
         var _loc7_:PresettingItem = null;
         var _loc2_:Slider = Slider(param1.target);
         if(Settings.qualityCustomized)
         {
            setSettableSettingValue(SettingsField.TYPE_QUALITY_CUSTOMIZED,String(0));
         }
         var _loc3_:SimpleContainer = this.settingTabPages[ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY];
         var _loc4_:Array = _loc3_.getAllElements();
         var _loc5_:Array = this.qualityPresetting.getQualitySet(_loc2_.value);
         for each(_loc7_ in _loc5_)
         {
            for each(_loc6_ in _loc4_)
            {
               if(_loc6_.getID() == SimpleElement.TYPE_CHECKBOX)
               {
                  if(CheckBoxComponent(_loc6_).typeID == _loc7_.typeID)
                  {
                     CheckBoxComponent(_loc6_).switchChecked(_loc7_.value);
                  }
               }
               if(_loc6_.getID() == SimpleElement.TYPE_COMBOBOX)
               {
                  if(ComboBoxComponent(_loc6_).type == _loc7_.typeID)
                  {
                     ComboBoxComponent(_loc6_).setSelected(_loc7_.value);
                  }
               }
            }
         }
      }
      
      private function handleSimpleSliderChanged(param1:SliderEvent) : void
      {
         var _loc2_:Slider = Slider(param1.target);
         if(_loc2_.name == SettingsField.TYPE_MUSIC_VOLUME.toString())
         {
            AudioSettingsHandler.run(new AudioSettingsModule(false,Settings.soundVolume,_loc2_.value,Settings.voiceVolume,Settings.playCombatMusic.value),true);
            this.guiManager.saveAudioSettings(null,true);
            AudioManager.updateMusicVolume();
         }
         else if(_loc2_.name == SettingsField.TYPE_SOUND_VOLUME.toString())
         {
            AudioSettingsHandler.run(new AudioSettingsModule(false,_loc2_.value,Settings.musicVolume,Settings.voiceVolume,Settings.playCombatMusic.value),true);
            this.guiManager.saveAudioSettings(null,true);
            AudioManager.updateSoundVolume();
         }
         else if(_loc2_.name == SettingsField.TYPE_VOICE_VOLUME.toString())
         {
            AudioSettingsHandler.run(new AudioSettingsModule(false,Settings.soundVolume,Settings.musicVolume,_loc2_.value,Settings.playCombatMusic.value),true);
            this.guiManager.saveAudioSettings(null,true);
            AudioManager.updateSoundVolume();
         }
      }
      
      private function handleSettingsTabClick(param1:MouseEvent) : void
      {
         this._selectedTabId = (param1.currentTarget as ButtonElement).getType();
         (this.settingTabButtons[ButtonElementTypes.TYPE_SETTINGS_TAB_GAMEPLAY] as ButtonElement).selected = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_GAMEPLAY;
         (this.settingTabButtons[ButtonElementTypes.TYPE_SETTINGS_TAB_INTERFACE] as ButtonElement).selected = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_INTERFACE;
         (this.settingTabButtons[ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY] as ButtonElement).selected = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY;
         (this.settingTabButtons[ButtonElementTypes.TYPE_SETTINGS_TAB_SOUND] as ButtonElement).selected = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_SOUND;
         (this.settingTabButtons[ButtonElementTypes.TYPE_SETTINGS_TAB_KEYBOARD] as ButtonElement).selected = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_KEYBOARD;
         (this.settingTabPages[ButtonElementTypes.TYPE_SETTINGS_TAB_KEYBOARD] as SimpleContainer).visible = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_KEYBOARD;
         (this.settingTabPages[ButtonElementTypes.TYPE_SETTINGS_TAB_GAMEPLAY] as SimpleContainer).visible = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_GAMEPLAY;
         (this.settingTabPages[ButtonElementTypes.TYPE_SETTINGS_TAB_INTERFACE] as SimpleContainer).visible = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_INTERFACE;
         (this.settingTabPages[ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY] as SimpleContainer).visible = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_DISPLAY;
         (this.settingTabPages[ButtonElementTypes.TYPE_SETTINGS_TAB_SOUND] as SimpleContainer).visible = this._selectedTabId == ButtonElementTypes.TYPE_SETTINGS_TAB_SOUND;
      }
      
      private function handleSettingsWindowRequested(param1:SimpleWindowEvent) : void
      {
         this.checkKeyboardVisibility();
         this.resetSettingFields();
         this.getKeyboardvalues();
      }
      
      private function handleAdvancedButtonClick(param1:MouseEvent) : void
      {
         this.showAdvancedSettings(!this.isAdvanced);
      }
      
      private function handleResetButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = this.guiManager.createWindow(GuiConstants.RESET_PROMPT_WINDOW,new SimpleWindowCreationVO(GuiConstants.RESET_PROMPT_WINDOW,null,SimpleWindow.OPEN_STRATEGY_LAYER_2)) as SimpleWindow;
         this.guiManager.getMain().screenManager.getWindowLayer2().addChild(_loc2_);
         var _loc3_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_PROMPT);
         var _loc4_:TextFieldElement = new TextFieldElement(280,80,new TextFormat(),"");
         var _loc5_:TextFormat = new TextFormat(Styles.plainBigFmt.font,Styles.plainBigFontHeight,16777215);
         _loc5_.align = TextFormatAlign.CENTER;
         var _loc6_:TextField = _loc4_.textField;
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
         var _loc7_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_OK,BPLocale.getItem("dest_ok"),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc7_.addEventListener(MouseEvent.CLICK,this.handleConfirmResetSettingsButtonClick);
         _loc3_.addElement(_loc7_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc7_.x -= _loc7_.width;
         var _loc8_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_CANCEL,BPLocale.getItem("btn_cancel"),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc8_.addEventListener(MouseEvent.CLICK,this.handleResetSettingsCancel);
         _loc3_.addElement(_loc8_,SimpleContainer.ALIGN_HORIZONTAL);
         _loc2_.addContainer(_loc3_);
         _loc2_.activateModalLayer(true);
      }
      
      private function handleConfirmResetSettingsButtonClick(param1:MouseEvent) : void
      {
         this.guiManager.getMain().getConnectionManager().sendRequest(new ResetSettingsRequest());
         JavascriptProxy.call(JavascriptProxy.FUNCTION_CLOSE_CHILD_WINDOW,[false],System.exit,[0]);
      }
      
      private function handleResetSettingsCancel(param1:MouseEvent) : void
      {
         this.settingsWindowKeyboardParser.reset();
         this.closeResetSettingsWindow();
      }
      
      private function handleSaveButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:SimpleWindow = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:SimpleElement = null;
         this.saveKeyboardSettings();
         for each(_loc2_ in this.settingTabPages)
         {
            _loc4_ = _loc2_.getAllElements();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               if(_loc6_.getID() == SimpleElement.TYPE_SLIDER)
               {
                  SliderComponent(_loc6_).setSetting();
               }
               if(_loc6_.getID() == SimpleElement.TYPE_CHECKBOX)
               {
                  CheckBoxComponent(_loc6_).setSetting();
               }
               if(_loc6_.getID() == SimpleElement.TYPE_COMBOBOX)
               {
                  ComboBoxComponent(_loc6_).setSetting();
               }
               _loc5_++;
            }
         }
         _loc3_ = this.guiManager.getWindow(GuiConstants.SETTINGS_WINDOW);
         _loc3_.dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.SAVE_WINDOW_SETTINGS));
         _loc3_.dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.SAVE_AUDIO_SETTINGS));
         _loc3_.dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.SAVE_DISPLAY_SETTINGS));
         _loc3_.dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.SAVE_QUALITY_SETTINGS));
         _loc3_.dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.SAVE_GAMEPLAY_SETTINGS));
         _loc3_.minimize();
      }
      
      private function handleCancelButtonClick(param1:MouseEvent = null) : void
      {
         this.settingsWindowKeyboardParser.reset();
         AudioSettingsHandler.restoreLastSavedSettings();
         this.guiManager.getWindow(GuiConstants.SETTINGS_WINDOW).minimize();
      }
   }
}

