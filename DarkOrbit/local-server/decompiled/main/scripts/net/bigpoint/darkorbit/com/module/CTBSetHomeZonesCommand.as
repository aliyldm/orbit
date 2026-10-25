package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CTBSetHomeZonesCommand implements IModule
   {
      
      private static var _instance:CTBSetHomeZonesCommand;
      
      public var beaconId:int = 0;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public function CTBSetHomeZonesCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.beaconId = param1;
         this.x = param2;
         this.y = param3;
      }
      
      public static function get instance() : CTBSetHomeZonesCommand
      {
         return _instance || (_instance = new CTBSetHomeZonesCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 198;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.beaconId = param1.readInt();
         this.beaconId = this.beaconId >>> 8 % 32 | this.beaconId << 32 - 8 % 32;
         this.x = param1.readInt();
         this.x = this.x << 9 % 32 | this.x >>> 32 - 9 % 32;
         this.y = param1.readInt();
         this.y = this.y >>> 12 % 32 | this.y << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(198);
         param1.writeInt(this.beaconId << 8 % 32 | this.beaconId >>> 32 - 8 % 32);
         param1.writeInt(this.x >>> 9 % 32 | this.x << 32 - 9 % 32);
         param1.writeInt(this.y << 12 % 32 | this.y >>> 32 - 12 % 32);
      }
   }
}

