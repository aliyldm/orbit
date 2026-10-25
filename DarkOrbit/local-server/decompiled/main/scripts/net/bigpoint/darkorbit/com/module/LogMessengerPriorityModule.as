package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LogMessengerPriorityModule implements IModule
   {
      
      private static var _instance:LogMessengerPriorityModule;
      
      public static const PRIORITYMODE_STANDARD:int = 0;
      
      public static const PRIORITYMODE_HIGH_PRIORITY:int = 1;
      
      public static const PRIORITYMODE__MAX:int = 2;
      
      public var priorityModeValue:int = 0;
      
      public function LogMessengerPriorityModule(param1:int = 0)
      {
         super();
         this.priorityModeValue = param1;
      }
      
      public static function get instance() : LogMessengerPriorityModule
      {
         return _instance || (_instance = new LogMessengerPriorityModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 202;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityModeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(202);
         param1.writeShort(this.priorityModeValue);
      }
   }
}

