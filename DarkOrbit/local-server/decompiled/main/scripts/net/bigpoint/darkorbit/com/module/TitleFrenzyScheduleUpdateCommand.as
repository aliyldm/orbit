package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TitleFrenzyScheduleUpdateCommand implements IModule
   {
      
      private static var _instance:TitleFrenzyScheduleUpdateCommand;
      
      public var timeToNextWindow:Number = 0;
      
      public var timeToWindowEnd:Number = 0;
      
      public function TitleFrenzyScheduleUpdateCommand(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.timeToNextWindow = param2;
         this.timeToWindowEnd = param1;
      }
      
      public static function get instance() : TitleFrenzyScheduleUpdateCommand
      {
         return _instance || (_instance = new TitleFrenzyScheduleUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15423;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToNextWindow = param1.readDouble();
         this.timeToWindowEnd = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-15423);
         param1.writeDouble(this.timeToNextWindow);
         param1.writeDouble(this.timeToWindowEnd);
      }
   }
}

