package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactListEntryAttributeOnlineModule extends ContactListEntryAttributeBaseModule
   {
      
      private static var _instance:ContactListEntryAttributeOnlineModule;
      
      public var online:Boolean = false;
      
      public function ContactListEntryAttributeOnlineModule(param1:Boolean = false)
      {
         super();
         this.online = param1;
      }
      
      public static function get instance() : ContactListEntryAttributeOnlineModule
      {
         return _instance || (_instance = new ContactListEntryAttributeOnlineModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 21885;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.online = param1.readBoolean();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(21885);
         super.write(param1);
         param1.writeBoolean(this.online);
      }
   }
}

