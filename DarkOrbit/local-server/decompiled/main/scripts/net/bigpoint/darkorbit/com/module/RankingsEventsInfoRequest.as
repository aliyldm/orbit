package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RankingsEventsInfoRequest implements IModule
   {
      
      private static var _instance:RankingsEventsInfoRequest;
      
      public static const RANKTYPE_WORLD_BOSS_DAILY_TODAY:int = 0;
      
      public static const RANKTYPE_WORLD_BOSS_DAILY_YESTERDAY:int = 1;
      
      public static const RANKTYPE_WORLD_BOSS_EVENT:int = 2;
      
      public static const RANKTYPE_TITLE_FRENZY:int = 3;
      
      public static const RANKTYPE__MAX:int = 4;
      
      public var rankType:int = 0;
      
      public function RankingsEventsInfoRequest(param1:int = 0)
      {
         super();
         this.rankType = param1;
      }
      
      public static function get instance() : RankingsEventsInfoRequest
      {
         return _instance || (_instance = new RankingsEventsInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13945;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rankType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-13945);
         param1.writeShort(this.rankType);
      }
   }
}

