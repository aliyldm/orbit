package net.bigpoint.darkorbit.mvc.global.contorl
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CloseSettingsWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function CloseSettingsWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         sendNotification(GuiNotifications.MINIMIZE_WINDOW_BY_ID,GuiConstants.SETTINGS_WINDOW);
         sendNotification(GuiNotifications.MINIMIZE_WINDOW_BY_ID,GuiConstants.SETTINGS_WINDOW_3D);
      }
   }
}

