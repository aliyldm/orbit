package net.bigpoint.darkorbit.mvc.chatclient.model
{
   import mx.utils.Base64Decoder;
   import mx.utils.Base64Encoder;
   
   public class DOChatInviteVO
   {
      
      private static const SERIALIZATION_SEPERATOR:String = "|";
      
      private var _roomId:String;
      
      private var _roomName:String;
      
      private var _ownerId:String;
      
      public function DOChatInviteVO(param1:String, param2:String, param3:String)
      {
         super();
         this._roomId = param1;
         this._roomName = param2;
         this._ownerId = param3;
      }
      
      public static function deserialize(param1:String) : DOChatInviteVO
      {
         var _loc2_:Array = param1.split(SERIALIZATION_SEPERATOR);
         var _loc3_:Base64Decoder = new Base64Decoder();
         _loc3_.decode(_loc2_[1]);
         return new DOChatInviteVO(String(_loc2_[0]),_loc3_.toByteArray().toString(),String(_loc2_[2]));
      }
      
      public function get roomId() : String
      {
         return this._roomId;
      }
      
      public function get roomName() : String
      {
         return this._roomName;
      }
      
      public function get ownerId() : String
      {
         return this._ownerId;
      }
      
      public function serialize() : String
      {
         var _loc1_:Base64Encoder = new Base64Encoder();
         _loc1_.encode(this.roomName);
         return this.roomId + SERIALIZATION_SEPERATOR + _loc1_.toString() + SERIALIZATION_SEPERATOR + this.ownerId;
      }
   }
}

