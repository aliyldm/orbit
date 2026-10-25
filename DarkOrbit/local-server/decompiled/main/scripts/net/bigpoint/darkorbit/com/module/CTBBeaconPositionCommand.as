package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CTBBeaconPositionCommand implements IModule
   {
      
      private static var _instance:CTBBeaconPositionCommand;
      
      public var beaconId:int = 0;
      
      public var mapId:int = 0;
      
      public function CTBBeaconPositionCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.beaconId = param1;
         this.mapId = param2;
      }
      
      public static function get instance() : CTBBeaconPositionCommand
      {
         return _instance || (_instance = new CTBBeaconPositionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 222;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.beaconId = param1.readInt();
         this.beaconId = this.beaconId << 12 % 32 | this.beaconId >>> 32 - 12 % 32;
         this.mapId = param1.readInt();
         this.mapId = this.mapId << 14 % 32 | this.mapId >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(222);
         param1.writeInt(this.beaconId >>> 12 % 32 | this.beaconId << 32 - 12 % 32);
         param1.writeInt(this.mapId >>> 14 % 32 | this.mapId << 32 - 14 % 32);
      }
   }
}

