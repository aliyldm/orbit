package net.bigpoint.darkorbit.gui.windows.simpleWindow
{
   import flash.events.Event;
   
   public class SimpleWindowEvent extends Event
   {
      
      private static const NAME:String = "SimpleWindowEvent";
      
      public static const ZOOM_IN:String = NAME + "zoomIn";
      
      public static const ZOOM_OUT:String = NAME + "zoomOut";
      
      public static const RESIZE_START:String = NAME + "resizeStart";
      
      public static const RESIZE_STOP:String = NAME + "resizeStop";
      
      public static const ON_RESIZE:String = NAME + "onResize";
      
      public static const ON_MAXIMIZED:String = NAME + "onMaximized";
      
      public static const ON_MINIMIZED:String = NAME + "onMinimized";
      
      public static const ON_MINIMIZE:String = NAME + "onMinimize";
      
      public static const ON_MAXIMIZE_CLICKED:String = NAME + "onMaximizeClicked";
      
      public static const ON_MINIMIZE_CLICKED:String = NAME + "onMinimizeClicked";
      
      public static const SAVE_WINDOW_SETTINGS:String = NAME + "SaveWindowSettings";
      
      public static const SAVE_AUDIO_SETTINGS:String = NAME + "SaveAudioSettings";
      
      public static const SAVE_QUALITY_SETTINGS:String = NAME + "SaveQualitySettings";
      
      public static const SAVE_DISPLAY_SETTINGS:String = NAME + "SaveDisplaySettings";
      
      public static const SAVE_GAMEPLAY_SETTINGS:String = NAME + "SaveGameplaySettings";
      
      public static const SAVE_SHIP_SETTINGS:String = NAME + "SaveShipSettings";
      
      public static const BG_FADE_OUT:String = NAME + "BG_FADE_OUT";
      
      public static const BG_FADE_IN:String = NAME + "BG_FADE_IN";
      
      public static const SHOW_POPUP:String = NAME + "SHOW_POPUP";
      
      public static const HIDE_POPUP:String = NAME + "HIDE_POPUP";
      
      public static const ON_CLOSE:String = NAME + "ON_CLOSE";
      
      public static const OPEN_HINT:String = NAME + "OPEN_HINT";
      
      public static const START_DRAG:String = NAME + "START_DRAG";
      
      public static const STOP_DRAG:String = NAME + "STOP_DRAG";
      
      public static const SIZE_CHANGED:String = NAME + "SIZE_CHANGED";
      
      public static const WIDTH_CHANGED:String = NAME + "WIDTH_CHANGED";
      
      public static const HEIGHT_CHANGED:String = NAME + "HEIGHT_CHANGED";
      
      public function SimpleWindowEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
      }
   }
}

