package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WarGameLeaveQueueRequest implements IModule
   {
      
      private static var _instance:WarGameLeaveQueueRequest;
      
      public function WarGameLeaveQueueRequest()
      {
         super();
      }
      
      public static function get instance() : WarGameLeaveQueueRequest
      {
         return _instance || (_instance = new WarGameLeaveQueueRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31331;
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
         param1.writeShort(-31331);
      }
   }
}

