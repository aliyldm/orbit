package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactListRequest implements IModule
   {
      
      private static var _instance:ContactListRequest;
      
      public var startIndex:int = 0;
      
      public function ContactListRequest(param1:int = 0)
      {
         super();
         this.startIndex = param1;
      }
      
      public static function get instance() : ContactListRequest
      {
         return _instance || (_instance = new ContactListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1883;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex >>> 10 % 32 | this.startIndex << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1883);
         param1.writeInt(this.startIndex << 10 % 32 | this.startIndex >>> 32 - 10 % 32);
      }
   }
}

