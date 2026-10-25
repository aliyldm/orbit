package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackLaserRunCommand implements IModule
   {
      
      private static var _instance:AttackLaserRunCommand;
      
      public var attackerId:int = 0;
      
      public var targetId:int = 0;
      
      public var laserColor:int = 0;
      
      public var isDiminishedBySkillShield:Boolean = false;
      
      public var skilledLaser:Boolean = false;
      
      public var visualType:int = 0;
      
      public function AttackLaserRunCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:Boolean = false, param5:Boolean = false, param6:int = 0)
      {
         super();
         this.attackerId = param1;
         this.targetId = param2;
         this.laserColor = param3;
         this.isDiminishedBySkillShield = param4;
         this.skilledLaser = param5;
         this.visualType = param6;
      }
      
      public static function get instance() : AttackLaserRunCommand
      {
         return _instance || (_instance = new AttackLaserRunCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attackerId = param1.readInt();
         this.attackerId = this.attackerId >>> 2 % 32 | this.attackerId << 32 - 2 % 32;
         this.targetId = param1.readInt();
         this.targetId = this.targetId << 1 % 32 | this.targetId >>> 32 - 1 % 32;
         this.laserColor = param1.readInt();
         this.laserColor = this.laserColor >>> 16 % 32 | this.laserColor << 32 - 16 % 32;
         this.isDiminishedBySkillShield = param1.readBoolean();
         this.skilledLaser = param1.readBoolean();
         this.visualType = param1.readInt();
         this.visualType = this.visualType << 9 % 32 | this.visualType >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3);
         param1.writeInt(this.attackerId << 2 % 32 | this.attackerId >>> 32 - 2 % 32);
         param1.writeInt(this.targetId >>> 1 % 32 | this.targetId << 32 - 1 % 32);
         param1.writeInt(this.laserColor << 16 % 32 | this.laserColor >>> 32 - 16 % 32);
         param1.writeBoolean(this.isDiminishedBySkillShield);
         param1.writeBoolean(this.skilledLaser);
         param1.writeInt(this.visualType >>> 9 % 32 | this.visualType << 32 - 9 % 32);
      }
   }
}

