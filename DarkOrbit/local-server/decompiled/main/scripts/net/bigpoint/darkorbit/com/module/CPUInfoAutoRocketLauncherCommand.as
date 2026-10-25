package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CPUInfoAutoRocketLauncherCommand implements IModule
   {
      
      private static var _instance:CPUInfoAutoRocketLauncherCommand;
      
      public var active:Boolean = false;
      
      public function CPUInfoAutoRocketLauncherCommand(param1:Boolean = false)
      {
         super();
         this.active = param1;
      }
      
      public static function get instance() : CPUInfoAutoRocketLauncherCommand
      {
         return _instance || (_instance = new CPUInfoAutoRocketLauncherCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 86;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.active = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(86);
         param1.writeBoolean(this.active);
      }
   }
}

