package net.bigpoint.darkorbit.mvc.chatclient
{
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ChatPathSettings
   {
      
      public function ChatPathSettings()
      {
         super();
      }
      
      public static function get chatLocaURL() : String
      {
         return Settings.staticHost + "spacemap/templates/" + ChatSettings.chatLanguage + "/resource_chat.xml";
      }
   }
}

