package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.net.ClientCommands;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ChangeConfingCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "changeConfing";
      
      public function ChangeConfingCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         var _loc3_:int = Settings.selectedConfiguration;
         if(_loc3_ == 1)
         {
            _loc3_ = 2;
         }
         else if(_loc3_ == 2)
         {
            _loc3_ = 1;
         }
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_COMMAND,[ClientCommands.SELECT,[ClientCommands.CONFIGURATION,_loc3_.toString(),Hero.userID.toString(),Hero.sessionID.toString()]]);
      }
   }
}

