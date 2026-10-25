package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackHitNoLockCommand implements IModule
   {
      
      private static var _instance:AttackHitNoLockCommand;
      
      public var victimHitpoints:Number = 0;
      
      public var strike:Boolean = false;
      
      public var victimMaxShield:int = 0;
      
      public var attackerId:int = 0;
      
      public var damage:int = 0;
      
      public var attackType:AttackTypeModule;
      
      public var victimNanoHull:int = 0;
      
      public var victimId:int = 0;
      
      public var victimShield:int = 0;
      
      public var victimMaxHitpoints:Number = 0;
      
      public var victimMaxNanohull:int = 0;
      
      public var skilled:Boolean = false;
      
      public function AttackHitNoLockCommand(param1:AttackTypeModule = null, param2:int = 0, param3:int = 0, param4:Number = 0, param5:Number = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:Boolean = false, param12:Boolean = false)
      {
         super();
         this.victimHitpoints = param4;
         this.strike = param12;
         this.victimMaxShield = param7;
         this.attackerId = param2;
         this.damage = param10;
         if(param1 == null)
         {
            this.attackType = new AttackTypeModule();
         }
         else
         {
            this.attackType = param1;
         }
         this.victimNanoHull = param8;
         this.victimId = param3;
         this.victimShield = param6;
         this.victimMaxHitpoints = param5;
         this.victimMaxNanohull = param9;
         this.skilled = param11;
      }
      
      public static function get instance() : AttackHitNoLockCommand
      {
         return _instance || (_instance = new AttackHitNoLockCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1145;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 46;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.victimHitpoints = param1.readDouble();
         this.strike = param1.readBoolean();
         this.victimMaxShield = param1.readInt();
         this.victimMaxShield = this.victimMaxShield >>> 4 % 32 | this.victimMaxShield << 32 - 4 % 32;
         this.attackerId = param1.readInt();
         this.attackerId = this.attackerId << 11 % 32 | this.attackerId >>> 32 - 11 % 32;
         this.damage = param1.readInt();
         this.damage = this.damage << 6 % 32 | this.damage >>> 32 - 6 % 32;
         this.attackType = AttackTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.attackType)
         {
            this.attackType.read(param1);
         }
         this.victimNanoHull = param1.readInt();
         this.victimNanoHull = this.victimNanoHull << 4 % 32 | this.victimNanoHull >>> 32 - 4 % 32;
         this.victimId = param1.readInt();
         this.victimId = this.victimId >>> 13 % 32 | this.victimId << 32 - 13 % 32;
         this.victimShield = param1.readInt();
         this.victimShield = this.victimShield << 6 % 32 | this.victimShield >>> 32 - 6 % 32;
         this.victimMaxHitpoints = param1.readDouble();
         this.victimMaxNanohull = param1.readInt();
         this.victimMaxNanohull = this.victimMaxNanohull >>> 14 % 32 | this.victimMaxNanohull << 32 - 14 % 32;
         this.skilled = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1145);
         param1.writeDouble(this.victimHitpoints);
         param1.writeBoolean(this.strike);
         param1.writeInt(this.victimMaxShield << 4 % 32 | this.victimMaxShield >>> 32 - 4 % 32);
         param1.writeInt(this.attackerId >>> 11 % 32 | this.attackerId << 32 - 11 % 32);
         param1.writeInt(this.damage >>> 6 % 32 | this.damage << 32 - 6 % 32);
         if(null != this.attackType)
         {
            this.attackType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.victimNanoHull >>> 4 % 32 | this.victimNanoHull << 32 - 4 % 32);
         param1.writeInt(this.victimId << 13 % 32 | this.victimId >>> 32 - 13 % 32);
         param1.writeInt(this.victimShield >>> 6 % 32 | this.victimShield << 32 - 6 % 32);
         param1.writeDouble(this.victimMaxHitpoints);
         param1.writeInt(this.victimMaxNanohull << 14 % 32 | this.victimMaxNanohull >>> 32 - 14 % 32);
         param1.writeBoolean(this.skilled);
      }
   }
}

