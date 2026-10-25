package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventProgressResetRequest implements IModule
   {
      
      private static var _instance:EventProgressResetRequest;
      
      public function EventProgressResetRequest()
      {
         super();
      }
      
      public static function get instance() : EventProgressResetRequest
      {
         return _instance || (_instance = new EventProgressResetRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 32321;
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
         param1.writeShort(32321);
      }
   }
}

