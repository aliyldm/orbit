package net.bigpoint.darkorbit.equipment.model
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.bplocale.BPLocaleEvent;
   import net.bigpoint.as3toolbox.bplocale.parser.IBPLocaleParser;
   import net.bigpoint.darkorbit.bplocal.BPLocalLoadVO;
   import net.bigpoint.darkorbit.bplocal.BPLocalLoader;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.model.VO.FileHashList;
   import net.bigpoint.darkorbit.equipment.model.deprecated.AvatarVO;
   import net.bigpoint.darkorbit.equipment.view.Fonts;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.utils.BPlocaleParser4Equipment;
   import net.bigpoint.utils.DebugSession;
   import net.bigpoint.utils.TextFormatter;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class LoadDataProxy extends Proxy implements IProxy
   {
      
      public static const PROXY_NAME:String = "LoadDataProxy";
      
      public var entries:Array;
      
      private var loadedEventName:String = "Nothing";
      
      private var entry:AvatarVO;
      
      public var thumbsBmp:Array;
      
      public var assetLib:Array = [];
      
      private var neededAssetsCount:uint;
      
      private var loadingItemIndex:int = 0;
      
      public var fileHashList:FileHashList = new FileHashList();
      
      public const PRE_PATH:String = "inventory_item-icons_global_items_";
      
      public function LoadDataProxy(param1:String, param2:String)
      {
         super(param1,null);
      }
      
      public function loadAssets() : void
      {
         var _loc1_:Array = ["accordionBtn","scrollComponents","inventoryItems"];
         this.neededAssetsCount = _loc1_.length;
         var _loc2_:int = 0;
         while(_loc2_ < this.neededAssetsCount)
         {
            AssetProxy.load(_loc1_[_loc2_],this.handleAssetLoaded);
            _loc2_++;
         }
      }
      
      private function handleAssetLoaded(param1:SWFFinisher = null) : void
      {
         if(++this.loadingItemIndex == this.neededAssetsCount)
         {
            sendNotification(ApplicationNotificationNames.ASSETS_LOADED);
         }
      }
      
      public function loadLocalConfig(param1:Stage) : void
      {
         this.parseFlashVars(param1.loaderInfo.parameters);
         sendNotification(ApplicationNotificationNames.INIT_APPLICATION);
      }
      
      private function updateSettingsFromDebugSettings() : void
      {
         DebugSession.initUserSession();
         Settings.username = DebugSession.username;
         Settings.userID = DebugSession.userID;
         Settings.password = DebugSession.password;
         Settings.employeeID = DebugSession.employeeID;
         Settings.projectID = DebugSession.projectID;
         Settings.baseServerName = DebugSession.host;
         Settings.instance = DebugSession.instance;
         Settings.language = DebugSession.lang;
         Settings.baseServerName = DebugSession.baseServerName;
         Settings.cdnHost = "http://" + DebugSession.cdnHost + "/";
         Settings.dynamicHost = "http://" + DebugSession.host + "/";
      }
      
      private function parseFlashVars(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         try
         {
            for(_loc3_ in param1)
            {
               _loc2_ = param1[_loc3_];
               switch(_loc3_)
               {
                  case "lang":
                     Settings.language = _loc2_.split("_")[0];
                     break;
                  case "dynamicHost":
                     Settings.dynamicHost = _loc2_ + "/";
                     break;
                  case "hangarPage":
                     Settings.hangarPage = int(_loc2_);
                     break;
                  case "cdn":
                     Settings.cdnHost = _loc2_;
                     break;
                  case "locale_hash":
                     this.fileHashList.locale = _loc2_;
                     break;
                  case "assets_config_hash":
                     this.fileHashList.assetsConfig = _loc2_;
                     break;
                  case "items_config_hash":
                     this.fileHashList.itemsConfig = _loc2_;
                     break;
                  case "menu_layout_config_hash":
                     this.fileHashList.menuLayoutConfig = _loc2_;
                     break;
                  case "useDeviceFonts":
                     Settings.useEmbeddedFonts = _loc2_ != "1";
                     break;
                  case "languageXmlHash":
                     Settings.languageXMLHash = _loc2_;
                     break;
                  case "show":
                     Settings.showViewOnInit = _loc2_;
               }
            }
            if(Settings.useEmbeddedFonts)
            {
               Fonts.initialize();
            }
            else
            {
               Styles.useDeviceFonts();
            }
            if(Settings.cdnHost != null && Settings.cdnHost.length > 0)
            {
               Security.allowDomain(Settings.cdnHost);
            }
            else
            {
               Settings.cdnHost = Settings.dynamicHost;
            }
            Security.allowDomain(Settings.dynamicHost);
         }
         catch(error:Error)
         {
         }
      }
      
      public function initBPLocale() : void
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.handleHashFileLoaded);
         var _loc2_:String = Settings.cdnHost + "spacemap/templates/language_" + Settings.language + ".xml?__cv=" + Settings.languageXMLHash;
         _loc1_.load(new URLRequest(_loc2_));
      }
      
      private function handleHashFileLoaded(param1:Event) : void
      {
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:IBPLocaleParser = null;
         var _loc12_:Vector.<BPLocalLoadVO> = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.handleHashFileLoaded);
         var _loc3_:XMLList = XML(_loc2_.data).children();
         var _loc4_:Dictionary = new Dictionary();
         for each(_loc5_ in _loc3_)
         {
            _loc4_[_loc5_.attribute("name").toString()] = _loc5_.attribute("hash").toString();
         }
         _loc6_ = Settings.language;
         _loc7_ = Settings.cdnHost + "spacemap/templates/" + _loc6_ + "/";
         _loc8_ = _loc7_ + "resource_items.xml?__cv=" + _loc4_["resource_items"];
         _loc9_ = _loc7_ + "resource_inventory.xml?__cv=" + _loc4_["resource_inventory"];
         _loc10_ = _loc7_ + "resource_equipment_ui.xml?__cv=" + _loc4_["resource_equipment_ui"];
         _loc11_ = new BPlocaleParser4Equipment();
         BPLocale.setParser(_loc11_);
         BPLocale.addEventListener(BPLocaleEvent.NO_LANGUAGES_LEFT_TO_LOAD,this.handleBPLocaleLanguageLoaded);
         BPLocale.addEventListener(BPLocaleEvent.LANGUAGE_LOADING_ERROR,this.handleBPLocaleLanguageLoadingError);
         BPLocale.onFailMode = BPLocale.ON_FAIL_EVENT;
         _loc12_ = new Vector.<BPLocalLoadVO>();
         _loc12_.push(new BPLocalLoadVO(_loc8_,"items"));
         _loc12_.push(new BPLocalLoadVO(_loc9_,""));
         _loc12_.push(new BPLocalLoadVO(_loc10_,"equipment_ui"));
         new BPLocalLoader().loaderMultipleURLs(_loc12_,this.handleBPLocaleLanguageLoaded);
      }
      
      private function handleBPLocaleLanguageLoaded(param1:Vector.<XML>) : void
      {
         var _loc2_:XML = null;
         for each(_loc2_ in param1)
         {
            BPLocale.addXMLObject(_loc2_);
         }
         TextFormatter.setNumberSeparators();
         sendNotification(ApplicationNotificationNames.BP_LOCALE_LOADED);
      }
      
      private function handleBPLocaleLanguageLoadingError(param1:BPLocaleEvent) : void
      {
      }
      
      private function handleBPLocaleKeyNotFound(param1:BPLocaleEvent) : void
      {
      }
      
      private function handleBPLocaleCategoryNotFound(param1:BPLocaleEvent) : void
      {
      }
   }
}

