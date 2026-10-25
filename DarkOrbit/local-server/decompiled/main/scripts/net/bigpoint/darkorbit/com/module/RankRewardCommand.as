package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RankRewardCommand implements IModule
   {
      
      private static var _instance:RankRewardCommand;
      
      public static const RANKTYPE_HUNT_PLAYER:int = 0;
      
      public static const RANKTYPE_HUNT_CLAN:int = 1;
      
      public static const RANKTYPE_GAUNTLET_OF_PLUTUS:int = 2;
      
      public static const RANKTYPE_PVP_SUMMER_EVENT_REPUTATION:int = 3;
      
      public static const RANKTYPE_PVP_SUMMER_EVENT_REPUTATION_PER_KILL:int = 4;
      
      public static const RANKTYPE_PAYLOAD_ESCORT:int = 5;
      
      public static const RANKTYPE_ETERNAL_GATE:int = 6;
      
      public static const RANKTYPE_ETERNAL_BLACKLIGHT:int = 7;
      
      public static const RANKTYPE_TIERED_ARENA_EVENT_REPUTATION:int = 8;
      
      public static const RANKTYPE_ROGUE_LITE:int = 9;
      
      public static const RANKTYPE_WORLD_BOSS_DAILY:int = 10;
      
      public static const RANKTYPE_WORLD_BOSS_EVENT:int = 11;
      
      public static const RANKTYPE_TITLE_FRENZY:int = 12;
      
      public static const RANKTYPE_EXPEDITION:int = 13;
      
      public static const RANKTYPE__MAX:int = 14;
      
      public var rankType:int = 0;
      
      public var rewardContentModuleList:Vector.<RewardContentModule>;
      
      public var rewardRange:RankRewardRangeModule;
      
      public function RankRewardCommand(param1:Vector.<RewardContentModule> = null, param2:RankRewardRangeModule = null, param3:int = 0)
      {
         super();
         this.rankType = param3;
         if(param1 == null)
         {
            this.rewardContentModuleList = new Vector.<RewardContentModule>();
         }
         else
         {
            this.rewardContentModuleList = param1;
         }
         if(param2 == null)
         {
            this.rewardRange = new RankRewardRangeModule();
         }
         else
         {
            this.rewardRange = param2;
         }
      }
      
      public static function get instance() : RankRewardCommand
      {
         return _instance || (_instance = new RankRewardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18128;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardContentModule = null;
         this.rankType = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rewardContentModuleList.length > 0)
         {
            this.rewardContentModuleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardContentModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rewardContentModuleList.push(_loc4_);
            _loc2_++;
         }
         this.rewardRange = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rewardRange)
         {
            this.rewardRange.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardContentModule = null;
         param1.writeShort(-18128);
         param1.writeShort(this.rankType);
         param1.writeByte(this.rewardContentModuleList.length);
         for each(_loc2_ in this.rewardContentModuleList)
         {
            _loc2_.write(param1);
         }
         if(null != this.rewardRange)
         {
            this.rewardRange.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

