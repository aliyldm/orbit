package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.chatclient.DOChatClientNotifications;
   
   public class FocusChatCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "FocusChatCommand";
      
      public function FocusChatCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         GameFacade.getInstance().sendNotification(DOChatClientNotifications.TOGGLE_VISIBILITY);
      }
   }
}

