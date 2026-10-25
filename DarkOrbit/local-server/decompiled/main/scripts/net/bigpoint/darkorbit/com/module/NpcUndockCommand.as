package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class NpcUndockCommand implements IModule
   {
      
      private static var _instance:NpcUndockCommand;
      
      public var motherShipId:int = 0;
      
      public var minionId:int = 0;
      
      public function NpcUndockCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.motherShipId = param1;
         this.minionId = param2;
      }
      
      public static function get instance() : NpcUndockCommand
      {
         return _instance || (_instance = new NpcUndockCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11902;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.motherShipId = param1.readInt();
         this.motherShipId = this.motherShipId >>> 2 % 32 | this.motherShipId << 32 - 2 % 32;
         this.minionId = param1.readInt();
         this.minionId = this.minionId >>> 16 % 32 | this.minionId << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(11902);
         param1.writeInt(this.motherShipId << 2 % 32 | this.motherShipId >>> 32 - 2 % 32);
         param1.writeInt(this.minionId << 16 % 32 | this.minionId >>> 32 - 16 % 32);
      }
   }
}

