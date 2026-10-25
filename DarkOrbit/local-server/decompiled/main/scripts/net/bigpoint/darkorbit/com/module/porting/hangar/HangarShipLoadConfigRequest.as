package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipLoadConfigRequest implements IModule
   {
      
      private static var _instance:HangarShipLoadConfigRequest;
      
      public var shipId:Number = 0;
      
      public function HangarShipLoadConfigRequest(param1:Number = 0)
      {
         super();
         this.shipId = param1;
      }
      
      public static function get instance() : HangarShipLoadConfigRequest
      {
         return _instance || (_instance = new HangarShipLoadConfigRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19090;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.shipId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(19090);
         param1.writeDouble(this.shipId);
      }
   }
}

