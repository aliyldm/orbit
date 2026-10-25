package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationErrorCommand implements IModule
   {
      
      private static var _instance:BattleStationErrorCommand;
      
      public static const ERRORTYPE_UNSPECIFIED:int = 0;
      
      public static const ERRORTYPE_NO_CLAN:int = 1;
      
      public static const ERRORTYPE_STATION_ALREADY_BUILDING:int = 2;
      
      public static const ERRORTYPE_ITEM_HITPOINTS_ZERO:int = 3;
      
      public static const ERRORTYPE_ITEM_ALREADY_EQUIPPED_IN_ANOTHER_ASTEROID:int = 4;
      
      public static const ERRORTYPE_CONCURRENT_EQUIP:int = 5;
      
      public static const ERRORTYPE_REPLACE_RIGHT_MISSING:int = 6;
      
      public static const ERRORTYPE_ITEM_NOT_OWNED:int = 7;
      
      public static const ERRORTYPE_OUT_OF_RANGE:int = 8;
      
      public static const ERRORTYPE_EQUIP_OF_SAME_PLAYER_RUNNING:int = 9;
      
      public static const ERRORTYPE_SATELLITE_ONLY:int = 10;
      
      public static const ERRORTYPE_HUB_ONLY:int = 11;
      
      public static const ERRORTYPE_ITEM_NOT_IN_STATION:int = 12;
      
      public static const ERRORTYPE_MAX_NUMBER_OF_MODULE_TYPE_EXCEEDED:int = 13;
      
      public static const ERRORTYPE_DEFLECTOR_NO_RIGHTS:int = 14;
      
      public static const ERRORTYPE_DEFLECTOR_ALREADY_OFF:int = 15;
      
      public static const ERRORTYPE_REPAIR_NO_MODULE:int = 16;
      
      public static const ERRORTYPE_REPAIR_NO_MONEY:int = 17;
      
      public static const ERRORTYPE_REPAIR_ALREADY_RUNNING:int = 18;
      
      public static const ERRORTYPE_UPGRADE_RUNNING:int = 19;
      
      public static const ERRORTYPE__MAX:int = 20;
      
      public var type:int = 0;
      
      public function BattleStationErrorCommand(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : BattleStationErrorCommand
      {
         return _instance || (_instance = new BattleStationErrorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6012;
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
         param1.writeShort(6012);
         param1.writeShort(this.type);
      }
   }
}

