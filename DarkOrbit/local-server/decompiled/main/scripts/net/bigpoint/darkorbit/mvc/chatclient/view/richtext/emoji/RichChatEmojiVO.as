package net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji
{
   public class RichChatEmojiVO
   {
      
      public var id:String;
      
      public var assetName:String;
      
      public var marker:String;
      
      public function RichChatEmojiVO(param1:String, param2:String, param3:String)
      {
         super();
         this.id = param1;
         this.assetName = param2;
         this.marker = param3;
      }
   }
}

