package net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.controller
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.advertisement.model.AdvertisementProxy;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class ReferToAdvertisementUrlCommand extends SimpleCommand implements ICommand
   {
      
      public function ReferToAdvertisementUrlCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AdvertisementProxy = facade.retrieveProxy(AdvertisementProxy.PROXY_NAME) as AdvertisementProxy;
         _loc2_.referToUrl();
      }
   }
}

