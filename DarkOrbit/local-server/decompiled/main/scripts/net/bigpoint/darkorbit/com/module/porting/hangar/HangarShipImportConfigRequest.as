package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipImportConfigRequest implements IModule
   {
      
      private static var _instance:HangarShipImportConfigRequest;
      
      public var originShipId:Number = 0;
      
      public var targetShipId:Number = 0;
      
      public function HangarShipImportConfigRequest(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.originShipId = param1;
         this.targetShipId = param2;
      }
      
      public static function get instance() : HangarShipImportConfigRequest
      {
         return _instance || (_instance = new HangarShipImportConfigRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21301;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.originShipId = param1.readDouble();
         this.targetShipId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(21301);
         param1.writeDouble(this.originShipId);
         param1.writeDouble(this.targetShipId);
      }
   }
}

