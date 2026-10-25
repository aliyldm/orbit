package net.bigpoint.darkorbit.mvc.chatclient.model
{
   public class DOChatMessageVO
   {
      
      public static const WHISPER_TYPE_NONE:String = "0";
      
      public static const WHISPER_TYPE_YOU:String = "1";
      
      public static const WHISPER_TYPE_THEY:String = "2";
      
      private var _message:String;
      
      private var _whisperType:String;
      
      private var _user:DOChatUserVO;
      
      private var _forceToAllRooms:Boolean;
      
      private var _timestamp:Number;
      
      public function DOChatMessageVO(param1:String, param2:DOChatUserVO, param3:String = "0", param4:Boolean = false, param5:Number = NaN)
      {
         super();
         this._message = param1;
         this._user = param2;
         this._whisperType = param3;
         this._forceToAllRooms = param4;
         this._timestamp = isValidTimestamp(param5) ? param5 : NaN;
      }
      
      private static function isValidTimestamp(param1:Number) : Boolean
      {
         return !isNaN(param1) && param1 >= 0;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get whisperType() : String
      {
         return this._whisperType;
      }
      
      public function get user() : DOChatUserVO
      {
         return this._user;
      }
      
      public function get forceToAllRooms() : Boolean
      {
         return this._forceToAllRooms;
      }
      
      public function get timestamp() : Number
      {
         return this._timestamp;
      }
      
      public function set timestamp(param1:Number) : void
      {
         this._timestamp = param1;
      }
   }
}

