package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.com.module.SectorControlDraftConfirmationRequest;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.SectorControlWindowNotifications;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class SectorControlDraftConfirmationPopUpMediator extends Mediator
   {
      
      public static const NAME:String = "SectorControlDraftConfirmationPopUpMediator";
      
      public function SectorControlDraftConfirmationPopUpMediator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         sendNotification(SectorControlWindowNotifications.SET_UI_INTERACTIVITY,false);
         this.popUp.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseButtonClicked);
         this.popUp.addEventListener(SectorControlDraftConfirmationPopUp.EVENT_TIMER_FINISHED,this.handleTimerFinished);
         this.popUp.addEventListener(SectorControlDraftConfirmationPopUp.EVENT_ACCEPT_DRAFT_CONFIRMATION,this.handleAcceptDraftEvent);
         this.popUp.addEventListener(SectorControlDraftConfirmationPopUp.EVENT_REFUSE_DRAFT_CONFIRMATION,this.handleRefuseDraftEvent);
      }
      
      override public function onRemove() : void
      {
         sendNotification(SectorControlWindowNotifications.SET_UI_INTERACTIVITY,true);
         this.popUp.removeEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseButtonClicked);
         this.popUp.removeEventListener(SectorControlDraftConfirmationPopUp.EVENT_TIMER_FINISHED,this.handleTimerFinished);
         this.popUp.removeEventListener(SectorControlDraftConfirmationPopUp.EVENT_ACCEPT_DRAFT_CONFIRMATION,this.handleAcceptDraftEvent);
         this.popUp.removeEventListener(SectorControlDraftConfirmationPopUp.EVENT_REFUSE_DRAFT_CONFIRMATION,this.handleRefuseDraftEvent);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,this.popUp.windowType);
      }
      
      private function handleTimerFinished(param1:Event) : void
      {
         this.removeMediator();
      }
      
      private function handleCloseButtonClicked(param1:Event) : void
      {
         this.removeMediator();
      }
      
      private function handleRefuseDraftEvent(param1:Event) : void
      {
         this.sendDraftConfirmationRequest(false);
      }
      
      private function removeMediator() : void
      {
         facade.removeMediator(NAME);
      }
      
      private function handleAcceptDraftEvent(param1:Event) : void
      {
         this.sendDraftConfirmationRequest(true);
      }
      
      private function sendDraftConfirmationRequest(param1:Boolean) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SectorControlDraftConfirmationRequest(param1));
         this.removeMediator();
      }
      
      protected function get popUp() : SectorControlDraftConfirmationPopUp
      {
         return viewComponent as SectorControlDraftConfirmationPopUp;
      }
   }
}

