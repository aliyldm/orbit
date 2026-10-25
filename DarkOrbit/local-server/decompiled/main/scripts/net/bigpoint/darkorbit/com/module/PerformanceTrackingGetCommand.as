package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PerformanceTrackingGetCommand implements IModule
   {
      
      private static var _instance:PerformanceTrackingGetCommand;
      
      public function PerformanceTrackingGetCommand()
      {
         super();
      }
      
      public static function get instance() : PerformanceTrackingGetCommand
      {
         return _instance || (_instance = new PerformanceTrackingGetCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 149;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(149);
      }
   }
}

