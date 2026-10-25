package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactListEntryAttributeLevelModule extends ContactListEntryAttributeBaseModule
   {
      
      private static var _instance:ContactListEntryAttributeLevelModule;
      
      public var level:int = 0;
      
      public function ContactListEntryAttributeLevelModule(param1:int = 0)
      {
         super();
         this.level = param1;
      }
      
      public static function get instance() : ContactListEntryAttributeLevelModule
      {
         return _instance || (_instance = new ContactListEntryAttributeLevelModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 6868;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.level = param1.readInt();
         this.level = this.level << 8 % 32 | this.level >>> 32 - 8 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6868);
         super.write(param1);
         param1.writeInt(this.level >>> 8 % 32 | this.level << 32 - 8 % 32);
      }
   }
}

