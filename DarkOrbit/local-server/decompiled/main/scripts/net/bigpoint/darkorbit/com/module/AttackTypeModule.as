package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackTypeModule implements IModule
   {
      
      private static var _instance:AttackTypeModule;
      
      public static const ATTACKTYPE_ROCKET:int = 0;
      
      public static const ATTACKTYPE_LASER:int = 1;
      
      public static const ATTACKTYPE_MINE:int = 2;
      
      public static const ATTACKTYPE_RADIATION:int = 3;
      
      public static const ATTACKTYPE_PLASMA:int = 4;
      
      public static const ATTACKTYPE_ECI:int = 5;
      
      public static const ATTACKTYPE_SL:int = 6;
      
      public static const ATTACKTYPE_CID:int = 7;
      
      public static const ATTACKTYPE_SINGULARITY:int = 8;
      
      public static const ATTACKTYPE_KAMIKAZE:int = 9;
      
      public static const ATTACKTYPE_REPAIR:int = 10;
      
      public static const ATTACKTYPE_DECELERATION:int = 11;
      
      public static const ATTACKTYPE_SHIELD_ABSORBER_ROCKET_CREDITS:int = 12;
      
      public static const ATTACKTYPE_SHIELD_ABSORBER_ROCKET_URIDIUM:int = 13;
      
      public static const ATTACKTYPE_STICKY_BOMB:int = 14;
      
      public static const ATTACKTYPE_POLARITY:int = 15;
      
      public static const ATTACKTYPE_INCINERATE:int = 16;
      
      public static const ATTACKTYPE_SPREAD:int = 17;
      
      public static const ATTACKTYPE_SLOW_AND_BLIND_ATTACK:int = 18;
      
      public static const ATTACKTYPE_HEAT_RELEASE:int = 19;
      
      public static const ATTACKTYPE_MULTIPLE_ROCKET:int = 20;
      
      public static const ATTACKTYPE_CANNON:int = 21;
      
      public static const ATTACKTYPE_DRIVE:int = 22;
      
      public static const ATTACKTYPE__MAX:int = 23;
      
      public var attackTypeValue:int = 0;
      
      public function AttackTypeModule(param1:int = 0)
      {
         super();
         this.attackTypeValue = param1;
      }
      
      public static function get instance() : AttackTypeModule
      {
         return _instance || (_instance = new AttackTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attackTypeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27);
         param1.writeShort(this.attackTypeValue);
      }
   }
}

