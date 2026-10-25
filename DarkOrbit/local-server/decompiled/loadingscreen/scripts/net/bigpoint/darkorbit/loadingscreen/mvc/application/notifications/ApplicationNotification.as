package net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications
{
   public class ApplicationNotification
   {
      
      public static const NAME:String = "ApplicationNotification";
      
      public static const ERROR:String = NAME + "Error";
      
      public static const STARTUP:String = NAME + "Startup";
      
      public static const RESIZE:String = NAME + "Resize";
      
      public static const INIT_APPLICATION:String = NAME + "InitApplication";
      
      public static const CLEANUP_APPLICATION:String = NAME + "CleanupApplication";
      
      public static const UI_READY:String = NAME + "UiReady";
      
      public static const GAMECLIENT_LOADED:String = NAME + "GameclientLoaded";
      
      public static const GAMECLIENT_LOAD_PROGRESS:String = NAME + "GameclientLoadProgress";
      
      public static const START_GAME:String = NAME + "StartGame";
      
      public function ApplicationNotification()
      {
         super();
      }
   }
}

