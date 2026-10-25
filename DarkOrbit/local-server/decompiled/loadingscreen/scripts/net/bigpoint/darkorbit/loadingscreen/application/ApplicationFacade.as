package net.bigpoint.darkorbit.loadingscreen.application
{
   import net.bigpoint.darkorbit.loadingscreen.GameclientLoaderApplication;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.controller.LoadAdvertisementVisualCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.controller.ReferToAdvertisementUrlCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.model.AdvertisementProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.notifications.AdvertisementNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.controller.CleanUpApplicationCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.controller.StartGameCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.controller.StartupCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.LoadingAnimationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller.InitAssetsCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller.LoadAssetsCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller.LoadBackgroundCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller.LoadImageCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.controller.LoadSWFFinisherCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.mediators.BackgroundContainerMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.background.view.mediators.BackgroundImageMediator;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.controller.LoadBonusCalendarListCommand;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.notifications.BonusCalendarNotifications;
   import net.bigpoint.darkorbit.loadingscreen.mvc.translation.model.TranslationProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.translation.notifications.TranslationNotification;
   import org.puremvc.as3.interfaces.IFacade;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class ApplicationFacade extends Facade implements IFacade
   {
      
      private var _appWindow:GameclientLoaderApplication;
      
      public function ApplicationFacade()
      {
         super();
      }
      
      public static function getInstance() : ApplicationFacade
      {
         if(instance == null)
         {
            instance = new ApplicationFacade();
         }
         return instance as ApplicationFacade;
      }
      
      override protected function initializeController() : void
      {
         super.initializeController();
         registerCommand(ApplicationNotification.STARTUP,StartupCommand);
         registerCommand(TranslationNotification.TRANSLATION_LOADED,InitAssetsCommand);
         registerCommand(AssetNotification.READY,LoadAssetsCommand);
         registerCommand(AdvertisementNotification.ADVERTISEMENT_LOADED,LoadAdvertisementVisualCommand);
         registerCommand(AssetNotification.LOAD_IMAGE,LoadImageCommand);
         registerCommand(AssetNotification.LOAD_BACKGROUND_IMAGE,LoadBackgroundCommand);
         registerCommand(AssetNotification.LOAD_SWFFINISHER,LoadSWFFinisherCommand);
         registerCommand(AdvertisementNotification.PARTNER_CLICK,ReferToAdvertisementUrlCommand);
         registerCommand(BonusCalendarNotifications.SEND_ITEMLIST_REQUEST,LoadBonusCalendarListCommand);
         registerCommand(ApplicationNotification.START_GAME,StartGameCommand);
         registerCommand(ApplicationNotification.CLEANUP_APPLICATION,CleanUpApplicationCommand);
      }
      
      public function startup(param1:GameclientLoaderApplication) : void
      {
         this._appWindow = param1;
         sendNotification(ApplicationNotification.STARTUP,param1);
         sendNotification(LoadingAnimationNotification.SHOW);
      }
      
      public function cleanUp() : void
      {
         this.cleanUpController();
         this.cleanUpModel();
         this.cleanUpMediator();
      }
      
      private function cleanUpController() : void
      {
         removeCommand(ApplicationNotification.STARTUP);
         removeCommand(TranslationNotification.TRANSLATION_LOADED);
         removeCommand(AssetNotification.READY);
         removeCommand(AssetNotification.UI_LOADED);
         removeCommand(AdvertisementNotification.ADVERTISEMENT_LOADED);
         removeCommand(AdvertisementNotification.VISUAL_LOADED);
         removeCommand(AdvertisementNotification.DISABLED);
         removeCommand(AssetNotification.LOAD_IMAGE);
         removeCommand(AssetNotification.LOAD_BACKGROUND_IMAGE);
         removeCommand(AssetNotification.LOAD_SWFFINISHER);
         removeCommand(AdvertisementNotification.PARTNER_CLICK);
         removeCommand(ApplicationNotification.CLEANUP_APPLICATION);
      }
      
      private function cleanUpMediator() : void
      {
         var _loc1_:BackgroundContainerMediator = retrieveMediator(BackgroundContainerMediator.NAME) as BackgroundContainerMediator;
         _loc1_.cleanup();
         var _loc2_:BackgroundImageMediator = retrieveMediator(BackgroundImageMediator.NAME) as BackgroundImageMediator;
         _loc2_.cleanup();
      }
      
      private function cleanUpModel() : void
      {
         var _loc1_:TranslationProxy = retrieveProxy(TranslationProxy.PROXY_NAME) as TranslationProxy;
         _loc1_.cleanup();
         this.removeProxy(TranslationProxy.PROXY_NAME);
         var _loc2_:AdvertisementProxy = retrieveProxy(AdvertisementProxy.PROXY_NAME) as AdvertisementProxy;
         _loc2_.cleanup();
         this.removeProxy(AdvertisementProxy.PROXY_NAME);
         var _loc3_:AssetsProxy = retrieveProxy(AssetsProxy.PROXY_NAME) as AssetsProxy;
         _loc3_.cleanup();
         this.removeProxy(AssetsProxy.PROXY_NAME);
      }
      
      public function get appWindow() : GameclientLoaderApplication
      {
         return this._appWindow;
      }
   }
}

