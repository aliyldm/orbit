package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationBuildingStateCommand implements IModule
   {
      
      private static var _instance:BattleStationBuildingStateCommand;
      
      public var mapAssetId:int = 0;
      
      public var battleStationId:int = 0;
      
      public var battleStationName:String = "";
      
      public var secondsLeft:int = 0;
      
      public var totalSeconds:int = 0;
      
      public var ownerClan:String = "";
      
      public var affiliatedFaction:FactionModule;
      
      public function BattleStationBuildingStateCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:int = 0, param5:int = 0, param6:String = "", param7:FactionModule = null)
      {
         super();
         this.mapAssetId = param1;
         this.battleStationId = param2;
         this.battleStationName = param3;
         this.secondsLeft = param4;
         this.totalSeconds = param5;
         this.ownerClan = param6;
         if(param7 == null)
         {
            this.affiliatedFaction = new FactionModule();
         }
         else
         {
            this.affiliatedFaction = param7;
         }
      }
      
      public static function get instance() : BattleStationBuildingStateCommand
      {
         return _instance || (_instance = new BattleStationBuildingStateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6003;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapAssetId = param1.readInt();
         this.mapAssetId = this.mapAssetId >>> 9 % 32 | this.mapAssetId << 32 - 9 % 32;
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId << 10 % 32 | this.battleStationId >>> 32 - 10 % 32;
         this.battleStationName = param1.readUTF();
         this.secondsLeft = param1.readInt();
         this.secondsLeft = this.secondsLeft >>> 16 % 32 | this.secondsLeft << 32 - 16 % 32;
         this.totalSeconds = param1.readInt();
         this.totalSeconds = this.totalSeconds >>> 10 % 32 | this.totalSeconds << 32 - 10 % 32;
         this.ownerClan = param1.readUTF();
         this.affiliatedFaction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.affiliatedFaction)
         {
            this.affiliatedFaction.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6003);
         param1.writeInt(this.mapAssetId << 9 % 32 | this.mapAssetId >>> 32 - 9 % 32);
         param1.writeInt(this.battleStationId >>> 10 % 32 | this.battleStationId << 32 - 10 % 32);
         param1.writeUTF(this.battleStationName);
         param1.writeInt(this.secondsLeft << 16 % 32 | this.secondsLeft >>> 32 - 16 % 32);
         param1.writeInt(this.totalSeconds << 10 % 32 | this.totalSeconds >>> 32 - 10 % 32);
         param1.writeUTF(this.ownerClan);
         if(null != this.affiliatedFaction)
         {
            this.affiliatedFaction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

