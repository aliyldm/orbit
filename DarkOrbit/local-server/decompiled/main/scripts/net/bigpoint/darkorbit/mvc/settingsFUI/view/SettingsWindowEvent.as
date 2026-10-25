package net.bigpoint.darkorbit.mvc.settingsFUI.view
{
   import flash.events.Event;
   
   public class SettingsWindowEvent extends Event
   {
      
      public static const LISTED_CHECKBOX_CHANGED:String = "LISTED_CHECKBOX_CHANGED";
      
      public static const LISTED_KEYBINDING_CHANGED:String = "LISTED_KEYBINDING_CHANGED";
      
      public static const NOW_LISTENING_FOR_KEYBINDING:String = "NOW_LISTENING_FOR_KEYBINDING";
      
      public static const TAB_SWITCHED:String = "TAB_SWITCHED";
      
      private var _data:Object;
      
      public function SettingsWindowEvent(param1:String, param2:Object)
      {
         super(param1,true);
         this._data = param2;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

