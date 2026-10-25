package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalBlacklightInfoCommand implements IModule
   {
      
      private static var _instance:EternalBlacklightInfoCommand;
      
      public var waveInfo:EternalBlacklightWaveInfoCommand;
      
      public var cpuInfoCommand:EternalBlacklightCpuInfoCommand;
      
      public var boosterInfoCommand:EternalBlacklightBoosterInfoCommand;
      
      public function EternalBlacklightInfoCommand(param1:EternalBlacklightWaveInfoCommand = null, param2:EternalBlacklightBoosterInfoCommand = null, param3:EternalBlacklightCpuInfoCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.waveInfo = new EternalBlacklightWaveInfoCommand();
         }
         else
         {
            this.waveInfo = param1;
         }
         if(param3 == null)
         {
            this.cpuInfoCommand = new EternalBlacklightCpuInfoCommand();
         }
         else
         {
            this.cpuInfoCommand = param3;
         }
         if(param2 == null)
         {
            this.boosterInfoCommand = new EternalBlacklightBoosterInfoCommand();
         }
         else
         {
            this.boosterInfoCommand = param2;
         }
      }
      
      public static function get instance() : EternalBlacklightInfoCommand
      {
         return _instance || (_instance = new EternalBlacklightInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31274;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.waveInfo = EternalBlacklightWaveInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.waveInfo)
         {
            this.waveInfo.read(param1);
         }
         this.cpuInfoCommand = EternalBlacklightCpuInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.cpuInfoCommand)
         {
            this.cpuInfoCommand.read(param1);
         }
         this.boosterInfoCommand = EternalBlacklightBoosterInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.boosterInfoCommand)
         {
            this.boosterInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(31274);
         if(null != this.waveInfo)
         {
            this.waveInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.cpuInfoCommand)
         {
            this.cpuInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.boosterInfoCommand)
         {
            this.boosterInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

