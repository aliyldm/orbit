package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RankRewardRequest implements IModule
   {
      
      private static var _instance:RankRewardRequest;
      
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
      
      public static const RANKTYPE__MAX:int = 13;
      
      public var ranking:int = 0;
      
      public var rankType:int = 0;
      
      public function RankRewardRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.ranking = param1;
         this.rankType = param2;
      }
      
      public static function get instance() : RankRewardRequest
      {
         return _instance || (_instance = new RankRewardRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4475;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ranking = param1.readInt();
         this.ranking = this.ranking >>> 6 % 32 | this.ranking << 32 - 6 % 32;
         this.rankType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-4475);
         param1.writeInt(this.ranking << 6 % 32 | this.ranking >>> 32 - 6 % 32);
         param1.writeShort(this.rankType);
      }
   }
}

