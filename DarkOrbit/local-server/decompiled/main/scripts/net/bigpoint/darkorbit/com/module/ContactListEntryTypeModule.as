package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListEntryTypeModule implements IModule
   {
      
      private static var _instance:ContactListEntryTypeModule;
      
      public static const CONTACTLISTENTRYTYPE_FRIEND:int = 0;
      
      public static const CONTACTLISTENTRYTYPE_CLAN_MEMBER:int = 1;
      
      public static const CONTACTLISTENTRYTYPE_INCOMING_REQUEST:int = 2;
      
      public static const CONTACTLISTENTRYTYPE_OUTGOUING_REQUEST_PENDING:int = 3;
      
      public static const CONTACTLISTENTRYTYPE_OUTGOUING_REQUEST_DECLINED:int = 4;
      
      public static const CONTACTLISTENTRYTYPE_BLOCKED_CONTACT:int = 5;
      
      public static const CONTACTLISTENTRYTYPE__MAX:int = 6;
      
      public var entryType:int = 0;
      
      public function ContactListEntryTypeModule(param1:int = 0)
      {
         super();
         this.entryType = param1;
      }
      
      public static function get instance() : ContactListEntryTypeModule
      {
         return _instance || (_instance = new ContactListEntryTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19871;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.entryType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(19871);
         param1.writeShort(this.entryType);
      }
   }
}

