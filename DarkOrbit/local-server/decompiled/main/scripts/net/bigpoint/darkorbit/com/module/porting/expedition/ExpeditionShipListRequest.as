package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionShipListRequest implements IModule
   {
      
      private static var _instance:ExpeditionShipListRequest;
      
      public function ExpeditionShipListRequest()
      {
         super();
      }
      
      public static function get instance() : ExpeditionShipListRequest
      {
         return _instance || (_instance = new ExpeditionShipListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16736;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(16736);
      }
   }
}

