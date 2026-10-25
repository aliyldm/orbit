package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactListEntryAttributeMapModule extends ContactListEntryAttributeBaseModule
   {
      
      private static var _instance:ContactListEntryAttributeMapModule;
      
      public var currentMap:int = 0;
      
      public function ContactListEntryAttributeMapModule(param1:int = 0)
      {
         super();
         this.currentMap = param1;
      }
      
      public static function get instance() : ContactListEntryAttributeMapModule
      {
         return _instance || (_instance = new ContactListEntryAttributeMapModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 5101;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.currentMap = param1.readInt();
         this.currentMap = this.currentMap >>> 9 % 32 | this.currentMap << 32 - 9 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5101);
         super.write(param1);
         param1.writeInt(this.currentMap << 9 % 32 | this.currentMap >>> 32 - 9 % 32);
      }
   }
}

