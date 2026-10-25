package net.bigpoint.darkorbit.loadingscreen
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.system.Security;
   import net.bigpoint.darkorbit.BpEventStreamUtil;
   import net.bigpoint.darkorbit.loadingscreen.application.ApplicationFacade;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.view.components.FlashAdvertismentView;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.view.FlashLoadingBarView;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.view.components.FlashLoadingAnimation;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.components.FlashBackgroundContainer;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.components.FlashBackgroundImage;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.BonusCalendarView;
   import net.bigpoint.darkorbit.loadingscreen.utils.EmbeddedFonts;
   import net.bigpoint.darkorbit.loadingscreen.utils.FlashVarsParser;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import net.bigpoint.darkorbit.loadingscreen.utils.TooltipControl;
   
   [SWF(width="1280", height="900", backgroundColor="#ffffff", frameRate="24")]
   public class GameclientLoaderApplication extends Sprite
   {
      
      public static var LoadingAnimation:Class = GameclientLoaderApplication_LoadingAnimation;
      
      AssetsProxy.registerLib(LoadingAnimation,"LoadingAnimation");
      
      private var _flashVars:Object;
      
      private var _rootContainer:Sprite;
      
      private var _loadingAnimation:FlashLoadingAnimation;
      
      private var _backgroundContainer:FlashBackgroundContainer;
      
      private var _backgroundImage:Sprite;
      
      private var _bonusCalendarView:BonusCalendarView;
      
      private var _partnerView:Sprite;
      
      public function GameclientLoaderApplication(param1:Object = null)
      {
         super();
         BpEventStreamUtil.rawTrack("flash_loadingscreen_construct");
         this._flashVars = param1;
         this.preinitialize();
      }
      
      private function preinitialize() : void
      {
         EmbeddedFonts.initialize();
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
      }
      
      private function handleAddedToStage(param1:Event = null) : void
      {
         var flashVars:Object;
         var e:Event = param1;
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         flashVars = this._flashVars || (loaderInfo.parameters.host ? loaderInfo.parameters : stage.loaderInfo.parameters);
         FlashVarsParser.parse(flashVars);
         try
         {
            Security.loadPolicyFile(Session.host + "/crossdomain.xml?_cv=" + Session.crossdomainHash);
            Security.allowDomain("*");
         }
         catch(e:Error)
         {
            JavascriptProxy.log("LoadingScreen - error found",e);
         }
         this.createViewLayers();
         ApplicationFacade.getInstance().startup(this);
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         var _loc2_:ApplicationFacade = ApplicationFacade.getInstance();
         _loc2_.sendNotification(ApplicationNotification.CLEANUP_APPLICATION);
         this.cleanUp();
      }
      
      public function cleanUp() : void
      {
         TooltipControl.getInstance().removeAllToolTips();
         this._bonusCalendarView.dispose();
         this._rootContainer.alpha = 0.35;
         var _loc1_:ApplicationFacade = ApplicationFacade.getInstance();
         _loc1_.cleanUp();
         this.removeViewLayers();
         mouseEnabled = mouseChildren = visible = false;
      }
      
      private function removeViewLayers() : void
      {
         this._rootContainer.removeChild(this._backgroundImage);
         this._backgroundImage = null;
         this._rootContainer.removeChild(this._backgroundContainer);
         this._backgroundContainer = null;
         this.removeChild(this._rootContainer);
         this._rootContainer = null;
      }
      
      private function createViewLayers() : void
      {
         this._rootContainer = new Sprite();
         addChild(this._rootContainer);
         this._backgroundImage = new FlashBackgroundImage();
         this._rootContainer.addChild(this._backgroundImage);
         this._backgroundContainer = new FlashBackgroundContainer();
         this._rootContainer.addChild(this._backgroundContainer);
         this._bonusCalendarView = new BonusCalendarView();
         this._rootContainer.addChild(this._bonusCalendarView);
         this._loadingAnimation = new FlashLoadingAnimation();
         this._rootContainer.addChild(this._loadingAnimation);
         this._partnerView = new FlashAdvertismentView();
         this._rootContainer.addChild(this._partnerView);
      }
      
      public function get loadingAnimation() : FlashLoadingAnimation
      {
         return this._loadingAnimation;
      }
      
      public function get loadingBar() : FlashLoadingBarView
      {
         return this._bonusCalendarView.loadingBarView;
      }
      
      public function get partnerView() : Sprite
      {
         return this._partnerView;
      }
      
      public function get bonusCalendarView() : Sprite
      {
         return this._bonusCalendarView;
      }
      
      public function get backgroundContainer() : FlashBackgroundContainer
      {
         return this._backgroundContainer;
      }
      
      public function get backgroundImage() : Sprite
      {
         return this._backgroundImage;
      }
      
      [SecureSWF(rename="off")]
      public function setGameclientLoadProgress(param1:Number) : void
      {
         ApplicationFacade.getInstance().sendNotification(ApplicationNotification.GAMECLIENT_LOAD_PROGRESS,[param1 * 100]);
      }
      
      [SecureSWF(rename="off")]
      public function gameclientReady() : void
      {
         ApplicationFacade.getInstance().sendNotification(ApplicationNotification.GAMECLIENT_LOADED);
      }
   }
}

