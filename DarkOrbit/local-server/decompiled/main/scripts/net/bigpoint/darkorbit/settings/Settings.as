package net.bigpoint.darkorbit.settings
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.net.SharedObject;
   import flash.system.Capabilities;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.vo.InstantLogViewConfigurationVO;
   
   public class Settings
   {
      
      public static var crossdomainHash:String;
      
      private static var _localSettings:SharedObject;
      
      public static var userType:int;
      
      public static var autoBoost:Boolean;
      
      public static var autoRefinement:Boolean;
      
      public static var instantLogViewConfig:InstantLogViewConfigurationVO;
      
      public static var advertisingHintEnabled:Boolean;
      
      public static var instanceID:int;
      
      public static var chatHost:String;
      
      public static var boardLink:String;
      
      public static var basePath:String;
      
      public static var language:String;
      
      public static var staticHost:String;
      
      public static var sharedImagesHost:String;
      
      private static var _defaultGameServer:String;
      
      public static var useDefaultGameServer:Boolean;
      
      private static var _majorVersion:int;
      
      private static var _minorVersion:int;
      
      private static var _buildNumber:int;
      
      public static var browser:String;
      
      public static var profileXMLHash:String;
      
      public static var resourceXMLHash:String;
      
      public static var resources3dXmlHash:String;
      
      public static var resources3dparticlesXmlHash:String;
      
      private static var _itemXMLHash:String;
      
      public static const USER_TYPE_NEW:int = -1;
      
      public static const USER_TYPE_NOT_SELECTED:int = 0;
      
      public static const USER_TYPE_2D:int = 2;
      
      public static const USER_TYPE_3D:int = 1;
      
      public static const collisions:BindableBoolean = new BindableBoolean(true);
      
      public static var achievementsResourceHash:String = "";
      
      public static var commandCenterHash:String = "";
      
      public static var eventsResourceHash:String = "";
      
      public static var jumpGateResourceHash:String = "";
      
      public static var platform:String = "";
      
      public static var platformTypeWeb:String = "WEB";
      
      public static var platformTypeClient:String = "PC_CLIENT";
      
      private static var _localSettingsAvailable:Boolean = true;
      
      public static var localSettingsErrors:String = "";
      
      public static const QUALITY_LOW:int = 0;
      
      public static const QUALITY_MEDIUM:int = 1;
      
      public static const QUALITY_GOOD:int = 2;
      
      public static const QUALITY_HIGH:int = 3;
      
      public static var selectedLauncherRocket:int = 6;
      
      private static var _selectedConfiguration:int = 1;
      
      public static var selectedQuickBuyIcon:int = 1;
      
      public static var questsAvailableFilter:Boolean = true;
      
      public static var questsUnavailableFilter:Boolean = false;
      
      public static var questsCompletedFilter:Boolean = false;
      
      public static var questsLevelOrderDescending:Boolean = false;
      
      public static var challengesAttemptedFilter:Boolean = true;
      
      public static var challengesUnattemptedFilter:Boolean = true;
      
      public static var languageXMLHash:String = "";
      
      private static var _driverInfo:String = "";
      
      public static var stage3DProfile:String = "";
      
      public static var useEmbeddedFonts:Boolean = true;
      
      public static var displayChat:BindableBoolean = new BindableBoolean(true);
      
      public static var playMusic:BindableBoolean = new BindableBoolean(true);
      
      public static var playCombatMusic:BindableBoolean = new BindableBoolean(true);
      
      public static var combatMusicActive:BindableBoolean = new BindableBoolean(false);
      
      public static var playSFX:BindableBoolean = new BindableBoolean(true);
      
      public static var playVoice:BindableBoolean = new BindableBoolean(true);
      
      public static var musicVolume:int = 50;
      
      public static var soundVolume:int = 50;
      
      public static var voiceVolume:int = 50;
      
      public static var displayHitpointBubbles:Boolean = true;
      
      public static const displayPlayerNames:BindableBoolean = new BindableBoolean(true);
      
      public static const displayNotifications:BindableBoolean = new BindableBoolean(true);
      
      public static const displayResources:BindableBoolean = new BindableBoolean(true);
      
      public static const displayBonusBoxes:BindableBoolean = new BindableBoolean(true);
      
      public static const displayFreeCargoBoxes:BindableBoolean = new BindableBoolean(true);
      
      public static const displayNotFreeCargoBoxes:BindableBoolean = new BindableBoolean(false);
      
      public static const displayMiniMapBackgroundImage:BindableBoolean = new BindableBoolean(true);
      
      public static const showMyDrones:BindableBoolean = new BindableBoolean(true);
      
      public static const showDrones:BindableBoolean = new BindableBoolean(true);
      
      public static const show2DFormation:BindableBoolean = new BindableBoolean(false);
      
      public static var hoverShips:BindableBoolean = new BindableBoolean(true);
      
      private static var _showPremiumQuickslotBar:Boolean = true;
      
      public static var proActionBarEnabled:BindableBoolean = new BindableBoolean(true);
      
      public static var proActionBarAutohideEnabled:Boolean = true;
      
      public static var proActionBarKeyboardInputEnabled:Boolean = true;
      
      public static var autochangeAmmo:Boolean = true;
      
      public static var quickSlotStopAttack:Boolean = true;
      
      public static const enemyCount:BindableInt = new BindableInt(0);
      
      public static var useLocalMapsXML:Boolean = false;
      
      public static var JS_EVENT_TRACKING_ENABLED:Boolean = false;
      
      public static var doubleclickAttackEnabled:Boolean = true;
      
      public static var displayBattlerayNotifications:Boolean = false;
      
      public static var autoBuyBootyKeys:Boolean = false;
      
      public static var showLowHpWarnings:Boolean = true;
      
      public static var showNotOwnedItems:Boolean = false;
      
      public static var autoStartEnabled:Boolean = false;
      
      public static var singleSessionAutoStartEnabled:Boolean = false;
      
      public static var showInstantLog:Boolean = true;
      
      public static const createCollectables:Boolean = true;
      
      public static const createOpponents:Boolean = true;
      
      public static var createChat:Boolean = true;
      
      public static const createMinimap:Boolean = true;
      
      public static const createMusic:Boolean = true;
      
      public static var unloadResources:Boolean = true;
      
      public static var nextMapID:int = -1;
      
      public static var mapID:int = -1;
      
      public static var lastMapID:int = -1;
      
      public static var currency:String = "EUR";
      
      public static var dynamicHost:String = "/";
      
      public static var rocketLauncherTypes:Vector.<int> = new Vector.<int>();
      
      public static var rocketLauncherRocketsLoaded:int = 0;
      
      public static var displayWindowsBackground:BindableBoolean = new BindableBoolean(true);
      
      public static var maxWindowsTransparency:Number = 1;
      
      public static var gridSize:int = 10;
      
      public static var dragWindowsAlways:Boolean = true;
      
      public static var preloadUserShips:Boolean = false;
      
      public static var resizeOnTheFly:Boolean = true;
      
      public static const allowAutoQuality:BindableBoolean = new BindableBoolean(true);
      
      public static const autoQualityReduction:BindableInt = new BindableInt(0,0);
      
      public static const AQ_NONE:int = 0;
      
      public static const AQ_NO_STARFIELD_MOVEMENT_LIMIT:int = 5;
      
      public static const AQ_NO_PORTAL_TARGET_PREVIEW_LIMIT:int = 1;
      
      public static const AQ_NO_ENGINE_SMOKE_LIMIT:int = 2;
      
      public static const AQ_NO_ANIMATED_MAPASSETS_LIMIT:int = 3;
      
      public static const AQ_LOW_EXPLOSION_DETAIL_LIMIT:int = 4;
      
      public static const AQ_NO_EXPLOSION_LIMIT:int = 5;
      
      public static const AQ_MAX_REDUCTION:int = 5;
      
      public static var qualityPresetting:int = 3;
      
      public static var qualityCustomized:Boolean = false;
      
      public static const qualityBackground:BindableSettings = new BindableSettings(QUALITY_HIGH);
      
      public static const qualityPoizone:BindableSettings = new BindableSettings(QUALITY_HIGH);
      
      public static const qualityShip:BindableInt = new BindableInt(QUALITY_LOW);
      
      public static const qualityEngine:BindableInt = new BindableInt(QUALITY_LOW);
      
      public static const qualityExplosion:BindableInt = new BindableInt(QUALITY_LOW);
      
      public static const qualityCollectable:BindableInt = new BindableInt(QUALITY_LOW);
      
      public static const qualityAttack:BindableInt = new BindableInt(QUALITY_HIGH);
      
      public static const qualityEffect:BindableInt = new BindableInt(QUALITY_HIGH);
      
      public static var gpuSupport:Boolean = true;
      
      public static const FORCE_2D:BindableBoolean = initLocalBooleanSetting("force2D",false);
      
      public static const displaySetting3DqualityAntialias:BindableSettings = initLocalIntegerSetting("displaySetting3DqualityAntialias",3);
      
      public static const displaySetting3DqualityLights:BindableSettings = initLocalIntegerSetting("displaySetting3DqualityLights",3);
      
      public static const displaySetting3DqualityTextures:BindableSettings = initLocalIntegerSetting("displaySetting3DqualityTextures",3);
      
      public static const displaySetting3DsizeTextures:BindableSettings = initLocalIntegerSetting("displaySetting3DsizeTextures",3);
      
      public static const displaySetting3DqualityEffects:BindableSettings = initLocalIntegerSetting("displaySetting3DqualityEffects",3);
      
      public static const displaySetting3DtextureFiltering:BindableSettings = initLocalIntegerSetting("displaySetting3DtextureFiltering",3);
      
      public static const displaySettingPixelationMode:BindableBoolean = new BindableBoolean(false);
      
      public static var pixelatedRenderingAvailable:BindableBoolean = new BindableBoolean(false);
      
      public static const showHUD:BindableBoolean = new BindableBoolean(true);
      
      public static const showUI:BindableBoolean = new BindableBoolean(true);
      
      public static const show_debug_objects:BindableBoolean = new BindableBoolean(false);
      
      public static var isPepperFlashPlayer:Boolean = false;
      
      public static var gameXMLHash:String = "8e862ced6d19447d051139697b4db264";
      
      public static var eventStreamContext:String = null;
      
      private static var _has3DCapabilities:Boolean = false;
      
      public static var traceCom:Boolean = false;
      
      public function Settings()
      {
         super();
      }
      
      private static function initLocalBooleanSetting(param1:String, param2:Boolean) : BindableBoolean
      {
         var bindable:BindableBoolean = null;
         var key:String = param1;
         var defaultValue:Boolean = param2;
         if(_localSettings == null)
         {
            try
            {
               _localSettings = SharedObject.getLocal("darkorbit","/");
            }
            catch(e:Error)
            {
               _localSettingsAvailable = false;
               localSettingsErrors += e + "\n";
            }
         }
         bindable = new BindableBoolean(defaultValue);
         if(_localSettings != null)
         {
            if(Boolean(_localSettings.data.settings) && _localSettings.data.settings[key] !== undefined)
            {
               bindable.value = Boolean(_localSettings.data.settings[key]);
            }
            else
            {
               storeLocalBooleanSetting(key,bindable);
               _localSettingsAvailable = false;
            }
            bindable.changed.add(function():void
            {
               storeLocalBooleanSetting(key,bindable);
            });
         }
         return bindable;
      }
      
      public static function initLocalIntegerSetting(param1:String, param2:int) : BindableSettings
      {
         var bindable:BindableSettings = null;
         var key:String = param1;
         var defaultValue:int = param2;
         if(_localSettings == null)
         {
            _localSettingsAvailable = false;
            try
            {
               _localSettings = SharedObject.getLocal("darkorbit","/");
            }
            catch(e:Error)
            {
            }
         }
         bindable = new BindableSettings(defaultValue);
         if(_localSettings != null)
         {
            if(Boolean(_localSettings.data.settings) && _localSettings.data.settings[key] !== undefined)
            {
               bindable.value = int(_localSettings.data.settings[key]);
            }
            else
            {
               storeLocalIntegerSetting(key,bindable);
               _localSettingsAvailable = false;
            }
            bindable.changed.add(function():void
            {
               storeLocalIntegerSetting(key,bindable);
            });
         }
         return bindable;
      }
      
      private static function storeLocalIntegerSetting(param1:String, param2:BindableSettings) : void
      {
         var key:String = param1;
         var bindable:BindableSettings = param2;
         if(_localSettings.data.settings == null)
         {
            _localSettings.data.settings = {};
         }
         _localSettings.data.settings[key] = bindable.value;
         try
         {
            _localSettings.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public static function storeLocalBooleanSetting(param1:String, param2:BindableBoolean) : void
      {
         var key:String = param1;
         var bindable:BindableBoolean = param2;
         if(_localSettings.data.settings == null)
         {
            _localSettings.data.settings = {};
         }
         _localSettings.data.settings[key] = bindable.value;
         try
         {
            _localSettings.flush();
         }
         catch(e:Error)
         {
         }
      }
      
      public static function get useATF() : Boolean
      {
         return gpuSupport;
      }
      
      public static function getQualitySettingLevel() : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Array = [qualityBackground.value,qualityPoizone.value,qualityShip,qualityEngine,qualityExplosion,qualityCollectable.value];
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            _loc2_ += _loc3_;
         }
         return int(Math.round(_loc2_ / _loc1_.length));
      }
      
      public static function parsePlayerVersion() : void
      {
         var _loc1_:String = Capabilities.version;
         var _loc2_:Array = _loc1_.split(",");
         var _loc3_:Array = String(_loc2_[0]).split(" ");
         _majorVersion = parseInt(_loc3_[1]);
         _minorVersion = parseInt(_loc2_[1]);
         _buildNumber = parseInt(_loc2_[2]);
      }
      
      public static function get showPremiumQuickslotBar() : Boolean
      {
         return _showPremiumQuickslotBar;
      }
      
      public static function set showPremiumQuickslotBar(param1:Boolean) : void
      {
         _showPremiumQuickslotBar = param1;
      }
      
      public static function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += "chatHost   = " + chatHost + "\n";
         return _loc1_ + ("instanceID = " + instanceID + "\n");
      }
      
      public static function setDefaultQualitySettings() : void
      {
         qualityShip.value = QUALITY_HIGH;
         qualityEngine.value = QUALITY_HIGH;
         qualityExplosion.value = QUALITY_HIGH;
         qualityCollectable.value = QUALITY_HIGH;
      }
      
      public static function localSettingsAvailable() : Boolean
      {
         return _localSettingsAvailable;
      }
      
      public static function get has3DCapabilities() : Boolean
      {
         return _has3DCapabilities;
      }
      
      public static function get driverInfo() : String
      {
         return _driverInfo;
      }
      
      public static function set driverInfo(param1:String) : void
      {
         _driverInfo = param1;
         var _loc2_:Array = Capabilities.version.split(" ")[1].split(",");
         var _loc3_:Number = int(_loc2_[0]) + int(_loc2_[1]) / 10;
         Settings.gpuSupport = _driverInfo && _driverInfo.indexOf("Software") == -1 && _driverInfo.indexOf("Disabled") == -1 && _loc3_ >= 11.8;
         _has3DCapabilities = gpuSupport;
      }
      
      public static function set itemXMLHash(param1:String) : void
      {
         _itemXMLHash = param1;
      }
      
      public static function get itemXMLHash() : String
      {
         return _itemXMLHash;
      }
      
      public static function getCurrentSettingsTrackData() : Object
      {
         var _loc1_:Object = {};
         if(Settings.FORCE_2D.value || !Settings.gpuSupport)
         {
            _loc1_.background = Settings.qualityBackground.value;
            _loc1_.zones = Settings.qualityPoizone.value;
            _loc1_.qualityShip = Settings.qualityShip.value;
            _loc1_.qualityEngine = Settings.qualityEngine.value;
            _loc1_.qualityExplosion = Settings.qualityExplosion.value;
            _loc1_.qualityCollectable = Settings.qualityCollectable.value;
         }
         else
         {
            _loc1_.antiAlias = Settings.displaySetting3DqualityAntialias.value;
            _loc1_.background = Settings.qualityBackground.value;
            _loc1_.fx = Settings.displaySetting3DqualityEffects.value;
            _loc1_.lights = Settings.displaySetting3DqualityLights.value;
            _loc1_.textureQuality = Settings.displaySetting3DqualityTextures.value;
            _loc1_.zones = Settings.qualityPoizone.value;
            _loc1_.textureSize = Settings.displaySetting3DsizeTextures.value;
            _loc1_.textureFiltering = Settings.displaySetting3DtextureFiltering.value;
         }
         return _loc1_;
      }
      
      public static function get selectedConfiguration() : int
      {
         return _selectedConfiguration;
      }
      
      public static function set selectedConfiguration(param1:int) : void
      {
         _selectedConfiguration = param1;
      }
      
      public static function get defaultGameServer() : String
      {
         return _defaultGameServer;
      }
      
      public static function set defaultGameServer(param1:String) : void
      {
         useDefaultGameServer = true;
         _defaultGameServer = param1;
      }
      
      public static function isTestInstance() : Boolean
      {
         var _loc1_:Array = [175,316,679,1103,1123,1199];
         if(_loc1_.indexOf(instanceID) != -1)
         {
            return true;
         }
         return false;
      }
   }
}

