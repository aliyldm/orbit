package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PVPSummerEventFeverInfoCommand implements IModule
   {
      
      private static var _instance:PVPSummerEventFeverInfoCommand;
      
      public var timeToEndFever:Number = 0;
      
      public var timeToNextFever:Number = 0;
      
      public function PVPSummerEventFeverInfoCommand(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.timeToEndFever = param1;
         this.timeToNextFever = param2;
      }
      
      public static function get instance() : PVPSummerEventFeverInfoCommand
      {
         return _instance || (_instance = new PVPSummerEventFeverInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24527;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToEndFever = param1.readDouble();
         this.timeToNextFever = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24527);
         param1.writeDouble(this.timeToEndFever);
         param1.writeDouble(this.timeToNextFever);
      }
   }
}

