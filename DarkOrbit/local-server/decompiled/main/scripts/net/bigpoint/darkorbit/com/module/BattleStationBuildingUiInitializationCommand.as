package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationBuildingUiInitializationCommand implements IModule
   {
      
      private static var _instance:BattleStationBuildingUiInitializationCommand;
      
      public var mapAssetId:int = 0;
      
      public var battleStationId:int = 0;
      
      public var battleStationName:String = "";
      
      public var progress:AsteroidProgressCommand;
      
      public var availableModules:AvailableModulesCommand;
      
      public var buildTimeInMinutesMin:int = 0;
      
      public var buildTimeInMinutesMax:int = 0;
      
      public var buildTimeInMinutesIncrement:int = 0;
      
      public function BattleStationBuildingUiInitializationCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:AsteroidProgressCommand = null, param5:AvailableModulesCommand = null, param6:int = 0, param7:int = 0, param8:int = 0)
      {
         super();
         this.mapAssetId = param1;
         this.battleStationId = param2;
         this.battleStationName = param3;
         if(param4 == null)
         {
            this.progress = new AsteroidProgressCommand();
         }
         else
         {
            this.progress = param4;
         }
         if(param5 == null)
         {
            this.availableModules = new AvailableModulesCommand();
         }
         else
         {
            this.availableModules = param5;
         }
         this.buildTimeInMinutesMin = param6;
         this.buildTimeInMinutesMax = param7;
         this.buildTimeInMinutesIncrement = param8;
      }
      
      public static function get instance() : BattleStationBuildingUiInitializationCommand
      {
         return _instance || (_instance = new BattleStationBuildingUiInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6016;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapAssetId = param1.readInt();
         this.mapAssetId = this.mapAssetId << 4 % 32 | this.mapAssetId >>> 32 - 4 % 32;
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId << 14 % 32 | this.battleStationId >>> 32 - 14 % 32;
         this.battleStationName = param1.readUTF();
         this.progress = AsteroidProgressCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.progress)
         {
            this.progress.read(param1);
         }
         this.availableModules = AvailableModulesCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.availableModules)
         {
            this.availableModules.read(param1);
         }
         this.buildTimeInMinutesMin = param1.readInt();
         this.buildTimeInMinutesMin = this.buildTimeInMinutesMin >>> 1 % 32 | this.buildTimeInMinutesMin << 32 - 1 % 32;
         this.buildTimeInMinutesMax = param1.readInt();
         this.buildTimeInMinutesMax = this.buildTimeInMinutesMax >>> 5 % 32 | this.buildTimeInMinutesMax << 32 - 5 % 32;
         this.buildTimeInMinutesIncrement = param1.readInt();
         this.buildTimeInMinutesIncrement = this.buildTimeInMinutesIncrement >>> 10 % 32 | this.buildTimeInMinutesIncrement << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6016);
         param1.writeInt(this.mapAssetId >>> 4 % 32 | this.mapAssetId << 32 - 4 % 32);
         param1.writeInt(this.battleStationId >>> 14 % 32 | this.battleStationId << 32 - 14 % 32);
         param1.writeUTF(this.battleStationName);
         if(null != this.progress)
         {
            this.progress.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.availableModules)
         {
            this.availableModules.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.buildTimeInMinutesMin << 1 % 32 | this.buildTimeInMinutesMin >>> 32 - 1 % 32);
         param1.writeInt(this.buildTimeInMinutesMax << 5 % 32 | this.buildTimeInMinutesMax >>> 32 - 5 % 32);
         param1.writeInt(this.buildTimeInMinutesIncrement << 10 % 32 | this.buildTimeInMinutesIncrement >>> 32 - 10 % 32);
      }
   }
}

