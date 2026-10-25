package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HuntRewardRequest implements IModule
   {
      
      private static var _instance:HuntRewardRequest;
      
      public static const REWARDTYPE_PLAYER:int = 0;
      
      public static const REWARDTYPE_CLAN:int = 1;
      
      public static const REWARDTYPE__MAX:int = 2;
      
      public var ranking:int = 0;
      
      public var rewardType:int = 0;
      
      public function HuntRewardRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.ranking = param1;
         this.rewardType = param2;
      }
      
      public static function get instance() : HuntRewardRequest
      {
         return _instance || (_instance = new HuntRewardRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2028;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ranking = param1.readInt();
         this.ranking = this.ranking << 11 % 32 | this.ranking >>> 32 - 11 % 32;
         this.rewardType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-2028);
         param1.writeInt(this.ranking >>> 11 % 32 | this.ranking << 32 - 11 % 32);
         param1.writeShort(this.rewardType);
      }
   }
}

