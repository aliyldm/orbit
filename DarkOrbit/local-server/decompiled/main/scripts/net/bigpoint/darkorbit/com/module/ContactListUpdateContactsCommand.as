package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListUpdateContactsCommand implements IModule
   {
      
      private static var _instance:ContactListUpdateContactsCommand;
      
      public var contacts:Vector.<ContactListEntryModule>;
      
      public function ContactListUpdateContactsCommand(param1:Vector.<ContactListEntryModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.contacts = new Vector.<ContactListEntryModule>();
         }
         else
         {
            this.contacts = param1;
         }
      }
      
      public static function get instance() : ContactListUpdateContactsCommand
      {
         return _instance || (_instance = new ContactListUpdateContactsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22989;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ContactListEntryModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.contacts.length > 0)
         {
            this.contacts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ContactListEntryModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.contacts.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ContactListEntryModule = null;
         param1.writeShort(-22989);
         param1.writeShort(this.contacts.length);
         for each(_loc2_ in this.contacts)
         {
            _loc2_.write(param1);
         }
      }
   }
}

