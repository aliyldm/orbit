package net.bigpoint.darkorbit.net.netty.handlers.uridiumBank
{
   import net.bigpoint.darkorbit.com.module.UridiumBankClaimCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UridiumBankClaimCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function UridiumBankClaimCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:UridiumBankClaimCommand = param1.getBody() as UridiumBankClaimCommand;
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP_WITH_LINK,[Settings.dynamicHost + _loc2_.paymentLink]);
      }
   }
}

