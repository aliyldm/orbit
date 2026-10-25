package net.bigpoint.darkorbit.mvc.gui.windows.expedition.handler
{
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionSelectedShipListCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ExpeditionSelectedShipListHandler extends BaseHandler
   {
      
      public function ExpeditionSelectedShipListHandler()
      {
         super();
      }
      
      public static function run(param1:ExpeditionSelectedShipListCommand) : void
      {
         GuiManager.instance.tryCreateAndOpen(GuiConstants.EXPEDITION_SHIPWARP);
         GameFacade.getInstance().sendNotification(ExpeditionNotification.SHOW_SHIPWARP,param1);
      }
   }
}

