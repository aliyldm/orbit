package net.bigpoint.darkorbit.mvc.tdm.popups.view
{
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.tdm.popups.TeamDeathMatchPopupNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TeamDeathMatchLevelRequirementPopupMediator extends TeamDeathMatchAbstractPopupMediator
   {
      
      public static const NAME:String = "TeamDeathMatchLevelRequirementPopupMediator";
      
      public function TeamDeathMatchLevelRequirementPopupMediator()
      {
         super(NAME);
      }
      
      override public function listNotificationInterests() : Array
      {
         super.listNotificationInterests();
         return [TeamDeathMatchPopupNotifications.OPEN_PLAYER_REQUIREMENT_POPUP,TeamDeathMatchPopupNotifications.CLOSE_PLAYER_REQUIREMENT_POPUP];
      }
      
      override protected function mapNotificationsToCommand() : void
      {
         super.mapNotificationsToCommand();
         notificationToCommandMap[TeamDeathMatchPopupNotifications.OPEN_PLAYER_REQUIREMENT_POPUP] = this.openPopup;
         notificationToCommandMap[TeamDeathMatchPopupNotifications.CLOSE_PLAYER_REQUIREMENT_POPUP] = this.closePopup;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
      }
      
      override protected function openPopup(param1:INotification = null) : void
      {
         super.openPopup(param1);
      }
      
      override protected function createPopup() : void
      {
         popup = FlexWindowManager.getInstance().createWindow(FlexWindowManager.TEAMDEATHMATCH_LEVELREQUIREMENT_POPUP,FlexWindowManager.WINDOW_CENTERED) as TeamDeathMatchLevelRequirementPopup;
      }
      
      override protected function closePopup(param1:INotification = null) : void
      {
         super.closePopup(param1);
      }
      
      override protected function destroyPopup() : void
      {
         FlexWindowManager.getInstance().destroyWindow(FlexWindowManager.TEAMDEATHMATCH_LEVELREQUIREMENT_POPUP);
      }
   }
}

