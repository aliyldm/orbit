package net.bigpoint.darkorbit.com.module.porting.voyagers
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VoyagersClaimPassRewardRequest implements IModule
   {
      
      private static var _instance:VoyagersClaimPassRewardRequest;
      
      public var isVip:Boolean = false;
      
      public var rewardLevel:int = 0;
      
      public function VoyagersClaimPassRewardRequest(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.isVip = param2;
         this.rewardLevel = param1;
      }
      
      public static function get instance() : VoyagersClaimPassRewardRequest
      {
         return _instance || (_instance = new VoyagersClaimPassRewardRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28522;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isVip = param1.readBoolean();
         this.rewardLevel = param1.readInt();
         this.rewardLevel = this.rewardLevel >>> 7 % 32 | this.rewardLevel << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(28522);
         param1.writeBoolean(this.isVip);
         param1.writeInt(this.rewardLevel << 7 % 32 | this.rewardLevel >>> 32 - 7 % 32);
      }
   }
}

