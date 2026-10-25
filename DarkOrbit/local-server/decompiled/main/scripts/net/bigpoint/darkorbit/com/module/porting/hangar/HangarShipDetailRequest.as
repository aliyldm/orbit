package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipDetailRequest implements IModule
   {
      
      private static var _instance:HangarShipDetailRequest;
      
      public var shipId:Number = 0;
      
      public function HangarShipDetailRequest(param1:Number = 0)
      {
         super();
         this.shipId = param1;
      }
      
      public static function get instance() : HangarShipDetailRequest
      {
         return _instance || (_instance = new HangarShipDetailRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 692;
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
         param1.writeShort(692);
         param1.writeDouble(this.shipId);
      }
   }
}

