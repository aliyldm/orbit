package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VisualModifierCommand implements IModule
   {
      
      private static var _instance:VisualModifierCommand;
      
      public static const VISUALMODIFIER_SPEED_BOOST:int = 0;
      
      public static const VISUALMODIFIER_RAPID_FIRE:int = 1;
      
      public static const VISUALMODIFIER_HOLOGRAM:int = 2;
      
      public static const VISUALMODIFIER_SCRAMBLE:int = 3;
      
      public static const VISUALMODIFIER_PHASE_OUT:int = 4;
      
      public static const VISUALMODIFIER_MIMESIS_HAS_SET:int = 5;
      
      public static const VISUALMODIFIER_TRAVEL_MODE:int = 6;
      
      public static const VISUALMODIFIER_HEALING_POD:int = 7;
      
      public static const VISUALMODIFIER_FORTIFY:int = 8;
      
      public static const VISUALMODIFIER_PROTECT_OWNER:int = 9;
      
      public static const VISUALMODIFIER_PROTECT_TARGET:int = 10;
      
      public static const VISUALMODIFIER_DRAW_FIRE_OWNER:int = 11;
      
      public static const VISUALMODIFIER_DRAW_FIRE_TARGET:int = 12;
      
      public static const VISUALMODIFIER_ULTIMATE_EMP_TARGET:int = 13;
      
      public static const VISUALMODIFIER_INACTIVE:int = 14;
      
      public static const VISUALMODIFIER_FORTRESS:int = 15;
      
      public static const VISUALMODIFIER_PRISMATIC_SHIELD:int = 16;
      
      public static const VISUALMODIFIER_PRISMATIC_REFLECTING:int = 17;
      
      public static const VISUALMODIFIER_WEAKEN_SHIELDS:int = 18;
      
      public static const VISUALMODIFIER_WEAKEN_SHIELDS_TARGET:int = 19;
      
      public static const VISUALMODIFIER_SINGULARITY:int = 20;
      
      public static const VISUALMODIFIER_SINGULARITY_TARGET:int = 21;
      
      public static const VISUALMODIFIER_SHIP_WARP:int = 22;
      
      public static const VISUALMODIFIER_NPC_INFILTRATOR:int = 23;
      
      public static const VISUALMODIFIER_LEONOV_EFFECT:int = 24;
      
      public static const VISUALMODIFIER_CHANGE_SHIP_DESIGN:int = 25;
      
      public static const VISUALMODIFIER_GHOST_EFFECT:int = 26;
      
      public static const VISUALMODIFIER_MIRRORED_CONTROLS:int = 27;
      
      public static const VISUALMODIFIER_STICKY_BOMB:int = 28;
      
      public static const VISUALMODIFIER_GREEN_GLOW:int = 29;
      
      public static const VISUALMODIFIER_RED_GLOW:int = 30;
      
      public static const VISUALMODIFIER_GENERIC_GLOW:int = 31;
      
      public static const VISUALMODIFIER_EMERGENCY_REPAIR:int = 32;
      
      public static const VISUALMODIFIER_INVINCIBILITY:int = 33;
      
      public static const VISUALMODIFIER_BATTLESTATION_DEFLECTOR:int = 34;
      
      public static const VISUALMODIFIER_BATTLESTATION_DOWNTIME_TIMER:int = 35;
      
      public static const VISUALMODIFIER_BATTLESTATION_INSTALLING:int = 36;
      
      public static const VISUALMODIFIER_BATTLESTATION_CONSTRUCTING:int = 37;
      
      public static const VISUALMODIFIER_OWNS_BATTLESTATION:int = 38;
      
      public static const VISUALMODIFIER_BUFFZONE:int = 39;
      
      public static const VISUALMODIFIER_BLOCKED_ZONE_EXPLOSION:int = 40;
      
      public static const VISUALMODIFIER_NPC_DECLOAK_ZONE:int = 41;
      
      public static const VISUALMODIFIER_LEGENDARY_NPC_NAME:int = 42;
      
      public static const VISUALMODIFIER_POLARITY_POSITIVE:int = 43;
      
      public static const VISUALMODIFIER_POLARITY_NEGATIVE:int = 44;
      
      public static const VISUALMODIFIER_POLARITY_POWERUP:int = 45;
      
      public static const VISUALMODIFIER_WARP_POWERUP:int = 46;
      
      public static const VISUALMODIFIER_STICKY_BOMB_EMPEROR:int = 47;
      
      public static const VISUALMODIFIER_EMPEROR_LORDAKIUM_SPAWN:int = 48;
      
      public static const VISUALMODIFIER_LORDAKIUM_HEAL:int = 49;
      
      public static const VISUALMODIFIER_EMPEROR_SIBELON_BUFF:int = 50;
      
      public static const VISUALMODIFIER_EMPEROR_SIBELON_DEBUFF:int = 51;
      
      public static const VISUALMODIFIER_CAMERA_DRONES:int = 52;
      
      public static const VISUALMODIFIER_ICY_ROCKET_TARGET_RED:int = 53;
      
      public static const VISUALMODIFIER_ICY_ROCKET_TARGET_BLUE:int = 54;
      
      public static const VISUALMODIFIER_SHIP_SPAWN:int = 55;
      
      public static const VISUALMODIFIER_SHIP_DESPAWN:int = 56;
      
      public static const VISUALMODIFIER_PLAGUE:int = 57;
      
      public static const VISUALMODIFIER_ARENA_CHAMPION_ICON:int = 58;
      
      public static const VISUALMODIFIER_ENERGY_LEECH_ARRAY:int = 59;
      
      public static const VISUALMODIFIER_BATTLE_REPBOT:int = 60;
      
      public static const VISUALMODIFIER_BATTLE_REPBOT2:int = 61;
      
      public static const VISUALMODIFIER_FLASHLIGHT:int = 62;
      
      public static const VISUALMODIFIER_DISRUPTION:int = 63;
      
      public static const VISUALMODIFIER_CAMERA_SHAKE:int = 64;
      
      public static const VISUALMODIFIER_OVERRIDE_SHIP_MODEL:int = 65;
      
      public static const VISUALMODIFIER_DOCKING:int = 66;
      
      public static const VISUALMODIFIER_LASERS_CHARGED:int = 67;
      
      public static const VISUALMODIFIER_FX_SHIELD:int = 68;
      
      public static const VISUALMODIFIER_MAYHEM_WINNER_SPECIAL_EFFECT:int = 69;
      
      public static const VISUALMODIFIER_MAYHEM_RAMPAGE_SPECIAL_EFFECT:int = 70;
      
      public static const VISUALMODIFIER_COUNTDOWN:int = 71;
      
      public static const VISUALMODIFIER_TIMER_COUNTDOWN:int = 72;
      
      public static const VISUALMODIFIER_EXPLOSIVE_CHARGING_BLOB:int = 73;
      
      public static const VISUALMODIFIER_PARTICLE_BEAM:int = 74;
      
      public static const VISUALMODIFIER_INVADER:int = 75;
      
      public static const VISUALMODIFIER_RED_MERCENARY:int = 76;
      
      public static const VISUALMODIFIER_BLUE_MERCENARY:int = 77;
      
      public static const VISUALMODIFIER_KILL_STREAK:int = 78;
      
      public static const VISUALMODIFIER_PVP_PROTECTION:int = 79;
      
      public static const VISUALMODIFIER_SHIELD_DISARRAY:int = 80;
      
      public static const VISUALMODIFIER_REDIRECT:int = 81;
      
      public static const VISUALMODIFIER_DISTRIBUTED_DENIAL_OF_LASER:int = 82;
      
      public static const VISUALMODIFIER_SHIELD_LINK:int = 83;
      
      public static const VISUALMODIFIER_BERSERK:int = 84;
      
      public static const VISUALMODIFIER_REVENGE:int = 85;
      
      public static const VISUALMODIFIER_HP_LINK:int = 86;
      
      public static const VISUALMODIFIER_INCINERATE:int = 87;
      
      public static const VISUALMODIFIER_VALENTINE_BUFF_GLOW:int = 88;
      
      public static const VISUALMODIFIER_SKULL:int = 89;
      
      public static const VISUALMODIFIER_COLLECTOR_BEAM:int = 90;
      
      public static const VISUALMODIFIER_HEALING_GLOW:int = 91;
      
      public static const VISUALMODIFIER_PULSING_HEALING_GLOW:int = 92;
      
      public static const VISUALMODIFIER_SPREAD:int = 93;
      
      public static const VISUALMODIFIER_CHARGESHOT:int = 94;
      
      public static const VISUALMODIFIER_SPEED_BURST:int = 95;
      
      public static const VISUALMODIFIER_ANTI_MINE_TRANSIMITTER:int = 96;
      
      public static const VISUALMODIFIER_SHIP_RED_GLOW:int = 97;
      
      public static const VISUALMODIFIER_SHIP_GREEN_GLOW:int = 98;
      
      public static const VISUALMODIFIER_ASSIMILATE:int = 99;
      
      public static const VISUALMODIFIER_EMERGENCY_RESERVES:int = 100;
      
      public static const VISUALMODIFIER_KILL_STREAK_PROMETHEUS:int = 101;
      
      public static const VISUALMODIFIER_FROST_FIELD:int = 102;
      
      public static const VISUALMODIFIER_SELF_REVERSAL:int = 103;
      
      public static const VISUALMODIFIER_ENEMY_REVERSAL:int = 104;
      
      public static const VISUALMODIFIER_PRISMATIC_ENDURANCE:int = 105;
      
      public static const VISUALMODIFIER_STOCKPILE:int = 106;
      
      public static const VISUALMODIFIER_HEAT_RELEASE:int = 107;
      
      public static const VISUALMODIFIER_JAMX_CREED_DAMAGE:int = 108;
      
      public static const VISUALMODIFIER_JAMX_CREED_REVERSAL_IMMUNITY:int = 109;
      
      public static const VISUALMODIFIER_NEUTRALIZING_TARGET:int = 110;
      
      public static const VISUALMODIFIER_VOLTAGE_LINK:int = 111;
      
      public static const VISUALMODIFIER_STUN:int = 112;
      
      public static const VISUALMODIFIER_VOLT_DISCHARGE:int = 113;
      
      public static const VISUALMODIFIER_VOLT_BACKUP:int = 114;
      
      public static const VISUALMODIFIER_EMBRACING_GLOW:int = 115;
      
      public static const VISUALMODIFIER_PULSING_RED_GLOW:int = 116;
      
      public static const VISUALMODIFIER_PAYLOAD_PROTECTION_ZONE:int = 117;
      
      public static const VISUALMODIFIER_FLUX_CRATE:int = 118;
      
      public static const VISUALMODIFIER_MIRE_CRATE:int = 119;
      
      public static const VISUALMODIFIER_MIRE_CRATE_TARGET:int = 120;
      
      public static const VISUALMODIFIER_WORLDBOSS_DAMAGING_ZONE_EFFECT:int = 121;
      
      public static const VISUALMODIFIER_WORLDBOSS_MISSILE_TELEGRAPH_EFFECT:int = 122;
      
      public static const VISUALMODIFIER_TITLE_BUFF:int = 123;
      
      public static const VISUALMODIFIER_NOXIOUS_NEBULA:int = 124;
      
      public static const VISUALMODIFIER_HEIGHTENED_VALOUR:int = 125;
      
      public static const VISUALMODIFIER_WORLDBOSS_CONTINUOUS_LASER_EFFECT:int = 126;
      
      public static const VISUALMODIFIER_SNIPED_LASER:int = 127;
      
      public static const VISUALMODIFIER_ROCKET_ATK_MINIONS:int = 128;
      
      public static const VISUALMODIFIER_M_ROCKET:int = 129;
      
      public static const VISUALMODIFIER_M_LASER:int = 130;
      
      public static const VISUALMODIFIER_RIPPER:int = 131;
      
      public static const VISUALMODIFIER_LAST_STAND:int = 132;
      
      public static const VISUALMODIFIER_BOSS_ESCAPE:int = 133;
      
      public static const VISUALMODIFIER_BOSS_LASER_PREPARATION:int = 134;
      
      public static const VISUALMODIFIER_BOSS_LASER_CHARGE:int = 135;
      
      public static const VISUALMODIFIER_BOSS_LASER_SHOT:int = 136;
      
      public static const VISUALMODIFIER_BOSS_EMP_SHOCK:int = 137;
      
      public static const VISUALMODIFIER_BOSS_ENERGY_BAY_ACTIVATE:int = 138;
      
      public static const VISUALMODIFIER_BOSS_ENERGY_BAY_EMP:int = 139;
      
      public static const VISUALMODIFIER_BOSS_ENERGY_BAY_SHIELD_LINK:int = 140;
      
      public static const VISUALMODIFIER_BOSS_LEVELED_SHIELD:int = 141;
      
      public static const VISUALMODIFIER_EXIT_AREA:int = 142;
      
      public static const VISUALMODIFIER_SPOT_LIGHT:int = 143;
      
      public static const VISUALMODIFIER_SHOW_NUMBER:int = 144;
      
      public static const VISUALMODIFIER_RAGE:int = 145;
      
      public static const VISUALMODIFIER_CANNON_SKILL_CORROSIVE:int = 146;
      
      public static const VISUALMODIFIER_CHSP_UP:int = 147;
      
      public static const VISUALMODIFIER_SPCP_UP:int = 148;
      
      public static const VISUALMODIFIER_CHSP_W_UP:int = 149;
      
      public static const VISUALMODIFIER_SPCP_W_UP:int = 150;
      
      public static const VISUALMODIFIER_DA_OUTER_ENEMY_01:int = 151;
      
      public static const VISUALMODIFIER_DA_OUTER_FRIENDLY_01:int = 152;
      
      public static const VISUALMODIFIER_DA_OUTER_ENEMY_02:int = 153;
      
      public static const VISUALMODIFIER_DA_OUTER_FRIENDLY_02:int = 154;
      
      public static const VISUALMODIFIER_DA_OUTER_ENEMY_03:int = 155;
      
      public static const VISUALMODIFIER_DA_OUTER_FRIENDLY_03:int = 156;
      
      public static const VISUALMODIFIER_GRAVITATIONAL_ANCHOR_ACTIVATE:int = 157;
      
      public static const VISUALMODIFIER__MAX:int = 158;
      
      public var userId:int = 0;
      
      public var modifier:int = 0;
      
      public var attribute:int = 0;
      
      public var additionalAttribute:String = "";
      
      public var count:int = 0;
      
      public var activated:Boolean = false;
      
      public function VisualModifierCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:int = 0, param6:Boolean = false)
      {
         super();
         this.userId = param1;
         this.modifier = param2;
         this.attribute = param3;
         this.additionalAttribute = param4;
         this.count = param5;
         this.activated = param6;
      }
      
      public static function get instance() : VisualModifierCommand
      {
         return _instance || (_instance = new VisualModifierCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 280;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId >>> 12 % 32 | this.userId << 32 - 12 % 32;
         this.modifier = param1.readShort();
         this.attribute = param1.readInt();
         this.attribute = this.attribute << 7 % 32 | this.attribute >>> 32 - 7 % 32;
         this.additionalAttribute = param1.readUTF();
         this.count = param1.readInt();
         this.count = this.count >>> 14 % 32 | this.count << 32 - 14 % 32;
         this.activated = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(280);
         param1.writeInt(this.userId << 12 % 32 | this.userId >>> 32 - 12 % 32);
         param1.writeShort(this.modifier);
         param1.writeInt(this.attribute >>> 7 % 32 | this.attribute << 32 - 7 % 32);
         param1.writeUTF(this.additionalAttribute);
         param1.writeInt(this.count << 14 % 32 | this.count >>> 32 - 14 % 32);
         param1.writeBoolean(this.activated);
      }
   }
}

