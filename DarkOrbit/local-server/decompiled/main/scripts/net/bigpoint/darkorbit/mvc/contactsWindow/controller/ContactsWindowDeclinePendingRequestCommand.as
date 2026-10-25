package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowDeclinePendingRequestCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowDeclinePendingRequestCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:int = param1.getBody() as int;
         contactProxy.declinePendingRequest(_loc2_);
      }
   }
}

