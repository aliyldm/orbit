package net.bigpoint.darkorbit.net.netty.handlers.contactlist
{
   import net.bigpoint.darkorbit.com.module.ContactListEntryModule;
   import net.bigpoint.darkorbit.com.module.ContactListUpdateContactsCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactListEntryModuleHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function ContactListEntryModuleHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ContactListEntryModule = param1.getBody() as ContactListEntryModule;
         var _loc3_:ContactListUpdateContactsCommand = new ContactListUpdateContactsCommand(new <ContactListEntryModule>[_loc2_]);
         HandlerLookup.execute(_loc3_);
      }
   }
}

