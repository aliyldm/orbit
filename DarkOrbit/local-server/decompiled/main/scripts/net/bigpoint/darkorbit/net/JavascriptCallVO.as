package net.bigpoint.darkorbit.net
{
   public class JavascriptCallVO
   {
      
      private var _action:String;
      
      private var _textKey:String;
      
      private var _template:String;
      
      private var _focus:Boolean;
      
      private var _category:String;
      
      private var _openPage:Boolean;
      
      private var _lootID:String;
      
      private var _jsUnavailableCallback:Function;
      
      private var _jsUnavailableCallBackParams:Array;
      
      public function JavascriptCallVO(param1:String, param2:String, param3:String = null, param4:Boolean = true, param5:String = null, param6:Boolean = true, param7:String = "", param8:Function = null, param9:Array = null)
      {
         super();
         this._action = param1;
         this._textKey = param2;
         this._template = param3;
         this._focus = param4;
         this._category = param5;
         this._openPage = param6;
         this._lootID = param7;
         this._jsUnavailableCallback = param8;
         this._jsUnavailableCallBackParams = param9;
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function get textKey() : String
      {
         return this._textKey;
      }
      
      public function get template() : String
      {
         return this._template;
      }
      
      public function get focus() : Boolean
      {
         return this._focus;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get openPage() : Boolean
      {
         return this._openPage;
      }
      
      public function get lootID() : String
      {
         return this._lootID;
      }
      
      public function get jsUnavailableCallback() : Function
      {
         return this._jsUnavailableCallback;
      }
      
      public function get jsUnavailableCallBackParams() : Array
      {
         return this._jsUnavailableCallBackParams;
      }
      
      public function set lootID(param1:String) : void
      {
         this._lootID = param1;
      }
      
      public function set openPage(param1:Boolean) : void
      {
         this._openPage = param1;
      }
      
      public function set category(param1:String) : void
      {
         this._category = param1;
      }
      
      public function set focus(param1:Boolean) : void
      {
         this._focus = param1;
      }
      
      public function set template(param1:String) : void
      {
         this._template = param1;
      }
   }
}

