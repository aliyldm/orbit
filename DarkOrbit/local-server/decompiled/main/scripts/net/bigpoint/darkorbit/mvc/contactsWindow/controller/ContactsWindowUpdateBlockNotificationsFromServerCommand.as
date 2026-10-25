package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowUpdateBlockNotificationsFromServerCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowUpdateBlockNotificationsFromServerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:Boolean = param1.getBody() as Boolean;
         contactProxy.updateBlockAllNotificationsFromServer(_loc2_);
      }
   }
}

