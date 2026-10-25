package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ToggleProActionBarCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "toggleProActionBarCommand";
      
      public function ToggleProActionBarCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         if(Settings.proActionBarEnabled.value)
         {
            GameFacade.getInstance().sendNotification(ItemsControlMenuNotifications.TOGGLE_PRO_ACTION_BUTTON);
         }
      }
   }
}

