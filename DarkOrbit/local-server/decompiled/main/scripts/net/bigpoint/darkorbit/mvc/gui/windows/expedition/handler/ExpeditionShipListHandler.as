package net.bigpoint.darkorbit.mvc.gui.windows.expedition.handler
{
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipListCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ExpeditionShipListHandler extends BaseHandler
   {
      
      public function ExpeditionShipListHandler()
      {
         super();
      }
      
      public static function run(param1:ExpeditionShipListCommand) : void
      {
         GuiManager.instance.tryCreateAndOpen(GuiConstants.EXPEDITION_SHIPHANGAR);
         GameFacade.getInstance().sendNotification(ExpeditionNotification.SHOW_SHIPHANGER,param1);
      }
   }
}

