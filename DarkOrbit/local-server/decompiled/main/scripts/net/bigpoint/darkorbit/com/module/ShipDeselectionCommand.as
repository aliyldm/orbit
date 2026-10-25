package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipDeselectionCommand implements IModule
   {
      
      private static var _instance:ShipDeselectionCommand;
      
      public function ShipDeselectionCommand()
      {
         super();
      }
      
      public static function get instance() : ShipDeselectionCommand
      {
         return _instance || (_instance = new ShipDeselectionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17;
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
         param1.writeShort(17);
      }
   }
}

