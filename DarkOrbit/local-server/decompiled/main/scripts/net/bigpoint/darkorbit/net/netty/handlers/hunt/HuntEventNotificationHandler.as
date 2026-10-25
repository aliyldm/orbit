package net.bigpoint.darkorbit.net.netty.handlers.hunt
{
   import net.bigpoint.darkorbit.com.module.HuntEventNotificationCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HuntEventNotificationHandler extends DOAbstractSimpleCommand
   {
      
      public function HuntEventNotificationHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:HuntEventNotificationCommand = param1.getBody() as HuntEventNotificationCommand;
         var _loc3_:SimpleWindowCreationVO = SimpleWindowCreationMap.getById(GuiConstants.ALIEN_HUNT_WINDOW);
         if(_loc2_.notificationType == HuntEventNotificationCommand.NOTIFICATIONTYPE_START)
         {
            facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc3_);
         }
         else
         {
            facade.sendNotification(GuiNotifications.DESTROY_SIMPLE_WINDOW,_loc3_);
         }
      }
   }
}

