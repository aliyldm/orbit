package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RzoneCancelRequest implements IModule
   {
      
      private static var _instance:RzoneCancelRequest;
      
      public function RzoneCancelRequest()
      {
         super();
      }
      
      public static function get instance() : RzoneCancelRequest
      {
         return _instance || (_instance = new RzoneCancelRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27327;
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
         param1.writeShort(-27327);
      }
   }
}

