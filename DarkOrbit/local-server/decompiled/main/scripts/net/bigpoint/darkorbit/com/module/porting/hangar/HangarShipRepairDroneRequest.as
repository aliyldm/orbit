package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipRepairDroneRequest implements IModule
   {
      
      private static var _instance:HangarShipRepairDroneRequest;
      
      public var shipId:Number = 0;
      
      public var droneId:int = 0;
      
      public function HangarShipRepairDroneRequest(param1:Number = 0, param2:int = 0)
      {
         super();
         this.shipId = param1;
         this.droneId = param2;
      }
      
      public static function get instance() : HangarShipRepairDroneRequest
      {
         return _instance || (_instance = new HangarShipRepairDroneRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4613;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.shipId = param1.readDouble();
         this.droneId = param1.readInt();
         this.droneId = this.droneId >>> 2 % 32 | this.droneId << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4613);
         param1.writeDouble(this.shipId);
         param1.writeInt(this.droneId << 2 % 32 | this.droneId >>> 32 - 2 % 32);
      }
   }
}

