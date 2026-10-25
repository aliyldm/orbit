package net.bigpoint.darkorbit.mvc.gui.messages.controller
{
   public class MessageCommandParams
   {
      
      private var _message:String;
      
      private var _type:String;
      
      private var _id:String;
      
      private var _fadeOutDelay:Number = 0;
      
      private var _fadeInDelay:Number = 0;
      
      public function MessageCommandParams(param1:String = null, param2:String = null)
      {
         super();
         this._message = param1;
         this._id = param2;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get fadeInDelay() : Number
      {
         return this._fadeInDelay;
      }
      
      public function get fadeOutDelay() : Number
      {
         return this._fadeOutDelay;
      }
      
      public function setId(param1:String) : MessageCommandParams
      {
         this._id = param1;
         return this;
      }
      
      public function setFadeOutDelay(param1:Number) : MessageCommandParams
      {
         this._fadeOutDelay = param1;
         return this;
      }
      
      public function setFadeInDelay(param1:Number) : MessageCommandParams
      {
         this._fadeInDelay = param1;
         return this;
      }
      
      public function setType(param1:String) : MessageCommandParams
      {
         this._type = param1;
         return this;
      }
      
      public function setMessage(param1:String) : MessageCommandParams
      {
         this._message = param1;
         return this;
      }
   }
}

