package net.bigpoint.darkorbit.mvc.gui.windows.expedition.handler
{
   import net.bigpoint.darkorbit.com.module.JumpToServerCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   
   public class JumpToServerHandler
   {
      
      public function JumpToServerHandler()
      {
         super();
      }
      
      public static function run(param1:JumpToServerCommand) : void
      {
         GameFacade.getInstance().sendNotification(ExpeditionNotification.END_INSTANCE);
      }
   }
}

