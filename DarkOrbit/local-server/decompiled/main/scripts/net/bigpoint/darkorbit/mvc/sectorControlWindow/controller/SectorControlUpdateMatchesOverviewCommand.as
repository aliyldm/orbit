package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.darkorbit.com.module.SectorControlMatchOverviewCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlUpdateMatchesOverviewCommand extends SimpleCommand
   {
      
      public function SectorControlUpdateMatchesOverviewCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SectorControlMatchOverviewCommand = param1.getBody() as SectorControlMatchOverviewCommand;
         var _loc3_:SectorControlProxy = facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
         _loc3_.updateMatchOverview(_loc2_);
         if(_loc3_.openLobbyWindowOnNextResponse)
         {
            _loc3_.openLobbyWindowOnNextResponse = false;
            facade.sendNotification(SectorControlWindowNotifications.OPEN_SECTOR_CONTROL_LOBBY_WINDOW);
         }
      }
   }
}

