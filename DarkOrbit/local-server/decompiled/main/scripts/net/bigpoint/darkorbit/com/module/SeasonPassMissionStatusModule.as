package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassMissionStatusModule implements IModule
   {
      
      private static var _instance:SeasonPassMissionStatusModule;
      
      public static const MISSIONSTATUSTYPE_NORMAL_RUNNING:int = 0;
      
      public static const MISSIONSTATUSTYPE_GOLD_RUNNING:int = 1;
      
      public static const MISSIONSTATUSTYPE_GOLD_LOCKED_INCOMPLETE:int = 2;
      
      public static const MISSIONSTATUSTYPE_NORMAL_COMPLETED:int = 3;
      
      public static const MISSIONSTATUSTYPE_GOLD_COMPLETED:int = 4;
      
      public static const MISSIONSTATUSTYPE_GOLD_LOCKED_COMPLETE:int = 5;
      
      public static const MISSIONSTATUSTYPE__MAX:int = 6;
      
      public var type:int = 0;
      
      public function SeasonPassMissionStatusModule(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : SeasonPassMissionStatusModule
      {
         return _instance || (_instance = new SeasonPassMissionStatusModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7906;
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
         param1.writeShort(7906);
         param1.writeShort(this.type);
      }
   }
}

