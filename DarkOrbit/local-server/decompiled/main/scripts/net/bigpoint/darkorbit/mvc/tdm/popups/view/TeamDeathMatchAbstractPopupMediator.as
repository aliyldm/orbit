package net.bigpoint.darkorbit.mvc.tdm.popups.view
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOPopUp;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.TeamDeathMatchLobbywindowNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class TeamDeathMatchAbstractPopupMediator extends Mediator
   {
      
      protected var notificationToCommandMap:Dictionary;
      
      public function TeamDeathMatchAbstractPopupMediator(param1:String)
      {
         super(param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         this.mapNotificationsToCommand();
         return super.listNotificationInterests();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         var _loc3_:Function = this.notificationToCommandMap[_loc2_];
         if(_loc3_ != null)
         {
            _loc3_(param1);
         }
      }
      
      protected function mapNotificationsToCommand() : void
      {
         this.notificationToCommandMap = new Dictionary();
      }
      
      protected function openPopup(param1:INotification = null) : void
      {
         sendNotification(TeamDeathMatchLobbywindowNotifications.SET_UI_INTERACTIVITY,false);
         this.createPopup();
         this.popup.addEventListener(Event.CLOSE,this.handlePopUpCloseEvent);
      }
      
      protected function createPopup() : void
      {
      }
      
      protected function closePopup(param1:INotification = null) : void
      {
         this.beforePopupDestroyed();
         this.destroyPopup();
      }
      
      protected function destroyPopup() : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      protected function beforePopupDestroyed() : void
      {
         sendNotification(TeamDeathMatchLobbywindowNotifications.SET_UI_INTERACTIVITY,true);
         this.popup.removeEventListener(Event.CLOSE,this.handlePopUpCloseEvent);
      }
      
      protected function handlePopUpCloseEvent(param1:Event) : void
      {
         this.beforePopupDestroyed();
      }
      
      protected function get popup() : DOPopUp
      {
         return viewComponent as DOPopUp;
      }
      
      protected function set popup(param1:DOPopUp) : void
      {
         viewComponent = param1;
      }
   }
}

