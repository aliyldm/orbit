package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchExitRequest implements IModule
   {
      
      private static var _instance:TeamDeathMatchExitRequest;
      
      public function TeamDeathMatchExitRequest()
      {
         super();
      }
      
      public static function get instance() : TeamDeathMatchExitRequest
      {
         return _instance || (_instance = new TeamDeathMatchExitRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21835;
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
         param1.writeShort(21835);
      }
   }
}

