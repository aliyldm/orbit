package net.bigpoint.darkorbit.mvc.battlestationswindow
{
   public class BattleStationNotification
   {
      
      public static const NAME:String = "BattleStationNotification";
      
      public static const INIT_BATTLE_STATION_BUILD_WINDOW:String = NAME + "InitBattleStationBuildWindow";
      
      public static const INIT_BATTLE_STATION_MANAGEMENT_WINDOW:String = NAME + "InitBattleStationManagementWindow";
      
      public static const BATTLE_STATION_ASSET_CLICKED:String = NAME + "PopulateBattleStationBuildWindow";
      
      public static const REQUEST_EQUIP_MODULE_TO_ASTEROID_SLOT:String = NAME + "RequestEquipModuleToAsteroidSlot";
      
      public static const REQUEST_UNEQUIP_MODULE_FROM_ASTEROID_SLOT:String = NAME + "RequestUnequipModuleFromAsteroidSlot";
      
      public static const EQUIP_MODULE_TO_ASTEROID_SLOT:String = NAME + "EquipModuleToAsteroidSlot";
      
      public static const UNEQUIP_MODULE_FROM_ASTEROID_SLOT:String = NAME + "UnequipModuleFromAsteroidSlot";
      
      public static const TRY_TO_POPULATE_BATTLE_STATION_BUILD_WINDOW:String = NAME + "TryToPopulateBattleStationBuildWindow";
      
      public static const DISPLAY_ERROR_MESSAGE:String = NAME + "DisplayErrorMessage";
      
      public static const REQUEST_BEGIN_BATTLE_STATION_CONSTRUCTION:String = NAME + "RequestBeginBattleStationConstruction";
      
      public static const REQUEST_DEACTIVATE_DEFLECTOR:String = NAME + "RequestDeactivateDeflector";
      
      public static const REQUEST_REPAIR_MODULE:String = NAME + "RequestRepairModule";
      
      public static const UPDATE_USER_INVENTORY:String = NAME + "UpdateUserInventory";
      
      public static const UPDATE_DEFLECTOR_TIME_PROGRESS:String = NAME + "UpdateDeflectorTimeProgress";
      
      public static const UPDATE_MODULE_HITPOINTS_AND_SHIELD:String = NAME + "UpdateModuleHitpointsAndShield";
      
      public static const INIT_BATTLESTATION_UI:String = NAME + "InitUI";
      
      public static const FILTER_INVENTORY:String = NAME + "filterInventory";
      
      public static const UPDATE_INSTALLED_MODULES:String = "updateInstalledModules";
      
      public function BattleStationNotification()
      {
         super();
      }
   }
}

