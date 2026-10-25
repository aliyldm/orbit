package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.utils.Dictionary;
   
   public class ItemFilterTypes
   {
      
      public static var FILTER_PRESET__ALL:Dictionary;
      
      public static var FILTER_PRESET__DEVICE_SHIP:Dictionary;
      
      public static var FILTER_PRESET__DEVICE_DRONE:Dictionary;
      
      public static var FILTER_PRESET__DEVICE_PET:Dictionary;
      
      public static var FILTER_PRESET__TYPE_AMMUNITION:Dictionary;
      
      public static var FILTER_PRESET__TYPE_CLANBATTLESTATION:Dictionary;
      
      public static var FILTER_PRESET__TYPE_DRONES:Dictionary;
      
      public static var FILTER_PRESET__TYPE_EXTRAS:Dictionary;
      
      public static var FILTER_PRESET__TYPE_GENERATORS:Dictionary;
      
      public static var FILTER_PRESET__TYPE_PET_GEARS:Dictionary;
      
      public static var FILTER_PRESET__TYPE_PET_PROTOCOLS:Dictionary;
      
      public static var FILTER_PRESET__TYPE_WEAPONS:Dictionary;
      
      public static var FILTER_PRESET__TYPE_RAW_MATERIALS:Dictionary;
      
      public static var FILTER_PRESET__TYPE_SPECIAL:Dictionary;
      
      public static const Ammo__AmmunitionType:String = "net.bigpoint.darkorbit.asset.weapon.ammo.AmmunitionType";
      
      public static const Ammo__LaserType:String = "net.bigpoint.darkorbit.asset.weapon.ammo.LaserType";
      
      public static const Ammo__RocketType:String = "net.bigpoint.darkorbit.asset.weapon.ammo.RocketType";
      
      public static const Drone:String = "net.bigpoint.darkorbit.asset.drone.DroneType";
      
      public static const DroneFormationType:String = "net.bigpoint.darkorbit.asset.drone.formation.DroneFormationType";
      
      public static const DroneVisualDesignType:String = "net.bigpoint.darkorbit.asset.drone.design.DroneCustomizationType";
      
      public static const DroneStatsDesignType:String = "net.bigpoint.darkorbit.asset.drone.design.DroneDesignType";
      
      public static const BoosterType:String = "net.bigpoint.darkorbit.asset.extra.BoosterType";
      
      public static const BoosterValue:String = "BOOSTER";
      
      public static const ExtraType:String = "net.bigpoint.darkorbit.asset.extra.ExtraType";
      
      public static const ModuleType:String = "net.bigpoint.darkorbit.asset.extra.ModuleType";
      
      public static const RobotType:String = "net.bigpoint.darkorbit.asset.extra.RobotType";
      
      public static const UpgradeType:String = "net.bigpoint.darkorbit.asset.extra.UpgradeType";
      
      public static const CPUType:String = "net.bigpoint.darkorbit.asset.extra.cpu.CPUType";
      
      public static const ShieldType:String = "net.bigpoint.darkorbit.asset.generator.ShieldType";
      
      public static const EngineType:String = "net.bigpoint.darkorbit.asset.generator.EngineType";
      
      public static const GeneratorType:String = "net.bigpoint.darkorbit.asset.generator.GeneratorType";
      
      public static const ItemType:String = "net.bigpoint.darkorbit.asset.item.ItemType";
      
      public static const StationModuleType:String = "net.bigpoint.darkorbit.asset.module.StationModuleType";
      
      public static const PetGearType:String = "net.bigpoint.darkorbit.asset.pet.PetGearType";
      
      public static const PetAIProtocolType:String = "net.bigpoint.darkorbit.asset.pet.AIProtocolType";
      
      public static const PetDesignVisualType:String = "net.bigpoint.darkorbit.asset.pet.design.PetDesignVisualType";
      
      public static const PetDesignStatsType:String = "net.bigpoint.darkorbit.asset.pet.design.PetDesignStatsType";
      
      public static const OreType:String = "net.bigpoint.darkorbit.asset.resource.OreType";
      
      public static const ResourceType:String = "net.bigpoint.darkorbit.asset.resource.ResourceType";
      
      public static const Weapon__HellstormLauncherType:String = "net.bigpoint.darkorbit.asset.weapon.HellstormLauncherType";
      
      public static const Weapon__LaserType:String = "net.bigpoint.darkorbit.asset.weapon.LaserType";
      
      public static const Weapon__CannonType:String = "net.bigpoint.darkorbit.asset.weapon.CannonType";
      
      public static const Weapon__CannonShieldType:String = "net.bigpoint.darkorbit.asset.cannonshield.CannonShieldType";
      
      public static const Weapon__QuantumFluidCoreType:String = "net.bigpoint.darkorbit.asset.quantum.QuantumFluidCoreType";
      
      public static const Equipment__DriveType:String = "net.bigpoint.darkorbit.asset.weapon.DriveType";
      
      public static const Equipment__LensType:String = "net.bigpoint.darkorbit.asset.lens.LensType";
      
      public static const AMMUNITION_BUY_CPU_TYPE_VALUE:String = "AMMUNITION_BUY";
      
      public static const ROCKET_BUY_CPU_TYPE_VALUE:String = "ROCKET_BUY";
      
      private static var _initialized:Boolean = false;
      
      public function ItemFilterTypes()
      {
         super();
      }
      
      public static function initialize() : void
      {
         if(!_initialized)
         {
            createItemTypesFilterSets();
            createShipPresetFilterSets();
            _initialized = true;
         }
      }
      
      private static function createItemTypesFilterSets() : void
      {
         FILTER_PRESET__ALL = null;
         FILTER_PRESET__TYPE_AMMUNITION = new Dictionary();
         FILTER_PRESET__TYPE_AMMUNITION[Ammo__AmmunitionType] = Ammo__AmmunitionType;
         FILTER_PRESET__TYPE_AMMUNITION[Ammo__LaserType] = Ammo__LaserType;
         FILTER_PRESET__TYPE_AMMUNITION[Ammo__RocketType] = Ammo__RocketType;
         FILTER_PRESET__TYPE_CLANBATTLESTATION = new Dictionary();
         FILTER_PRESET__TYPE_CLANBATTLESTATION[StationModuleType] = StationModuleType;
         FILTER_PRESET__TYPE_DRONES = new Dictionary();
         FILTER_PRESET__TYPE_DRONES[DroneFormationType] = DroneFormationType;
         FILTER_PRESET__TYPE_DRONES[DroneVisualDesignType] = DroneVisualDesignType;
         FILTER_PRESET__TYPE_DRONES[DroneStatsDesignType] = DroneStatsDesignType;
         FILTER_PRESET__TYPE_EXTRAS = new Dictionary();
         FILTER_PRESET__TYPE_EXTRAS[BoosterType] = BoosterType;
         FILTER_PRESET__TYPE_EXTRAS[ExtraType] = ExtraType;
         FILTER_PRESET__TYPE_EXTRAS[ModuleType] = ModuleType;
         FILTER_PRESET__TYPE_EXTRAS[RobotType] = RobotType;
         FILTER_PRESET__TYPE_EXTRAS[UpgradeType] = UpgradeType;
         FILTER_PRESET__TYPE_EXTRAS[CPUType] = CPUType;
         FILTER_PRESET__TYPE_GENERATORS = new Dictionary();
         FILTER_PRESET__TYPE_GENERATORS[ShieldType] = ShieldType;
         FILTER_PRESET__TYPE_GENERATORS[EngineType] = EngineType;
         FILTER_PRESET__TYPE_GENERATORS[GeneratorType] = GeneratorType;
         FILTER_PRESET__TYPE_PET_GEARS = new Dictionary();
         FILTER_PRESET__TYPE_PET_GEARS[PetGearType] = PetGearType;
         FILTER_PRESET__TYPE_PET_PROTOCOLS = new Dictionary();
         FILTER_PRESET__TYPE_PET_PROTOCOLS[PetAIProtocolType] = PetAIProtocolType;
         FILTER_PRESET__TYPE_SPECIAL = new Dictionary();
         FILTER_PRESET__TYPE_SPECIAL[ItemType] = ItemType;
         FILTER_PRESET__TYPE_RAW_MATERIALS = new Dictionary();
         FILTER_PRESET__TYPE_RAW_MATERIALS[ResourceType] = ResourceType;
         FILTER_PRESET__TYPE_WEAPONS = new Dictionary();
         FILTER_PRESET__TYPE_WEAPONS[Weapon__HellstormLauncherType] = Weapon__HellstormLauncherType;
         FILTER_PRESET__TYPE_WEAPONS[Weapon__LaserType] = Weapon__LaserType;
         FILTER_PRESET__TYPE_WEAPONS[Weapon__CannonType] = Weapon__CannonType;
         FILTER_PRESET__TYPE_WEAPONS[Weapon__CannonShieldType] = Weapon__CannonShieldType;
         FILTER_PRESET__TYPE_WEAPONS[Weapon__QuantumFluidCoreType] = Weapon__QuantumFluidCoreType;
      }
      
      private static function createShipPresetFilterSets() : void
      {
         var _loc1_:Vector.<Dictionary> = null;
         _loc1_ = new <Dictionary>[FILTER_PRESET__TYPE_WEAPONS,FILTER_PRESET__TYPE_GENERATORS,FILTER_PRESET__TYPE_EXTRAS];
         FILTER_PRESET__DEVICE_SHIP = mergeFilterPresets(_loc1_);
         _loc1_ = new <Dictionary>[FILTER_PRESET__TYPE_WEAPONS,FILTER_PRESET__TYPE_GENERATORS,FILTER_PRESET__TYPE_EXTRAS,FILTER_PRESET__TYPE_DRONES];
         FILTER_PRESET__DEVICE_DRONE = mergeFilterPresets(_loc1_);
         _loc1_ = new <Dictionary>[FILTER_PRESET__TYPE_WEAPONS,FILTER_PRESET__TYPE_GENERATORS,FILTER_PRESET__TYPE_PET_GEARS,FILTER_PRESET__TYPE_PET_PROTOCOLS];
         FILTER_PRESET__DEVICE_PET = mergeFilterPresets(_loc1_);
      }
      
      public static function mergeFilterPresets(param1:Vector.<Dictionary>) : Dictionary
      {
         var _loc3_:Dictionary = null;
         var _loc4_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in param1)
         {
            for(_loc4_ in _loc3_)
            {
               _loc2_[_loc4_] = _loc4_;
            }
         }
         return _loc2_;
      }
   }
}

