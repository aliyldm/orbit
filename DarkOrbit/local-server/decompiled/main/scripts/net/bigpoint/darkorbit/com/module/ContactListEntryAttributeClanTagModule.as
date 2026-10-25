package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactListEntryAttributeClanTagModule extends ContactListEntryAttributeBaseModule
   {
      
      private static var _instance:ContactListEntryAttributeClanTagModule;
      
      public var clanTag:String = "";
      
      public function ContactListEntryAttributeClanTagModule(param1:String = "")
      {
         super();
         this.clanTag = param1;
      }
      
      public static function get instance() : ContactListEntryAttributeClanTagModule
      {
         return _instance || (_instance = new ContactListEntryAttributeClanTagModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -23538;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.clanTag = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-23538);
         super.write(param1);
         param1.writeUTF(this.clanTag);
      }
   }
}

