package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MonthlyDeluxeTimeInfoCommand implements IModule
   {
      
      private static var _instance:MonthlyDeluxeTimeInfoCommand;
      
      public var timeToPassEnd:Number = 0;
      
      public function MonthlyDeluxeTimeInfoCommand(param1:Number = 0)
      {
         super();
         this.timeToPassEnd = param1;
      }
      
      public static function get instance() : MonthlyDeluxeTimeInfoCommand
      {
         return _instance || (_instance = new MonthlyDeluxeTimeInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12124;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToPassEnd = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12124);
         param1.writeDouble(this.timeToPassEnd);
      }
   }
}

