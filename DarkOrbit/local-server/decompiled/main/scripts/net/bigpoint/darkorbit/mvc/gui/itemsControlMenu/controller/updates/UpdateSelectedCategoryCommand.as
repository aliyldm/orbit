package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller.updates
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateSelectedCategoryCommand extends DOAbstractSimpleCommand
   {
      
      public function UpdateSelectedCategoryCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(ItemsControlMenuNotifications.REFRESH_SELECTED_CATEGORY_ITEMS_BAR);
      }
   }
}

