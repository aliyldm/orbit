package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipDestroyedCommand implements IModule
   {
      
      private static var _instance:ShipDestroyedCommand;
      
      public var destroyedUserId:int = 0;
      
      public var explosionTypeId:int = 0;
      
      public function ShipDestroyedCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.destroyedUserId = param1;
         this.explosionTypeId = param2;
      }
      
      public static function get instance() : ShipDestroyedCommand
      {
         return _instance || (_instance = new ShipDestroyedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 30;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.destroyedUserId = param1.readInt();
         this.destroyedUserId = this.destroyedUserId << 5 % 32 | this.destroyedUserId >>> 32 - 5 % 32;
         this.explosionTypeId = param1.readInt();
         this.explosionTypeId = this.explosionTypeId >>> 7 % 32 | this.explosionTypeId << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(30);
         param1.writeInt(this.destroyedUserId >>> 5 % 32 | this.destroyedUserId << 32 - 5 % 32);
         param1.writeInt(this.explosionTypeId << 7 % 32 | this.explosionTypeId >>> 32 - 7 % 32);
      }
   }
}

