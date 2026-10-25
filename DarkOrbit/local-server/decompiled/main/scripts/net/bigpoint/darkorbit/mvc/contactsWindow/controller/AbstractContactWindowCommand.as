package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.ContactsWindowProxy;
   
   public class AbstractContactWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function AbstractContactWindowCommand()
      {
         super();
      }
      
      protected function get contactProxy() : ContactsWindowProxy
      {
         return facade.retrieveProxy(ContactsWindowProxy.NAME) as ContactsWindowProxy;
      }
   }
}

