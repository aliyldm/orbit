package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KillUiInfoMessageCommand implements IModule
   {
      
      private static var _instance:KillUiInfoMessageCommand;
      
      public var currentNpcKills:int = 0;
      
      public var killNpcId:int = 0;
      
      public var currentNpcOnMap:int = 0;
      
      public var maxNpcAmountForMap:int = 0;
      
      public var spawnNpcId:int = 0;
      
      public var mapId:int = 0;
      
      public function KillUiInfoMessageCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0)
      {
         super();
         this.currentNpcKills = param6;
         this.killNpcId = param2;
         this.currentNpcOnMap = param4;
         this.maxNpcAmountForMap = param5;
         this.spawnNpcId = param3;
         this.mapId = param1;
      }
      
      public static function get instance() : KillUiInfoMessageCommand
      {
         return _instance || (_instance = new KillUiInfoMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9790;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currentNpcKills = param1.readInt();
         this.currentNpcKills = this.currentNpcKills >>> 11 % 32 | this.currentNpcKills << 32 - 11 % 32;
         this.killNpcId = param1.readInt();
         this.killNpcId = this.killNpcId >>> 13 % 32 | this.killNpcId << 32 - 13 % 32;
         this.currentNpcOnMap = param1.readInt();
         this.currentNpcOnMap = this.currentNpcOnMap << 1 % 32 | this.currentNpcOnMap >>> 32 - 1 % 32;
         this.maxNpcAmountForMap = param1.readInt();
         this.maxNpcAmountForMap = this.maxNpcAmountForMap << 4 % 32 | this.maxNpcAmountForMap >>> 32 - 4 % 32;
         this.spawnNpcId = param1.readInt();
         this.spawnNpcId = this.spawnNpcId << 13 % 32 | this.spawnNpcId >>> 32 - 13 % 32;
         this.mapId = param1.readInt();
         this.mapId = this.mapId << 14 % 32 | this.mapId >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9790);
         param1.writeInt(this.currentNpcKills << 11 % 32 | this.currentNpcKills >>> 32 - 11 % 32);
         param1.writeInt(this.killNpcId << 13 % 32 | this.killNpcId >>> 32 - 13 % 32);
         param1.writeInt(this.currentNpcOnMap >>> 1 % 32 | this.currentNpcOnMap << 32 - 1 % 32);
         param1.writeInt(this.maxNpcAmountForMap >>> 4 % 32 | this.maxNpcAmountForMap << 32 - 4 % 32);
         param1.writeInt(this.spawnNpcId >>> 13 % 32 | this.spawnNpcId << 32 - 13 % 32);
         param1.writeInt(this.mapId >>> 14 % 32 | this.mapId << 32 - 14 % 32);
      }
   }
}

