package net.bigpoint.darkorbit.net.netty.handlers.sectorcontrol
{
   import net.bigpoint.darkorbit.com.module.SectorControlMatchStateInfoCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class SectorControlMatchStateInfoHandler extends BaseHandler
   {
      
      public function SectorControlMatchStateInfoHandler()
      {
         super();
      }
      
      public static function run(param1:SectorControlMatchStateInfoCommand) : void
      {
         GameFacade.getInstance().forwardNotification(SectorControlNotifications.INIT);
         GameFacade.getInstance().forwardNotification(SectorControlNotifications.UPDATE_FACTION_CONTROL_POINT_BONUSSES_MODEL,param1.bonusInformation);
         GameFacade.getInstance().forwardNotification(SectorControlNotifications.UPDATE_FACTION_TICKETS_MODEL,param1.ticketCounts);
         GameFacade.getInstance().forwardNotification(SectorControlNotifications.UPDATE_FACTION_PLAYERS_MODEL,param1.playerCounts);
      }
   }
}

