package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventProgressInfoCommand implements IModule
   {
      
      private static var _instance:EventProgressInfoCommand;
      
      public var remainingTimeInMS:Number = 0;
      
      public function EventProgressInfoCommand(param1:Number = 0)
      {
         super();
         this.remainingTimeInMS = param1;
      }
      
      public static function get instance() : EventProgressInfoCommand
      {
         return _instance || (_instance = new EventProgressInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27897;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.remainingTimeInMS = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27897);
         param1.writeDouble(this.remainingTimeInMS);
      }
   }
}

