package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import net.bigpoint.darkorbit.mvc.chatclient.view.DOChatEvent;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiRegistry;
   
   public class RichChatMessageParser
   {
      
      private static const TOKEN_PATTERN:RegExp = /\[\[(?:image|ref)[^\]]*\]\]|\[emoji:emoji_[0-9]+\]|<sprite\s+name=(?:"emoji_[0-9]+"|'emoji_[0-9]+'|emoji_[0-9]+)\s*\/?>/g;
      
      private static const RICH_TOKEN_PATTERN:RegExp = /^\[\[(image|ref)([^\]]*)\]\]$/;
      
      private static const EMOJI_ID_PATTERN:RegExp = /emoji_([0-9]+)/;
      
      private static const ATTRIBUTE_PATTERN:RegExp = /(\w+)=("([^"]*)"|'([^']*)'|[^\s\]]+)/g;
      
      public function RichChatMessageParser()
      {
         super();
      }
      
      public function parse(param1:String, param2:Boolean = false) : Vector.<RichChatMessageSegmentVO>
      {
         var _loc5_:Object = null;
         var _loc3_:Vector.<RichChatMessageSegmentVO> = new Vector.<RichChatMessageSegmentVO>(0);
         if(!param1)
         {
            return _loc3_;
         }
         TOKEN_PATTERN.lastIndex = 0;
         var _loc4_:int = 0;
         while(true)
         {
            _loc5_ = TOKEN_PATTERN.exec(param1);
            if(_loc5_ == null)
            {
               break;
            }
            if(_loc5_.index > _loc4_)
            {
               _loc3_.push(RichChatMessageSegmentVO.textSegment(param1.substring(_loc4_,_loc5_.index),param2));
            }
            this.appendMatchedToken(_loc3_,String(_loc5_[0]),param2);
            _loc4_ = TOKEN_PATTERN.lastIndex;
         }
         if(_loc4_ < param1.length)
         {
            _loc3_.push(RichChatMessageSegmentVO.textSegment(param1.substring(_loc4_),param2));
         }
         return _loc3_;
      }
      
      private function appendMatchedToken(param1:Vector.<RichChatMessageSegmentVO>, param2:String, param3:Boolean) : void
      {
         var _loc4_:Object = RICH_TOKEN_PATTERN.exec(param2);
         if(_loc4_)
         {
            this.appendTokenSegments(param1,String(_loc4_[1]),String(_loc4_[2]));
            return;
         }
         var _loc5_:Object = EMOJI_ID_PATTERN.exec(param2);
         var _loc6_:String = _loc5_ ? String(_loc5_[1]) : "";
         if((Boolean(_loc6_)) && RichChatEmojiRegistry.hasEmoji(_loc6_))
         {
            param1.push(RichChatMessageSegmentVO.imageSegment(RichChatEmojiRegistry.IMAGE_TYPE,_loc6_,18,18));
         }
         else
         {
            param1.push(RichChatMessageSegmentVO.textSegment(param2,param3));
         }
      }
      
      private function appendTokenSegments(param1:Vector.<RichChatMessageSegmentVO>, param2:String, param3:String) : void
      {
         var _loc4_:Object = this.parseAttributes(param3);
         var _loc5_:String = _loc4_.type ? String(_loc4_.type) : param2;
         var _loc6_:String = _loc4_.id ? String(_loc4_.id) : (_loc4_.key ? String(_loc4_.key) : "");
         var _loc7_:Number = this.toNumber(_loc4_.width,16);
         var _loc8_:Number = this.toNumber(_loc4_.height,16);
         if(param2 == "image")
         {
            param1.push(RichChatMessageSegmentVO.imageSegment(_loc5_,_loc6_,_loc7_,_loc8_));
            return;
         }
         if(param2 == "ref")
         {
            param1.push(RichChatMessageSegmentVO.imageSegment(_loc5_,_loc6_,_loc7_,_loc8_));
            if(_loc4_.label)
            {
               param1.push(RichChatMessageSegmentVO.linkSegment(String(_loc4_.label),_loc4_.event ? String(_loc4_.event) : DOChatEvent.CMD_CLICKED,_loc4_.payload ? _loc4_.payload : _loc6_));
            }
         }
      }
      
      private function parseAttributes(param1:String) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc2_:Object = {};
         ATTRIBUTE_PATTERN.lastIndex = 0;
         while(true)
         {
            _loc3_ = ATTRIBUTE_PATTERN.exec(param1);
            if(_loc3_ == null)
            {
               break;
            }
            _loc4_ = _loc3_[3] ? String(_loc3_[3]) : (_loc3_[4] ? String(_loc3_[4]) : String(_loc3_[2]));
            _loc2_[_loc3_[1]] = _loc4_;
         }
         return _loc2_;
      }
      
      private function toNumber(param1:Object, param2:Number) : Number
      {
         var _loc3_:Number = Number(param1);
         return isNaN(_loc3_) ? param2 : _loc3_;
      }
   }
}

