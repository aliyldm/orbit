package net.bigpoint.darkorbit.mvc.tdm.popups.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.tdm.popups.TeamDeathMatchPopupNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TeamDeathMatchErrorPopUpMediator extends TeamDeathMatchAbstractPopupMediator
   {
      
      public static const NAME:String = "TeamDeathMatchErrorPopUpMediator";
      
      private var _title:String;
      
      private var _message:String;
      
      public function TeamDeathMatchErrorPopUpMediator()
      {
         super(NAME);
      }
      
      override public function listNotificationInterests() : Array
      {
         super.listNotificationInterests();
         return [TeamDeathMatchPopupNotifications.OPEN_LEVEL_TOO_LOW_POPUP,TeamDeathMatchPopupNotifications.OPEN_MATCH_ENDED_POPUP,TeamDeathMatchPopupNotifications.OPEN_NO_MATCH_FOR_FACTION_POPUP,TeamDeathMatchPopupNotifications.CLOSE_PARTICIPATION_POPUP];
      }
      
      override protected function mapNotificationsToCommand() : void
      {
         super.mapNotificationsToCommand();
         notificationToCommandMap[TeamDeathMatchPopupNotifications.OPEN_LEVEL_TOO_LOW_POPUP] = this.openLevelTooLowPopup;
         notificationToCommandMap[TeamDeathMatchPopupNotifications.OPEN_MATCH_ENDED_POPUP] = this.openMatchEndedPopup;
         notificationToCommandMap[TeamDeathMatchPopupNotifications.OPEN_NO_MATCH_FOR_FACTION_POPUP] = this.openNoMatchForFactionPopup;
         notificationToCommandMap[TeamDeathMatchPopupNotifications.CLOSE_PARTICIPATION_POPUP] = closePopup;
      }
      
      private function openLevelTooLowPopup(param1:INotification = null) : void
      {
         this._title = BPLocale.getItem("tdm_popup_level_too_low_title");
         this._message = BPLocale.getItem("tdm_popup_level_too_low_message");
         openPopup();
      }
      
      private function openMatchEndedPopup(param1:INotification = null) : void
      {
         this._title = BPLocale.getItem("tdm_popup_match_ended_title");
         this._message = BPLocale.getItem("tdm_popup_match_ended_message");
         openPopup();
      }
      
      private function openNoMatchForFactionPopup(param1:INotification = null) : void
      {
         this._title = BPLocale.getItem("tdm_popup_no_match_for_faction_title");
         this._message = BPLocale.getItem("tdm_popup_no_match_for_faction_message");
         openPopup();
      }
      
      override protected function createPopup() : void
      {
         popup = FlexWindowManager.getInstance().createWindow(FlexWindowManager.TEAMDEATHMATCH_MATCH_ERROR_POPUP,FlexWindowManager.WINDOW_CENTERED) as TeamDeathMatchErrorPopup;
         var _loc1_:TeamDeathMatchErrorPopup = popup as TeamDeathMatchErrorPopup;
         _loc1_.title = this._title;
         _loc1_.errorMessage = this._message;
      }
   }
}

