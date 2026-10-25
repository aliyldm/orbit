package net.bigpoint.darkorbit.preloader
{
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.system.Security;
   import flash.text.Font;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.ByteArray;
   import net.bigpoint.darkorbit.BpEventStreamUtil;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import net.bigpoint.darkorbit.preloader.error.GlobalErrorHandlerBpEventStream;
   import net.bigpoint.darkorbit.preloader.loaders.GameclientLoader;
   import net.bigpoint.darkorbit.preloader.loaders.LoadingScreenProxy;
   import net.bigpoint.darkorbit.preloader.loaders.SimpleLoadingAnimation;
   
   [SWF(width="1280", height="900", backgroundColor="#000000", frameRate="60")]
   public dynamic class DarkOrbitPreloader extends Sprite
   {
      
      private static var fontEurostileHeaFl:Class = DarkOrbitPreloader_fontEurostileHeaFl;
      
      private static const BUILD:String = "23462228";
      
      private var _bpStreamErrorHandler:GlobalErrorHandlerBpEventStream;
      
      private var _session:Object;
      
      private var _cdnHost:String;
      
      private var _animation:SimpleLoadingAnimation;
      
      private var _loadingScreen:LoadingScreenProxy;
      
      private var _gameclientLoader:GameclientLoader;
      
      private const _statsContainer:ByteArray = new ByteArray();
      
      public function DarkOrbitPreloader()
      {
         super();
         JavascriptProxy.log("DarkOrbitPreloader",["loader initializing"]);
         this._statsContainer.writeInt(loaderInfo.bytes.length);
         this._statsContainer.writeUTF(name);
         this._statsContainer.writeUTF(loaderInfo.parameters.pid || "");
         this._statsContainer.writeUTF(loaderInfo.parameters.sessionID || "");
         this._statsContainer.writeUTF(loaderInfo.parameters.userID || "");
         this._statsContainer.writeDouble(Math.random());
         this._statsContainer.compress();
         Font.registerFont(fontEurostileHeaFl);
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         _loc1_.builtInItems.quality = true;
         _loc1_.customItems.push(new ContextMenuItem("Build " + BUILD));
         contextMenu = _loc1_;
         if(name == "root1")
         {
            addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         try
         {
            Security.loadPolicyFile(loaderInfo.parameters.host + "/crossdomain.xml?_cv=" + loaderInfo.parameters.crossdomainHash);
            Security.allowDomain("*");
         }
         catch(e:Error)
         {
         }
         this.start();
      }
      
      private function start() : void
      {
         this._session = loaderInfo.parameters;
         var _loc1_:String = BUILD;
         if(Boolean(this._session.gameclientPath) && this._session.gameclientPath.indexOf("acp") != -1)
         {
            _loc1_ += " [cli]";
         }
         this._bpStreamErrorHandler = new GlobalErrorHandlerBpEventStream(_loc1_);
         this._bpStreamErrorHandler.addSource(loaderInfo.uncaughtErrorEvents);
         JavascriptProxy.log("Preloader","start()");
         this._cdnHost = this._session.cdn || this._session.host + "/";
         this.showLoadingAnimation();
         this._loadingScreen = new LoadingScreenProxy();
         this._bpStreamErrorHandler.addSource(this._loadingScreen.contentLoader.uncaughtErrorEvents);
         this._loadingScreen.ready.addOnce(this.handleLoadingScreenReady);
         this._loadingScreen.load(this._session,this._cdnHost);
         addChild(this._loadingScreen);
      }
      
      private function handleLoadingScreenReady(param1:String) : void
      {
         JavascriptProxy.log("Preloader","LoadingScreenReady");
         this.hideLoadingAnimation();
         BpEventStreamUtil.rawTrack("flash_preloader_loadingScreenReady");
         this._gameclientLoader = new GameclientLoader(this);
         this._bpStreamErrorHandler.addSource(this._gameclientLoader.gameclientLoader.uncaughtErrorEvents);
         this._gameclientLoader.loadProgress.add(this.handleGameclientLoadProgress);
         this._gameclientLoader.ready.add(this.handleGameclientReady);
         JavascriptProxy.log("Preloader parameters",[this._cdnHost,param1]);
         JavascriptProxy.log("Preloader session",this._session);
         this._gameclientLoader.load(this._session,this._cdnHost,param1);
      }
      
      private function handleGameclientLoadProgress(param1:Number) : void
      {
         this._loadingScreen.preloaderProgress = param1;
      }
      
      private function handleGameclientReady(param1:Boolean) : void
      {
         if(param1)
         {
            this.handleStartGame();
         }
         else
         {
            this._loadingScreen.startGame.addOnce(this.handleStartGame);
            this._loadingScreen.gameclientReady();
         }
      }
      
      private function handleStartGame() : void
      {
         removeChild(this._loadingScreen);
         this._loadingScreen.dispose();
         this._gameclientLoader.startGame();
      }
      
      private function showLoadingAnimation() : void
      {
         this.hideLoadingAnimation();
         this._animation = new SimpleLoadingAnimation(this._session.loadingClaim as String);
         this._animation.show();
         addChild(this._animation);
      }
      
      private function hideLoadingAnimation() : void
      {
         if(this._animation)
         {
            this._animation.hide();
            removeChild(this._animation);
            this._animation = null;
         }
      }
   }
}

