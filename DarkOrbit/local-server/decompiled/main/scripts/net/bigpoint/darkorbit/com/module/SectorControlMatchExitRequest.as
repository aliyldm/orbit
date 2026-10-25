package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlMatchExitRequest implements IModule
   {
      
      private static var _instance:SectorControlMatchExitRequest;
      
      public function SectorControlMatchExitRequest()
      {
         super();
      }
      
      public static function get instance() : SectorControlMatchExitRequest
      {
         return _instance || (_instance = new SectorControlMatchExitRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6521;
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
         param1.writeShort(6521);
      }
   }
}

