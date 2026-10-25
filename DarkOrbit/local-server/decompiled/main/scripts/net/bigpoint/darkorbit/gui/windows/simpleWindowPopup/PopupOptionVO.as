package net.bigpoint.darkorbit.gui.windows.simpleWindowPopup
{
   public class PopupOptionVO
   {
      
      private var _btnId:int;
      
      private var _btnLabelTextKey:String;
      
      private var _clickCallback:Function;
      
      private var _clickCallbackParams:Array;
      
      private var _showContentUnderPopupDelay:int;
      
      private var _localLib:String;
      
      public function PopupOptionVO(param1:int, param2:String, param3:Function = null, param4:Array = null, param5:String = "", param6:int = 0)
      {
         super();
         this._btnId = param1;
         this._btnLabelTextKey = param2;
         this._clickCallback = param3;
         this._clickCallbackParams = param4;
         this._localLib = param5;
         this._showContentUnderPopupDelay = param6;
      }
      
      public function get btnLabelTextKey() : String
      {
         return this._btnLabelTextKey;
      }
      
      public function get clickCallback() : Function
      {
         return this._clickCallback;
      }
      
      public function get btnId() : int
      {
         return this._btnId;
      }
      
      public function get clickCallbackParams() : Array
      {
         return this._clickCallbackParams;
      }
      
      public function get showContentUnderPopupDelay() : int
      {
         return this._showContentUnderPopupDelay;
      }
      
      public function get localLib() : String
      {
         return this._localLib;
      }
   }
}

