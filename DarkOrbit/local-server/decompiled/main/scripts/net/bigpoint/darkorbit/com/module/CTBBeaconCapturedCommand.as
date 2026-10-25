package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CTBBeaconCapturedCommand implements IModule
   {
      
      private static var _instance:CTBBeaconCapturedCommand;
      
      public var userId:int = 0;
      
      public var beaconId:int = 0;
      
      public function CTBBeaconCapturedCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.userId = param1;
         this.beaconId = param2;
      }
      
      public static function get instance() : CTBBeaconCapturedCommand
      {
         return _instance || (_instance = new CTBBeaconCapturedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 220;
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
         this.beaconId = this.beaconId << 13 % 32 | this.beaconId >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(220);
         param1.writeInt(this.userId << 11 % 32 | this.userId >>> 32 - 11 % 32);
         param1.writeInt(this.beaconId >>> 13 % 32 | this.beaconId << 32 - 13 % 32);
      }
   }
}

