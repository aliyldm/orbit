package net.bigpoint.darkorbit.items.utils
{
   import flash.utils.Dictionary;
   
   public class ItemCategories
   {
      
      public static const CATEGORY_AMMUNITION:String = "ammunition";
      
      public static const CATEGORY_DRONES:String = "drones";
      
      public static const CATEGORY_EXTRAS:String = "extras";
      
      public static const CATEGORY_GENERATORS:String = "generators";
      
      public static const CATEGORY_SHIPS:String = "ships";
      
      public static const CATEGORY_MODULES:String = "modules";
      
      public static const CATEGORY_PET_GEAR:String = "pet.gear";
      
      public static const CATEGORY_PET_PROTOCOLS:String = "pet.protocols";
      
      public static const CATEGORY_RESOURCES:String = "resources";
      
      public static const CATEGORY_WEAPONS:String = "weapons";
      
      public static const CATEGORY_PET:String = "pet";
      
      public static const CATEGORY_SHIPS_AND_DESIGNS:String = "ships_and_designs";
      
      public static const CATEGORY_HARDWARE:String = "hardware";
      
      public static const CATEGORY_BOOSTERS:String = "boosters";
      
      public static const CATEGORY_TECHS:String = "techs";
      
      private static var categoryName:Dictionary = new Dictionary();
      
      private static var itemTypes:Dictionary = new Dictionary();
      
      public function ItemCategories()
      {
         super();
      }
      
      public static function initialize() : void
      {
         var _loc1_:Array = null;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.weapon.ammo.AmmunitionType");
         itemTypes["net.bigpoint.darkorbit.asset.weapon.ammo.AmmunitionType"] = "ammunition";
         _loc1_.push("net.bigpoint.darkorbit.asset.weapon.ammo.LaserType");
         itemTypes["net.bigpoint.darkorbit.asset.weapon.ammo.LaserType"] = "ammunition";
         _loc1_.push("net.bigpoint.darkorbit.asset.weapon.ammo.RocketType");
         itemTypes["net.bigpoint.darkorbit.asset.weapon.ammo.RocketType"] = "ammunition";
         categoryName["ammunition"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.drone.DroneType");
         itemTypes["net.bigpoint.darkorbit.asset.drone.DroneType"] = "drones";
         _loc1_.push("net.bigpoint.darkorbit.asset.drone.formation.DroneFormationType");
         itemTypes["net.bigpoint.darkorbit.asset.drone.formation.DroneFormationType"] = "drones";
         _loc1_.push("net.bigpoint.darkorbit.asset.drone.design.DroneDesignType");
         itemTypes["net.bigpoint.darkorbit.asset.drone.design.DroneDesignType"] = "drones";
         _loc1_.push("net.bigpoint.darkorbit.asset.drone.design.DroneCustomizationType");
         itemTypes["net.bigpoint.darkorbit.asset.drone.design.DroneCustomizationType"] = "drones";
         _loc1_.push("net.bigpoint.darkorbit.asset.item.ItemType.BLUEPRINT");
         itemTypes["net.bigpoint.darkorbit.asset.item.ItemType.BLUEPRINT"] = "drones";
         categoryName["drones"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.item.ItemType");
         itemTypes["net.bigpoint.darkorbit.asset.item.ItemType"] = "extras";
         _loc1_.push("net.bigpoint.darkorbit.asset.extra.ModuleType");
         itemTypes["net.bigpoint.darkorbit.asset.extra.ModuleType"] = "extras";
         _loc1_.push("net.bigpoint.darkorbit.asset.extra.RobotType");
         itemTypes["net.bigpoint.darkorbit.asset.extra.RobotType"] = "extras";
         _loc1_.push("net.bigpoint.darkorbit.asset.extra.UpgradeType");
         itemTypes["net.bigpoint.darkorbit.asset.extra.UpgradeType"] = "extras";
         _loc1_.push("net.bigpoint.darkorbit.asset.extra.cpu.CPUType");
         itemTypes["net.bigpoint.darkorbit.asset.extra.cpu.CPUType"] = "extras";
         _loc1_.push("net.bigpoint.darkorbit.asset.resource.OreType");
         itemTypes["net.bigpoint.darkorbit.asset.resource.OreType"] = "extras";
         _loc1_.push("net.bigpoint.darkorbit.asset.shipupgrade.ShipUpgradeType");
         itemTypes["net.bigpoint.darkorbit.asset.shipupgrade.ShipUpgradeType"] = "extras";
         _loc1_.push("net.bigpoint.darkorbit.asset.shipupgrade.ShipUpgradeType");
         itemTypes["net.bigpoint.darkorbit.asset.shipupgrade.ShipUpgradeType"] = "extras";
         _loc1_.push("net.bigpoint.darkorbit.asset.captain.CaptainType");
         itemTypes["net.bigpoint.darkorbit.asset.captain.CaptainType"] = "extras";
         categoryName["extras"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.generator.ShieldType");
         itemTypes["net.bigpoint.darkorbit.asset.generator.ShieldType"] = "generators";
         _loc1_.push("net.bigpoint.darkorbit.asset.generator.EngineType");
         itemTypes["net.bigpoint.darkorbit.asset.generator.EngineType"] = "generators";
         _loc1_.push("net.bigpoint.darkorbit.asset.generator.GeneratorType");
         itemTypes["net.bigpoint.darkorbit.asset.generator.GeneratorType"] = "generators";
         _loc1_.push("net.bigpoint.darkorbit.asset.cannonshield.CannonShieldType");
         itemTypes["net.bigpoint.darkorbit.asset.cannonshield.CannonShieldType"] = "generators";
         categoryName["generators"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.ship.ShipType");
         itemTypes["net.bigpoint.darkorbit.asset.ship.ShipType"] = "ships";
         categoryName["ships"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.module.StationModuleType");
         itemTypes["net.bigpoint.darkorbit.asset.module.StationModuleType"] = "modules";
         categoryName["modules"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.pet.PetGearType");
         itemTypes["net.bigpoint.darkorbit.asset.pet.PetGearType"] = "pet.gear";
         categoryName["pet.gear"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.pet.AIProtocolType");
         itemTypes["net.bigpoint.darkorbit.asset.pet.AIProtocolType"] = "pet.protocols";
         categoryName["pet.protocols"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.resource.OreType");
         itemTypes["net.bigpoint.darkorbit.asset.resource.OreType"] = "resources";
         _loc1_.push("net.bigpoint.darkorbit.asset.resource.ResourceType");
         itemTypes["net.bigpoint.darkorbit.asset.resource.ResourceType"] = "resources";
         categoryName["resources"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.weapon.HellstormLauncherType");
         itemTypes["net.bigpoint.darkorbit.asset.weapon.HellstormLauncherType"] = "weapons";
         _loc1_.push("net.bigpoint.darkorbit.asset.weapon.LaserType");
         itemTypes["net.bigpoint.darkorbit.asset.weapon.LaserType"] = "weapons";
         _loc1_.push("net.bigpoint.darkorbit.asset.weapon.CannonType");
         itemTypes["net.bigpoint.darkorbit.asset.weapon.CannonType"] = "weapons";
         _loc1_.push("net.bigpoint.darkorbit.asset.lens.LensType");
         itemTypes["net.bigpoint.darkorbit.asset.lens.LensType"] = "weapons";
         _loc1_.push("net.bigpoint.darkorbit.asset.weapon.DriveType");
         itemTypes["net.bigpoint.darkorbit.asset.weapon.DriveType"] = "weapons";
         categoryName["weapons"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.pet.AIProtocolType");
         itemTypes["net.bigpoint.darkorbit.asset.pet.AIProtocolType"] = "pet";
         _loc1_.push("net.bigpoint.darkorbit.asset.pet.PetGearType");
         itemTypes["net.bigpoint.darkorbit.asset.pet.PetGearType"] = "pet";
         _loc1_.push("net.bigpoint.darkorbit.asset.pet.PetType");
         itemTypes["net.bigpoint.darkorbit.asset.pet.PetType"] = "pet";
         _loc1_.push("net.bigpoint.darkorbit.asset.pet.design.PetCustomizationType");
         itemTypes["net.bigpoint.darkorbit.asset.pet.design.PetCustomizationType"] = "pet";
         categoryName["pet"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.ship.ShipType");
         itemTypes["net.bigpoint.darkorbit.asset.ship.ShipType"] = "ships_and_designs";
         _loc1_.push("net.bigpoint.darkorbit.asset.ship.ShipDesignType");
         itemTypes["net.bigpoint.darkorbit.asset.ship.ShipDesignType"] = "ships_and_designs";
         categoryName["ships_and_designs"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.item.HardwareType");
         itemTypes["net.bigpoint.darkorbit.asset.item.HardwareType"] = "hardware";
         categoryName["hardware"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.extra.ExtraType.BOOSTER");
         itemTypes["net.bigpoint.darkorbit.asset.extra.ExtraType.BOOSTER"] = "boosters";
         categoryName["boosters"] = _loc1_;
         _loc1_ = [];
         _loc1_.push("net.bigpoint.darkorbit.asset.nanotech.TechType");
         itemTypes["net.bigpoint.darkorbit.asset.nanotech.TechType"] = "techs";
         categoryName["techs"] = _loc1_;
      }
      
      public static function getItemTypesForCategoryID(param1:String) : Array
      {
         return categoryName[param1];
      }
      
      public static function getCategoryIDForItemType(param1:String) : String
      {
         return itemTypes[param1];
      }
   }
}

