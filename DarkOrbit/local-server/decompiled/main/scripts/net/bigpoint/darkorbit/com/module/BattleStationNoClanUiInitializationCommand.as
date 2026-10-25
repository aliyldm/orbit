package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattleStationNoClanUiInitializationCommand implements IModule
   {
      
      private static var _instance:BattleStationNoClanUiInitializationCommand;
      
      public var mapAssetId:int = 0;
      
      public function BattleStationNoClanUiInitializationCommand(param1:int = 0)
      {
         super();
         this.mapAssetId = param1;
      }
      
      public static function get instance() : BattleStationNoClanUiInitializationCommand
      {
         return _instance || (_instance = new BattleStationNoClanUiInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6030;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapAssetId = param1.readInt();
         this.mapAssetId = this.mapAssetId >>> 16 % 32 | this.mapAssetId << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6030);
         param1.writeInt(this.mapAssetId << 16 % 32 | this.mapAssetId >>> 32 - 16 % 32);
      }
   }
}

