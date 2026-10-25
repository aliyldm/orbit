package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageOutboxListRequest implements IModule
   {
      
      private static var _instance:UserMessageOutboxListRequest;
      
      public var startIndex:int = 0;
      
      public function UserMessageOutboxListRequest(param1:int = 0)
      {
         super();
         this.startIndex = param1;
      }
      
      public static function get instance() : UserMessageOutboxListRequest
      {
         return _instance || (_instance = new UserMessageOutboxListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8115;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex >>> 5 % 32 | this.startIndex << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8115);
         param1.writeInt(this.startIndex << 5 % 32 | this.startIndex >>> 32 - 5 % 32);
      }
   }
}

