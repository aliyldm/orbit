package net.bigpoint.darkorbit.com.module.porting.halloffame
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HallOfFameTopRequest implements IModule
   {
      
      private static var _instance:HallOfFameTopRequest;
      
      public static const TOPREQTYPE_home:int = 0;
      
      public static const TOPREQTYPE_homeTotal:int = 1;
      
      public static const TOPREQTYPE_homeWeek:int = 2;
      
      public static const TOPREQTYPE_homeClimbers:int = 3;
      
      public static const TOPREQTYPE_homeExp:int = 4;
      
      public static const TOPREQTYPE_homeExpTotal:int = 5;
      
      public static const TOPREQTYPE_homeExpWeek:int = 6;
      
      public static const TOPREQTYPE_homeExpClimbers:int = 7;
      
      public static const TOPREQTYPE_homeHonor:int = 8;
      
      public static const TOPREQTYPE_homeHonorTotal:int = 9;
      
      public static const TOPREQTYPE_homeHonorWeek:int = 10;
      
      public static const TOPREQTYPE_homeHonorClimbers:int = 11;
      
      public static const TOPREQTYPE_homeClan:int = 12;
      
      public static const TOPREQTYPE_homeClanTotal:int = 13;
      
      public static const TOPREQTYPE_homeClanWeek:int = 14;
      
      public static const TOPREQTYPE_homeClanClimbers:int = 15;
      
      public static const TOPREQTYPE_homeMonth:int = 16;
      
      public static const TOPREQTYPE_dailyRank:int = 17;
      
      public static const TOPREQTYPE_bestPilots:int = 18;
      
      public static const TOPREQTYPE_bestClans:int = 19;
      
      public static const TOPREQTYPE__MAX:int = 20;
      
      public var type:int = 0;
      
      public function HallOfFameTopRequest(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : HallOfFameTopRequest
      {
         return _instance || (_instance = new HallOfFameTopRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29300;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29300);
         param1.writeShort(this.type);
      }
   }
}

