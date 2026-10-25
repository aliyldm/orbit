package net.bigpoint.darkorbit.net.netty.handlers.vipMerchantExchange
{
   import net.bigpoint.darkorbit.com.module.VIPMerchantExchangePackageUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model.VIPMerchantExchangeUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class VIPMerchantExchangePackageUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function VIPMerchantExchangePackageUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:VIPMerchantExchangeUIProxy = retrieveProxy(GuiConstants.VIP_MERCHANT_EXCHANGE) as VIPMerchantExchangeUIProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.VIP_MERCHANT_EXCHANGE);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.VIP_MERCHANT_EXCHANGE) as VIPMerchantExchangeUIProxy;
         }
         var _loc3_:VIPMerchantExchangePackageUpdateCommand = param1.getBody() as VIPMerchantExchangePackageUpdateCommand;
         _loc2_.updatePackageBought(_loc3_);
      }
   }
}

