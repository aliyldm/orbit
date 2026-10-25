package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListEntryModule implements IModule
   {
      
      private static var _instance:ContactListEntryModule;
      
      public var attributeCommand:ContactListEntryAttributeCommand;
      
      public var typeCommand:ContactListEntryTypeCommand;
      
      public function ContactListEntryModule(param1:ContactListEntryAttributeCommand = null, param2:ContactListEntryTypeCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.attributeCommand = new ContactListEntryAttributeCommand();
         }
         else
         {
            this.attributeCommand = param1;
         }
         if(param2 == null)
         {
            this.typeCommand = new ContactListEntryTypeCommand();
         }
         else
         {
            this.typeCommand = param2;
         }
      }
      
      public static function get instance() : ContactListEntryModule
      {
         return _instance || (_instance = new ContactListEntryModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7492;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attributeCommand = ContactListEntryAttributeCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.attributeCommand)
         {
            this.attributeCommand.read(param1);
         }
         this.typeCommand = ContactListEntryTypeCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.typeCommand)
         {
            this.typeCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7492);
         if(null != this.attributeCommand)
         {
            this.attributeCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.typeCommand)
         {
            this.typeCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

