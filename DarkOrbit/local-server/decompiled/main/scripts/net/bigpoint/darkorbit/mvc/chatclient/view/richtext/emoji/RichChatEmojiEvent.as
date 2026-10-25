package net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji
{
   import flash.events.Event;
   
   public class RichChatEmojiEvent extends Event
   {
      
      public static const SELECTED:String = "richChatEmojiSelected";
      
      public var emojiId:String;
      
      public function RichChatEmojiEvent(param1:String, param2:String, param3:Boolean = false)
      {
         super(param1,param3);
         this.emojiId = param2;
      }
      
      override public function clone() : Event
      {
         return new RichChatEmojiEvent(type,this.emojiId,bubbles);
      }
   }
}

