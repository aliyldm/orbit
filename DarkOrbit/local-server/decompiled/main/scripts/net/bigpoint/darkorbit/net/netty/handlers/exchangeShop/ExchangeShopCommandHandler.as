package net.bigpoint.darkorbit.net.netty.handlers.exchangeShop
{
   import net.bigpoint.darkorbit.com.module.porting.shop.exchange.ExchangeShopCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ExchangeShopCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ExchangeShopCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:ExchangeShopCommand = param1.getBody() as ExchangeShopCommand;
         if("StrikeAndExit" == _loc2_.eventName)
         {
            this.strikeAndExitShop(_loc2_);
         }
         else if("StrikeAndExitVIP" == _loc2_.eventName)
         {
            this.strikeAndExitShopVIP(_loc2_);
         }
      }
      
      private function strikeAndExitShop(param1:ExchangeShopCommand) : void
      {
         var _loc2_:StrikeAndExitShopProxy = retrieveProxy(GuiConstants.STRIKE_AND_EXIT_SHOP) as StrikeAndExitShopProxy;
         if(_loc2_)
         {
            _loc2_.updateShop(param1.eventName,param1.shopId,param1.assets,param1.items);
         }
      }
      
      private function strikeAndExitShopVIP(param1:ExchangeShopCommand) : void
      {
         var _loc2_:StrikeAndExitShopProxy = retrieveProxy(GuiConstants.STRIKE_AND_EXIT_VANGUARD_MART) as StrikeAndExitShopProxy;
         if(_loc2_)
         {
            _loc2_.updateShop(param1.eventName,param1.shopId,param1.assets,param1.items,param1.isVIPShop,param1.isVIP,param1.vipEndSeconds);
         }
      }
   }
}

