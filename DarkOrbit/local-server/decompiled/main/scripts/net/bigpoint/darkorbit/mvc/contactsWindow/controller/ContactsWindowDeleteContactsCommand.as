package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowDeleteContactsCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowDeleteContactsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:Vector.<int> = param1.getBody() as Vector.<int>;
         contactProxy.deleteContacts(_loc2_);
      }
   }
}

