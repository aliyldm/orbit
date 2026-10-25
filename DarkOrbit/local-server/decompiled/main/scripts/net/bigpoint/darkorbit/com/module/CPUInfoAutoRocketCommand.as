package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CPUInfoAutoRocketCommand implements IModule
   {
      
      private static var _instance:CPUInfoAutoRocketCommand;
      
      public var isActive:Boolean = false;
      
      public function CPUInfoAutoRocketCommand(param1:Boolean = false)
      {
         super();
         this.isActive = param1;
      }
      
      public static function get instance() : CPUInfoAutoRocketCommand
      {
         return _instance || (_instance = new CPUInfoAutoRocketCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 60;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isActive = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(60);
         param1.writeBoolean(this.isActive);
      }
   }
}

