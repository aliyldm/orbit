package net.bigpoint.darkorbit.net.netty.handlers.monthlyDeluxe
{
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeTimeInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.model.MonthlyDeluxeWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MonthlyDeluxeTimeInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function MonthlyDeluxeTimeInfoCommandHandler()
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
         var _loc3_:MonthlyDeluxeTimeInfoCommand = param1.getBody() as MonthlyDeluxeTimeInfoCommand;
         _loc2_.updateTimeInfo(_loc3_);
      }
   }
}

