package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BlackListAddRequest implements IModule
   {
      
      private static var _instance:BlackListAddRequest;
      
      public var blackUserId:int = 0;
      
      public function BlackListAddRequest(param1:int = 0)
      {
         super();
         this.blackUserId = param1;
      }
      
      public static function get instance() : BlackListAddRequest
      {
         return _instance || (_instance = new BlackListAddRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10087;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.blackUserId = param1.readInt();
         this.blackUserId = this.blackUserId << 8 % 32 | this.blackUserId >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10087);
         param1.writeInt(this.blackUserId >>> 8 % 32 | this.blackUserId << 32 - 8 % 32);
      }
   }
}

