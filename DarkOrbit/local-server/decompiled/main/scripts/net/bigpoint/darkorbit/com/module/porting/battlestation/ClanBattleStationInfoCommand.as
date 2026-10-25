package net.bigpoint.darkorbit.com.module.porting.battlestation
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanBattleStationInfoCommand implements IModule
   {
      
      private static var _instance:ClanBattleStationInfoCommand;
      
      public var battleStationOverviewInfoCommands:Vector.<BattleStationOverviewInfoCommand>;
      
      public var stationOwnedLongestTime:String = "";
      
      public var maxStationAtOnce:int = 0;
      
      public var destroyedStations:int = 0;
      
      public var stations:int = 0;
      
      public var allStations:int = 0;
      
      public function ClanBattleStationInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:int = 0, param6:Vector.<BattleStationOverviewInfoCommand> = null)
      {
         super();
         if(param6 == null)
         {
            this.battleStationOverviewInfoCommands = new Vector.<BattleStationOverviewInfoCommand>();
         }
         else
         {
            this.battleStationOverviewInfoCommands = param6;
         }
         this.stationOwnedLongestTime = param4;
         this.maxStationAtOnce = param3;
         this.destroyedStations = param5;
         this.stations = param1;
         this.allStations = param2;
      }
      
      public static function get instance() : ClanBattleStationInfoCommand
      {
         return _instance || (_instance = new ClanBattleStationInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13016;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:BattleStationOverviewInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.battleStationOverviewInfoCommands.length > 0)
         {
            this.battleStationOverviewInfoCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = BattleStationOverviewInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.battleStationOverviewInfoCommands.push(_loc4_);
            _loc2_++;
         }
         this.stationOwnedLongestTime = param1.readUTF();
         this.maxStationAtOnce = param1.readInt();
         this.maxStationAtOnce = this.maxStationAtOnce << 8 % 32 | this.maxStationAtOnce >>> 32 - 8 % 32;
         this.destroyedStations = param1.readInt();
         this.destroyedStations = this.destroyedStations >>> 7 % 32 | this.destroyedStations << 32 - 7 % 32;
         this.stations = param1.readInt();
         this.stations = this.stations >>> 12 % 32 | this.stations << 32 - 12 % 32;
         this.allStations = param1.readInt();
         this.allStations = this.allStations >>> 15 % 32 | this.allStations << 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:BattleStationOverviewInfoCommand = null;
         param1.writeShort(13016);
         param1.writeByte(this.battleStationOverviewInfoCommands.length);
         for each(_loc2_ in this.battleStationOverviewInfoCommands)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.stationOwnedLongestTime);
         param1.writeInt(this.maxStationAtOnce >>> 8 % 32 | this.maxStationAtOnce << 32 - 8 % 32);
         param1.writeInt(this.destroyedStations << 7 % 32 | this.destroyedStations >>> 32 - 7 % 32);
         param1.writeInt(this.stations << 12 % 32 | this.stations >>> 32 - 12 % 32);
         param1.writeInt(this.allStations << 15 % 32 | this.allStations >>> 32 - 15 % 32);
      }
   }
}

