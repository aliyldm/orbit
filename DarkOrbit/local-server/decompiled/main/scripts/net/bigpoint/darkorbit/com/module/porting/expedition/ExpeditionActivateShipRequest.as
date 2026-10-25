package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionActivateShipRequest implements IModule
   {
      
      private static var _instance:ExpeditionActivateShipRequest;
      
      public var hangarId:Number = 0;
      
      public function ExpeditionActivateShipRequest(param1:Number = 0)
      {
         super();
         this.hangarId = param1;
      }
      
      public static function get instance() : ExpeditionActivateShipRequest
      {
         return _instance || (_instance = new ExpeditionActivateShipRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -21218;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hangarId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-21218);
         param1.writeDouble(this.hangarId);
      }
   }
}

