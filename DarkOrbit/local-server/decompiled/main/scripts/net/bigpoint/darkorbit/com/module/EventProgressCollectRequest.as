package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventProgressCollectRequest implements IModule
   {
      
      private static var _instance:EventProgressCollectRequest;
      
      public function EventProgressCollectRequest()
      {
         super();
      }
      
      public static function get instance() : EventProgressCollectRequest
      {
         return _instance || (_instance = new EventProgressCollectRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29981;
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
         param1.writeShort(-29981);
      }
   }
}

