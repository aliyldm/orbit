package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackHitCommand implements IModule
   {
      
      private static var _instance:AttackHitCommand;
      
      public var attackType:AttackTypeModule;
      
      public var attackerId:int = 0;
      
      public var victimId:int = 0;
      
      public var victimHitpoints:Number = 0;
      
      public var victimShield:int = 0;
      
      public var victimNanoHull:int = 0;
      
      public var damage:int = 0;
      
      public var skilled:Boolean = false;
      
      public var strike:Boolean = false;
      
      public var cannonType:int = 0;
      
      public function AttackHitCommand(param1:AttackTypeModule = null, param2:int = 0, param3:int = 0, param4:Number = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:Boolean = false, param9:Boolean = false, param10:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.attackType = new AttackTypeModule();
         }
         else
         {
            this.attackType = param1;
         }
         this.attackerId = param2;
         this.victimId = param3;
         this.victimHitpoints = param4;
         this.victimShield = param5;
         this.victimNanoHull = param6;
         this.damage = param7;
         this.skilled = param8;
         this.strike = param9;
         this.cannonType = param10;
      }
      
      public static function get instance() : AttackHitCommand
      {
         return _instance || (_instance = new AttackHitCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 30;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attackType = AttackTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.attackType)
         {
            this.attackType.read(param1);
         }
         this.attackerId = param1.readInt();
         this.attackerId = this.attackerId << 7 % 32 | this.attackerId >>> 32 - 7 % 32;
         this.victimId = param1.readInt();
         this.victimId = this.victimId >>> 3 % 32 | this.victimId << 32 - 3 % 32;
         this.victimHitpoints = param1.readDouble();
         this.victimShield = param1.readInt();
         this.victimShield = this.victimShield << 13 % 32 | this.victimShield >>> 32 - 13 % 32;
         this.victimNanoHull = param1.readInt();
         this.victimNanoHull = this.victimNanoHull >>> 8 % 32 | this.victimNanoHull << 32 - 8 % 32;
         this.damage = param1.readInt();
         this.damage = this.damage >>> 8 % 32 | this.damage << 32 - 8 % 32;
         this.skilled = param1.readBoolean();
         this.strike = param1.readBoolean();
         this.cannonType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(28);
         if(null != this.attackType)
         {
            this.attackType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.attackerId >>> 7 % 32 | this.attackerId << 32 - 7 % 32);
         param1.writeInt(this.victimId << 3 % 32 | this.victimId >>> 32 - 3 % 32);
         param1.writeDouble(this.victimHitpoints);
         param1.writeInt(this.victimShield >>> 13 % 32 | this.victimShield << 32 - 13 % 32);
         param1.writeInt(this.victimNanoHull << 8 % 32 | this.victimNanoHull >>> 32 - 8 % 32);
         param1.writeInt(this.damage << 8 % 32 | this.damage >>> 32 - 8 % 32);
         param1.writeBoolean(this.skilled);
         param1.writeBoolean(this.strike);
         param1.writeShort(this.cannonType);
      }
   }
}

