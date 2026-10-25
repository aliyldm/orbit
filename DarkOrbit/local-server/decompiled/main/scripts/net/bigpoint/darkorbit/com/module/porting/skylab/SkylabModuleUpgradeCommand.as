package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabModuleUpgradeCommand implements IModule
   {
      
      private static var _instance:SkylabModuleUpgradeCommand;
      
      public var timeLeft:Number = 0;
      
      public var credits:int = 0;
      
      public var terbium:int = 0;
      
      public var uridiumInstant:int = 0;
      
      public var endurium:int = 0;
      
      public var prometium:int = 0;
      
      public var timeNormal:Number = 0;
      
      public function SkylabModuleUpgradeCommand(param1:int = 0, param2:Number = 0, param3:Number = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0)
      {
         super();
         this.timeLeft = param3;
         this.credits = param4;
         this.terbium = param7;
         this.uridiumInstant = param1;
         this.endurium = param6;
         this.prometium = param5;
         this.timeNormal = param2;
      }
      
      public static function get instance() : SkylabModuleUpgradeCommand
      {
         return _instance || (_instance = new SkylabModuleUpgradeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10545;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 36;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeLeft = param1.readDouble();
         this.credits = param1.readInt();
         this.credits = this.credits >>> 1 % 32 | this.credits << 32 - 1 % 32;
         this.terbium = param1.readInt();
         this.terbium = this.terbium << 2 % 32 | this.terbium >>> 32 - 2 % 32;
         this.uridiumInstant = param1.readInt();
         this.uridiumInstant = this.uridiumInstant << 16 % 32 | this.uridiumInstant >>> 32 - 16 % 32;
         this.endurium = param1.readInt();
         this.endurium = this.endurium >>> 12 % 32 | this.endurium << 32 - 12 % 32;
         this.prometium = param1.readInt();
         this.prometium = this.prometium >>> 5 % 32 | this.prometium << 32 - 5 % 32;
         this.timeNormal = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10545);
         param1.writeDouble(this.timeLeft);
         param1.writeInt(this.credits << 1 % 32 | this.credits >>> 32 - 1 % 32);
         param1.writeInt(this.terbium >>> 2 % 32 | this.terbium << 32 - 2 % 32);
         param1.writeInt(this.uridiumInstant >>> 16 % 32 | this.uridiumInstant << 32 - 16 % 32);
         param1.writeInt(this.endurium << 12 % 32 | this.endurium >>> 32 - 12 % 32);
         param1.writeInt(this.prometium << 5 % 32 | this.prometium >>> 32 - 5 % 32);
         param1.writeDouble(this.timeNormal);
      }
   }
}

