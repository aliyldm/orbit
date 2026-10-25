package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KickMemberRequest implements IModule
   {
      
      private static var _instance:KickMemberRequest;
      
      public var memberId:int = 0;
      
      public function KickMemberRequest(param1:int = 0)
      {
         super();
         this.memberId = param1;
      }
      
      public static function get instance() : KickMemberRequest
      {
         return _instance || (_instance = new KickMemberRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11982;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.memberId = param1.readInt();
         this.memberId = this.memberId << 11 % 32 | this.memberId >>> 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11982);
         param1.writeInt(this.memberId >>> 11 % 32 | this.memberId << 32 - 11 % 32);
      }
   }
}

