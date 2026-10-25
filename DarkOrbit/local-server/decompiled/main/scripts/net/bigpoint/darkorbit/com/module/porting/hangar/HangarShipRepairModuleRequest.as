package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipRepairModuleRequest implements IModule
   {
      
      private static var _instance:HangarShipRepairModuleRequest;
      
      public var itemId:Number = 0;
      
      public function HangarShipRepairModuleRequest(param1:Number = 0)
      {
         super();
         this.itemId = param1;
      }
      
      public static function get instance() : HangarShipRepairModuleRequest
      {
         return _instance || (_instance = new HangarShipRepairModuleRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7088;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7088);
         param1.writeDouble(this.itemId);
      }
   }
}

