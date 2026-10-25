package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventRewardConfirmationCommand implements IModule
   {
      
      private static var _instance:EventRewardConfirmationCommand;
      
      public static const REWARDTYPE_HUNT_PLAYER:int = 0;
      
      public static const REWARDTYPE_HUNT_CLAN:int = 1;
      
      public static const REWARDTYPE_PLUTUS:int = 2;
      
      public static const REWARDTYPE_DEFAULT:int = 3;
      
      public static const REWARDTYPE_PVP_SUMMER_REPUTATION:int = 4;
      
      public static const REWARDTYPE_PVP_SUMMER_REPUTATION_PER_KILL:int = 5;
      
      public static const REWARDTYPE_PAYLOAD_ESCORT:int = 6;
      
      public static const REWARDTYPE_ETERNAL_BLACKLIGHT:int = 7;
      
      public static const REWARDTYPE_TIERED_ARENA_REPUTATION:int = 8;
      
      public static const REWARDTYPE_ROGUELITE_ASTRAL_ASCENSION:int = 9;
      
      public static const REWARDTYPE_WORLD_BOSS_EVENT:int = 10;
      
      public static const REWARDTYPE_WORLD_BOSS_DAILY:int = 11;
      
      public static const REWARDTYPE__MAX:int = 12;
      
      public var ranking:int = 0;
      
      public var rewardType:int = 0;
      
      public var reward:Vector.<RewardContentModule>;
      
      public function EventRewardConfirmationCommand(param1:Vector.<RewardContentModule> = null, param2:int = 0, param3:int = 0)
      {
         super();
         this.ranking = param2;
         this.rewardType = param3;
         if(param1 == null)
         {
            this.reward = new Vector.<RewardContentModule>();
         }
         else
         {
            this.reward = param1;
         }
      }
      
      public static function get instance() : EventRewardConfirmationCommand
      {
         return _instance || (_instance = new EventRewardConfirmationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10623;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardContentModule = null;
         this.ranking = param1.readInt();
         this.ranking = this.ranking << 8 % 32 | this.ranking >>> 32 - 8 % 32;
         this.rewardType = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.reward.length > 0)
         {
            this.reward.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardContentModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.reward.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardContentModule = null;
         param1.writeShort(10623);
         param1.writeInt(this.ranking >>> 8 % 32 | this.ranking << 32 - 8 % 32);
         param1.writeShort(this.rewardType);
         param1.writeByte(this.reward.length);
         for each(_loc2_ in this.reward)
         {
            _loc2_.write(param1);
         }
      }
   }
}

