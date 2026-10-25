package net.bigpoint.darkorbit.mvc.gui.messages.controller
{
   import net.bigpoint.darkorbit.mvc.gui.messages.view.GlobalNotificationsMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AddGlobalNotificationMessageCommand extends AbstractMessageCommand
   {
      
      public function AddGlobalNotificationMessageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MessageCommandParams = param1.getBody() as MessageCommandParams;
         if(_loc2_)
         {
            this.addMessage(_loc2_);
            return;
         }
         throw new Error("Send this notification with a proper MessageCommandParams instance.");
      }
      
      private function addMessage(param1:MessageCommandParams) : void
      {
         var _loc2_:GlobalNotificationsMediator = retrieveMediator(GlobalNotificationsMediator.NAME) as GlobalNotificationsMediator;
         _loc2_.globalNotificationView.addMessage(param1.message);
      }
   }
}

