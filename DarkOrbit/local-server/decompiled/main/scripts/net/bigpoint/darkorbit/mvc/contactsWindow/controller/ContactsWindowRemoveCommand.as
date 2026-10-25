package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowRemoveCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowRemoveCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = param1.getBody() as String;
         contactProxy.removeSelectedUser(_loc2_);
      }
   }
}

