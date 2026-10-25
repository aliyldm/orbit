package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackAbortLaserRequest implements IModule
   {
      
      private static var _instance:AttackAbortLaserRequest;
      
      public function AttackAbortLaserRequest()
      {
         super();
      }
      
      public static function get instance() : AttackAbortLaserRequest
      {
         return _instance || (_instance = new AttackAbortLaserRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25;
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
         param1.writeShort(25);
      }
   }
}

