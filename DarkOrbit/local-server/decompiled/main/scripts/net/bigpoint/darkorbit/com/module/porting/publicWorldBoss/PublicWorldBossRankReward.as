package net.bigpoint.darkorbit.com.module.porting.publicWorldBoss
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class PublicWorldBossRankReward implements IModule
   {
      
      private static var _instance:PublicWorldBossRankReward;
      
      public var rewardTitleModule:RewardTitleModule;
      
      public var from:int = 0;
      
      public var to:int = 0;
      
      public var rewards:Vector.<RewardModule>;
      
      public function PublicWorldBossRankReward(param1:int = 0, param2:int = 0, param3:Vector.<RewardModule> = null, param4:RewardTitleModule = null)
      {
         super();
         if(param4 == null)
         {
            this.rewardTitleModule = new RewardTitleModule();
         }
         else
         {
            this.rewardTitleModule = param4;
         }
         this.from = param1;
         this.to = param2;
         if(param3 == null)
         {
            this.rewards = new Vector.<RewardModule>();
         }
         else
         {
            this.rewards = param3;
         }
      }
      
      public static function get instance() : PublicWorldBossRankReward
      {
         return _instance || (_instance = new PublicWorldBossRankReward());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27687;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardModule = null;
         this.rewardTitleModule = RewardTitleModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rewardTitleModule)
         {
            this.rewardTitleModule.read(param1);
         }
         this.from = param1.readInt();
         this.from = this.from << 16 % 32 | this.from >>> 32 - 16 % 32;
         this.to = param1.readInt();
         this.to = this.to >>> 14 % 32 | this.to << 32 - 14 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewards.length > 0)
         {
            this.rewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewards.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardModule = null;
         param1.writeShort(-27687);
         if(null != this.rewardTitleModule)
         {
            this.rewardTitleModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.from >>> 16 % 32 | this.from << 32 - 16 % 32);
         param1.writeInt(this.to << 14 % 32 | this.to >>> 32 - 14 % 32);
         param1.writeByte(this.rewards.length);
         for each(_loc2_ in this.rewards)
         {
            _loc2_.write(param1);
         }
      }
   }
}

