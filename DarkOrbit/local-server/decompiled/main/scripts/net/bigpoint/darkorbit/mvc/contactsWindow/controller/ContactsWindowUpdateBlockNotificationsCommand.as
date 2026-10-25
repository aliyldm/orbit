package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowUpdateBlockNotificationsCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowUpdateBlockNotificationsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:Boolean = param1.getBody() as Boolean;
         contactProxy.updateBlockAllNotifications(_loc2_);
      }
   }
}

