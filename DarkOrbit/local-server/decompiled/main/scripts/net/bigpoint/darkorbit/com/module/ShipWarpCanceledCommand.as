package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipWarpCanceledCommand implements IModule
   {
      
      private static var _instance:ShipWarpCanceledCommand;
      
      public function ShipWarpCanceledCommand()
      {
         super();
      }
      
      public static function get instance() : ShipWarpCanceledCommand
      {
         return _instance || (_instance = new ShipWarpCanceledCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1010;
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
         param1.writeShort(1010);
      }
   }
}

