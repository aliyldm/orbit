package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipWarpWindowCloseCommand implements IModule
   {
      
      private static var _instance:ShipWarpWindowCloseCommand;
      
      public function ShipWarpWindowCloseCommand()
      {
         super();
      }
      
      public static function get instance() : ShipWarpWindowCloseCommand
      {
         return _instance || (_instance = new ShipWarpWindowCloseCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1011;
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
         param1.writeShort(1011);
      }
   }
}

