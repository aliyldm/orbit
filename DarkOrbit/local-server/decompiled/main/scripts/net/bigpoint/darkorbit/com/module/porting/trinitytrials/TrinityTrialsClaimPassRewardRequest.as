package net.bigpoint.darkorbit.com.module.porting.trinitytrials
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrinityTrialsClaimPassRewardRequest implements IModule
   {
      
      private static var _instance:TrinityTrialsClaimPassRewardRequest;
      
      public var rewardLevel:int = 0;
      
      public var isVip:Boolean = false;
      
      public function TrinityTrialsClaimPassRewardRequest(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.rewardLevel = param1;
         this.isVip = param2;
      }
      
      public static function get instance() : TrinityTrialsClaimPassRewardRequest
      {
         return _instance || (_instance = new TrinityTrialsClaimPassRewardRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23601;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rewardLevel = param1.readInt();
         this.rewardLevel = this.rewardLevel >>> 8 % 32 | this.rewardLevel << 32 - 8 % 32;
         this.isVip = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23601);
         param1.writeInt(this.rewardLevel << 8 % 32 | this.rewardLevel >>> 32 - 8 % 32);
         param1.writeBoolean(this.isVip);
      }
   }
}

