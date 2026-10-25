package net.bigpoint.darkorbit.fui
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.fui.builder.IUIBuilder;
   import net.bigpoint.darkorbit.fui.builder.repository.IUITemplateRepository;
   import net.bigpoint.darkorbit.fui.builder.repository.UIInstanceRepository;
   import net.bigpoint.darkorbit.fui.builder.xml.XMLBasedUIBuilder;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.system.loader.IUISystemLoader;
   import net.bigpoint.darkorbit.fui.system.loader.parser.UILoaderParserConstants;
   import net.bigpoint.darkorbit.fui.system.manager.IFocusManager;
   import net.bigpoint.darkorbit.fui.system.manager.IKeyboardManager;
   import net.bigpoint.darkorbit.fui.system.manager.IPopUpManager;
   import net.bigpoint.darkorbit.fui.system.manager.ITooltipManager;
   import net.bigpoint.darkorbit.fui.system.manager.IWindowManager;
   import net.bigpoint.darkorbit.fui.system.manager.dragNdrop.IDragNDropManager;
   import net.bigpoint.darkorbit.fui.system.manager.mouse.IMouseManagerImpl;
   import net.bigpoint.darkorbit.fui.system.utils.selector.IMultiSelector;
   
   public class UISystem
   {
      
      protected static var _instance:UISystem;
      
      protected static var _stage:Stage;
      
      private static var _logInfoFunctionReference:Function;
      
      private static var _logWarnFunctionReference:Function;
      
      private static var _localizationFunctionReference:Function;
      
      public static const VERSION:String = "0.36.1";
      
      public static const AUTHOR:String = "db0x90";
      
      public static const DEFAULT_UI_LIBRARY:String = "gameclientCommonUI";
      
      public static var VISUAL_DEBUG:Boolean = false;
      
      public static const LOG_LEVEL_INFO:uint = 0;
      
      public static const LOG_LEVEL_WARN:uint = 8;
      
      private static var _localDiagnosticCount:int = 0;
      
      protected var _builder:IUIBuilder;
      
      protected var _loader:IUISystemLoader;
      
      private var _focusManager:IFocusManager;
      
      private var _dragNDropManager:IDragNDropManager;
      
      private var _mouseManager:IMouseManagerImpl;
      
      private var _tooltipManager:ITooltipManager;
      
      private var _windowManager:IWindowManager;
      
      private var _popupManager:IPopUpManager;
      
      private var _keyboardManager:IKeyboardManager;
      
      private var _multiSelector:IMultiSelector;
      
      public function UISystem()
      {
         super();
      }
      
      public static function getInstance() : UISystem
      {
         if(_instance == null)
         {
            _instance = new UISystem();
         }
         return _instance;
      }
      
      public static function log(param1:String, param2:uint = 0) : void
      {
      }
      
      public static function localize(param1:String, param2:String = null) : String
      {
         if(_localizationFunctionReference == null)
         {
            return "You have to specify a localization method. The BPLocal.get() method f.e.";
         }
         return _localizationFunctionReference(param1,param2);
      }
      
      public static function localFlashDiag(stage:String, detail:String = "") : void
      {
         var loader:URLLoader;
         if(_localDiagnosticCount >= 40)
         {
            return;
         }
         ++_localDiagnosticCount;
         try
         {
            loader = new URLLoader();
            loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void
            {
            });
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(e:Event):void
            {
            });
            loader.load(new URLRequest("http://127.0.0.1:8095/client/do_img/global/items/resource/upgrade-module_30x30.png?flashdiag=" + encodeURIComponent(stage) + "&detail=" + encodeURIComponent(detail.substr(0,1800)) + "&n=" + _localDiagnosticCount));
         }
         catch(ignored:Error)
         {
         }
      }
      
      public function set tooltipManager(param1:ITooltipManager) : void
      {
         this._tooltipManager = param1;
      }
      
      public function get tooltipManager() : ITooltipManager
      {
         return this._tooltipManager;
      }
      
      public function set mouseManager(param1:IMouseManagerImpl) : void
      {
         this._mouseManager = param1;
      }
      
      public function get mouseManager() : IMouseManagerImpl
      {
         return this._mouseManager;
      }
      
      public function get focusManager() : IFocusManager
      {
         return this._focusManager;
      }
      
      public function set focusManager(param1:IFocusManager) : void
      {
         this._focusManager = param1;
      }
      
      public function get dragNDropManager() : IDragNDropManager
      {
         return this._dragNDropManager;
      }
      
      public function set dragNDropManager(param1:IDragNDropManager) : void
      {
         this._dragNDropManager = param1;
      }
      
      public function get windowManager() : IWindowManager
      {
         return this._windowManager;
      }
      
      public function set windowManager(param1:IWindowManager) : void
      {
         this._windowManager = param1;
      }
      
      public function get popupManager() : IPopUpManager
      {
         return this._popupManager;
      }
      
      public function set popupManager(param1:IPopUpManager) : void
      {
         this._popupManager = param1;
      }
      
      public function get keyboardManager() : IKeyboardManager
      {
         return this._keyboardManager;
      }
      
      public function set keyboardManager(param1:IKeyboardManager) : void
      {
         this._keyboardManager = param1;
      }
      
      public function get multiSelector() : IMultiSelector
      {
         return this._multiSelector;
      }
      
      public function set multiSelector(param1:IMultiSelector) : void
      {
         this._multiSelector = param1;
      }
      
      public function set logInfoFunctionReference(param1:Function) : void
      {
         _logInfoFunctionReference = param1;
      }
      
      public function set logWarnFunctionReference(param1:Function) : void
      {
         _logWarnFunctionReference = param1;
      }
      
      public function set localizationFunctionReference(param1:Function) : void
      {
         _localizationFunctionReference = param1;
      }
      
      public function set builder(param1:IUIBuilder) : void
      {
         this._builder = param1;
      }
      
      public function get builder() : IUIBuilder
      {
         return this._builder;
      }
      
      public function build(param1:Object, param2:DisplayObjectContainer = null, param3:Boolean = false) : void
      {
         this._builder.build(param1,param2,param3);
         UIInstanceRepository.clearDefaultModuleNaming();
         var _loc4_:ICoreponent = param2 as ICoreponent;
         if(_loc4_)
         {
            _loc4_.assignChildren();
         }
      }
      
      public function buildByTemplate(param1:String, param2:DisplayObjectContainer = null, param3:String = null, param4:Boolean = false) : void
      {
         param3 = param3 == null ? XMLBasedUIBuilder.TYPE : param3;
         var _loc5_:IUITemplateRepository = UISystem.getInstance().builder.getTemplateRepository(param3);
         var _loc6_:XML = _loc5_.getTemplateByName(param1) as XML;
         this.build(_loc6_,param2,param4);
      }
      
      public function buildWithCallback(param1:Object, param2:DisplayObjectContainer = null, param3:Function = null, param4:Array = null) : void
      {
         var description:String = param1 is XML ? XML(param1).toXMLString() : String(param1);
         var crafting:Boolean = description.indexOf("assembly_") >= 0 || description.indexOf("crafting_") >= 0 || description.indexOf("upgrade_") >= 0;
         if(crafting)
         {
            localFlashDiag("ui-begin",description.substr(0,180));
         }
         try
         {
            this.build(param1,param2,true);
            if(crafting)
            {
               localFlashDiag("ui-built",description.substr(0,180));
            }
            if(param4)
            {
               param3.apply(undefined,param4);
            }
            else
            {
               param3();
            }
            if(crafting)
            {
               localFlashDiag("ui-callback-done",description.substr(0,180));
            }
         }
         catch(error:Error)
         {
            localFlashDiag("ui-error",description.substr(0,180) + " | " + error.name + " | " + error.message + " | " + error.getStackTrace());
            throw error;
         }
      }
      
      public function loadLibrariesAndCall(param1:Object, param2:Function, param3:Array) : void
      {
         if(this._loader)
         {
            this._loader.loadAndCall(param1,UILoaderParserConstants.XML,param2,param3);
         }
      }
      
      public function loadAndBuild(param1:Object, param2:DisplayObjectContainer = null, param3:Function = null, param4:Array = null) : void
      {
         this.loadLibrariesAndCall(param1,this.buildWithCallback,[param1,param2,param3,param4]);
      }
      
      public function loadAndBuildWithResKey(param1:String, param2:DisplayObjectContainer = null, param3:Function = null, param4:Array = null) : void
      {
         var xmlResKey:String = param1;
         var root:DisplayObjectContainer = param2;
         var callback:Function = param3;
         var callbackParams:Array = param4;
         this._loader.loadAsset(xmlResKey,function(param1:XMLFinisher):void
         {
            var _loc2_:XML = param1.getXML();
            loadAndBuild(_loc2_,root,callback,callbackParams);
         });
      }
      
      public function getTemplate(param1:String, param2:String = "xml") : Object
      {
         var _loc3_:IUITemplateRepository = UISystem.getInstance().builder.getTemplateRepository(param2);
         return _loc3_.getTemplateByName(param1);
      }
      
      public function set uiloader(param1:IUISystemLoader) : void
      {
         this._loader = param1;
      }
      
      public function get uiloader() : IUISystemLoader
      {
         return this._loader;
      }
      
      public function get stage() : Stage
      {
         return _stage;
      }
      
      public function set stage(param1:Stage) : void
      {
         _stage = param1;
      }
   }
}

