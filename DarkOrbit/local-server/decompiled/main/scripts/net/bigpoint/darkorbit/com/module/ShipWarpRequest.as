package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipWarpRequest implements IModule
   {
      
      private static var _instance:ShipWarpRequest;
      
      public var shipId:int = 0;
      
      public function ShipWarpRequest(param1:int = 0)
      {
         super();
         this.shipId = param1;
      }
      
      public static function get instance() : ShipWarpRequest
      {
         return _instance || (_instance = new ShipWarpRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 290;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.shipId = param1.readInt();
         this.shipId = this.shipId >>> 16 % 32 | this.shipId << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(290);
         param1.writeInt(this.shipId << 16 % 32 | this.shipId >>> 32 - 16 % 32);
      }
   }
}

