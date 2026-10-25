package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   public class RichChatMessageSegmentVO
   {
      
      public static const TEXT:String = "text";
      
      public static const IMAGE:String = "image";
      
      public static const LINK:String = "link";
      
      public var type:String;
      
      public var text:String;
      
      public var isHtml:Boolean;
      
      public var imageType:String;
      
      public var imageId:String;
      
      public var width:Number;
      
      public var height:Number;
      
      public var eventType:String;
      
      public var eventPayload:Object;
      
      public function RichChatMessageSegmentVO(param1:String)
      {
         super();
         this.type = param1;
      }
      
      public static function textSegment(param1:String, param2:Boolean = false) : RichChatMessageSegmentVO
      {
         var _loc3_:RichChatMessageSegmentVO = new RichChatMessageSegmentVO(TEXT);
         _loc3_.text = param1;
         _loc3_.isHtml = param2;
         return _loc3_;
      }
      
      public static function imageSegment(param1:String, param2:String, param3:Number = 16, param4:Number = 16) : RichChatMessageSegmentVO
      {
         var _loc5_:RichChatMessageSegmentVO = new RichChatMessageSegmentVO(IMAGE);
         _loc5_.imageType = param1;
         _loc5_.imageId = param2;
         _loc5_.width = param3;
         _loc5_.height = param4;
         return _loc5_;
      }
      
      public static function linkSegment(param1:String, param2:String, param3:Object = null) : RichChatMessageSegmentVO
      {
         var _loc4_:RichChatMessageSegmentVO = new RichChatMessageSegmentVO(LINK);
         _loc4_.text = param1;
         _loc4_.eventType = param2;
         _loc4_.eventPayload = param3;
         return _loc4_;
      }
   }
}

