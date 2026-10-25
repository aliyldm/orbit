package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchExitRequest;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.components.LeaveGamePopUp;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class SectorControlLeaveGamePopUpMediator extends Mediator
   {
      
      public static const NAME:String = "SectorControlLeaveGamePopUpMediator";
      
      public function SectorControlLeaveGamePopUpMediator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         sendNotification(SectorControlWindowNotifications.SET_UI_INTERACTIVITY,false);
         this.popUp.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseButtonClicked);
         this.popUp.addEventListener(LeaveGamePopUp.EVENT_EXIT_MATCH_CONFIRMATION,this.handleOKButtonClicked);
         this.popUp.addEventListener(LeaveGamePopUp.EVENT_EXIT_MATCH_CANCEL,this.handleCancelButtonClicked);
      }
      
      private function handleCloseButtonClicked(param1:Event) : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      private function handleOKButtonClicked(param1:Event) : void
      {
         facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SectorControlMatchExitRequest());
         facade.removeMediator(getMediatorName());
      }
      
      override public function onRemove() : void
      {
         sendNotification(SectorControlWindowNotifications.SET_UI_INTERACTIVITY,true);
         this.popUp.removeEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseButtonClicked);
         this.popUp.removeEventListener(LeaveGamePopUp.EVENT_EXIT_MATCH_CONFIRMATION,this.handleOKButtonClicked);
         this.popUp.removeEventListener(LeaveGamePopUp.EVENT_EXIT_MATCH_CANCEL,this.handleCancelButtonClicked);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,this.popUp.windowType);
      }
      
      private function handleCancelButtonClicked(param1:Event) : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      protected function get popUp() : LeaveGamePopUp
      {
         return viewComponent as LeaveGamePopUp;
      }
   }
}

