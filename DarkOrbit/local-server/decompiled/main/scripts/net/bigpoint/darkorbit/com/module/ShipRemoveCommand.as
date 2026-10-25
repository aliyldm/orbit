package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipRemoveCommand implements IModule
   {
      
      private static var _instance:ShipRemoveCommand;
      
      public var userId:int = 0;
      
      public function ShipRemoveCommand(param1:int = 0)
      {
         super();
         this.userId = param1;
      }
      
      public static function get instance() : ShipRemoveCommand
      {
         return _instance || (_instance = new ShipRemoveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 52;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId >>> 5 % 32 | this.userId << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(52);
         param1.writeInt(this.userId << 5 % 32 | this.userId >>> 32 - 5 % 32);
      }
   }
}

