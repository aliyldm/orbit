package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WorldBossRewardsInfoCommand implements IModule
   {
      
      private static var _instance:WorldBossRewardsInfoCommand;
      
      public var currentTier:int = 0;
      
      public var descriptionKey:String = "";
      
      public var rewards:Vector.<WorldBossRewardModule>;
      
      public function WorldBossRewardsInfoCommand(param1:int = 0, param2:Vector.<WorldBossRewardModule> = null, param3:String = "")
      {
         super();
         this.currentTier = param1;
         this.descriptionKey = param3;
         if(param2 == null)
         {
            this.rewards = new Vector.<WorldBossRewardModule>();
         }
         else
         {
            this.rewards = param2;
         }
      }
      
      public static function get instance() : WorldBossRewardsInfoCommand
      {
         return _instance || (_instance = new WorldBossRewardsInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20286;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:WorldBossRewardModule = null;
         this.currentTier = param1.readInt();
         this.currentTier = this.currentTier >>> 7 % 32 | this.currentTier << 32 - 7 % 32;
         this.descriptionKey = param1.readUTF();
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
            _loc4_ = WorldBossRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewards.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:WorldBossRewardModule = null;
         param1.writeShort(20286);
         param1.writeInt(this.currentTier << 7 % 32 | this.currentTier >>> 32 - 7 % 32);
         param1.writeUTF(this.descriptionKey);
         param1.writeByte(this.rewards.length);
         for each(_loc2_ in this.rewards)
         {
            _loc2_.write(param1);
         }
      }
   }
}

