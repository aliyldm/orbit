package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipWarpCompletedCommand implements IModule
   {
      
      private static var _instance:ShipWarpCompletedCommand;
      
      public var currentShipLootId:String = "";
      
      public function ShipWarpCompletedCommand(param1:String = "")
      {
         super();
         this.currentShipLootId = param1;
      }
      
      public static function get instance() : ShipWarpCompletedCommand
      {
         return _instance || (_instance = new ShipWarpCompletedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1001;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currentShipLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1001);
         param1.writeUTF(this.currentShipLootId);
      }
   }
}

