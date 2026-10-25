package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipPetView implements IModule
   {
      
      private static var _instance:HangarShipPetView;
      
      public var petHeatSlotPrice:int = 0;
      
      public var maxGearSlots:int = 0;
      
      public var petGearsSlotPrice:int = 0;
      
      public var rootId:String = "";
      
      public var petProtocolsSlotPrice:int = 0;
      
      public var maxFuel:int = 0;
      
      public var maxLaserSlots:int = 0;
      
      public var petRenamePrice:int = 0;
      
      public var maxHeatSlots:int = 0;
      
      public var expNextLevel:Number = 0;
      
      public var shieldGenerators:int = 0;
      
      public var fuel:int = 0;
      
      public var hitPoints:Number = 0;
      
      public var petGeneratorsSlotPrice:int = 0;
      
      public var petLasersSlotPrice:int = 0;
      
      public var exp:Number = 0;
      
      public var maxHitPoints:Number = 0;
      
      public var damageDistribution:int = 0;
      
      public var level:int = 0;
      
      public var maxDamageDistribution:int = 0;
      
      public var maxProtocolSlots:int = 0;
      
      public var lasers:int = 0;
      
      public var maxGeneratorSlots:int = 0;
      
      public var name:String = "";
      
      public var maxLasers:int = 0;
      
      public function HangarShipPetView(param1:String = "", param2:String = "", param3:int = 0, param4:int = 0, param5:int = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0, param9:Number = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:int = 0, param14:int = 0, param15:int = 0, param16:int = 0, param17:int = 0, param18:int = 0, param19:int = 0, param20:int = 0, param21:int = 0, param22:int = 0, param23:int = 0, param24:int = 0, param25:int = 0)
      {
         super();
         this.petHeatSlotPrice = param25;
         this.maxGearSlots = param17;
         this.petGearsSlotPrice = param21;
         this.rootId = param2;
         this.petProtocolsSlotPrice = param24;
         this.maxFuel = param4;
         this.maxLaserSlots = param15;
         this.petRenamePrice = param20;
         this.maxHeatSlots = param19;
         this.expNextLevel = param7;
         this.shieldGenerators = param10;
         this.fuel = param3;
         this.hitPoints = param8;
         this.petGeneratorsSlotPrice = param23;
         this.petLasersSlotPrice = param22;
         this.exp = param6;
         this.maxHitPoints = param9;
         this.damageDistribution = param13;
         this.level = param5;
         this.maxDamageDistribution = param14;
         this.maxProtocolSlots = param18;
         this.lasers = param11;
         this.maxGeneratorSlots = param16;
         this.name = param1;
         this.maxLasers = param12;
      }
      
      public static function get instance() : HangarShipPetView
      {
         return _instance || (_instance = new HangarShipPetView());
      }
      
      public function getLibcomModuleId() : int
      {
         return 22866;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 112;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petHeatSlotPrice = param1.readInt();
         this.petHeatSlotPrice = this.petHeatSlotPrice << 8 % 32 | this.petHeatSlotPrice >>> 32 - 8 % 32;
         this.maxGearSlots = param1.readInt();
         this.maxGearSlots = this.maxGearSlots >>> 15 % 32 | this.maxGearSlots << 32 - 15 % 32;
         this.petGearsSlotPrice = param1.readInt();
         this.petGearsSlotPrice = this.petGearsSlotPrice >>> 14 % 32 | this.petGearsSlotPrice << 32 - 14 % 32;
         this.rootId = param1.readUTF();
         this.petProtocolsSlotPrice = param1.readInt();
         this.petProtocolsSlotPrice = this.petProtocolsSlotPrice << 4 % 32 | this.petProtocolsSlotPrice >>> 32 - 4 % 32;
         this.maxFuel = param1.readInt();
         this.maxFuel = this.maxFuel << 7 % 32 | this.maxFuel >>> 32 - 7 % 32;
         this.maxLaserSlots = param1.readInt();
         this.maxLaserSlots = this.maxLaserSlots << 4 % 32 | this.maxLaserSlots >>> 32 - 4 % 32;
         this.petRenamePrice = param1.readInt();
         this.petRenamePrice = this.petRenamePrice >>> 9 % 32 | this.petRenamePrice << 32 - 9 % 32;
         this.maxHeatSlots = param1.readInt();
         this.maxHeatSlots = this.maxHeatSlots >>> 7 % 32 | this.maxHeatSlots << 32 - 7 % 32;
         this.expNextLevel = param1.readDouble();
         this.shieldGenerators = param1.readInt();
         this.shieldGenerators = this.shieldGenerators >>> 1 % 32 | this.shieldGenerators << 32 - 1 % 32;
         this.fuel = param1.readInt();
         this.fuel = this.fuel << 2 % 32 | this.fuel >>> 32 - 2 % 32;
         this.hitPoints = param1.readDouble();
         this.petGeneratorsSlotPrice = param1.readInt();
         this.petGeneratorsSlotPrice = this.petGeneratorsSlotPrice >>> 3 % 32 | this.petGeneratorsSlotPrice << 32 - 3 % 32;
         this.petLasersSlotPrice = param1.readInt();
         this.petLasersSlotPrice = this.petLasersSlotPrice >>> 7 % 32 | this.petLasersSlotPrice << 32 - 7 % 32;
         this.exp = param1.readDouble();
         this.maxHitPoints = param1.readDouble();
         this.damageDistribution = param1.readInt();
         this.damageDistribution = this.damageDistribution >>> 12 % 32 | this.damageDistribution << 32 - 12 % 32;
         this.level = param1.readInt();
         this.level = this.level << 6 % 32 | this.level >>> 32 - 6 % 32;
         this.maxDamageDistribution = param1.readInt();
         this.maxDamageDistribution = this.maxDamageDistribution << 11 % 32 | this.maxDamageDistribution >>> 32 - 11 % 32;
         this.maxProtocolSlots = param1.readInt();
         this.maxProtocolSlots = this.maxProtocolSlots >>> 6 % 32 | this.maxProtocolSlots << 32 - 6 % 32;
         this.lasers = param1.readInt();
         this.lasers = this.lasers << 8 % 32 | this.lasers >>> 32 - 8 % 32;
         this.maxGeneratorSlots = param1.readInt();
         this.maxGeneratorSlots = this.maxGeneratorSlots << 6 % 32 | this.maxGeneratorSlots >>> 32 - 6 % 32;
         this.name = param1.readUTF();
         this.maxLasers = param1.readInt();
         this.maxLasers = this.maxLasers >>> 1 % 32 | this.maxLasers << 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(22866);
         param1.writeInt(this.petHeatSlotPrice >>> 8 % 32 | this.petHeatSlotPrice << 32 - 8 % 32);
         param1.writeInt(this.maxGearSlots << 15 % 32 | this.maxGearSlots >>> 32 - 15 % 32);
         param1.writeInt(this.petGearsSlotPrice << 14 % 32 | this.petGearsSlotPrice >>> 32 - 14 % 32);
         param1.writeUTF(this.rootId);
         param1.writeInt(this.petProtocolsSlotPrice >>> 4 % 32 | this.petProtocolsSlotPrice << 32 - 4 % 32);
         param1.writeInt(this.maxFuel >>> 7 % 32 | this.maxFuel << 32 - 7 % 32);
         param1.writeInt(this.maxLaserSlots >>> 4 % 32 | this.maxLaserSlots << 32 - 4 % 32);
         param1.writeInt(this.petRenamePrice << 9 % 32 | this.petRenamePrice >>> 32 - 9 % 32);
         param1.writeInt(this.maxHeatSlots << 7 % 32 | this.maxHeatSlots >>> 32 - 7 % 32);
         param1.writeDouble(this.expNextLevel);
         param1.writeInt(this.shieldGenerators << 1 % 32 | this.shieldGenerators >>> 32 - 1 % 32);
         param1.writeInt(this.fuel >>> 2 % 32 | this.fuel << 32 - 2 % 32);
         param1.writeDouble(this.hitPoints);
         param1.writeInt(this.petGeneratorsSlotPrice << 3 % 32 | this.petGeneratorsSlotPrice >>> 32 - 3 % 32);
         param1.writeInt(this.petLasersSlotPrice << 7 % 32 | this.petLasersSlotPrice >>> 32 - 7 % 32);
         param1.writeDouble(this.exp);
         param1.writeDouble(this.maxHitPoints);
         param1.writeInt(this.damageDistribution << 12 % 32 | this.damageDistribution >>> 32 - 12 % 32);
         param1.writeInt(this.level >>> 6 % 32 | this.level << 32 - 6 % 32);
         param1.writeInt(this.maxDamageDistribution >>> 11 % 32 | this.maxDamageDistribution << 32 - 11 % 32);
         param1.writeInt(this.maxProtocolSlots << 6 % 32 | this.maxProtocolSlots >>> 32 - 6 % 32);
         param1.writeInt(this.lasers >>> 8 % 32 | this.lasers << 32 - 8 % 32);
         param1.writeInt(this.maxGeneratorSlots >>> 6 % 32 | this.maxGeneratorSlots << 32 - 6 % 32);
         param1.writeUTF(this.name);
         param1.writeInt(this.maxLasers << 1 % 32 | this.maxLasers >>> 32 - 1 % 32);
      }
   }
}

