package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class ContactListEntryAttributeNameModule extends ContactListEntryAttributeBaseModule
   {
      
      private static var _instance:ContactListEntryAttributeNameModule;
      
      public var userName:String = "";
      
      public function ContactListEntryAttributeNameModule(param1:String = "")
      {
         super();
         this.userName = param1;
      }
      
      public static function get instance() : ContactListEntryAttributeNameModule
      {
         return _instance || (_instance = new ContactListEntryAttributeNameModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -28574;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.userName = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-28574);
         super.write(param1);
         param1.writeUTF(this.userName);
      }
   }
}

