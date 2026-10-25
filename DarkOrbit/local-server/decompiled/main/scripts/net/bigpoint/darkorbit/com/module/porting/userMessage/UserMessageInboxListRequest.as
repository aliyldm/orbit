package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageInboxListRequest implements IModule
   {
      
      private static var _instance:UserMessageInboxListRequest;
      
      public var startIndex:int = 0;
      
      public function UserMessageInboxListRequest(param1:int = 0)
      {
         super();
         this.startIndex = param1;
      }
      
      public static function get instance() : UserMessageInboxListRequest
      {
         return _instance || (_instance = new UserMessageInboxListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15573;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex << 14 % 32 | this.startIndex >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(15573);
         param1.writeInt(this.startIndex >>> 14 % 32 | this.startIndex << 32 - 14 % 32);
      }
   }
}

