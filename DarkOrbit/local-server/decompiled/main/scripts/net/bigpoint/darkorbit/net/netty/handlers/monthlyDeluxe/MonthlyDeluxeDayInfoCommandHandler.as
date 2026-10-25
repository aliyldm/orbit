package net.bigpoint.darkorbit.net.netty.handlers.monthlyDeluxe
{
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeDayInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.model.MonthlyDeluxeWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MonthlyDeluxeDayInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function MonthlyDeluxeDayInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:MonthlyDeluxeWindowProxy = retrieveProxy(GuiConstants.MONTHLY_DELUXE) as MonthlyDeluxeWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.MONTHLY_DELUXE);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.MONTHLY_DELUXE) as MonthlyDeluxeWindowProxy;
         }
         var _loc3_:MonthlyDeluxeDayInfoCommand = param1.getBody() as MonthlyDeluxeDayInfoCommand;
         _loc2_.updateDayInfo(_loc3_);
      }
   }
}

