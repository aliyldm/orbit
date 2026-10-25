package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CPUInitializationCommand implements IModule
   {
      
      private static var _instance:CPUInitializationCommand;
      
      public var advancedJumpCPUEquipped:Boolean = false;
      
      public var radarCPUEquipped:Boolean = false;
      
      public function CPUInitializationCommand(param1:Boolean = false, param2:Boolean = false)
      {
         super();
         this.advancedJumpCPUEquipped = param1;
         this.radarCPUEquipped = param2;
      }
      
      public static function get instance() : CPUInitializationCommand
      {
         return _instance || (_instance = new CPUInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3967;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.advancedJumpCPUEquipped = param1.readBoolean();
         this.radarCPUEquipped = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-3967);
         param1.writeBoolean(this.advancedJumpCPUEquipped);
         param1.writeBoolean(this.radarCPUEquipped);
      }
   }
}

