package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RzoneSignUpRequest implements IModule
   {
      
      private static var _instance:RzoneSignUpRequest;
      
      public function RzoneSignUpRequest()
      {
         super();
      }
      
      public static function get instance() : RzoneSignUpRequest
      {
         return _instance || (_instance = new RzoneSignUpRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10716;
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
         param1.writeShort(10716);
      }
   }
}

