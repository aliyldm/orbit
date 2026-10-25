package net.bigpoint.darkorbit.loadingscreen.mvc.translation.model
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.bplocal.BPLocalLoadVO;
   import net.bigpoint.darkorbit.bplocal.BPLocalLoader;
   import net.bigpoint.darkorbit.bplocal.parser.BPLocaleParser4DO;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class TranslationProxy extends Proxy implements IProxy
   {
      
      public static const PROXY_NAME:String = "TranslationProxy";
      
      private static const TARGET_COUNT_HACK:int = 2;
      
      private var fileLoadedCount:int = 0;
      
      private var loadedEventName:String;
      
      public function TranslationProxy(param1:String, param2:String)
      {
         super(param1,null);
         this.loadedEventName = param2;
      }
      
      public function loadTranslation() : void
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.handleHashFileLoaded);
         var _loc2_:String = Session.cdnHost + Session.basePath + "/templates/language_" + Session.lang + ".xml?__cv=" + Session.languageXMLHash;
         _loc1_.load(new URLRequest(_loc2_));
      }
      
      private function handleHashFileLoaded(param1:Event) : void
      {
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         BPLocale.onFailMode = BPLocale.ON_FAIL_NOTHING;
         _loc2_.removeEventListener(Event.COMPLETE,this.handleHashFileLoaded);
         var _loc3_:XMLList = XML(_loc2_.data).children();
         var _loc4_:Dictionary = new Dictionary();
         for each(_loc5_ in _loc3_)
         {
            _loc4_[_loc5_.attribute("name").toString()] = _loc5_.attribute("hash").toString();
         }
         _loc6_ = Session.lang;
         _loc7_ = Session.cdnHost + Session.basePath + "/templates/" + _loc6_ + "/";
         _loc8_ = _loc7_ + "resource_loadingScreen.xml?__cv=" + _loc4_["resource_loadingScreen"];
         _loc9_ = _loc7_ + "resource_items.xml?__cv=" + _loc4_["resource_items"];
         this.fileLoadedCount = 0;
         this.load(new <BPLocalLoadVO>[new BPLocalLoadVO(_loc8_,"")],this.handleTranslationFileFileLoaded);
         this.load(new <BPLocalLoadVO>[new BPLocalLoadVO(_loc9_,"items")],this.handleItemFileFileLoaded);
      }
      
      private function load(param1:Vector.<BPLocalLoadVO>, param2:Function) : void
      {
         new BPLocalLoader().loaderMultipleURLs(param1,param2);
      }
      
      private function handleTranslationFileFileLoaded(param1:Vector.<XML>) : void
      {
         var _loc5_:XML = null;
         ++this.fileLoadedCount;
         var _loc2_:int = int(param1.length);
         var _loc3_:BPLocaleParser4DO = new BPLocaleParser4DO();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1[_loc4_];
            _loc3_.parseXML(_loc5_);
            _loc4_++;
         }
         param1.length = 0;
         if(this.fileLoadedCount == TARGET_COUNT_HACK)
         {
            sendNotification(this.loadedEventName);
         }
      }
      
      private function handleItemFileFileLoaded(param1:Vector.<XML>) : void
      {
         var _loc5_:XML = null;
         ++this.fileLoadedCount;
         var _loc2_:int = int(param1.length);
         var _loc3_:BPLocaleParser4DO = new BPLocaleParser4DO();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1[_loc4_];
            _loc3_.parseXML(_loc5_);
            _loc4_++;
         }
         param1.length = 0;
         if(this.fileLoadedCount == TARGET_COUNT_HACK)
         {
            sendNotification(this.loadedEventName);
         }
      }
      
      public function cleanup() : void
      {
      }
   }
}

