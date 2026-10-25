package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ButtonIDModule implements IModule
   {
      
      private static var _instance:ButtonIDModule;
      
      public static const BUTTONID_LASER_x1:int = 0;
      
      public static const BUTTONID_LASER_x2:int = 1;
      
      public static const BUTTONID_LASER_x3:int = 2;
      
      public static const BUTTONID_LASER_x4:int = 3;
      
      public static const BUTTONID_LASER_SAB:int = 4;
      
      public static const BUTTONID_LASER_RSB:int = 5;
      
      public static const BUTTONID_ROCKET_1:int = 6;
      
      public static const BUTTONID_ROCKET_2:int = 7;
      
      public static const BUTTONID_ROCKET_3:int = 8;
      
      public static const BUTTONID_WIZARD:int = 9;
      
      public static const BUTTONID_PLASMA:int = 10;
      
      public static const BUTTONID_DECELERATION_ROCKET:int = 11;
      
      public static const BUTTONID_EMP:int = 12;
      
      public static const BUTTONID_MINE_ACM:int = 13;
      
      public static const BUTTONID_MINE_EMP:int = 14;
      
      public static const BUTTONID_MINE_SAB:int = 15;
      
      public static const BUTTONID_MINE_DD:int = 16;
      
      public static const BUTTONID_ROCKET_LAUNCHER:int = 17;
      
      public static const BUTTONID_HELLSTORM_01:int = 18;
      
      public static const BUTTONID_UBR_100:int = 19;
      
      public static const BUTTONID_ECO_10:int = 20;
      
      public static const BUTTONID_CPU_DRONE_REPAIR:int = 21;
      
      public static const BUTTONID_CPU_AIM:int = 22;
      
      public static const BUTTONID_CPU_AROL:int = 23;
      
      public static const BUTTONID_CPU_CLOAK:int = 24;
      
      public static const BUTTONID_CPU_JUMP:int = 25;
      
      public static const BUTTONID_CPU_REPAIR_ROBOT:int = 26;
      
      public static const BUTTONID_CPU_HM7:int = 27;
      
      public static const BUTTONID_CPU_AMMOBUY:int = 28;
      
      public static const BUTTONID_JUMP:int = 29;
      
      public static const BUTTONID_FAST_REPAIR:int = 30;
      
      public static const BUTTONID_LOGOUT:int = 31;
      
      public static const BUTTONID_MENU_LASER:int = 32;
      
      public static const BUTTONID_MENU_ROCKET:int = 33;
      
      public static const BUTTONID_MENU_EXPLOSIVES:int = 34;
      
      public static const BUTTONID_MENU_CPU:int = 35;
      
      public static const BUTTONID_MENU_EXTRAS:int = 36;
      
      public static const BUTTONID_MENU_TECHS:int = 37;
      
      public static const BUTTONID_MENU_SKILLS:int = 38;
      
      public static const BUTTONID__MAX:int = 39;
      
      public var idValue:int = 0;
      
      public function ButtonIDModule(param1:int = 0)
      {
         super();
         this.idValue = param1;
      }
      
      public static function get instance() : ButtonIDModule
      {
         return _instance || (_instance = new ButtonIDModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 124;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.idValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(124);
         param1.writeShort(this.idValue);
      }
   }
}

