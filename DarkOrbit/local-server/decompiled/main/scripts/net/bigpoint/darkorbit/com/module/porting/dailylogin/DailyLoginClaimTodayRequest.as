package net.bigpoint.darkorbit.com.module.porting.dailylogin
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DailyLoginClaimTodayRequest implements IModule
   {
      
      private static var _instance:DailyLoginClaimTodayRequest;
      
      public function DailyLoginClaimTodayRequest()
      {
         super();
      }
      
      public static function get instance() : DailyLoginClaimTodayRequest
      {
         return _instance || (_instance = new DailyLoginClaimTodayRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -28303;
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
         param1.writeShort(-28303);
      }
   }
}

