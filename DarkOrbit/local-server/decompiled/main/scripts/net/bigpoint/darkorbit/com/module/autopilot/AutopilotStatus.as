package net.bigpoint.darkorbit.com.module.autopilot
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AutopilotStatus implements IModule
   {
      
      private static var _instance:AutopilotStatus;
      
      public static const AUTO_STATUS_START:int = 0;
      
      public static const AUTO_STATUS_STOP:int = 1;
      
      public static const AUTO_STATUS__MAX:int = 2;
      
      public var status:int = 0;
      
      public function AutopilotStatus(param1:int = 0)
      {
         super();
         this.status = param1;
      }
      
      public static function get instance() : AutopilotStatus
      {
         return _instance || (_instance = new AutopilotStatus());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12706;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.status = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12706);
         param1.writeShort(this.status);
      }
   }
}

