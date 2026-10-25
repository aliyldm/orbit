package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ModuleStatusUpdateCommand implements IModule
   {
      
      private static var _instance:ModuleStatusUpdateCommand;
      
      public var asteroidId:int = 0;
      
      public var slotId:int = 0;
      
      public var hitpoints:int = 0;
      
      public var hitpointsMax:int = 0;
      
      public var shield:int = 0;
      
      public var shieldMax:int = 0;
      
      public var emergencyRepairSecondsLeft:int = 0;
      
      public var emergencyRepairSecondsTotal:int = 0;
      
      public function ModuleStatusUpdateCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0)
      {
         super();
         this.asteroidId = param1;
         this.slotId = param2;
         this.hitpoints = param3;
         this.hitpointsMax = param4;
         this.shield = param5;
         this.shieldMax = param6;
         this.emergencyRepairSecondsLeft = param7;
         this.emergencyRepairSecondsTotal = param8;
      }
      
      public static function get instance() : ModuleStatusUpdateCommand
      {
         return _instance || (_instance = new ModuleStatusUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7002;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 32;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.asteroidId = param1.readInt();
         this.asteroidId = this.asteroidId << 8 % 32 | this.asteroidId >>> 32 - 8 % 32;
         this.slotId = param1.readInt();
         this.slotId = this.slotId << 2 % 32 | this.slotId >>> 32 - 2 % 32;
         this.hitpoints = param1.readInt();
         this.hitpoints = this.hitpoints >>> 1 % 32 | this.hitpoints << 32 - 1 % 32;
         this.hitpointsMax = param1.readInt();
         this.hitpointsMax = this.hitpointsMax << 12 % 32 | this.hitpointsMax >>> 32 - 12 % 32;
         this.shield = param1.readInt();
         this.shield = this.shield << 7 % 32 | this.shield >>> 32 - 7 % 32;
         this.shieldMax = param1.readInt();
         this.shieldMax = this.shieldMax >>> 14 % 32 | this.shieldMax << 32 - 14 % 32;
         this.emergencyRepairSecondsLeft = param1.readInt();
         this.emergencyRepairSecondsLeft = this.emergencyRepairSecondsLeft >>> 13 % 32 | this.emergencyRepairSecondsLeft << 32 - 13 % 32;
         this.emergencyRepairSecondsTotal = param1.readInt();
         this.emergencyRepairSecondsTotal = this.emergencyRepairSecondsTotal << 4 % 32 | this.emergencyRepairSecondsTotal >>> 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7002);
         param1.writeInt(this.asteroidId >>> 8 % 32 | this.asteroidId << 32 - 8 % 32);
         param1.writeInt(this.slotId >>> 2 % 32 | this.slotId << 32 - 2 % 32);
         param1.writeInt(this.hitpoints << 1 % 32 | this.hitpoints >>> 32 - 1 % 32);
         param1.writeInt(this.hitpointsMax >>> 12 % 32 | this.hitpointsMax << 32 - 12 % 32);
         param1.writeInt(this.shield >>> 7 % 32 | this.shield << 32 - 7 % 32);
         param1.writeInt(this.shieldMax << 14 % 32 | this.shieldMax >>> 32 - 14 % 32);
         param1.writeInt(this.emergencyRepairSecondsLeft << 13 % 32 | this.emergencyRepairSecondsLeft >>> 32 - 13 % 32);
         param1.writeInt(this.emergencyRepairSecondsTotal >>> 4 % 32 | this.emergencyRepairSecondsTotal << 32 - 4 % 32);
      }
   }
}

