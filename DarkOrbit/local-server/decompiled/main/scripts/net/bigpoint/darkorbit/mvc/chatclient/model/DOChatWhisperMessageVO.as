package net.bigpoint.darkorbit.mvc.chatclient.model
{
   public class DOChatWhisperMessageVO
   {
      
      private var _user:String;
      
      private var _msg:String;
      
      private var _userData:DOChatUserVO;
      
      public function DOChatWhisperMessageVO(param1:String, param2:DOChatUserVO = null)
      {
         super();
         this._userData = param2;
         if(param1.indexOf("/w ") == 0)
         {
            param1 = param1.substr(3);
         }
         var _loc3_:int = param1.indexOf(" ");
         this._user = param1.substr(0,_loc3_);
         this._msg = param1.substr(_loc3_ + 1);
      }
      
      public function get user() : String
      {
         return this._user;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function get userData() : DOChatUserVO
      {
         return this._userData;
      }
   }
}

