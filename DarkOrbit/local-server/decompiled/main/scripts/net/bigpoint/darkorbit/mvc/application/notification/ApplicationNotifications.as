package net.bigpoint.darkorbit.mvc.application.notification
{
   public class ApplicationNotifications
   {
      
      public static const NAME:String = "ApplicationNotification";
      
      public static const ERROR:String = NAME + "Error";
      
      public static const STARTUP:String = NAME + "Startup";
      
      public static const BOOTUP:String = NAME + "Bootup";
      
      public static const INIT:String = NAME + "InitApplication";
      
      public static const CLEANUP:String = NAME + "CleanupApplication";
      
      public function ApplicationNotifications()
      {
         super();
      }
   }
}

