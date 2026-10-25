package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlMatchLeaveQueueRequest implements IModule
   {
      
      private static var _instance:SectorControlMatchLeaveQueueRequest;
      
      public function SectorControlMatchLeaveQueueRequest()
      {
         super();
      }
      
      public static function get instance() : SectorControlMatchLeaveQueueRequest
      {
         return _instance || (_instance = new SectorControlMatchLeaveQueueRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5255;
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
         param1.writeShort(5255);
      }
   }
}

