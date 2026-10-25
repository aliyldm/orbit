package net.bigpoint.darkorbit.mvc.chatclient.model.backend
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ChatSettings
   {
      
      private static var _endpointID:String;
      
      public static const role:String = "chatter";
      
      public static const space:String = "achat";
      
      public static const gameName:String = "DO";
      
      public static var autoReconnectEnabled:Boolean = true;
      
      private static var _chat_cross_ip:String = "";
      
      private static var _server:String = "";
      
      public function ChatSettings()
      {
         super();
      }
      
      public static function get endpointID() : String
      {
         return _endpointID;
      }
      
      public static function set endpointID(param1:String) : void
      {
         _endpointID = param1;
      }
      
      public static function get server() : String
      {
         return _server;
      }
      
      public static function set server(param1:String) : void
      {
         _server = param1;
      }
      
      public static function get userName() : String
      {
         return Hero.username;
      }
      
      public static function get chatLanguage() : String
      {
         var _loc1_:String = Settings.language.split("_")[0];
         if(_loc1_ == "dev")
         {
            _loc1_ = "de";
         }
         if(_loc1_ == "br")
         {
            _loc1_ = "pt";
         }
         if(_loc1_ == "us")
         {
            _loc1_ = "en";
         }
         if(_loc1_ == "mx")
         {
            _loc1_ = "es";
         }
         if(_loc1_ == "sk")
         {
            _loc1_ = "cs";
         }
         if(_loc1_ == "da")
         {
            _loc1_ = "no";
         }
         return _loc1_;
      }
      
      public static function get address() : String
      {
         return _server;
      }
      
      public static function get addressNoPort() : String
      {
         return _server.split(":")[0];
      }
      
      public static function get chat_cross_ip() : String
      {
         return _chat_cross_ip;
      }
      
      public static function set chat_cross_ip(param1:String) : void
      {
         _chat_cross_ip = param1;
      }
      
      public static function get isNew() : Boolean
      {
         return ChatSettings.address.indexOf("ingrid-chat") != -1;
      }
   }
}

