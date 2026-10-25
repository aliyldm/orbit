package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.com.module.JumpRequest;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class JumpCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "jump";
      
      public function JumpCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         var _loc3_:SimpleWindow = GuiManager.instance.getWindow(GuiConstants.LOGOUT_WINDOW);
         if(_loc3_.isMaximizeClicked())
         {
            return;
         }
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new JumpRequest());
      }
   }
}

