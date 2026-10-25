package net.bigpoint.darkorbit.net.netty.handlers.mileageMarket
{
   import net.bigpoint.darkorbit.com.module.MileageMarketInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.model.MileageMarketUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MileageMarketInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function MileageMarketInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:MileageMarketUIProxy = retrieveProxy(GuiConstants.MILEAGE_MARKET) as MileageMarketUIProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.MILEAGE_MARKET);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.MILEAGE_MARKET) as MileageMarketUIProxy;
         }
         var _loc3_:MileageMarketInfoCommand = param1.getBody() as MileageMarketInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

