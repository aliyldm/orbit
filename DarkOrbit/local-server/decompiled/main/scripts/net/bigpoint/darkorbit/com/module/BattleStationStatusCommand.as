package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationStatusCommand implements IModule
   {
      
      private static var _instance:BattleStationStatusCommand;
      
      public var mapAssetId:int = 0;
      
      public var battleStationId:int = 0;
      
      public var battleStationName:String = "";
      
      public var deflectorShieldActive:Boolean = false;
      
      public var deflectorShieldSeconds:int = 0;
      
      public var deflectorShieldSecondsMax:int = 0;
      
      public var attackRating:int = 0;
      
      public var defenceRating:int = 0;
      
      public var repairRating:int = 0;
      
      public var honorBoosterRating:int = 0;
      
      public var experienceBoosterRating:int = 0;
      
      public var damageBoosterRating:int = 0;
      
      public var deflectorShieldRate:int = 0;
      
      public var repairPrice:int = 0;
      
      public var equipment:EquippedModulesModule;
      
      public var isOreTradeAvailable:Boolean = false;
      
      public function BattleStationStatusCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:Boolean = false, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:int = 0, param14:int = 0, param15:EquippedModulesModule = null, param16:Boolean = false)
      {
         super();
         this.mapAssetId = param1;
         this.battleStationId = param2;
         this.battleStationName = param3;
         this.deflectorShieldActive = param4;
         this.deflectorShieldSeconds = param5;
         this.deflectorShieldSecondsMax = param6;
         this.attackRating = param7;
         this.defenceRating = param8;
         this.repairRating = param9;
         this.honorBoosterRating = param10;
         this.experienceBoosterRating = param11;
         this.damageBoosterRating = param12;
         this.deflectorShieldRate = param13;
         this.repairPrice = param14;
         if(param15 == null)
         {
            this.equipment = new EquippedModulesModule();
         }
         else
         {
            this.equipment = param15;
         }
         this.isOreTradeAvailable = param16;
      }
      
      public static function get instance() : BattleStationStatusCommand
      {
         return _instance || (_instance = new BattleStationStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6005;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 52;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapAssetId = param1.readInt();
         this.mapAssetId = this.mapAssetId >>> 11 % 32 | this.mapAssetId << 32 - 11 % 32;
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId >>> 1 % 32 | this.battleStationId << 32 - 1 % 32;
         this.battleStationName = param1.readUTF();
         this.deflectorShieldActive = param1.readBoolean();
         this.deflectorShieldSeconds = param1.readInt();
         this.deflectorShieldSeconds = this.deflectorShieldSeconds >>> 12 % 32 | this.deflectorShieldSeconds << 32 - 12 % 32;
         this.deflectorShieldSecondsMax = param1.readInt();
         this.deflectorShieldSecondsMax = this.deflectorShieldSecondsMax >>> 11 % 32 | this.deflectorShieldSecondsMax << 32 - 11 % 32;
         this.attackRating = param1.readInt();
         this.attackRating = this.attackRating << 7 % 32 | this.attackRating >>> 32 - 7 % 32;
         this.defenceRating = param1.readInt();
         this.defenceRating = this.defenceRating << 7 % 32 | this.defenceRating >>> 32 - 7 % 32;
         this.repairRating = param1.readInt();
         this.repairRating = this.repairRating >>> 1 % 32 | this.repairRating << 32 - 1 % 32;
         this.honorBoosterRating = param1.readInt();
         this.honorBoosterRating = this.honorBoosterRating >>> 7 % 32 | this.honorBoosterRating << 32 - 7 % 32;
         this.experienceBoosterRating = param1.readInt();
         this.experienceBoosterRating = this.experienceBoosterRating >>> 16 % 32 | this.experienceBoosterRating << 32 - 16 % 32;
         this.damageBoosterRating = param1.readInt();
         this.damageBoosterRating = this.damageBoosterRating << 3 % 32 | this.damageBoosterRating >>> 32 - 3 % 32;
         this.deflectorShieldRate = param1.readInt();
         this.deflectorShieldRate = this.deflectorShieldRate << 16 % 32 | this.deflectorShieldRate >>> 32 - 16 % 32;
         this.repairPrice = param1.readInt();
         this.repairPrice = this.repairPrice >>> 8 % 32 | this.repairPrice << 32 - 8 % 32;
         this.equipment = EquippedModulesModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.equipment)
         {
            this.equipment.read(param1);
         }
         this.isOreTradeAvailable = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6005);
         param1.writeInt(this.mapAssetId << 11 % 32 | this.mapAssetId >>> 32 - 11 % 32);
         param1.writeInt(this.battleStationId << 1 % 32 | this.battleStationId >>> 32 - 1 % 32);
         param1.writeUTF(this.battleStationName);
         param1.writeBoolean(this.deflectorShieldActive);
         param1.writeInt(this.deflectorShieldSeconds << 12 % 32 | this.deflectorShieldSeconds >>> 32 - 12 % 32);
         param1.writeInt(this.deflectorShieldSecondsMax << 11 % 32 | this.deflectorShieldSecondsMax >>> 32 - 11 % 32);
         param1.writeInt(this.attackRating >>> 7 % 32 | this.attackRating << 32 - 7 % 32);
         param1.writeInt(this.defenceRating >>> 7 % 32 | this.defenceRating << 32 - 7 % 32);
         param1.writeInt(this.repairRating << 1 % 32 | this.repairRating >>> 32 - 1 % 32);
         param1.writeInt(this.honorBoosterRating << 7 % 32 | this.honorBoosterRating >>> 32 - 7 % 32);
         param1.writeInt(this.experienceBoosterRating << 16 % 32 | this.experienceBoosterRating >>> 32 - 16 % 32);
         param1.writeInt(this.damageBoosterRating >>> 3 % 32 | this.damageBoosterRating << 32 - 3 % 32);
         param1.writeInt(this.deflectorShieldRate >>> 16 % 32 | this.deflectorShieldRate << 32 - 16 % 32);
         param1.writeInt(this.repairPrice << 8 % 32 | this.repairPrice >>> 32 - 8 % 32);
         if(null != this.equipment)
         {
            this.equipment.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.isOreTradeAvailable);
      }
   }
}

