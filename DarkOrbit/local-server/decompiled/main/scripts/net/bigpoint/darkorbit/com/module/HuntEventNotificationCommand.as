package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HuntEventNotificationCommand implements IModule
   {
      
      private static var _instance:HuntEventNotificationCommand;
      
      public static const NOTIFICATIONTYPE_START:int = 0;
      
      public static const NOTIFICATIONTYPE_END:int = 1;
      
      public static const NOTIFICATIONTYPE__MAX:int = 2;
      
      public var notificationType:int = 0;
      
      public function HuntEventNotificationCommand(param1:int = 0)
      {
         super();
         this.notificationType = param1;
      }
      
      public static function get instance() : HuntEventNotificationCommand
      {
         return _instance || (_instance = new HuntEventNotificationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 197;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.notificationType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(197);
         param1.writeShort(this.notificationType);
      }
   }
}

