package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KillScreenOptionTypeModule implements IModule
   {
      
      private static var _instance:KillScreenOptionTypeModule;
      
      public static const OPTIONTYPE_FREE_PHOENIX:int = 0;
      
      public static const OPTIONTYPE_BASIC_REPAIR:int = 1;
      
      public static const OPTIONTYPE_AT_JUMPGATE_REPAIR:int = 2;
      
      public static const OPTIONTYPE_AT_DEATHLOCATION_REPAIR:int = 3;
      
      public static const OPTIONTYPE_AT_SECTOR_CONTROL_SPAWNPOINT:int = 4;
      
      public static const OPTIONTYPE_EXIT_SECTOR_CONTROL:int = 5;
      
      public static const OPTIONTYPE_BASIC_FULL_REPAIR:int = 6;
      
      public static const OPTIONTYPE_RAID_GATE_REPAIR:int = 7;
      
      public static const OPTIONTYPE_TDM_REPAIR:int = 8;
      
      public static const OPTIONTYPE_PAYMENT:int = 9;
      
      public static const OPTIONTYPE_REFRACTION_ZONE_FACTION_BASE:int = 10;
      
      public static const OPTIONTYPE_REFRACTION_ZONE_DEATH_LOCATION:int = 11;
      
      public static const OPTIONTYPE_WAR_GAME_REPAIR:int = 12;
      
      public static const OPTIONTYPE_STRIKE_AND_EXIT:int = 13;
      
      public static const OPTIONTYPE__MAX:int = 14;
      
      public var repairTypeValue:int = 0;
      
      public function KillScreenOptionTypeModule(param1:int = 0)
      {
         super();
         this.repairTypeValue = param1;
      }
      
      public static function get instance() : KillScreenOptionTypeModule
      {
         return _instance || (_instance = new KillScreenOptionTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 254;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.repairTypeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(254);
         param1.writeShort(this.repairTypeValue);
      }
   }
}

