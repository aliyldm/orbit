package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HellstormAttackCommand implements IModule
   {
      
      private static var _instance:HellstormAttackCommand;
      
      public var attackerId:int = 0;
      
      public var targetId:int = 0;
      
      public var hit:Boolean = false;
      
      public var currentLoad:int = 0;
      
      public var rocketType:AmmunitionTypeModule;
      
      public function HellstormAttackCommand(param1:int = 0, param2:int = 0, param3:Boolean = false, param4:int = 0, param5:AmmunitionTypeModule = null)
      {
         super();
         this.attackerId = param1;
         this.targetId = param2;
         this.hit = param3;
         this.currentLoad = param4;
         if(param5 == null)
         {
            this.rocketType = new AmmunitionTypeModule();
         }
         else
         {
            this.rocketType = param5;
         }
      }
      
      public static function get instance() : HellstormAttackCommand
      {
         return _instance || (_instance = new HellstormAttackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 287;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attackerId = param1.readInt();
         this.attackerId = this.attackerId << 2 % 32 | this.attackerId >>> 32 - 2 % 32;
         this.targetId = param1.readInt();
         this.targetId = this.targetId >>> 16 % 32 | this.targetId << 32 - 16 % 32;
         this.hit = param1.readBoolean();
         this.currentLoad = param1.readInt();
         this.currentLoad = this.currentLoad >>> 1 % 32 | this.currentLoad << 32 - 1 % 32;
         this.rocketType = AmmunitionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rocketType)
         {
            this.rocketType.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(287);
         param1.writeInt(this.attackerId >>> 2 % 32 | this.attackerId << 32 - 2 % 32);
         param1.writeInt(this.targetId << 16 % 32 | this.targetId >>> 32 - 16 % 32);
         param1.writeBoolean(this.hit);
         param1.writeInt(this.currentLoad << 1 % 32 | this.currentLoad >>> 32 - 1 % 32);
         if(null != this.rocketType)
         {
            this.rocketType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

