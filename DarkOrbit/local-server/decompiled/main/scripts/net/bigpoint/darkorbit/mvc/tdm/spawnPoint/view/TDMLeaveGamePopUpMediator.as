package net.bigpoint.darkorbit.mvc.tdm.spawnPoint.view
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchExitRequest;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.components.LeaveGamePopUp;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class TDMLeaveGamePopUpMediator extends Mediator
   {
      
      public static const NAME:String = "TDMLeaveGamePopUpMediator";
      
      public function TDMLeaveGamePopUpMediator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [MapNotification.CLEANUP];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case MapNotification.CLEANUP:
               this.closePopup();
         }
      }
      
      public function closePopup() : void
      {
         this.unregisterMediator();
      }
      
      override public function onRegister() : void
      {
         this.popUp.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseButtonClicked);
         this.popUp.addEventListener(LeaveGamePopUp.EVENT_EXIT_MATCH_CONFIRMATION,this.handleOKButtonClicked);
         this.popUp.addEventListener(LeaveGamePopUp.EVENT_EXIT_MATCH_CANCEL,this.handleCancelButtonClicked);
      }
      
      private function handleCloseButtonClicked(param1:Event) : void
      {
         this.unregisterMediator();
      }
      
      private function handleCancelButtonClicked(param1:Event) : void
      {
         this.unregisterMediator();
      }
      
      private function handleOKButtonClicked(param1:Event) : void
      {
         facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TeamDeathMatchExitRequest());
         this.unregisterMediator();
      }
      
      private function unregisterMediator() : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      override public function onRemove() : void
      {
         this.popUp.removeEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseButtonClicked);
         this.popUp.removeEventListener(LeaveGamePopUp.EVENT_EXIT_MATCH_CONFIRMATION,this.handleOKButtonClicked);
         this.popUp.removeEventListener(LeaveGamePopUp.EVENT_EXIT_MATCH_CANCEL,this.handleCancelButtonClicked);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,this.popUp.windowType);
      }
      
      protected function get popUp() : LeaveGamePopUp
      {
         return viewComponent as LeaveGamePopUp;
      }
   }
}

