package net.bigpoint.darkorbit.mvc.battlestationswindow
{
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.BattleStationErrorCommand;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.ModuleVO;
   
   public class BattleStationConstants
   {
      
      private static var _cachedBitmapData:Object = {};
      
      public static const FILTER_CHANGE:String = "filterChange";
      
      public static const moduleResKeyLookup:Dictionary = new Dictionary();
      
      public static const MODULES_IDS_MAP:Object = {};
      
      public static const HULL_CATEGORY:String = "hull";
      
      public static const DEFLECTOR_CATEGORY:String = "deflector";
      
      public static const ENGINEERING_BAY_CATEGORY:String = "engineering_bay";
      
      public static const LASERS_CATEGORY:String = "lasers";
      
      public static const ROCKETS_CATEGORY:String = "rockets";
      
      public static const BOOSTERS_CATEGORY:String = "boosters";
      
      public static const SHOW_ALL:String = "show_all";
      
      public static const CATEGORIES_IDS_MAP:Object = {};
      
      public static const ERROR_MESSAGE_MAP:Array = [];
      
      moduleResKeyLookup[ModuleVO.NONE] = "itemslot_empty";
      moduleResKeyLookup[ModuleVO.DESTROYED] = "destroyedModule";
      moduleResKeyLookup[ModuleVO.HULL] = "module_hulm_1";
      moduleResKeyLookup[ModuleVO.DEFLECTOR] = "module_defm_1";
      moduleResKeyLookup[ModuleVO.REPAIR] = "module_repm_1";
      moduleResKeyLookup[ModuleVO.DAMAGE_BOOSTER] = "damageBoosterModulePH";
      moduleResKeyLookup[ModuleVO.LASER_HIGH_RANGE] = "module_ltm_hr";
      moduleResKeyLookup[ModuleVO.LASER_MID_RANGE] = "module_ltm_mr";
      moduleResKeyLookup[ModuleVO.LASER_LOW_RANGE] = "module_ltm_lr";
      moduleResKeyLookup[ModuleVO.ROCKET_MID_ACCURACY] = "module_ram_ma";
      moduleResKeyLookup[ModuleVO.ROCKET_LOW_ACCURACY] = "module_ram_la";
      moduleResKeyLookup[ModuleVO.HONOR_BOOSTER] = "module_honm_1";
      moduleResKeyLookup[ModuleVO.DAMAGE_BOOSTER] = "module_dmgm_1";
      moduleResKeyLookup[ModuleVO.EXPERIENCE_BOOSTER] = "module_xpm_1";
      MODULES_IDS_MAP[ModuleVO.HULL] = "module_hulm-1";
      MODULES_IDS_MAP[ModuleVO.DEFLECTOR] = "module_defm-1";
      MODULES_IDS_MAP[ModuleVO.REPAIR] = "module_repm-1";
      MODULES_IDS_MAP[ModuleVO.LASER_LOW_RANGE] = "module_ltm-lr";
      MODULES_IDS_MAP[ModuleVO.LASER_MID_RANGE] = "module_ltm-mr";
      MODULES_IDS_MAP[ModuleVO.LASER_HIGH_RANGE] = "module_ltm-hr";
      MODULES_IDS_MAP[ModuleVO.ROCKET_MID_ACCURACY] = "module_ram-ma";
      MODULES_IDS_MAP[ModuleVO.ROCKET_LOW_ACCURACY] = "module_ram-la";
      MODULES_IDS_MAP[ModuleVO.HONOR_BOOSTER] = "module_honm-1";
      MODULES_IDS_MAP[ModuleVO.DAMAGE_BOOSTER] = "module_dmgm-1";
      MODULES_IDS_MAP[ModuleVO.EXPERIENCE_BOOSTER] = "module_xpm-1";
      CATEGORIES_IDS_MAP[ModuleVO.HULL] = HULL_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.DEFLECTOR] = DEFLECTOR_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.REPAIR] = ENGINEERING_BAY_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.LASER_LOW_RANGE] = LASERS_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.LASER_MID_RANGE] = LASERS_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.LASER_HIGH_RANGE] = LASERS_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.ROCKET_MID_ACCURACY] = ROCKETS_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.ROCKET_LOW_ACCURACY] = ROCKETS_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.HONOR_BOOSTER] = BOOSTERS_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.DAMAGE_BOOSTER] = BOOSTERS_CATEGORY;
      CATEGORIES_IDS_MAP[ModuleVO.EXPERIENCE_BOOSTER] = BOOSTERS_CATEGORY;
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_UNSPECIFIED] = "error_bswin_unspecified";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_NO_CLAN] = "error_bswin_no_clan";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_STATION_ALREADY_BUILDING] = "error_bswin_station_already_building";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_ITEM_HITPOINTS_ZERO] = "error_bswin_item_hitpoints_not_full";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_ITEM_ALREADY_EQUIPPED_IN_ANOTHER_ASTEROID] = "error_bswin_item_already_equipped_in_another_asteroid";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_CONCURRENT_EQUIP] = "error_bswin_concurrent_equip";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_REPLACE_RIGHT_MISSING] = "error_bswin_replace_rights_missing";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_ITEM_NOT_OWNED] = "error_bswin_item_not_owned";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_OUT_OF_RANGE] = "error_bswin_out_of_range";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_EQUIP_OF_SAME_PLAYER_RUNNING] = "error_bswin_equip_of_same_player_running";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_SATELLITE_ONLY] = "error_bswin_satellite_only";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_HUB_ONLY] = "error_bswin_hub_only";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_ITEM_NOT_IN_STATION] = "error_bswin_item_not_in_station";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_MAX_NUMBER_OF_MODULE_TYPE_EXCEEDED] = "error_bswin_max_number_of_module_type_exceeded";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_DEFLECTOR_NO_RIGHTS] = "error_bswin_deflector_no_rights";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_DEFLECTOR_ALREADY_OFF] = "error_bswin_deflector_already_off";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_REPAIR_NO_MODULE] = "error_bswin_repair_no_module";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_REPAIR_NO_MONEY] = "error_bswin_repair_no_money";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_REPAIR_ALREADY_RUNNING] = "error_bswin_repair_already_running";
      ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_UPGRADE_RUNNING] = "error_bswin_item_upgrade_running";
      
      public function BattleStationConstants()
      {
         super();
      }
      
      public static function getBitmapData(param1:String) : BitmapData
      {
         var _loc2_:BitmapData = _cachedBitmapData[param1] as BitmapData;
         if(_loc2_)
         {
            return _loc2_;
         }
         return _cachedBitmapData[param1] = ResourceManager.getBitmapData("battleStationsUI",param1);
      }
   }
}

