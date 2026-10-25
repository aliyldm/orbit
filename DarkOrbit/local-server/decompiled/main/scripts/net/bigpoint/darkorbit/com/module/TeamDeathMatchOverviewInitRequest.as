package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchOverviewInitRequest implements IModule
   {
      
      private static var _instance:TeamDeathMatchOverviewInitRequest;
      
      public function TeamDeathMatchOverviewInitRequest()
      {
         super();
      }
      
      public static function get instance() : TeamDeathMatchOverviewInitRequest
      {
         return _instance || (_instance = new TeamDeathMatchOverviewInitRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1520;
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
         param1.writeShort(1520);
      }
   }
}

