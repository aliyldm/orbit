package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactListEntryAttributeClanModule extends ContactListEntryAttributeBaseModule
   {
      
      private static var _instance:ContactListEntryAttributeClanModule;
      
      public var clanId:int = 0;
      
      public function ContactListEntryAttributeClanModule(param1:int = 0)
      {
         super();
         this.clanId = param1;
      }
      
      public static function get instance() : ContactListEntryAttributeClanModule
      {
         return _instance || (_instance = new ContactListEntryAttributeClanModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -11717;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.clanId = param1.readInt();
         this.clanId = this.clanId << 11 % 32 | this.clanId >>> 32 - 11 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11717);
         super.write(param1);
         param1.writeInt(this.clanId >>> 11 % 32 | this.clanId << 32 - 11 % 32);
      }
   }
}

