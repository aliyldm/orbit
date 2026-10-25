package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StarmapStationInfo implements IModule
   {
      
      private static var _instance:StarmapStationInfo;
      
      public static const STATIONSTATUS_ASTEROID:int = 0;
      
      public static const STATIONSTATUS_OWN_STATION:int = 1;
      
      public static const STATIONSTATUS_NEUTRAL_STATION:int = 2;
      
      public static const STATIONSTATUS_HOSTILE_STATION:int = 3;
      
      public static const STATIONSTATUS__MAX:int = 4;
      
      public var mapId:int = 0;
      
      public var xPositionPercentage:int = 0;
      
      public var yPositionPercentage:int = 0;
      
      public var status:int = 0;
      
      public var lastChangedTimestamp:Number = 0;
      
      public var clanName:String = "";
      
      public var asteroidName:String = "";
      
      public var owningFaction:FactionModule;
      
      public function StarmapStationInfo(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Number = 0, param6:String = "", param7:String = "", param8:FactionModule = null)
      {
         super();
         this.mapId = param1;
         this.xPositionPercentage = param2;
         this.yPositionPercentage = param3;
         this.status = param4;
         this.lastChangedTimestamp = param5;
         this.clanName = param6;
         this.asteroidName = param7;
         if(param8 == null)
         {
            this.owningFaction = new FactionModule();
         }
         else
         {
            this.owningFaction = param8;
         }
      }
      
      public static function get instance() : StarmapStationInfo
      {
         return _instance || (_instance = new StarmapStationInfo());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1151;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapId = param1.readInt();
         this.mapId = this.mapId >>> 3 % 32 | this.mapId << 32 - 3 % 32;
         this.xPositionPercentage = param1.readInt();
         this.xPositionPercentage = this.xPositionPercentage >>> 7 % 32 | this.xPositionPercentage << 32 - 7 % 32;
         this.yPositionPercentage = param1.readInt();
         this.yPositionPercentage = this.yPositionPercentage << 2 % 32 | this.yPositionPercentage >>> 32 - 2 % 32;
         this.status = param1.readShort();
         this.lastChangedTimestamp = param1.readDouble();
         this.clanName = param1.readUTF();
         this.asteroidName = param1.readUTF();
         this.owningFaction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.owningFaction)
         {
            this.owningFaction.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1151);
         param1.writeInt(this.mapId << 3 % 32 | this.mapId >>> 32 - 3 % 32);
         param1.writeInt(this.xPositionPercentage << 7 % 32 | this.xPositionPercentage >>> 32 - 7 % 32);
         param1.writeInt(this.yPositionPercentage >>> 2 % 32 | this.yPositionPercentage << 32 - 2 % 32);
         param1.writeShort(this.status);
         param1.writeDouble(this.lastChangedTimestamp);
         param1.writeUTF(this.clanName);
         param1.writeUTF(this.asteroidName);
         if(null != this.owningFaction)
         {
            this.owningFaction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

