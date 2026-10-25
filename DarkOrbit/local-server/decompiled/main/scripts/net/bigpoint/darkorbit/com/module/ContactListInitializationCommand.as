package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListInitializationCommand implements IModule
   {
      
      private static var _instance:ContactListInitializationCommand;
      
      public var filterSettings:ContactListSettingsModule;
      
      public var blockInvitations:ContactListBlockInvitationsModule;
      
      public var contactsCommand:ContactListUpdateContactsCommand;
      
      public function ContactListInitializationCommand(param1:ContactListUpdateContactsCommand = null, param2:ContactListSettingsModule = null, param3:ContactListBlockInvitationsModule = null)
      {
         super();
         if(param2 == null)
         {
            this.filterSettings = new ContactListSettingsModule();
         }
         else
         {
            this.filterSettings = param2;
         }
         if(param3 == null)
         {
            this.blockInvitations = new ContactListBlockInvitationsModule();
         }
         else
         {
            this.blockInvitations = param3;
         }
         if(param1 == null)
         {
            this.contactsCommand = new ContactListUpdateContactsCommand();
         }
         else
         {
            this.contactsCommand = param1;
         }
      }
      
      public static function get instance() : ContactListInitializationCommand
      {
         return _instance || (_instance = new ContactListInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17529;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.filterSettings = ContactListSettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.filterSettings)
         {
            this.filterSettings.read(param1);
         }
         this.blockInvitations = ContactListBlockInvitationsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.blockInvitations)
         {
            this.blockInvitations.read(param1);
         }
         this.contactsCommand = ContactListUpdateContactsCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.contactsCommand)
         {
            this.contactsCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17529);
         if(null != this.filterSettings)
         {
            this.filterSettings.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.blockInvitations)
         {
            this.blockInvitations.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.contactsCommand)
         {
            this.contactsCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

