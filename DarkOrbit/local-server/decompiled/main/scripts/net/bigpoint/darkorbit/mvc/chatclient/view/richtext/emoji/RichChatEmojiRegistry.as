package net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji
{
   import com.bigpoint.utils.BitmapAtlas;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Main;
   
   public class RichChatEmojiRegistry
   {
      
      private static var _atlas:BitmapAtlas;
      
      private static var _emojis:Vector.<RichChatEmojiVO>;
      
      public static const ATLAS_XML_RESOURCE_ID:String = "chat_emoji_atlasXml";
      
      public static const TEXTURE_RESOURCE_ID:String = "chat_emoji_texture";
      
      public static const BITMAP_ATLAS_ID:String = "chatWindowEmojiBitmapAtlas";
      
      public static const IMAGE_TYPE:String = "emoji";
      
      private static const MARKER_START:int = 57344;
      
      private static const VISIBLE_ALPHA_THRESHOLD:int = 12;
      
      private static var _emojiById:Object = {};
      
      private static var _emojiByMarker:Dictionary = new Dictionary();
      
      private static var _bitmapDataByAsset:Object = {};
      
      public function RichChatEmojiRegistry()
      {
         super();
      }
      
      public static function get emojis() : Vector.<RichChatEmojiVO>
      {
         ensureConfig();
         return _emojis;
      }
      
      public static function initialize(param1:BitmapAtlas) : void
      {
         if(Boolean(_atlas) || !param1)
         {
            return;
         }
         _atlas = param1;
      }
      
      public static function hasEmoji(param1:String) : Boolean
      {
         ensureConfig();
         return _emojiById[param1] != null;
      }
      
      public static function getEmoji(param1:String) : RichChatEmojiVO
      {
         ensureConfig();
         return _emojiById[param1] as RichChatEmojiVO;
      }
      
      public static function getEmojiByMarker(param1:String) : RichChatEmojiVO
      {
         ensureConfig();
         return _emojiByMarker[param1] as RichChatEmojiVO;
      }
      
      public static function createMarker(param1:String) : String
      {
         var _loc2_:RichChatEmojiVO = getEmoji(param1);
         return _loc2_ ? _loc2_.marker : "";
      }
      
      public static function createBitmap(param1:String, param2:Number = 18, param3:Number = 18) : Bitmap
      {
         var _loc4_:RichChatEmojiVO = getEmoji(param1);
         if(!_loc4_ || !_atlas)
         {
            return null;
         }
         var _loc5_:BitmapData = _bitmapDataByAsset[_loc4_.assetName] as BitmapData;
         if(!_loc5_)
         {
            _loc5_ = _atlas.getBitmapDataByName(_loc4_.assetName);
            if(!_loc5_)
            {
               return null;
            }
            _loc5_ = normalizeVisibleContent(_loc5_);
            _bitmapDataByAsset[_loc4_.assetName] = _loc5_;
         }
         var _loc6_:Bitmap = new Bitmap(_loc5_);
         _loc6_.smoothing = true;
         _loc6_.width = param2;
         _loc6_.height = param3;
         return _loc6_;
      }
      
      private static function normalizeVisibleContent(param1:BitmapData) : BitmapData
      {
         var _loc2_:Rectangle = getVisibleBounds(param1);
         if(_loc2_.equals(param1.rect))
         {
            return param1;
         }
         var _loc3_:int = Math.max(_loc2_.width,_loc2_.height);
         var _loc4_:BitmapData = new BitmapData(_loc3_,_loc3_,true,0);
         var _loc5_:Point = new Point(Math.floor((_loc3_ - _loc2_.width) * 0.5),Math.floor((_loc3_ - _loc2_.height) * 0.5));
         _loc4_.copyPixels(param1,_loc2_,_loc5_,null,null,true);
         return _loc4_;
      }
      
      private static function getVisibleBounds(param1:BitmapData) : Rectangle
      {
         var _loc7_:int = 0;
         var _loc2_:int = param1.width;
         var _loc3_:int = param1.height;
         var _loc4_:int = -1;
         var _loc5_:int = -1;
         var _loc6_:int = 0;
         while(_loc6_ < param1.height)
         {
            _loc7_ = 0;
            while(_loc7_ < param1.width)
            {
               if((param1.getPixel32(_loc7_,_loc6_) >>> 24 & 0xFF) > VISIBLE_ALPHA_THRESHOLD)
               {
                  _loc2_ = Math.min(_loc2_,_loc7_);
                  _loc3_ = Math.min(_loc3_,_loc6_);
                  _loc4_ = Math.max(_loc4_,_loc7_);
                  _loc5_ = Math.max(_loc5_,_loc6_);
               }
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc4_ < _loc2_ || _loc5_ < _loc3_ ? param1.rect : new Rectangle(_loc2_,_loc3_,_loc4_ - _loc2_ + 1,_loc5_ - _loc3_ + 1);
      }
      
      private static function ensureConfig() : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:RichChatEmojiVO = null;
         if(_emojis)
         {
            return;
         }
         _emojis = new Vector.<RichChatEmojiVO>(0);
         if(!Main.gameXML || Main.gameXML.chatEmojis.length() == 0)
         {
            return;
         }
         var _loc1_:int = 0;
         for each(_loc2_ in Main.gameXML.chatEmojis.emoji)
         {
            _loc3_ = String(_loc2_.@id);
            _loc4_ = String(_loc2_.@asset);
            if(!(!_loc3_ || !_loc4_ || Boolean(_emojiById[_loc3_])))
            {
               _loc5_ = String.fromCharCode(MARKER_START + _loc1_);
               _loc6_ = new RichChatEmojiVO(_loc3_,_loc4_,_loc5_);
               _emojis.push(_loc6_);
               _emojiById[_loc3_] = _loc6_;
               _emojiByMarker[_loc5_] = _loc6_;
               _loc1_++;
            }
         }
      }
   }
}

