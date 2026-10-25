package net.bigpoint.darkorbit.preloader.loaders
{
   import com.greensock.TweenLite;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLLoaderDataFormat;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.FileCollectionLoader;
   import net.bigpoint.as3toolbox.filecollection.vo.FileVO;
   import net.bigpoint.as3toolbox.filecollection.vo.LocationVO;
   import net.bigpoint.darkorbit.BpEventStreamUtil;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import org.osflash.signals.Promise;
   
   public class LoadingScreenProxy extends Sprite
   {
      
      private var _rawFileLoader:FileCollectionLoader;
      
      private var _contentLoader:Loader;
      
      private var _content:Object;
      
      private var _session:Object;
      
      private var _ready:Promise;
      
      private var _startGame:Promise;
      
      private var _key:String;
      
      public function LoadingScreenProxy()
      {
         super();
         this._ready = new Promise();
         this._startGame = new Promise();
         this._contentLoader = new Loader();
         this._contentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleLoadingScreenLoadComplete);
      }
      
      public function load(param1:Object, param2:String) : void
      {
         this._session = param1;
         var _loc3_:String = "loadingscreen";
         var _loc4_:String = this._session.loadingscreenHash || "";
         var _loc5_:String = param2 + "spacemap/";
         this._rawFileLoader = new FileCollection.fileLoaderClass();
         this._rawFileLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this._rawFileLoader.addEventListener(Event.COMPLETE,this.handleRawDataLoadComplete);
         BpEventStreamUtil.rawTrack("flash_preloader_loadingScreenLoadStart",{"url":_loc5_ + "loadingscreen.swf?__cv=" + this._session.loadingscreenHash});
         this._rawFileLoader.fileVO = new FileVO("",new LocationVO("",""),_loc3_,"swf","",new XML());
         this._rawFileLoader.fileVO.cdnHash = _loc4_;
         this._rawFileLoader.loadFile(true,_loc5_);
         JavascriptProxy.log("loading file from",_loc5_);
      }
      
      public function dispose() : void
      {
         if(this._content)
         {
            this._content.removeEventListener("ready",this.handleLoadingScreenReady);
            this._content.removeEventListener("startGame",this.handleStartGame);
         }
         if(this._contentLoader)
         {
            this._contentLoader.unloadAndStop(true);
         }
      }
      
      public function set preloaderProgress(param1:Number) : void
      {
         this._content.setGameclientLoadProgress(param1);
      }
      
      public function gameclientReady() : void
      {
         this._content.gameclientReady();
      }
      
      private function handleRawDataLoadComplete(param1:Event) : void
      {
         JavascriptProxy.log("handle loadingScreen RawDataLoadComplete",null);
         var _loc2_:ByteArray = this._rawFileLoader.data;
         var _loc3_:LoaderContext = new LoaderContext(false,new ApplicationDomain());
         _loc3_.allowCodeImport = true;
         _loc3_.parameters = this._session;
         this._contentLoader.loadBytes(_loc2_,_loc3_);
         this._contentLoader.visible = false;
      }
      
      private function handleKeyDispatched(param1:Event) : void
      {
         this._content.addEventListener("13584647345271048270",this.handleKeyDispatched);
         this._key = param1 + "";
      }
      
      private function handleLoadingScreenLoadComplete(param1:Event) : void
      {
         this._contentLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleLoadingScreenLoadComplete);
         this._content = param1.target.content;
         this._content.addEventListener("13584647345271048270",this.handleKeyDispatched);
         addChild(this._contentLoader);
         this._content.addEventListener("ready",this.handleLoadingScreenReady);
         this._content.addEventListener("startGame",this.handleStartGame);
      }
      
      private function handleLoadingScreenReady(param1:Event) : void
      {
         this._content.removeEventListener("ready",this.handleLoadingScreenReady);
         this._contentLoader.alpha = 0;
         this._contentLoader.visible = true;
         TweenLite.to(this._contentLoader,0.5,{"alpha":1});
         this._ready.dispatch(this._key);
      }
      
      private function handleStartGame(param1:Event) : void
      {
         this._startGame.dispatch();
      }
      
      private function decrypt(param1:ByteArray) : ByteArray
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:uint = param1.length;
         param1.position = 0;
         var _loc5_:uint = 57;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc5_ += 3;
            _loc5_ = uint(_loc5_ & 0xFF);
            _loc4_ = uint(_loc5_ & 4);
            _loc3_ = uint(param1[_loc6_]);
            param1[_loc6_] = _loc3_ ^ _loc5_;
            _loc6_++;
         }
         param1.position = 0;
         return param1;
      }
      
      public function get ready() : Promise
      {
         return this._ready;
      }
      
      public function get startGame() : Promise
      {
         return this._startGame;
      }
      
      public function get contentLoader() : Loader
      {
         return this._contentLoader;
      }
   }
}

