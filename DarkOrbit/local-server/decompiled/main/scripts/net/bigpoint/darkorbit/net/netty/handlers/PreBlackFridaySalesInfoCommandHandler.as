package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.PreBlackFridaySalesInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.preBlackFridaySales.model.PreBlackFridaySalesUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PreBlackFridaySalesInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PreBlackFridaySalesInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:PreBlackFridaySalesUIProxy = retrieveProxy(GuiConstants.PRE_BLACKFRIDAY_SALES) as PreBlackFridaySalesUIProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.PRE_BLACKFRIDAY_SALES);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.PRE_BLACKFRIDAY_SALES) as PreBlackFridaySalesUIProxy;
         }
         var _loc3_:PreBlackFridaySalesInfoCommand = param1.getBody() as PreBlackFridaySalesInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

