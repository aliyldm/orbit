package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LeaveClanRequest implements IModule
   {
      
      private static var _instance:LeaveClanRequest;
      
      public function LeaveClanRequest()
      {
         super();
      }
      
      public static function get instance() : LeaveClanRequest
      {
         return _instance || (_instance = new LeaveClanRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -25070;
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
         param1.writeShort(-25070);
      }
   }
}

