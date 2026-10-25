package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowRemoveOutgoingRequestCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowRemoveOutgoingRequestCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:int = param1.getBody() as int;
         contactProxy.removeOutgoingRequest(_loc2_);
      }
   }
}

