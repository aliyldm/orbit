package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RzoneConfirmRequest implements IModule
   {
      
      private static var _instance:RzoneConfirmRequest;
      
      public function RzoneConfirmRequest()
      {
         super();
      }
      
      public static function get instance() : RzoneConfirmRequest
      {
         return _instance || (_instance = new RzoneConfirmRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31070;
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
         param1.writeShort(-31070);
      }
   }
}

