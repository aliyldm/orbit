package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class OreTypeModule implements IModule
   {
      
      private static var _instance:OreTypeModule;
      
      public static const ORETYPE_PROMETIUM:int = 0;
      
      public static const ORETYPE_ENDURIUM:int = 1;
      
      public static const ORETYPE_TERBIUM:int = 2;
      
      public static const ORETYPE_XENOMIT:int = 3;
      
      public static const ORETYPE_PROMETID:int = 4;
      
      public static const ORETYPE_DURANIUM:int = 5;
      
      public static const ORETYPE_PROMERIUM:int = 6;
      
      public static const ORETYPE_SEPROM:int = 7;
      
      public static const ORETYPE_PALLADIUM:int = 8;
      
      public static const ORETYPE_MUCOSUM:int = 9;
      
      public static const ORETYPE_BOLTRUM:int = 10;
      
      public static const ORETYPE_SCRAPIUM:int = 11;
      
      public static const ORETYPE_PRISMATIUM:int = 12;
      
      public static const ORETYPE_PROXIM:int = 13;
      
      public static const ORETYPE_DUOTHRIN:int = 14;
      
      public static const ORETYPE_TRITTOTHRIN:int = 15;
      
      public static const ORETYPE_QUADROTHRIN:int = 16;
      
      public static const ORETYPE_KYHALON:int = 17;
      
      public static const ORETYPE_TETRATHRIN:int = 18;
      
      public static const ORETYPE_BIFENON:int = 19;
      
      public static const ORETYPE_INDOCTRINEOIL:int = 20;
      
      public static const ORETYPE_HYBRID_ALLOY:int = 21;
      
      public static const ORETYPE_RINUSK:int = 22;
      
      public static const ORETYPE_BLACKLIGHT_TRACE:int = 23;
      
      public static const ORETYPE_MINDFIRE_CEREBRUM:int = 24;
      
      public static const ORETYPE_TARNOM:int = 25;
      
      public static const ORETYPE_OPITITE:int = 26;
      
      public static const ORETYPE_CHROMIN:int = 27;
      
      public static const ORETYPE_OSMIUM:int = 28;
      
      public static const ORETYPE_CANDY_CORN:int = 29;
      
      public static const ORETYPE_AXION:int = 30;
      
      public static const ORETYPE_ISOCHRONATE:int = 31;
      
      public static const ORETYPE_CHAOS_FRAGMENT:int = 32;
      
      public static const ORETYPE_CHAROPOS_SHARD:int = 33;
      
      public static const ORETYPE_STYXUS_SHARD:int = 34;
      
      public static const ORETYPE_BYTE_REMNANT:int = 35;
      
      public static const ORETYPE_AGATE_SPLINTER:int = 36;
      
      public static const ORETYPE_CHAMPION_TOKEN:int = 37;
      
      public static const ORETYPE_FLOWER_TOKEN:int = 38;
      
      public static const ORETYPE_GOLDEN_CANDY_CORN:int = 39;
      
      public static const ORETYPE_ETERNAL_FRAGMENT:int = 40;
      
      public static const ORETYPE_INDOCTRINE_ACCELERATOR:int = 41;
      
      public static const ORETYPE_GGEU:int = 42;
      
      public static const ORETYPE_HYDRA_ALLOY:int = 43;
      
      public static const ORETYPE_NEPTUNE_ALLOY:int = 44;
      
      public static const ORETYPE_TRISKELION_ALLOY:int = 45;
      
      public static const ORETYPE_PERMIT:int = 46;
      
      public static const ORETYPE_QUICKCOUPON:int = 47;
      
      public static const ORETYPE_SOLIDUS:int = 48;
      
      public static const ORETYPE_DIAMETRION:int = 49;
      
      public static const ORETYPE_POLYCHROMIUM:int = 50;
      
      public static const ORETYPE_PERMIT_PLUS:int = 51;
      
      public static const ORETYPE_LUMINIUM:int = 52;
      
      public static const ORETYPE_EVOCATION_CHIP:int = 53;
      
      public static const ORETYPE_SEASON_PASS_GOLD_VOUCHER:int = 54;
      
      public static const ORETYPE_NEU:int = 55;
      
      public static const ORETYPE_INFILTRATOR_FRAGMENT:int = 56;
      
      public static const ORETYPE_MILEAGE_COIN:int = 57;
      
      public static const ORETYPE_CALLING_CHIP:int = 58;
      
      public static const ORETYPE_STELLAR_COIN:int = 59;
      
      public static const ORETYPE_NEUTRON_SHARD:int = 60;
      
      public static const ORETYPE_ARMORY_TOKEN:int = 61;
      
      public static const ORETYPE_ARMORY_TOKEN_MEGA:int = 62;
      
      public static const ORETYPE_PULSE_CORE:int = 63;
      
      public static const ORETYPE_GALAXY_COUPON:int = 64;
      
      public static const ORETYPE_QUANTUM_PRISM:int = 65;
      
      public static const ORETYPE_TRINITY_TOKEN:int = 66;
      
      public static const ORETYPE_XYRALITH:int = 67;
      
      public static const ORETYPE_VOYAGERS_TOKEN:int = 68;
      
      public static const ORETYPE_ETHER_SHARD:int = 69;
      
      public static const ORETYPE_OUROBOROS_ALLOY:int = 70;
      
      public static const ORETYPE__MAX:int = 71;
      
      public var typeValue:int = 0;
      
      public function OreTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : OreTypeModule
      {
         return _instance || (_instance = new OreTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24450;
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
         param1.writeShort(-24450);
         param1.writeShort(this.typeValue);
      }
   }
}

