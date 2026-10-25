package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RewardContentRequest implements IModule
   {
      
      private static var _instance:RewardContentRequest;
      
      public static const REWARDTYPE_PVP_SUMMER_EVENT_MILESTONE:int = 0;
      
      public static const REWARDTYPE_TIERED_ARENA_EVENT_PARTICIPATION:int = 1;
      
      public static const REWARDTYPE__MAX:int = 2;
      
      public var rewardType:int = 0;
      
      public function RewardContentRequest(param1:int = 0)
      {
         super();
         this.rewardType = param1;
      }
      
      public static function get instance() : RewardContentRequest
      {
         return _instance || (_instance = new RewardContentRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31241;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rewardType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31241);
         param1.writeShort(this.rewardType);
      }
   }
}

