package net.bigpoint.darkorbit.fui.system.manager
{
   public interface IKeyboardManager
   {
      
      function get isAltKeyDown() : Boolean;
      
      function get isCtrlKeyDown() : Boolean;
      
      function get isShiftKeyDown() : Boolean;
      
      function isKeyDown(param1:uint) : Boolean;
      
      function getKeyboardFocus() : Object;
      
      function setKeyboardFocus(param1:Object) : void;
      
      function clearKeyboardFocus() : void;
      
      function hasKeyboardFocus() : Boolean;
   }
}

