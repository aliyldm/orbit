package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MonthlyDeluxeClaimRequest implements IModule
   {
      
      private static var _instance:MonthlyDeluxeClaimRequest;
      
      public function MonthlyDeluxeClaimRequest()
      {
         super();
      }
      
      public static function get instance() : MonthlyDeluxeClaimRequest
      {
         return _instance || (_instance = new MonthlyDeluxeClaimRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19242;
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
         param1.writeShort(19242);
      }
   }
}

