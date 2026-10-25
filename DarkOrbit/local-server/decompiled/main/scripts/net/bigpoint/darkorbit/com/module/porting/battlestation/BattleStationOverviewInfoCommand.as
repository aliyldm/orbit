package net.bigpoint.darkorbit.com.module.porting.battlestation
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationOverviewInfoCommand implements IModule
   {
      
      private static var _instance:BattleStationOverviewInfoCommand;
      
      public var stationName:String = "";
      
      public var xpBonus:Number = 0;
      
      public var timerCounter:int = 0;
      
      public var deflectorDownTime:int = 0;
      
      public var damageBonus:Number = 0;
      
      public var defStatus:Boolean = false;
      
      public var hasDeflectorModul:Boolean = false;
      
      public var deflectorIsActive:Boolean = false;
      
      public var deflectorTime:int = 0;
      
      public var allModuleCount:int = 0;
      
      public var mapName:String = "";
      
      public var buildCompleted:Boolean = false;
      
      public var maxAmountOfModule:int = 0;
      
      public var honourBonus:Number = 0;
      
      public var stationId:int = 0;
      
      public function BattleStationOverviewInfoCommand(param1:int = 0, param2:String = "", param3:String = "", param4:Boolean = false, param5:Boolean = false, param6:int = 0, param7:Boolean = false, param8:Boolean = false, param9:int = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:Number = 0, param14:Number = 0, param15:Number = 0)
      {
         super();
         this.stationName = param3;
         this.xpBonus = param14;
         this.timerCounter = param10;
         this.deflectorDownTime = param9;
         this.damageBonus = param15;
         this.defStatus = param7;
         this.hasDeflectorModul = param4;
         this.deflectorIsActive = param5;
         this.deflectorTime = param6;
         this.allModuleCount = param11;
         this.mapName = param2;
         this.buildCompleted = param8;
         this.maxAmountOfModule = param12;
         this.honourBonus = param13;
         this.stationId = param1;
      }
      
      public static function get instance() : BattleStationOverviewInfoCommand
      {
         return _instance || (_instance = new BattleStationOverviewInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13149;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 44;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.stationName = param1.readUTF();
         this.xpBonus = param1.readFloat();
         this.timerCounter = param1.readInt();
         this.timerCounter = this.timerCounter >>> 8 % 32 | this.timerCounter << 32 - 8 % 32;
         this.deflectorDownTime = param1.readInt();
         this.deflectorDownTime = this.deflectorDownTime << 10 % 32 | this.deflectorDownTime >>> 32 - 10 % 32;
         this.damageBonus = param1.readFloat();
         this.defStatus = param1.readBoolean();
         this.hasDeflectorModul = param1.readBoolean();
         this.deflectorIsActive = param1.readBoolean();
         this.deflectorTime = param1.readInt();
         this.deflectorTime = this.deflectorTime << 6 % 32 | this.deflectorTime >>> 32 - 6 % 32;
         this.allModuleCount = param1.readInt();
         this.allModuleCount = this.allModuleCount >>> 6 % 32 | this.allModuleCount << 32 - 6 % 32;
         this.mapName = param1.readUTF();
         this.buildCompleted = param1.readBoolean();
         this.maxAmountOfModule = param1.readInt();
         this.maxAmountOfModule = this.maxAmountOfModule >>> 10 % 32 | this.maxAmountOfModule << 32 - 10 % 32;
         this.honourBonus = param1.readFloat();
         this.stationId = param1.readInt();
         this.stationId = this.stationId >>> 2 % 32 | this.stationId << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13149);
         param1.writeUTF(this.stationName);
         param1.writeFloat(this.xpBonus);
         param1.writeInt(this.timerCounter << 8 % 32 | this.timerCounter >>> 32 - 8 % 32);
         param1.writeInt(this.deflectorDownTime >>> 10 % 32 | this.deflectorDownTime << 32 - 10 % 32);
         param1.writeFloat(this.damageBonus);
         param1.writeBoolean(this.defStatus);
         param1.writeBoolean(this.hasDeflectorModul);
         param1.writeBoolean(this.deflectorIsActive);
         param1.writeInt(this.deflectorTime >>> 6 % 32 | this.deflectorTime << 32 - 6 % 32);
         param1.writeInt(this.allModuleCount << 6 % 32 | this.allModuleCount >>> 32 - 6 % 32);
         param1.writeUTF(this.mapName);
         param1.writeBoolean(this.buildCompleted);
         param1.writeInt(this.maxAmountOfModule << 10 % 32 | this.maxAmountOfModule >>> 32 - 10 % 32);
         param1.writeFloat(this.honourBonus);
         param1.writeInt(this.stationId << 2 % 32 | this.stationId >>> 32 - 2 % 32);
      }
   }
}

