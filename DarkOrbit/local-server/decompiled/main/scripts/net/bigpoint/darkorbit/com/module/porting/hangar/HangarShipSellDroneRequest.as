package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipSellDroneRequest implements IModule
   {
      
      private static var _instance:HangarShipSellDroneRequest;
      
      public var droneId:Number = 0;
      
      public function HangarShipSellDroneRequest(param1:Number = 0)
      {
         super();
         this.droneId = param1;
      }
      
      public static function get instance() : HangarShipSellDroneRequest
      {
         return _instance || (_instance = new HangarShipSellDroneRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8898;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.droneId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8898);
         param1.writeDouble(this.droneId);
      }
   }
}

