package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   
   public class ToggleCategoryBarCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "ToggleCategoryBarCommand";
      
      public function ToggleCategoryBarCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         GameFacade.getInstance().sendNotification(ItemsControlMenuNotifications.TOGGLE_CATEGORY_BUTTON);
      }
   }
}

