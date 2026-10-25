package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipBoostEventBoostInfoCommand implements IModule
   {
      
      private static var _instance:ShipBoostEventBoostInfoCommand;
      
      public var isShipBoosted:Boolean = false;
      
      public function ShipBoostEventBoostInfoCommand(param1:Boolean = false)
      {
         super();
         this.isShipBoosted = param1;
      }
      
      public static function get instance() : ShipBoostEventBoostInfoCommand
      {
         return _instance || (_instance = new ShipBoostEventBoostInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -19749;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isShipBoosted = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19749);
         param1.writeBoolean(this.isShipBoosted);
      }
   }
}

