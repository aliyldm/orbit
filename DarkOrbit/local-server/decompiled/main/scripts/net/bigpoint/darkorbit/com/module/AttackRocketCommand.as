package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackRocketCommand implements IModule
   {
      
      private static var _instance:AttackRocketCommand;
      
      public var attackerId:int = 0;
      
      public var targetId:int = 0;
      
      public var rocketType:int = 0;
      
      public var smokeId:int = 0;
      
      public var hit:Boolean = false;
      
      public var isHeatSeeking:Boolean = false;
      
      public function AttackRocketCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this.attackerId = param1;
         this.targetId = param2;
         this.rocketType = param3;
         this.smokeId = param4;
         this.hit = param5;
         this.isHeatSeeking = param6;
      }
      
      public static function get instance() : AttackRocketCommand
      {
         return _instance || (_instance = new AttackRocketCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attackerId = param1.readInt();
         this.attackerId = this.attackerId << 16 % 32 | this.attackerId >>> 32 - 16 % 32;
         this.targetId = param1.readInt();
         this.targetId = this.targetId >>> 11 % 32 | this.targetId << 32 - 11 % 32;
         this.rocketType = param1.readInt();
         this.rocketType = this.rocketType >>> 3 % 32 | this.rocketType << 32 - 3 % 32;
         this.smokeId = param1.readInt();
         this.smokeId = this.smokeId >>> 3 % 32 | this.smokeId << 32 - 3 % 32;
         this.hit = param1.readBoolean();
         this.isHeatSeeking = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6);
         param1.writeInt(this.attackerId >>> 16 % 32 | this.attackerId << 32 - 16 % 32);
         param1.writeInt(this.targetId << 11 % 32 | this.targetId >>> 32 - 11 % 32);
         param1.writeInt(this.rocketType << 3 % 32 | this.rocketType >>> 32 - 3 % 32);
         param1.writeInt(this.smokeId << 3 % 32 | this.smokeId >>> 32 - 3 % 32);
         param1.writeBoolean(this.hit);
         param1.writeBoolean(this.isHeatSeeking);
      }
   }
}

