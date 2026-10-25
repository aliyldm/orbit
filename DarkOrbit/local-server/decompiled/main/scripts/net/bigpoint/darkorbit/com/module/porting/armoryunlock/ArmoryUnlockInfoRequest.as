package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArmoryUnlockInfoRequest implements IModule
   {
      
      private static var _instance:ArmoryUnlockInfoRequest;
      
      public function ArmoryUnlockInfoRequest()
      {
         super();
      }
      
      public static function get instance() : ArmoryUnlockInfoRequest
      {
         return _instance || (_instance = new ArmoryUnlockInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15247;
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
         param1.writeShort(15247);
      }
   }
}

