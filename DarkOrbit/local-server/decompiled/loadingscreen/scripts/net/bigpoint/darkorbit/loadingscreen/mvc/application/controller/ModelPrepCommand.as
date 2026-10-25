package net.bigpoint.darkorbit.loadingscreen.mvc.application.controller
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.model.AdvertisementProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.notifications.AdvertisementNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.BonusCalendarProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.translation.model.TranslationProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.translation.notifications.TranslationNotification;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class ModelPrepCommand extends SimpleCommand implements ICommand
   {
      
      public function ModelPrepCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new TranslationProxy(TranslationProxy.PROXY_NAME,TranslationNotification.TRANSLATION_LOADED));
         facade.registerProxy(new AdvertisementProxy(AdvertisementProxy.PROXY_NAME,AdvertisementNotification.ADVERTISEMENT_LOADED));
         facade.registerProxy(new AssetsProxy(AssetsProxy.PROXY_NAME,AssetNotification.READY));
         facade.registerProxy(new BonusCalendarProxy());
      }
   }
}

