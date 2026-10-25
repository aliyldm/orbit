package net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji
{
   public class RichChatEmojiCodec
   {
      
      private static const PROTOCOL_PATTERN:RegExp = /\[emoji:emoji_([0-9]+)\]/g;
      
      private static const SPRITE_PATTERN:RegExp = /<sprite\s+name=(?:"emoji_([0-9]+)"|'emoji_([0-9]+)'|emoji_([0-9]+))\s*\/?>/g;
      
      public function RichChatEmojiCodec()
      {
         super();
      }
      
      public static function toInputText(param1:String) : String
      {
         if(!param1)
         {
            return param1 || "";
         }
         PROTOCOL_PATTERN.lastIndex = 0;
         param1 = param1.replace(PROTOCOL_PATTERN,replaceProtocolWithMarker);
         SPRITE_PATTERN.lastIndex = 0;
         return param1.replace(SPRITE_PATTERN,replaceSpriteWithMarker);
      }
      
      public static function toProtocolText(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc5_:RichChatEmojiVO = null;
         if(!param1)
         {
            return param1 || "";
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.charAt(_loc3_);
            _loc5_ = RichChatEmojiRegistry.getEmojiByMarker(_loc4_);
            _loc2_.push(_loc5_ ? "[emoji:emoji_" + _loc5_.id + "]" : _loc4_);
            _loc3_++;
         }
         return _loc2_.join("");
      }
      
      public static function getEmojiIdForMarker(param1:String) : String
      {
         var _loc2_:RichChatEmojiVO = RichChatEmojiRegistry.getEmojiByMarker(param1);
         return _loc2_ ? _loc2_.id : null;
      }
      
      private static function replaceProtocolWithMarker(... rest) : String
      {
         var _loc2_:String = String(rest[1]);
         var _loc3_:String = RichChatEmojiRegistry.createMarker(_loc2_);
         return _loc3_ || String(rest[0]);
      }
      
      private static function replaceSpriteWithMarker(... rest) : String
      {
         var _loc2_:String = rest[1] || rest[2] || rest[3];
         var _loc3_:String = RichChatEmojiRegistry.createMarker(_loc2_);
         return _loc3_ || String(rest[0]);
      }
   }
}

