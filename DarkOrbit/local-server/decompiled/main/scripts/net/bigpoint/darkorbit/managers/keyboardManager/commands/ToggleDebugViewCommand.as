package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.stats.StatsNotifications;
   
   public class ToggleDebugViewCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "toggleDebugView";
      
      public function ToggleDebugViewCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         GameFacade.getInstance().sendNotification(StatsNotifications.TOGGLE_VISIBILITY);
      }
   }
}

