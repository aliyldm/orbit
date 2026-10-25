package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipSpawnChildSwarmCommand implements IModule
   {
      
      private static var _instance:ShipSpawnChildSwarmCommand;
      
      public var motherShipId:int = 0;
      
      public function ShipSpawnChildSwarmCommand(param1:int = 0)
      {
         super();
         this.motherShipId = param1;
      }
      
      public static function get instance() : ShipSpawnChildSwarmCommand
      {
         return _instance || (_instance = new ShipSpawnChildSwarmCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 182;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.motherShipId = param1.readInt();
         this.motherShipId = this.motherShipId << 15 % 32 | this.motherShipId >>> 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(182);
         param1.writeInt(this.motherShipId >>> 15 % 32 | this.motherShipId << 32 - 15 % 32);
      }
   }
}

