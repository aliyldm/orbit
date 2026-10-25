package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   
   public class RichChatWhisperTabEvent extends Event
   {
      
      public static const CLOSE:String = "richChatWhisperTabClose";
      
      private var _user:DOChatUserVO;
      
      public function RichChatWhisperTabEvent(param1:String, param2:DOChatUserVO, param3:Boolean = true)
      {
         super(param1,param3);
         this._user = param2;
      }
      
      public function get user() : DOChatUserVO
      {
         return this._user;
      }
      
      override public function clone() : Event
      {
         return new RichChatWhisperTabEvent(type,this._user,bubbles);
      }
   }
}

