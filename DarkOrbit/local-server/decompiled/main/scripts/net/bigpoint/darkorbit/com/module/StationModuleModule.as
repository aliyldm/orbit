package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StationModuleModule implements IModule
   {
      
      private static var _instance:StationModuleModule;
      
      public static const MODULETYPE_NONE:int = 0;
      
      public static const MODULETYPE_DESTROYED:int = 1;
      
      public static const MODULETYPE_HULL:int = 2;
      
      public static const MODULETYPE_DEFLECTOR:int = 3;
      
      public static const MODULETYPE_REPAIR:int = 4;
      
      public static const MODULETYPE_LASER_HIGH_RANGE:int = 5;
      
      public static const MODULETYPE_LASER_MID_RANGE:int = 6;
      
      public static const MODULETYPE_LASER_LOW_RANGE:int = 7;
      
      public static const MODULETYPE_ROCKET_MID_ACCURACY:int = 8;
      
      public static const MODULETYPE_ROCKET_LOW_ACCURACY:int = 9;
      
      public static const MODULETYPE_HONOR_BOOSTER:int = 10;
      
      public static const MODULETYPE_DAMAGE_BOOSTER:int = 11;
      
      public static const MODULETYPE_EXPERIENCE_BOOSTER:int = 12;
      
      public static const MODULETYPE__MAX:int = 13;
      
      public var asteroidId:int = 0;
      
      public var itemId:int = 0;
      
      public var slotId:int = 0;
      
      public var type:int = 0;
      
      public var currentHitpoints:int = 0;
      
      public var maxHitpoints:int = 0;
      
      public var currentShield:int = 0;
      
      public var maxShield:int = 0;
      
      public var upgradeLevel:int = 0;
      
      public var ownerName:String = "";
      
      public var installationSeconds:int = 0;
      
      public var installationSecondsLeft:int = 0;
      
      public var emergencyRepairSecondsLeft:int = 0;
      
      public var emergencyRepairSecondsTotal:int = 0;
      
      public var emergencyRepairCost:int = 0;
      
      public function StationModuleModule(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:String = "", param11:int = 0, param12:int = 0, param13:int = 0, param14:int = 0, param15:int = 0)
      {
         super();
         this.asteroidId = param1;
         this.itemId = param2;
         this.slotId = param3;
         this.type = param4;
         this.currentHitpoints = param5;
         this.maxHitpoints = param6;
         this.currentShield = param7;
         this.maxShield = param8;
         this.upgradeLevel = param9;
         this.ownerName = param10;
         this.installationSeconds = param11;
         this.installationSecondsLeft = param12;
         this.emergencyRepairSecondsLeft = param13;
         this.emergencyRepairSecondsTotal = param14;
         this.emergencyRepairCost = param15;
      }
      
      public static function get instance() : StationModuleModule
      {
         return _instance || (_instance = new StationModuleModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6017;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 54;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.asteroidId = param1.readInt();
         this.asteroidId = this.asteroidId << 12 % 32 | this.asteroidId >>> 32 - 12 % 32;
         this.itemId = param1.readInt();
         this.itemId = this.itemId >>> 7 % 32 | this.itemId << 32 - 7 % 32;
         this.slotId = param1.readInt();
         this.slotId = this.slotId << 13 % 32 | this.slotId >>> 32 - 13 % 32;
         this.type = param1.readShort();
         this.currentHitpoints = param1.readInt();
         this.currentHitpoints = this.currentHitpoints >>> 16 % 32 | this.currentHitpoints << 32 - 16 % 32;
         this.maxHitpoints = param1.readInt();
         this.maxHitpoints = this.maxHitpoints << 6 % 32 | this.maxHitpoints >>> 32 - 6 % 32;
         this.currentShield = param1.readInt();
         this.currentShield = this.currentShield >>> 11 % 32 | this.currentShield << 32 - 11 % 32;
         this.maxShield = param1.readInt();
         this.maxShield = this.maxShield << 11 % 32 | this.maxShield >>> 32 - 11 % 32;
         this.upgradeLevel = param1.readInt();
         this.upgradeLevel = this.upgradeLevel << 13 % 32 | this.upgradeLevel >>> 32 - 13 % 32;
         this.ownerName = param1.readUTF();
         this.installationSeconds = param1.readInt();
         this.installationSeconds = this.installationSeconds << 16 % 32 | this.installationSeconds >>> 32 - 16 % 32;
         this.installationSecondsLeft = param1.readInt();
         this.installationSecondsLeft = this.installationSecondsLeft >>> 3 % 32 | this.installationSecondsLeft << 32 - 3 % 32;
         this.emergencyRepairSecondsLeft = param1.readInt();
         this.emergencyRepairSecondsLeft = this.emergencyRepairSecondsLeft >>> 6 % 32 | this.emergencyRepairSecondsLeft << 32 - 6 % 32;
         this.emergencyRepairSecondsTotal = param1.readInt();
         this.emergencyRepairSecondsTotal = this.emergencyRepairSecondsTotal >>> 4 % 32 | this.emergencyRepairSecondsTotal << 32 - 4 % 32;
         this.emergencyRepairCost = param1.readInt();
         this.emergencyRepairCost = this.emergencyRepairCost << 1 % 32 | this.emergencyRepairCost >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6017);
         param1.writeInt(this.asteroidId >>> 12 % 32 | this.asteroidId << 32 - 12 % 32);
         param1.writeInt(this.itemId << 7 % 32 | this.itemId >>> 32 - 7 % 32);
         param1.writeInt(this.slotId >>> 13 % 32 | this.slotId << 32 - 13 % 32);
         param1.writeShort(this.type);
         param1.writeInt(this.currentHitpoints << 16 % 32 | this.currentHitpoints >>> 32 - 16 % 32);
         param1.writeInt(this.maxHitpoints >>> 6 % 32 | this.maxHitpoints << 32 - 6 % 32);
         param1.writeInt(this.currentShield << 11 % 32 | this.currentShield >>> 32 - 11 % 32);
         param1.writeInt(this.maxShield >>> 11 % 32 | this.maxShield << 32 - 11 % 32);
         param1.writeInt(this.upgradeLevel >>> 13 % 32 | this.upgradeLevel << 32 - 13 % 32);
         param1.writeUTF(this.ownerName);
         param1.writeInt(this.installationSeconds >>> 16 % 32 | this.installationSeconds << 32 - 16 % 32);
         param1.writeInt(this.installationSecondsLeft << 3 % 32 | this.installationSecondsLeft >>> 32 - 3 % 32);
         param1.writeInt(this.emergencyRepairSecondsLeft << 6 % 32 | this.emergencyRepairSecondsLeft >>> 32 - 6 % 32);
         param1.writeInt(this.emergencyRepairSecondsTotal << 4 % 32 | this.emergencyRepairSecondsTotal >>> 32 - 4 % 32);
         param1.writeInt(this.emergencyRepairCost >>> 1 % 32 | this.emergencyRepairCost << 32 - 1 % 32);
      }
   }
}

