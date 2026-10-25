package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventSetShipAttackableCommand implements IModule
   {
      
      private static var _instance:MapEventSetShipAttackableCommand;
      
      public var userId:int = 0;
      
      public var isAttackable:Boolean = false;
      
      public function MapEventSetShipAttackableCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.userId = param1;
         this.isAttackable = param2;
      }
      
      public static function get instance() : MapEventSetShipAttackableCommand
      {
         return _instance || (_instance = new MapEventSetShipAttackableCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 189;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId << 7 % 32 | this.userId >>> 32 - 7 % 32;
         this.isAttackable = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(189);
         param1.writeInt(this.userId >>> 7 % 32 | this.userId << 32 - 7 % 32);
         param1.writeBoolean(this.isAttackable);
      }
   }
}

