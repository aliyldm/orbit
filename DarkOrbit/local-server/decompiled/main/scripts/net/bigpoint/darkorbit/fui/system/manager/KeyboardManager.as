package net.bigpoint.darkorbit.fui.system.manager
{
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   
   public class KeyboardManager extends EventDispatcher implements IKeyboardManager
   {
      
      private var _stage:Stage;
      
      private var _isAltKeyDown:Boolean;
      
      private var _isCtrlKeyDown:Boolean;
      
      private var _isShiftKeyDown:Boolean;
      
      private var _keyboardFocus:Object;
      
      private const _keys:Dictionary = new Dictionary();
      
      public function KeyboardManager(param1:Stage)
      {
         super();
         this._stage = param1;
         this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDownEvent);
         this._stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUpEvent);
      }
      
      protected function handleKeyDownEvent(param1:KeyboardEvent) : void
      {
         this._isAltKeyDown = param1.altKey;
         this._isCtrlKeyDown = param1.ctrlKey;
         this._isShiftKeyDown = param1.shiftKey;
         this._keys[param1.keyCode] = new KeyDownVO(param1.keyCode,param1.charCode);
      }
      
      protected function handleKeyUpEvent(param1:KeyboardEvent) : void
      {
         this._isAltKeyDown = false;
         this._isCtrlKeyDown = false;
         this._isShiftKeyDown = false;
         this._keys[param1.keyCode] = null;
      }
      
      public function get isAltKeyDown() : Boolean
      {
         return this._isAltKeyDown;
      }
      
      public function get isCtrlKeyDown() : Boolean
      {
         return this._isCtrlKeyDown;
      }
      
      public function get isShiftKeyDown() : Boolean
      {
         return this._isShiftKeyDown;
      }
      
      public function isKeyDown(param1:uint) : Boolean
      {
         return this._keys[param1] != null ? true : false;
      }
      
      override public function toString() : String
      {
         var _loc2_:KeyDownVO = null;
         var _loc1_:String = "- KeyboardManager ---------------------------------------------";
         for each(_loc2_ in this._keys)
         {
            _loc1_ += _loc2_.toString();
         }
         return _loc1_;
      }
      
      public function getKeyboardFocus() : Object
      {
         return this._keyboardFocus;
      }
      
      public function setKeyboardFocus(param1:Object) : void
      {
         this._keyboardFocus = param1;
      }
      
      public function clearKeyboardFocus() : void
      {
         this._keyboardFocus = null;
      }
      
      public function hasKeyboardFocus() : Boolean
      {
         return this._keyboardFocus == null;
      }
   }
}

