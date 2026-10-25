package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BlackListDeleteRequest implements IModule
   {
      
      private static var _instance:BlackListDeleteRequest;
      
      public var blackUserId:int = 0;
      
      public function BlackListDeleteRequest(param1:int = 0)
      {
         super();
         this.blackUserId = param1;
      }
      
      public static function get instance() : BlackListDeleteRequest
      {
         return _instance || (_instance = new BlackListDeleteRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10736;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.blackUserId = param1.readInt();
         this.blackUserId = this.blackUserId << 15 % 32 | this.blackUserId >>> 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(10736);
         param1.writeInt(this.blackUserId >>> 15 % 32 | this.blackUserId << 32 - 15 % 32);
      }
   }
}

