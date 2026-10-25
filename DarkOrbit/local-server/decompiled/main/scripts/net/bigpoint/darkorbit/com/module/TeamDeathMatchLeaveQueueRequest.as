package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchLeaveQueueRequest implements IModule
   {
      
      private static var _instance:TeamDeathMatchLeaveQueueRequest;
      
      public function TeamDeathMatchLeaveQueueRequest()
      {
         super();
      }
      
      public static function get instance() : TeamDeathMatchLeaveQueueRequest
      {
         return _instance || (_instance = new TeamDeathMatchLeaveQueueRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13255;
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
         param1.writeShort(13255);
      }
   }
}

