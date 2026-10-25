package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FollowRequest implements IModule
   {
      
      private static var _instance:FollowRequest;
      
      public var memberId:int = 0;
      
      public function FollowRequest(param1:int = 0)
      {
         super();
         this.memberId = param1;
      }
      
      public static function get instance() : FollowRequest
      {
         return _instance || (_instance = new FollowRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12117;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.memberId = param1.readInt();
         this.memberId = this.memberId << 2 % 32 | this.memberId >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12117);
         param1.writeInt(this.memberId >>> 2 % 32 | this.memberId << 32 - 2 % 32);
      }
   }
}

