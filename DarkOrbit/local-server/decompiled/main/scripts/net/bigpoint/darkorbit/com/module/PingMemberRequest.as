package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PingMemberRequest implements IModule
   {
      
      private static var _instance:PingMemberRequest;
      
      public var memberId:int = 0;
      
      public function PingMemberRequest(param1:int = 0)
      {
         super();
         this.memberId = param1;
      }
      
      public static function get instance() : PingMemberRequest
      {
         return _instance || (_instance = new PingMemberRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28238;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.memberId = param1.readInt();
         this.memberId = this.memberId >>> 4 % 32 | this.memberId << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(28238);
         param1.writeInt(this.memberId << 4 % 32 | this.memberId >>> 32 - 4 % 32);
      }
   }
}

