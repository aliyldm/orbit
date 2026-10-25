package net.bigpoint.darkorbit.net.netty.handlers.vipMerchantExchange
{
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangeBuyCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class VIPMerchantExchangeBuyCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function VIPMerchantExchangeBuyCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:VIPMerchantExchangeBuyCommand = param1.getBody() as VIPMerchantExchangeBuyCommand;
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP_WITH_LINK,[Settings.dynamicHost + _loc2_.paymentLink]);
      }
   }
}

