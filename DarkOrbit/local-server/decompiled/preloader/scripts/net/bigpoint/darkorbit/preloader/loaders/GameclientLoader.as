package net.bigpoint.darkorbit.preloader.loaders
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
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
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class GameclientLoader
   {
      
      private var _gameclientContainer:DisplayObjectContainer;
      
      private var _gameclientFileLoader:FileCollectionLoader;
      
      private var _gameclientLoader:Loader;
      
      private var _gameclient:DisplayObject;
      
      private var _gameclientFlexApp:DisplayObject;
      
      private var _session:Object;
      
      private var _loadProgress:ISignal;
      
      private var _ready:ISignal;
      
      private var _key:String;
      
      public function GameclientLoader(param1:DisplayObjectContainer)
      {
         super();
         this._gameclientContainer = param1;
         this._loadProgress = new Signal(Number);
         this._ready = new Signal(Boolean);
         this._gameclientLoader = new Loader();
         this._gameclientLoader.addEventListener("mx.managers.SystemManager.isBootstrapRoot",this.handleFlexSystemManagerEvent);
         this._gameclientLoader.addEventListener("mx.managers.SystemManager.isStageRoot",this.handleFlexSystemManagerEvent);
         this._gameclientLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleClientLoadComplete);
         this._gameclientLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleGameclientLoadeError);
      }
      
      private function handleGameclientLoadeError(param1:IOErrorEvent) : void
      {
         BpEventStreamUtil.rawTrack("flash_loadingscreen_handleGameclientLoadeError");
      }
      
      public function load(param1:Object, param2:String, param3:String) : void
      {
         this._session = param1;
         this._key = param3;
         BpEventStreamUtil.rawTrack("flash_loadingscreen_loadGameClient",{});
         this._gameclientFileLoader = new FileCollection.fileLoaderClass();
         this._gameclientFileLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this._gameclientFileLoader.addEventListener(Event.COMPLETE,this.handleRawDataLoadComplete);
         this._gameclientFileLoader.addEventListener(ProgressEvent.PROGRESS,this.handleRawDataLoadProgress);
         this._gameclientFileLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleError);
         this._gameclientFileLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         var _loc4_:String = (this._session.gameclientPath ? param2 + this._session.gameclientPath : null) || this._session.resourcesPath || param2 + this._session.basePath + "/";
         if(_loc4_.lastIndexOf("/") != _loc4_.length - 1)
         {
            _loc4_ += "/";
         }
         var _loc5_:String = this._session.gameclientFilename || "main";
         var _loc6_:String = this._session.gameclientHash;
         this._gameclientFileLoader.fileVO = new FileVO("",new LocationVO("",""),_loc5_,"swf","",new XML());
         this._gameclientFileLoader.fileVO.cdnHash = _loc6_;
         this._gameclientFileLoader.loadFile(true,_loc4_);
         JavascriptProxy.log("GameClientLoader","Loading gameclient from: " + _loc4_ + _loc5_ + ".swf?__cv=" + _loc6_);
      }
      
      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         BpEventStreamUtil.rawTrack("flash.error2" + param1.toString(),{"error":param1.toString()});
      }
      
      private function handleError(param1:IOErrorEvent) : void
      {
         JavascriptProxy.log("handleError",param1);
         BpEventStreamUtil.rawTrack("flash.error3" + param1.toString(),{"error":param1.toString()});
      }
      
      public function startGame() : void
      {
         this._gameclientFlexApp["startGame"]();
      }
      
      public function get loadProgress() : ISignal
      {
         return this._loadProgress;
      }
      
      public function get ready() : ISignal
      {
         return this._ready;
      }
      
      private function handleRawDataLoadProgress(param1:ProgressEvent) : void
      {
         this._loadProgress.dispatch(0.3 * param1.bytesLoaded / param1.bytesTotal);
      }
      
      private function handleRawDataLoadComplete(param1:Event) : void
      {
         var bytes:ByteArray;
         var lc:LoaderContext;
         var e:Event = param1;
         BpEventStreamUtil.rawTrack("flash_loadingscreen_handleRawDataLoadComplete");
         bytes = this._gameclientFileLoader.data;
         try
         {
            bytes.position = 0;
            BpEventStreamUtil.rawTrack("flash_loadingscreen_gameclient_uncompressed");
            bytes.position = 0;
            BpEventStreamUtil.rawTrack("flash_loadingscreen_gameclient_decrypted");
         }
         catch(e:Error)
         {
            JavascriptProxy.log("client loaded",[e.message + e.getStackTrace()]);
         }
         lc = new LoaderContext(false,new ApplicationDomain());
         lc.allowCodeImport = true;
         lc.parameters = this._session;
         JavascriptProxy.log("game client bytes length: ",bytes.length);
         this._gameclientLoader.loadBytes(bytes,lc);
         BpEventStreamUtil.rawTrack("flash_loadingscreen_internal_loader_started");
      }
      
      private function handleFlexSystemManagerEvent(param1:Event) : void
      {
         param1.preventDefault();
      }
      
      private function handleClientLoadComplete(param1:Event) : void
      {
         BpEventStreamUtil.rawTrack("flash_loadingscreen_internal_handleClientLoadComplete");
         this._gameclientLoader.removeEventListener("mx.managers.SystemManager.isBootstrapRoot",this.handleFlexSystemManagerEvent);
         this._gameclientLoader.removeEventListener("mx.managers.SystemManager.isStageRoot",this.handleFlexSystemManagerEvent);
         this._gameclientLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleClientLoadComplete);
         this._gameclientLoader = null;
         this._gameclient = param1.target.content as DisplayObject;
         this._gameclient.addEventListener(ProgressEvent.PROGRESS,this.handleClientLoadingProgress);
         this._gameclient.addEventListener(Event.COMPLETE,this.handleClientLoadingComplete);
         this._gameclientContainer.addChildAt(this._gameclient,0);
      }
      
      private function handleClientLoadingProgress(param1:ProgressEvent) : void
      {
         this._loadProgress.dispatch(0.3 + 0.7 * param1.bytesLoaded / param1.bytesTotal);
         BpEventStreamUtil.rawTrack("flash_loadingscreen_handleClientLoadingProgress  bytesLoaded/bytesTotal " + param1.bytesLoaded + " / " + param1.bytesTotal);
      }
      
      private function handleClientLoadingComplete(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         BpEventStreamUtil.rawTrack("flash_loadingscreen_handleClientLoadingComplete");
         this._gameclient.removeEventListener(ProgressEvent.PROGRESS,this.handleClientLoadingProgress);
         this._gameclient.removeEventListener(Event.COMPLETE,this.handleClientLoadingComplete);
         this._gameclientFlexApp = Object(this._gameclient).document as DisplayObject;
         if(this._gameclientFlexApp["startGame"] is Function)
         {
            BpEventStreamUtil.rawTrack("flash_loadingscreen_gameClientFullyLoaded",{});
            _loc2_ = this._gameclientFlexApp["autoStartEnabled"] as Boolean;
            this._ready.dispatch(_loc2_);
         }
         else
         {
            this._gameclientFlexApp.addEventListener("creationComplete",this.handleFlexAppReady);
         }
      }
      
      private function handleFlexAppReady(param1:Event) : void
      {
         BpEventStreamUtil.rawTrack("flash_loadingscreen_gameClientFullyLoaded",{});
         this._gameclientFlexApp.removeEventListener("creationComplete",this.handleFlexAppReady);
         this._ready.dispatch(this._gameclientFlexApp["autoStartEnabled"] as Boolean);
      }
      
      protected function toArray(param1:String) : ByteArray
      {
         param1 = param1.replace(/\s|:/gm,"");
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = param1.length & 1;
         if(_loc3_ == 1)
         {
            param1 = "0" + param1;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_[_loc4_ / 2] = parseInt(param1.substr(_loc4_,2),16);
            _loc4_ += 2;
         }
         return _loc2_;
      }
      
      public function get gameclient() : DisplayObject
      {
         return this._gameclient;
      }
      
      public function get gameclientLoader() : Loader
      {
         return this._gameclientLoader;
      }
   }
}

