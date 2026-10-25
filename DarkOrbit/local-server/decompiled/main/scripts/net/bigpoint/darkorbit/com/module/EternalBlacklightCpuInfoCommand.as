package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalBlacklightCpuInfoCommand implements IModule
   {
      
      private static var _instance:EternalBlacklightCpuInfoCommand;
      
      public var cpuCount:int = 0;
      
      public function EternalBlacklightCpuInfoCommand(param1:int = 0)
      {
         super();
         this.cpuCount = param1;
      }
      
      public static function get instance() : EternalBlacklightCpuInfoCommand
      {
         return _instance || (_instance = new EternalBlacklightCpuInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26307;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.cpuCount = param1.readInt();
         this.cpuCount = this.cpuCount >>> 11 % 32 | this.cpuCount << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26307);
         param1.writeInt(this.cpuCount << 11 % 32 | this.cpuCount >>> 32 - 11 % 32);
      }
   }
}

