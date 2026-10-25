package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RzoneCancelSignUpRequest implements IModule
   {
      
      private static var _instance:RzoneCancelSignUpRequest;
      
      public function RzoneCancelSignUpRequest()
      {
         super();
      }
      
      public static function get instance() : RzoneCancelSignUpRequest
      {
         return _instance || (_instance = new RzoneCancelSignUpRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15435;
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
         param1.writeShort(15435);
      }
   }
}

