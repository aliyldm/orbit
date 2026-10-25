package net.bigpoint.darkorbit.mvc.commandCenter.model.repo
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.osflash.signals.Signal;
   
   public class CommandCenterNewsRepository
   {
      
      private static const URL:String = Settings.dynamicHost + "flashAPI/brNews.php";
      
      private var finished:Signal = new Signal();
      
      private var reloadComplete:Signal = new Signal();
      
      private var _categories:Object = {};
      
      private var _listOfNews:Object = {};
      
      private var _eventBasedNewsByType:Object = {};
      
      private var _isLoading:Boolean;
      
      public function CommandCenterNewsRepository()
      {
         super();
      }
      
      public function get listOfNews() : Object
      {
         return this._listOfNews;
      }
      
      public function init() : Signal
      {
         var _loc1_:URLLoader = null;
         if(!this._isLoading)
         {
            _loc1_ = new URLLoader();
            _loc1_.addEventListener(Event.COMPLETE,this.handleComplete);
            _loc1_.load(new URLRequest(URL));
         }
         return this.finished;
      }
      
      public function reload() : Signal
      {
         var _loc1_:URLLoader = null;
         if(!this._isLoading)
         {
            _loc1_ = new URLLoader();
            _loc1_.addEventListener(Event.COMPLETE,this.handleReloadComplete);
            _loc1_.load(new URLRequest(URL));
         }
         return this.reloadComplete;
      }
      
      public function getNewsByEventType(param1:String) : Vector.<CommandCenterNewsDefinition>
      {
         return this._eventBasedNewsByType[param1];
      }
      
      public function getCategoryDefinition(param1:String) : CommandCenterCategoryDefinition
      {
         var _loc3_:* = undefined;
         var _loc2_:CommandCenterCategoryDefinition = this._categories[param1];
         if(!_loc2_)
         {
            for(_loc3_ in this._categories)
            {
               _loc2_ = this._categories[_loc3_];
               if(_loc2_)
               {
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function getNewsByName(param1:String) : CommandCenterNewsDefinition
      {
         return this._listOfNews[param1];
      }
      
      private function handleCategoriesLoaded(param1:XMLFinisher) : void
      {
         this.parseCategories(param1.getXML());
         this.finished.dispatch();
      }
      
      private function parseCategories(param1:XML) : void
      {
         var _loc3_:CommandCenterCategoryDefinition = null;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:XML = null;
         var _loc2_:XMLList = param1.children();
         for each(_loc8_ in _loc2_)
         {
            _loc4_ = String(_loc8_.attribute("id"));
            _loc5_ = ParserUtility.parseBooleanFromXmlAtribute(_loc8_.attribute("isSpecial"),false);
            _loc6_ = String(_loc8_.attribute("textKey"));
            _loc7_ = int(_loc8_.attribute("prio"));
            _loc3_ = new CommandCenterCategoryDefinition(_loc4_,_loc5_,_loc6_,_loc7_);
            this._categories[_loc4_] = _loc3_;
         }
      }
      
      private function parseXML(param1:XML) : void
      {
         var _loc6_:Vector.<CommandCenterNewsDefinition> = null;
         var _loc7_:String = null;
         var _loc8_:XML = null;
         var _loc2_:XMLList = param1.attribute("name");
         var _loc3_:String = String(_loc2_);
         var _loc4_:CommandCenterNewsDefinition = new CommandCenterNewsDefinition();
         _loc4_.parse(param1);
         var _loc5_:XMLList = param1.child("config").child("event");
         for each(_loc8_ in _loc5_)
         {
            _loc7_ = _loc8_.attribute("id");
            if(this._eventBasedNewsByType[_loc7_] === undefined)
            {
               _loc6_ = this._eventBasedNewsByType[_loc7_] = new Vector.<CommandCenterNewsDefinition>();
            }
            else
            {
               _loc6_ = this._eventBasedNewsByType[_loc7_];
            }
            _loc6_.push(_loc4_);
         }
         this._listOfNews[_loc3_] = _loc4_;
      }
      
      private function parseNews(param1:URLLoader) : void
      {
         var _loc2_:XMLList = new XML(param1.data).child("layer");
         var _loc3_:int = _loc2_.length();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.parseXML(_loc2_[_loc4_]);
            _loc4_++;
         }
      }
      
      private function handleComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         this.parseNews(_loc2_);
         var _loc3_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc3_.load("categories",this.handleCategoriesLoaded,null,AssetsProxy.NEWS);
      }
      
      private function handleReloadComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         this.parseNews(_loc2_);
         this.reloadComplete.dispatch();
      }
   }
}

