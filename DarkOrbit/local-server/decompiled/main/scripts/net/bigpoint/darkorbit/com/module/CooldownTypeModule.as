package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CooldownTypeModule implements IModule
   {
      
      private static var _instance:CooldownTypeModule;
      
      public static const COOLDOWNTYPE_NONE:int = 0;
      
      public static const COOLDOWNTYPE_MINE:int = 1;
      
      public static const COOLDOWNTYPE_SMARTBOMB:int = 2;
      
      public static const COOLDOWNTYPE_INSTANT_SHIELD:int = 3;
      
      public static const COOLDOWNTYPE_ROCKET:int = 4;
      
      public static const COOLDOWNTYPE_WIZARD:int = 5;
      
      public static const COOLDOWNTYPE_PRANK:int = 6;
      
      public static const COOLDOWNTYPE_PLASMA:int = 7;
      
      public static const COOLDOWNTYPE_DECELERATION_ROCKET:int = 8;
      
      public static const COOLDOWNTYPE_ELECTRO_MAGNETIC_PULSE:int = 9;
      
      public static const COOLDOWNTYPE_RAPID_SALVO_BLAST:int = 10;
      
      public static const COOLDOWNTYPE_ROCKET_LAUNCHER:int = 11;
      
      public static const COOLDOWNTYPE_LASER_GOBAL_COOLDOWN:int = 12;
      
      public static const COOLDOWNTYPE_PETGEAR_GLOBAL_COOLDOWN:int = 13;
      
      public static const COOLDOWNTYPE_SR5_ROCKET:int = 14;
      
      public static const COOLDOWNTYPE_K300M_ROCKET:int = 15;
      
      public static const COOLDOWNTYPE_SP100X_ROCKET:int = 16;
      
      public static const COOLDOWNTYPE_AGT500_ROCKET:int = 17;
      
      public static const COOLDOWNTYPE_ENERGY_LEECH_ARRAY:int = 18;
      
      public static const COOLDOWNTYPE_ENERGY_CHAIN_IMPULSE:int = 19;
      
      public static const COOLDOWNTYPE_ROCKET_PROBABILITY_MAXIMIZER:int = 20;
      
      public static const COOLDOWNTYPE_SHIELD_BACKUP:int = 21;
      
      public static const COOLDOWNTYPE_SPEED_LEECH:int = 22;
      
      public static const COOLDOWNTYPE_BATTLE_REPAIR_BOT:int = 23;
      
      public static const COOLDOWNTYPE_ANTI_MINE_TRANSMITTER:int = 24;
      
      public static const COOLDOWNTYPE_DRAW_FIRE_ABILITY:int = 25;
      
      public static const COOLDOWNTYPE_HEALING_BEAM:int = 26;
      
      public static const COOLDOWNTYPE_ULTIMATE_CLOAK_ABILITY:int = 27;
      
      public static const COOLDOWNTYPE_SHIELD_RECHARGE:int = 28;
      
      public static const COOLDOWNTYPE_HEALING_POD:int = 29;
      
      public static const COOLDOWNTYPE_MARK_TARGET:int = 30;
      
      public static const COOLDOWNTYPE_TRAVEL_MODE:int = 31;
      
      public static const COOLDOWNTYPE_PROTECT:int = 32;
      
      public static const COOLDOWNTYPE_FORTIFY:int = 33;
      
      public static const COOLDOWNTYPE_ULTIMATE_EMP:int = 34;
      
      public static const COOLDOWNTYPE_DOUBLE_MINIMAP:int = 35;
      
      public static const COOLDOWNTYPE_INSTANT_HEAL:int = 36;
      
      public static const COOLDOWNTYPE_WEAKEN_SHIELDS:int = 37;
      
      public static const COOLDOWNTYPE_PRISMATIC_SHIELDING:int = 38;
      
      public static const COOLDOWNTYPE_FORTRESS:int = 39;
      
      public static const COOLDOWNTYPE_SINGULARITY:int = 40;
      
      public static const COOLDOWNTYPE_SPEED_BUFF:int = 41;
      
      public static const COOLDOWNTYPE_SPEED_DEBUFF:int = 42;
      
      public static const COOLDOWNTYPE_CPU_SPECIALJUMP:int = 43;
      
      public static const COOLDOWNTYPE_PET_TRADE_GEAR:int = 44;
      
      public static const COOLDOWNTYPE_PET_KAMIKAZE_GEAR:int = 45;
      
      public static const COOLDOWNTYPE_PET_COMBO_SHIP_REPAIR:int = 46;
      
      public static const COOLDOWNTYPE_DRONE_FORMATION:int = 47;
      
      public static const COOLDOWNTYPE_DEATHLOCATION_REPAIR:int = 48;
      
      public static const COOLDOWNTYPE_ICY_ROCKET:int = 49;
      
      public static const COOLDOWNTYPE_RED_CARD:int = 50;
      
      public static const COOLDOWNTYPE_CPU_PLAGUE_CURE:int = 51;
      
      public static const COOLDOWNTYPE_CPU_PEACE_AMBASSADOR:int = 52;
      
      public static const COOLDOWNTYPE_VISUAL_PERK_GHOST_EFFECT:int = 53;
      
      public static const COOLDOWNTYPE_FROZEN_PORTAL:int = 54;
      
      public static const COOLDOWNTYPE_CUBI_PORTAL:int = 55;
      
      public static const COOLDOWNTYPE_ALIEN_CPU:int = 56;
      
      public static const COOLDOWNTYPE_SPRAY:int = 57;
      
      public static const COOLDOWNTYPE_EMOTE:int = 58;
      
      public static const COOLDOWNTYPE_MINE_AGL:int = 59;
      
      public static const COOLDOWNTYPE_CANNON_GOBAL_COOLDOWN:int = 60;
      
      public static const COOLDOWNTYPE_DRIVE_GOBAL_COOLDOWN:int = 61;
      
      public static const COOLDOWNTYPE__MAX:int = 62;
      
      public var typeValue:int = 0;
      
      public function CooldownTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : CooldownTypeModule
      {
         return _instance || (_instance = new CooldownTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 92;
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
         param1.writeShort(92);
         param1.writeShort(this.typeValue);
      }
   }
}

