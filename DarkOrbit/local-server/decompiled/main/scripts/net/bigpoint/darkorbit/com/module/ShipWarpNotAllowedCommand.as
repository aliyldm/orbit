package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipWarpNotAllowedCommand implements IModule
   {
      
      private static var _instance:ShipWarpNotAllowedCommand;
      
      public function ShipWarpNotAllowedCommand()
      {
         super();
      }
      
      public static function get instance() : ShipWarpNotAllowedCommand
      {
         return _instance || (_instance = new ShipWarpNotAllowedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1002;
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
         param1.writeShort(1002);
      }
   }
}

