package net.bigpoint.darkorbit.com.module.porting.cannon
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CannonAttackCommand implements IModule
   {
      
      private static var _instance:CannonAttackCommand;
      
      public var cannonType:int = 0;
      
      public var hit:Boolean = false;
      
      public var attackerId:int = 0;
      
      public var attackedId:int = 0;
      
      public function CannonAttackCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:Boolean = false)
      {
         super();
         this.cannonType = param1;
         this.hit = param4;
         this.attackerId = param2;
         this.attackedId = param3;
      }
      
      public static function get instance() : CannonAttackCommand
      {
         return _instance || (_instance = new CannonAttackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14081;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.cannonType = param1.readShort();
         this.hit = param1.readBoolean();
         this.attackerId = param1.readInt();
         this.attackerId = this.attackerId >>> 7 % 32 | this.attackerId << 32 - 7 % 32;
         this.attackedId = param1.readInt();
         this.attackedId = this.attackedId >>> 10 % 32 | this.attackedId << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14081);
         param1.writeShort(this.cannonType);
         param1.writeBoolean(this.hit);
         param1.writeInt(this.attackerId << 7 % 32 | this.attackerId >>> 32 - 7 % 32);
         param1.writeInt(this.attackedId << 10 % 32 | this.attackedId >>> 32 - 10 % 32);
      }
   }
}

