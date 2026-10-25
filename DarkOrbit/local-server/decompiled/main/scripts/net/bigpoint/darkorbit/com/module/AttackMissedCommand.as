package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackMissedCommand implements IModule
   {
      
      private static var _instance:AttackMissedCommand;
      
      public var attackType:AttackTypeModule;
      
      public var targetUserId:int = 0;
      
      public var skillColorId:int = 0;
      
      public function AttackMissedCommand(param1:AttackTypeModule = null, param2:int = 0, param3:int = 0)
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
         this.targetUserId = param2;
         this.skillColorId = param3;
      }
      
      public static function get instance() : AttackMissedCommand
      {
         return _instance || (_instance = new AttackMissedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 163;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attackType = AttackTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.attackType)
         {
            this.attackType.read(param1);
         }
         this.targetUserId = param1.readInt();
         this.targetUserId = this.targetUserId >>> 2 % 32 | this.targetUserId << 32 - 2 % 32;
         this.skillColorId = param1.readInt();
         this.skillColorId = this.skillColorId >>> 9 % 32 | this.skillColorId << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(163);
         if(null != this.attackType)
         {
            this.attackType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.targetUserId << 2 % 32 | this.targetUserId >>> 32 - 2 % 32);
         param1.writeInt(this.skillColorId << 9 % 32 | this.skillColorId >>> 32 - 9 % 32);
      }
   }
}

