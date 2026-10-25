package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchJoinRequest;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class SectorControlLeaveQueuePopUpMediator extends Mediator
   {
      
      public static const NAME:String = "SectorControlLeaveQueuePopUpMediator";
      
      private var _matchID:uint;
      
      public function SectorControlLeaveQueuePopUpMediator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         sendNotification(SectorControlWindowNotifications.SET_UI_INTERACTIVITY,false);
         this.popUp.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseButtonClicked);
         this.popUp.addEventListener(SectorControlLeaveQueuePopUp.EVENT_EXIT_QUEUE_CONFIRMATION,this.handleOKButtonClicked);
         this.popUp.addEventListener(SectorControlLeaveQueuePopUp.EVENT_EXIT_QUEUE_CANCEL,this.handleCancelButtonClicked);
      }
      
      private function handleCloseButtonClicked(param1:Event) : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      private function handleOKButtonClicked(param1:Event) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SectorControlMatchJoinRequest(this._matchID));
         facade.removeMediator(getMediatorName());
      }
      
      override public function onRemove() : void
      {
         this.popUp.removeEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseButtonClicked);
         this.popUp.removeEventListener(SectorControlLeaveQueuePopUp.EVENT_EXIT_QUEUE_CONFIRMATION,this.handleOKButtonClicked);
         this.popUp.removeEventListener(SectorControlLeaveQueuePopUp.EVENT_EXIT_QUEUE_CANCEL,this.handleCancelButtonClicked);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,this.popUp.windowType);
         sendNotification(SectorControlWindowNotifications.SET_UI_INTERACTIVITY,true);
      }
      
      private function handleCancelButtonClicked(param1:Event) : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      protected function get popUp() : SectorControlLeaveQueuePopUp
      {
         return viewComponent as SectorControlLeaveQueuePopUp;
      }
      
      public function set matchID(param1:uint) : void
      {
         this._matchID = param1;
      }
   }
}

