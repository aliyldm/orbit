package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiRegistry;
   
   public class RichChatImageRegistry
   {
      
      public static const AVATAR_TYPE:String = "avatar";
      
      private static var _factories:Object = {};
      
      public function RichChatImageRegistry()
      {
         super();
      }
      
      public static function registerFactory(param1:String, param2:Function) : void
      {
         if(!param1 || param2 == null)
         {
            return;
         }
         _factories[param1] = param2;
      }
      
      public static function createImage(param1:RichChatMessageSegmentVO, param2:DOChatUserVO = null) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         if(param1.imageType == AVATAR_TYPE)
         {
            return new RichChatRemoteAvatar(param1.imageId,param1.width,param1.height,param2);
         }
         if(param1.imageType == RichChatEmojiRegistry.IMAGE_TYPE)
         {
            _loc4_ = RichChatEmojiRegistry.createBitmap(param1.imageId,param1.width,param1.height);
            return (_loc4_) || createPlaceholder(param1);
         }
         var _loc3_:Function = _factories[param1.imageType] as Function;
         if(_loc3_ != null)
         {
            _loc5_ = _loc3_(param1.imageType,param1.imageId,param1.width,param1.height) as DisplayObject;
            if(_loc5_)
            {
               _loc5_.width = param1.width;
               _loc5_.height = param1.height;
               return _loc5_;
            }
         }
         return createPlaceholder(param1);
      }
      
      private static function createPlaceholder(param1:RichChatMessageSegmentVO) : DisplayObject
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:TextField = null;
         var _loc2_:Sprite = new Sprite();
         _loc3_ = isNaN(param1.width) ? 16 : param1.width;
         _loc4_ = isNaN(param1.height) ? 16 : param1.height;
         _loc2_.graphics.beginFill(473674,1);
         _loc2_.graphics.lineStyle(1,43478,1);
         _loc2_.graphics.drawRect(0,0,_loc3_,_loc4_);
         _loc2_.graphics.endFill();
         _loc5_ = new TextField();
         _loc5_.mouseEnabled = false;
         _loc5_.width = _loc3_;
         _loc5_.height = _loc4_;
         var _loc6_:TextFormat = new TextFormat("Verdana",Math.max(8,Math.min(10,_loc4_ - 4)),12121087,true);
         _loc6_.align = TextFormatAlign.CENTER;
         _loc5_.defaultTextFormat = _loc6_;
         _loc5_.text = param1.imageType ? param1.imageType.charAt(0).toUpperCase() : "?";
         _loc2_.addChild(_loc5_);
         return _loc2_;
      }
   }
}

