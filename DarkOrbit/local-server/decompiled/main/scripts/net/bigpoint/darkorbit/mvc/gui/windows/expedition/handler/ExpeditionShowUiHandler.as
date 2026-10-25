package net.bigpoint.darkorbit.mvc.gui.windows.expedition.handler
{
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipListRequest;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShowUiCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ExpeditionShowUiHandler extends BaseHandler
   {
      
      public function ExpeditionShowUiHandler()
      {
         super();
      }
      
      public static function run(param1:ExpeditionShowUiCommand) : void
      {
         switch(param1.type)
         {
            case ExpeditionShowUiCommand.UITYPE_SELECT_ERR:
               GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionShipListRequest());
               break;
            case ExpeditionShowUiCommand.UITYPE_TICKET:
            case ExpeditionShowUiCommand.UITYPE_LEAVE:
            case ExpeditionShowUiCommand.UITYPE_RESET:
               GuiManager.instance.tryCreateAndOpen(GuiConstants.EXPEDITION_CONFIRM);
               GameFacade.getInstance().sendNotification(ExpeditionNotification.SHOW_CONFIRM,param1.type);
         }
      }
   }
}

