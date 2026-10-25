package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LogoutCancelRequest implements IModule
   {
      
      private static var _instance:LogoutCancelRequest;
      
      public function LogoutCancelRequest()
      {
         super();
      }
      
      public static function get instance() : LogoutCancelRequest
      {
         return _instance || (_instance = new LogoutCancelRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15;
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
         param1.writeShort(15);
      }
   }
}

