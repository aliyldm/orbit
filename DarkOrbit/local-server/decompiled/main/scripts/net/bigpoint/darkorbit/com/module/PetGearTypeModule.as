package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetGearTypeModule implements IModule
   {
      
      private static var _instance:PetGearTypeModule;
      
      public static const PETGEARTYPE_BEHAVIOR:int = 0;
      
      public static const PETGEARTYPE_PASSIVE:int = 1;
      
      public static const PETGEARTYPE_GUARD:int = 2;
      
      public static const PETGEARTYPE_GEAR:int = 3;
      
      public static const PETGEARTYPE_AUTO_LOOT:int = 4;
      
      public static const PETGEARTYPE_AUTO_RESOURCE_COLLECTION:int = 5;
      
      public static const PETGEARTYPE_ENEMY_LOCATOR:int = 6;
      
      public static const PETGEARTYPE_RESOURCE_LOCATOR:int = 7;
      
      public static const PETGEARTYPE_TRADE_POD:int = 8;
      
      public static const PETGEARTYPE_REPAIR_PET:int = 9;
      
      public static const PETGEARTYPE_KAMIKAZE:int = 10;
      
      public static const PETGEARTYPE_COMBO_SHIP_REPAIR:int = 11;
      
      public static const PETGEARTYPE_COMBO_GUARD:int = 12;
      
      public static const PETGEARTYPE_ADMIN:int = 13;
      
      public static const PETGEARTYPE_FRIENDLY_SACRIFICE:int = 14;
      
      public static const PETGEARTYPE_RETARGETING:int = 15;
      
      public static const PETGEARTYPE_HP_LINK:int = 16;
      
      public static const PETGEARTYPE_MEGA_MINE:int = 17;
      
      public static const PETGEARTYPE_COMBAT_BEACON:int = 18;
      
      public static const PETGEARTYPE_HP_BEACON:int = 19;
      
      public static const PETGEARTYPE_HEAT_RELEASE:int = 20;
      
      public static const PETGEARTYPE__MAX:int = 21;
      
      public var typeValue:int = 0;
      
      public function PetGearTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : PetGearTypeModule
      {
         return _instance || (_instance = new PetGearTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 164;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.typeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(164);
         param1.writeShort(this.typeValue);
      }
   }
}

