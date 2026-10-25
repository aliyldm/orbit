package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CTBBeaconReleasedCommand implements IModule
   {
      
      private static var _instance:CTBBeaconReleasedCommand;
      
      public var userId:int = 0;
      
      public var beaconId:int = 0;
      
      public function CTBBeaconReleasedCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.userId = param1;
         this.beaconId = param2;
      }
      
      public static function get instance() : CTBBeaconReleasedCommand
      {
         return _instance || (_instance = new CTBBeaconReleasedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 221;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId >>> 11 % 32 | this.userId << 32 - 11 % 32;
         this.beaconId = param1.readInt();
         this.beaconId = this.beaconId >>> 3 % 32 | this.beaconId << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(221);
         param1.writeInt(this.userId << 11 % 32 | this.userId >>> 32 - 11 % 32);
         param1.writeInt(this.beaconId << 3 % 32 | this.beaconId >>> 32 - 3 % 32);
      }
   }
}

