package net.bigpoint.darkorbit.com.module.porting.battlestation
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationHistoryInfoCommand implements IModule
   {
      
      private static var _instance:BattleStationHistoryInfoCommand;
      
      public var mapName:String = "";
      
      public var stationId:int = 0;
      
      public var type:String = "";
      
      public var date:String = "";
      
      public var stationName:String = "";
      
      public var opponentClanName:String = "";
      
      public var values:String = "";
      
      public var userName:String = "";
      
      public var buildSeconds:int = 0;
      
      public function BattleStationHistoryInfoCommand(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:int = 0, param6:int = 0, param7:String = "", param8:String = "", param9:String = "")
      {
         super();
         this.mapName = param8;
         this.stationId = param6;
         this.type = param3;
         this.date = param7;
         this.stationName = param9;
         this.opponentClanName = param4;
         this.values = param1;
         this.userName = param2;
         this.buildSeconds = param5;
      }
      
      public static function get instance() : BattleStationHistoryInfoCommand
      {
         return _instance || (_instance = new BattleStationHistoryInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7121;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapName = param1.readUTF();
         this.stationId = param1.readInt();
         this.stationId = this.stationId >>> 7 % 32 | this.stationId << 32 - 7 % 32;
         this.type = param1.readUTF();
         this.date = param1.readUTF();
         this.stationName = param1.readUTF();
         this.opponentClanName = param1.readUTF();
         this.values = param1.readUTF();
         this.userName = param1.readUTF();
         this.buildSeconds = param1.readInt();
         this.buildSeconds = this.buildSeconds >>> 13 % 32 | this.buildSeconds << 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7121);
         param1.writeUTF(this.mapName);
         param1.writeInt(this.stationId << 7 % 32 | this.stationId >>> 32 - 7 % 32);
         param1.writeUTF(this.type);
         param1.writeUTF(this.date);
         param1.writeUTF(this.stationName);
         param1.writeUTF(this.opponentClanName);
         param1.writeUTF(this.values);
         param1.writeUTF(this.userName);
         param1.writeInt(this.buildSeconds << 13 % 32 | this.buildSeconds >>> 32 - 13 % 32);
      }
   }
}

