package net.bigpoint.darkorbit.com.module.porting.dailylogin
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DailyLoginRewardDayRequest implements IModule
   {
      
      private static var _instance:DailyLoginRewardDayRequest;
      
      public function DailyLoginRewardDayRequest()
      {
         super();
      }
      
      public static function get instance() : DailyLoginRewardDayRequest
      {
         return _instance || (_instance = new DailyLoginRewardDayRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23964;
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
         param1.writeShort(23964);
      }
   }
}

