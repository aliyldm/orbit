package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AmmunitionTypeModule implements IModule
   {
      
      private static var _instance:AmmunitionTypeModule;
      
      public static const AMMUNITIONTYPE_ROCKET:int = 0;
      
      public static const AMMUNITIONTYPE_TORPEDO:int = 1;
      
      public static const AMMUNITIONTYPE_WIZARD:int = 2;
      
      public static const AMMUNITIONTYPE_PRANK:int = 3;
      
      public static const AMMUNITIONTYPE_BATTERY:int = 4;
      
      public static const AMMUNITIONTYPE_FIREWORK:int = 5;
      
      public static const AMMUNITIONTYPE_FIREWORK_1:int = 6;
      
      public static const AMMUNITIONTYPE_FIREWORK_2:int = 7;
      
      public static const AMMUNITIONTYPE_FIREWORK_3:int = 8;
      
      public static const AMMUNITIONTYPE_MINE:int = 9;
      
      public static const AMMUNITIONTYPE_MINE_EMP:int = 10;
      
      public static const AMMUNITIONTYPE_MINE_SAB:int = 11;
      
      public static const AMMUNITIONTYPE_MINE_DD:int = 12;
      
      public static const AMMUNITIONTYPE_MINE_SL:int = 13;
      
      public static const AMMUNITIONTYPE_SMARTBOMB:int = 14;
      
      public static const AMMUNITIONTYPE_INSTANT_SHIELD:int = 15;
      
      public static const AMMUNITIONTYPE_PLASMA:int = 16;
      
      public static const AMMUNITIONTYPE_EMP:int = 17;
      
      public static const AMMUNITIONTYPE_LASER_AMMO:int = 18;
      
      public static const AMMUNITIONTYPE_ROCKET_AMMO:int = 19;
      
      public static const AMMUNITIONTYPE_RSB:int = 20;
      
      public static const AMMUNITIONTYPE_HELLSTORM:int = 21;
      
      public static const AMMUNITIONTYPE_UBER_ROCKET:int = 22;
      
      public static const AMMUNITIONTYPE_ECO_ROCKET:int = 23;
      
      public static const AMMUNITIONTYPE_SAR01:int = 24;
      
      public static const AMMUNITIONTYPE_SAR02:int = 25;
      
      public static const AMMUNITIONTYPE_X1:int = 26;
      
      public static const AMMUNITIONTYPE_X2:int = 27;
      
      public static const AMMUNITIONTYPE_X3:int = 28;
      
      public static const AMMUNITIONTYPE_X4:int = 29;
      
      public static const AMMUNITIONTYPE_SAB:int = 30;
      
      public static const AMMUNITIONTYPE_CBO:int = 31;
      
      public static const AMMUNITIONTYPE_R310:int = 32;
      
      public static const AMMUNITIONTYPE_PLT2026:int = 33;
      
      public static const AMMUNITIONTYPE_PLT2021:int = 34;
      
      public static const AMMUNITIONTYPE_PLT3030:int = 35;
      
      public static const AMMUNITIONTYPE_BDR1211:int = 36;
      
      public static const AMMUNITIONTYPE_RB214:int = 37;
      
      public static const AMMUNITIONTYPE_DECELERATION:int = 38;
      
      public static const AMMUNITIONTYPE_CBR:int = 39;
      
      public static const AMMUNITIONTYPE_HITAC_LASER:int = 40;
      
      public static const AMMUNITIONTYPE_JOB100:int = 41;
      
      public static const AMMUNITIONTYPE_BDR1212:int = 42;
      
      public static const AMMUNITIONTYPE_FIREWORK_COM:int = 43;
      
      public static const AMMUNITIONTYPE_FIREWORK_RZ:int = 44;
      
      public static const AMMUNITIONTYPE_RIC3:int = 45;
      
      public static const AMMUNITIONTYPE_PIR_100:int = 46;
      
      public static const AMMUNITIONTYPE_K300M:int = 47;
      
      public static const AMMUNITIONTYPE_OBR_100:int = 48;
      
      public static const AMMUNITIONTYPE__MAX:int = 49;
      
      public var typeValue:int = 0;
      
      public function AmmunitionTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : AmmunitionTypeModule
      {
         return _instance || (_instance = new AmmunitionTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 38;
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
         param1.writeShort(38);
         param1.writeShort(this.typeValue);
      }
   }
}

