package net.bigpoint.darkorbit.mvc.tdm.popups.view
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDraftConfirmationRequest;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.popups.TeamDeathMatchPopupNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TeamDeathMatchParticipationPopupMediator extends TeamDeathMatchAbstractPopupMediator
   {
      
      public static const NAME:String = "TeamDeathMatchParticipationPopupMediator";
      
      public function TeamDeathMatchParticipationPopupMediator()
      {
         super(NAME);
      }
      
      override public function listNotificationInterests() : Array
      {
         super.listNotificationInterests();
         return [TeamDeathMatchPopupNotifications.OPEN_PARTICIPATION_POPUP,TeamDeathMatchPopupNotifications.CLOSE_PARTICIPATION_POPUP];
      }
      
      override protected function mapNotificationsToCommand() : void
      {
         super.mapNotificationsToCommand();
         notificationToCommandMap[TeamDeathMatchPopupNotifications.OPEN_PARTICIPATION_POPUP] = this.openPopup;
         notificationToCommandMap[TeamDeathMatchPopupNotifications.CLOSE_PARTICIPATION_POPUP] = this.closePopup;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
      }
      
      override protected function openPopup(param1:INotification = null) : void
      {
         super.openPopup(param1);
         popup.addEventListener(TeamDeathMatchParticipationPopup.EVENT_LEAVE_QUEUE,this.handleLeaveQueueButtonClickHandler);
         popup.addEventListener(TeamDeathMatchParticipationPopup.EVENT_JOIN,this.handleJoinButtonClickHandler);
         popup.addEventListener(TeamDeathMatchParticipationPopup.EVENT_TIMER_FINISHED,this.handleTimerCompleteHandler);
         popup.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseWindowEvent);
         var _loc2_:int = param1.getBody() as int;
         var _loc3_:TeamDeathMatchParticipationPopup = popup as TeamDeathMatchParticipationPopup;
         if(_loc3_)
         {
            _loc3_.startTimer(_loc2_);
         }
      }
      
      override protected function createPopup() : void
      {
         var _loc1_:TeamDeathMatchParticipationPopup = FlexWindowManager.getInstance().createWindow(FlexWindowManager.TEAMDEATHMATCH_MATCH_PARTICIPATION_POPUP,FlexWindowManager.WINDOW_CENTERED) as TeamDeathMatchParticipationPopup;
         setViewComponent(_loc1_);
      }
      
      override protected function closePopup(param1:INotification = null) : void
      {
         popup.removeEventListener(TeamDeathMatchParticipationPopup.EVENT_LEAVE_QUEUE,this.handleLeaveQueueButtonClickHandler);
         popup.removeEventListener(TeamDeathMatchParticipationPopup.EVENT_JOIN,this.handleJoinButtonClickHandler);
         popup.removeEventListener(TeamDeathMatchParticipationPopup.EVENT_TIMER_FINISHED,this.handleTimerCompleteHandler);
         popup.removeEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.handleCloseWindowEvent);
         var _loc2_:TeamDeathMatchParticipationPopup = popup as TeamDeathMatchParticipationPopup;
         if(_loc2_)
         {
            _loc2_.clearTimer();
         }
         super.closePopup(param1);
      }
      
      override protected function destroyPopup() : void
      {
         FlexWindowManager.getInstance().destroyWindow(FlexWindowManager.TEAMDEATHMATCH_MATCH_PARTICIPATION_POPUP);
      }
      
      protected function handleJoinButtonClickHandler(param1:Event) : void
      {
         this.closePopup();
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TeamDeathMatchDraftConfirmationRequest(true));
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.TEAMDEATHMATCH_LOBBY_WINDOW);
      }
      
      protected function handleLeaveQueueButtonClickHandler(param1:Event) : void
      {
         this.closePopup();
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TeamDeathMatchDraftConfirmationRequest(false));
      }
      
      protected function handleTimerCompleteHandler(param1:Event) : void
      {
         this.closePopup();
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TeamDeathMatchDraftConfirmationRequest(false));
      }
      
      protected function handleCloseWindowEvent(param1:Event) : void
      {
         this.closePopup();
      }
   }
}

