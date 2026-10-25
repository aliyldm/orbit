package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.events.SectorControlLobbyWindowEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlSelectionChangedCommand extends SimpleCommand
   {
      
      public function SectorControlSelectionChangedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SectorControlItemlistOverviewVO = param1.getBody() as SectorControlItemlistOverviewVO;
         var _loc3_:SectorControlProxy = facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
         _loc3_.currentlySelected = _loc2_;
         this.updateJoinLeaveButton(_loc2_,_loc3_.quedMatchId);
      }
      
      private function updateJoinLeaveButton(param1:SectorControlItemlistOverviewVO, param2:int) : void
      {
         var _loc3_:String = null;
         if(param2 < 0)
         {
            _loc3_ = SectorControlLobbyWindowEvent.ACTION_JOIN;
         }
         else if(param1.matchID == param2)
         {
            _loc3_ = SectorControlLobbyWindowEvent.ACTION_LEAVE;
         }
         else
         {
            _loc3_ = SectorControlLobbyWindowEvent.ACTION_SHOW_LEAVE_QUEUE_DIALOG;
         }
         sendNotification(SectorControlWindowNotifications.SET_JOIN_LEAVE_BUTTON_STATE,_loc3_);
      }
   }
}

