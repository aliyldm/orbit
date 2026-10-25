package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssetTypeModule implements IModule
   {
      
      private static var _instance:AssetTypeModule;
      
      public static const ASSETTYPE_BOXTYPE_FROM_SHIP_BLOCKED:int = 0;
      
      public static const ASSETTYPE_BOXTYPE_FROM_SHIP:int = 1;
      
      public static const ASSETTYPE_BOXTYPE_BONUS_BOX:int = 2;
      
      public static const ASSETTYPE_BOXTYPE_ALIEN_EGG:int = 3;
      
      public static const ASSETTYPE_BOXTYPE_UNIQUE_COLLECTABLE:int = 4;
      
      public static const ASSETTYPE_BOXTYPE_GIANT_PUMPKIN:int = 5;
      
      public static const ASSETTYPE_BOXTYPE_MINI_PUMPKIN:int = 6;
      
      public static const ASSETTYPE_BOXTYPE_TURKEY:int = 7;
      
      public static const ASSETTYPE_BOXTYPE_STAR_BIG:int = 8;
      
      public static const ASSETTYPE_BOXTYPE_STAR_SMALL:int = 9;
      
      public static const ASSETTYPE_BOXTYPE_FLOWER:int = 10;
      
      public static const ASSETTYPE_BOXTYPE_ITALY:int = 11;
      
      public static const ASSETTYPE_BOXTYPE_FROM_SPACEBALL:int = 12;
      
      public static const ASSETTYPE_BOXTYPE_VUELTA_TSHIRT:int = 13;
      
      public static const ASSETTYPE_BOXTYPE_CRESCENT_STAR:int = 14;
      
      public static const ASSETTYPE_BOXTYPE_INDEPENDANCE_POLAND:int = 15;
      
      public static const ASSETTYPE_BOXTYPE_GIFT_BOX:int = 16;
      
      public static const ASSETTYPE_BOXTYPE_CARNIVAL:int = 17;
      
      public static const ASSETTYPE_BOXTYPE_FUELCAN:int = 18;
      
      public static const ASSETTYPE_BOXTYPE_SUMMERGAMES_2011:int = 19;
      
      public static const ASSETTYPE_BOXTYPE_PIRATE_BOOTY:int = 20;
      
      public static const ASSETTYPE_BEACON_MMO_FOR_EIC:int = 21;
      
      public static const ASSETTYPE_BEACON_MMO_FOR_VRU:int = 22;
      
      public static const ASSETTYPE_BEACON_EIC_FOR_MMO:int = 23;
      
      public static const ASSETTYPE_BEACON_EIC_FOR_VRU:int = 24;
      
      public static const ASSETTYPE_BEACON_VRU_FOR_MMO:int = 25;
      
      public static const ASSETTYPE_BEACON_VRU_FOR_EIC:int = 26;
      
      public static const ASSETTYPE_FIREWORK_SIZE_SMALL:int = 27;
      
      public static const ASSETTYPE_FIREWORK_SIZE_MEDIUM:int = 28;
      
      public static const ASSETTYPE_FIREWORK_SIZE_LARGE:int = 29;
      
      public static const ASSETTYPE_BILLBOARD_ASTEROID:int = 30;
      
      public static const ASSETTYPE_RELAY_STATION:int = 31;
      
      public static const ASSETTYPE_WRECK:int = 32;
      
      public static const ASSETTYPE_HEALING_POD:int = 33;
      
      public static const ASSETTYPE_QUESTGIVER:int = 34;
      
      public static const ASSETTYPE_ASTEROID:int = 35;
      
      public static const ASSETTYPE_BATTLESTATION:int = 36;
      
      public static const ASSETTYPE_SATELLITE:int = 37;
      
      public static const ASSETTYPE_BOOSTER_STATION:int = 38;
      
      public static const ASSETTYPE_GENERIC_SHIP:int = 39;
      
      public static const ASSETTYPE_SECTOR_CONTROL_EXIT_POINT:int = 40;
      
      public static const ASSETTYPE_SECTOR_CONTROL_SECTOR_ZONE:int = 41;
      
      public static const ASSETTYPE_SECTOR_CONTROL_BATTLEMASTER:int = 42;
      
      public static const ASSETTYPE_TEAMDEATHMATCH_BATTLEMASTER:int = 43;
      
      public static const ASSETTYPE_TEAMDEATHMATCH_EXIT_POINT:int = 44;
      
      public static const ASSETTYPE_BUFF_CAPSULE:int = 45;
      
      public static const ASSETTYPE_COMPANY_HQ_HOME:int = 46;
      
      public static const ASSETTYPE_COMPANY_HQ_OUTPOST:int = 47;
      
      public static const ASSETTYPE_HANGAR_HOME:int = 48;
      
      public static const ASSETTYPE_HANGAR_OUTPOST:int = 49;
      
      public static const ASSETTYPE_ORE_TRADE_HOME:int = 50;
      
      public static const ASSETTYPE_ORE_TRADE_OUTPOST:int = 51;
      
      public static const ASSETTYPE_ORE_TRADE_INVISIBLE:int = 52;
      
      public static const ASSETTYPE_INSTANT_REPAIR_HOME:int = 53;
      
      public static const ASSETTYPE_INSTANT_REPAIR_OUTPOST:int = 54;
      
      public static const ASSETTYPE_STATION_TURRET_SMALL_HOME:int = 55;
      
      public static const ASSETTYPE_STATION_TURRET_SMALL_OUTPOST:int = 56;
      
      public static const ASSETTYPE_STATION_TURRET_LARGE_HOME:int = 57;
      
      public static const ASSETTYPE_STATION_TURRET_LARGE_OUTPOST:int = 58;
      
      public static const ASSETTYPE_PLAGUE_EXPLODING_RANGE:int = 59;
      
      public static const ASSETTYPE_NPC_BEACON:int = 60;
      
      public static const ASSETTYPE_BURNING_TRAIL:int = 61;
      
      public static const ASSETTYPE_GOP_GENERATOR:int = 62;
      
      public static const ASSETTYPE_GOP_GENERATOR_GREEN:int = 63;
      
      public static const ASSETTYPE_GOP_GENERATOR_RED:int = 64;
      
      public static const ASSETTYPE_GOP_MINE:int = 65;
      
      public static const ASSETTYPE_WAR_GAME_BATTLEMASTER:int = 66;
      
      public static const ASSETTYPE_WAR_GAME_EXIT_POINT:int = 67;
      
      public static const ASSETTYPE_PAYLOAD_BOX_NODE:int = 68;
      
      public static const ASSETTYPE_SPRAY:int = 69;
      
      public static const ASSETTYPE_PET_MEGA_MINE:int = 70;
      
      public static const ASSETTYPE_PET_HP_BEACON:int = 71;
      
      public static const ASSETTYPE_PET_COMBAT_BEACON:int = 72;
      
      public static const ASSETTYPE_NOXIOUS_NEBULA:int = 73;
      
      public static const ASSETTYPE_EXPEDITION_HOME:int = 74;
      
      public static const ASSETTYPE__MAX:int = 75;
      
      public var typeValue:int = 0;
      
      public function AssetTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : AssetTypeModule
      {
         return _instance || (_instance = new AssetTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 146;
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
         param1.writeShort(146);
         param1.writeShort(this.typeValue);
      }
   }
}

