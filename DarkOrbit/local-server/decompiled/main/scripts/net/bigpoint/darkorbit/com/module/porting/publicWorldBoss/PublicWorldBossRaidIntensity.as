package net.bigpoint.darkorbit.com.module.porting.publicWorldBoss
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class PublicWorldBossRaidIntensity implements IModule
   {
      
      private static var _instance:PublicWorldBossRaidIntensity;
      
      public var currDamage:Number = 0;
      
      public var maxDamage:Number = 0;
      
      public var intensity:int = 0;
      
      public var claim:int = 0;
      
      public var rewards:Vector.<RewardModule>;
      
      public var claimLimit:int = 0;
      
      public function PublicWorldBossRaidIntensity(param1:int = 0, param2:Number = 0, param3:Number = 0, param4:int = 0, param5:int = 0, param6:Vector.<RewardModule> = null)
      {
         super();
         this.currDamage = param2;
         this.maxDamage = param3;
         this.intensity = param1;
         this.claim = param4;
         if(param6 == null)
         {
            this.rewards = new Vector.<RewardModule>();
         }
         else
         {
            this.rewards = param6;
         }
         this.claimLimit = param5;
      }
      
      public static function get instance() : PublicWorldBossRaidIntensity
      {
         return _instance || (_instance = new PublicWorldBossRaidIntensity());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27999;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 32;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardModule = null;
         this.currDamage = param1.readDouble();
         this.maxDamage = param1.readDouble();
         this.intensity = param1.readInt();
         this.intensity = this.intensity << 13 % 32 | this.intensity >>> 32 - 13 % 32;
         this.claim = param1.readInt();
         this.claim = this.claim << 4 % 32 | this.claim >>> 32 - 4 % 32;
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
         this.claimLimit = param1.readInt();
         this.claimLimit = this.claimLimit << 13 % 32 | this.claimLimit >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardModule = null;
         param1.writeShort(27999);
         param1.writeDouble(this.currDamage);
         param1.writeDouble(this.maxDamage);
         param1.writeInt(this.intensity >>> 13 % 32 | this.intensity << 32 - 13 % 32);
         param1.writeInt(this.claim >>> 4 % 32 | this.claim << 32 - 4 % 32);
         param1.writeByte(this.rewards.length);
         for each(_loc2_ in this.rewards)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.claimLimit >>> 13 % 32 | this.claimLimit << 32 - 13 % 32);
      }
   }
}

