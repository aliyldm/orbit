package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowBlockCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowBlockCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = param1.getBody() as String;
         contactProxy.blockSelectedUser(_loc2_);
      }
   }
}

