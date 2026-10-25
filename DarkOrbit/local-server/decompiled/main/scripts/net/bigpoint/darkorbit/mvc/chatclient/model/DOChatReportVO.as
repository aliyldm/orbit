package net.bigpoint.darkorbit.mvc.chatclient.model
{
   public class DOChatReportVO
   {
      
      private var _user:DOChatUserVO;
      
      private var _msg:Array;
      
      private var _roomPath:String;
      
      private var _reason:String;
      
      private var _reasonID:String;
      
      public function DOChatReportVO(param1:DOChatUserVO, param2:Array, param3:String, param4:String, param5:String)
      {
         super();
         this._user = param1;
         this._msg = param2;
         this._roomPath = param3;
         this._reason = param4;
         this._reasonID = param5;
      }
      
      public function get user() : DOChatUserVO
      {
         return this._user;
      }
      
      public function get msg() : Array
      {
         return this._msg;
      }
      
      public function get roomPath() : String
      {
         return this._roomPath;
      }
      
      public function get reason() : String
      {
         return this._reason;
      }
      
      public function get reasonID() : String
      {
         return this._reasonID;
      }
   }
}

