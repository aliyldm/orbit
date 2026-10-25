package net.bigpoint.darkorbit.mvc.common.controller.screen
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ScreenViewportResizedCommand extends DOAbstractSimpleCommand
   {
      
      public function ScreenViewportResizedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(ItemsControlMenuNotifications.UPDATE_MENUS_POSITION);
         sendNotification(FeaturesMenuNotifications.UPDATE_POSITION);
         sendNotification(GuiNotifications.UPDATE_WINDOWS_POSITIONS);
         sendNotification(GuiNotifications.UPDATE_MODAL_WINDOWS);
         sendNotification(FeaturesMenuNotifications.UPDATE_WINDOWS_MINIMIZED_POSITIONS);
      }
   }
}

