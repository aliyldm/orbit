package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WarGameExitRequest implements IModule
   {
      
      private static var _instance:WarGameExitRequest;
      
      public function WarGameExitRequest()
      {
         super();
      }
      
      public static function get instance() : WarGameExitRequest
      {
         return _instance || (_instance = new WarGameExitRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4519;
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
         param1.writeShort(4519);
      }
   }
}

