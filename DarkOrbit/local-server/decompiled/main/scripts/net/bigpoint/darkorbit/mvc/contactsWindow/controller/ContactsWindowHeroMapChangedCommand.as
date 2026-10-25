package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowHeroMapChangedCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowHeroMapChangedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(contactProxy != null)
         {
            contactProxy.handleMapjump();
         }
      }
   }
}

