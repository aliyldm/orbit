package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationManagementUiInitializationCommand implements IModule
   {
      
      private static var _instance:BattleStationManagementUiInitializationCommand;
      
      public var mapAssetId:int = 0;
      
      public var battleStationId:int = 0;
      
      public var battleStationName:String = "";
      
      public var clanName:String = "";
      
      public var faction:FactionModule;
      
      public var state:BattleStationStatusCommand;
      
      public var availableModules:AvailableModulesCommand;
      
      public var deflectorShieldMinutesMin:int = 0;
      
      public var deflectorShieldMinutesMax:int = 0;
      
      public var deflectorShieldMinutesIncrement:int = 0;
      
      public var deflectorDeactivationPossible:Boolean = false;
      
      public function BattleStationManagementUiInitializationCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:String = "", param5:FactionModule = null, param6:BattleStationStatusCommand = null, param7:AvailableModulesCommand = null, param8:int = 0, param9:int = 0, param10:int = 0, param11:Boolean = false)
      {
         super();
         this.mapAssetId = param1;
         this.battleStationId = param2;
         this.battleStationName = param3;
         this.clanName = param4;
         if(param5 == null)
         {
            this.faction = new FactionModule();
         }
         else
         {
            this.faction = param5;
         }
         if(param6 == null)
         {
            this.state = new BattleStationStatusCommand();
         }
         else
         {
            this.state = param6;
         }
         if(param7 == null)
         {
            this.availableModules = new AvailableModulesCommand();
         }
         else
         {
            this.availableModules = param7;
         }
         this.deflectorShieldMinutesMin = param8;
         this.deflectorShieldMinutesMax = param9;
         this.deflectorShieldMinutesIncrement = param10;
         this.deflectorDeactivationPossible = param11;
      }
      
      public static function get instance() : BattleStationManagementUiInitializationCommand
      {
         return _instance || (_instance = new BattleStationManagementUiInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6004;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 25;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapAssetId = param1.readInt();
         this.mapAssetId = this.mapAssetId << 11 % 32 | this.mapAssetId >>> 32 - 11 % 32;
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId >>> 2 % 32 | this.battleStationId << 32 - 2 % 32;
         this.battleStationName = param1.readUTF();
         this.clanName = param1.readUTF();
         this.faction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.faction)
         {
            this.faction.read(param1);
         }
         this.state = BattleStationStatusCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.state)
         {
            this.state.read(param1);
         }
         this.availableModules = AvailableModulesCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.availableModules)
         {
            this.availableModules.read(param1);
         }
         this.deflectorShieldMinutesMin = param1.readInt();
         this.deflectorShieldMinutesMin = this.deflectorShieldMinutesMin >>> 13 % 32 | this.deflectorShieldMinutesMin << 32 - 13 % 32;
         this.deflectorShieldMinutesMax = param1.readInt();
         this.deflectorShieldMinutesMax = this.deflectorShieldMinutesMax >>> 8 % 32 | this.deflectorShieldMinutesMax << 32 - 8 % 32;
         this.deflectorShieldMinutesIncrement = param1.readInt();
         this.deflectorShieldMinutesIncrement = this.deflectorShieldMinutesIncrement << 15 % 32 | this.deflectorShieldMinutesIncrement >>> 32 - 15 % 32;
         this.deflectorDeactivationPossible = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6004);
         param1.writeInt(this.mapAssetId >>> 11 % 32 | this.mapAssetId << 32 - 11 % 32);
         param1.writeInt(this.battleStationId << 2 % 32 | this.battleStationId >>> 32 - 2 % 32);
         param1.writeUTF(this.battleStationName);
         param1.writeUTF(this.clanName);
         if(null != this.faction)
         {
            this.faction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.state)
         {
            this.state.write(param1);
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
         param1.writeInt(this.deflectorShieldMinutesMin << 13 % 32 | this.deflectorShieldMinutesMin >>> 32 - 13 % 32);
         param1.writeInt(this.deflectorShieldMinutesMax << 8 % 32 | this.deflectorShieldMinutesMax >>> 32 - 8 % 32);
         param1.writeInt(this.deflectorShieldMinutesIncrement >>> 15 % 32 | this.deflectorShieldMinutesIncrement << 32 - 15 % 32);
         param1.writeBoolean(this.deflectorDeactivationPossible);
      }
   }
}

