package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateWaveInfoCommand implements IModule
   {
      
      private static var _instance:EternalGateWaveInfoCommand;
      
      public var furthestWave:int = 0;
      
      public var nextMilestone:int = 0;
      
      public var currentWave:int = 0;
      
      public function EternalGateWaveInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.furthestWave = param2;
         this.nextMilestone = param3;
         this.currentWave = param1;
      }
      
      public static function get instance() : EternalGateWaveInfoCommand
      {
         return _instance || (_instance = new EternalGateWaveInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 682;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.furthestWave = param1.readInt();
         this.furthestWave = this.furthestWave << 9 % 32 | this.furthestWave >>> 32 - 9 % 32;
         this.nextMilestone = param1.readInt();
         this.nextMilestone = this.nextMilestone >>> 15 % 32 | this.nextMilestone << 32 - 15 % 32;
         this.currentWave = param1.readInt();
         this.currentWave = this.currentWave << 12 % 32 | this.currentWave >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(682);
         param1.writeInt(this.furthestWave >>> 9 % 32 | this.furthestWave << 32 - 9 % 32);
         param1.writeInt(this.nextMilestone << 15 % 32 | this.nextMilestone >>> 32 - 15 % 32);
         param1.writeInt(this.currentWave >>> 12 % 32 | this.currentWave << 32 - 12 % 32);
      }
   }
}

