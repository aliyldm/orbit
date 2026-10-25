package net.bigpoint.darkorbit.net.netty.handlers.monthlyDeluxe
{
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.model.MonthlyDeluxeWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MonthlyDeluxeInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function MonthlyDeluxeInfoCommandHandler()
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
         var _loc3_:MonthlyDeluxeInfoCommand = param1.getBody() as MonthlyDeluxeInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

