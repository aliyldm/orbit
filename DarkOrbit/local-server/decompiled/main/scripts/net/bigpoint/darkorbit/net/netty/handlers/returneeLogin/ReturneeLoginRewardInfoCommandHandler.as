package net.bigpoint.darkorbit.net.netty.handlers.returneeLogin
{
   import net.bigpoint.darkorbit.com.module.ReturneeLoginRewardInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.model.ReturneeLoginCalendarProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ReturneeLoginRewardInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ReturneeLoginRewardInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:ReturneeLoginCalendarProxy = retrieveProxy(GuiConstants.RETURNEE_LOGIN_CALENDAR) as ReturneeLoginCalendarProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.RETURNEE_LOGIN);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.RETURNEE_LOGIN_CALENDAR) as ReturneeLoginCalendarProxy;
         }
         var _loc3_:ReturneeLoginRewardInfoCommand = param1.getBody() as ReturneeLoginRewardInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

