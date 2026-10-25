package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalBlacklightWaveInfoCommand implements IModule
   {
      
      private static var _instance:EternalBlacklightWaveInfoCommand;
      
      public var furthestWave:int = 0;
      
      public var currentWave:int = 0;
      
      public function EternalBlacklightWaveInfoCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.furthestWave = param2;
         this.currentWave = param1;
      }
      
      public static function get instance() : EternalBlacklightWaveInfoCommand
      {
         return _instance || (_instance = new EternalBlacklightWaveInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2405;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.furthestWave = param1.readInt();
         this.furthestWave = this.furthestWave << 2 % 32 | this.furthestWave >>> 32 - 2 % 32;
         this.currentWave = param1.readInt();
         this.currentWave = this.currentWave << 3 % 32 | this.currentWave >>> 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-2405);
         param1.writeInt(this.furthestWave >>> 2 % 32 | this.furthestWave << 32 - 2 % 32);
         param1.writeInt(this.currentWave >>> 3 % 32 | this.currentWave << 32 - 3 % 32);
      }
   }
}

