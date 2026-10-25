package net.bigpoint.darkorbit.mvc.gui.windows.expedition.handler
{
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionStartInstanceCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   
   public class ExpeditionStartInstanceHandler
   {
      
      public function ExpeditionStartInstanceHandler()
      {
         super();
      }
      
      public static function run(param1:ExpeditionStartInstanceCommand) : void
      {
         GameFacade.getInstance().sendNotification(ExpeditionNotification.START_INSTANCE,param1.seconds);
      }
   }
}

