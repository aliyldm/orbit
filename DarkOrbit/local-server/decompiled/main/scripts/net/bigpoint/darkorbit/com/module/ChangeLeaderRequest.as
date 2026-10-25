package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ChangeLeaderRequest implements IModule
   {
      
      private static var _instance:ChangeLeaderRequest;
      
      public var memberId:int = 0;
      
      public function ChangeLeaderRequest(param1:int = 0)
      {
         super();
         this.memberId = param1;
      }
      
      public static function get instance() : ChangeLeaderRequest
      {
         return _instance || (_instance = new ChangeLeaderRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1319;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.memberId = param1.readInt();
         this.memberId = this.memberId >>> 14 % 32 | this.memberId << 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1319);
         param1.writeInt(this.memberId << 14 % 32 | this.memberId >>> 32 - 14 % 32);
      }
   }
}

