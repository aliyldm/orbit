package net.bigpoint.darkorbit.fui.system.manager
{
   public class KeyDownVO
   {
      
      private var _charCode:uint;
      
      private var _keyCode:uint;
      
      public function KeyDownVO(param1:uint, param2:uint)
      {
         super();
         this._charCode = param2;
         this._keyCode = param1;
      }
      
      public function get charCode() : uint
      {
         return this._charCode;
      }
      
      public function get keyCode() : uint
      {
         return this._keyCode;
      }
      
      public function toString() : String
      {
         return "KeyDownVO { keyCode: " + this._keyCode + " charCode: " + this._charCode + " }\n";
      }
   }
}

