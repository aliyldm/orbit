package net.bigpoint.darkorbit.fui.components.core.interfaces
{
   public interface IFocusable
   {
      
      function setFocus() : void;
      
      function unfocus() : void;
      
      function set focusGroupId(param1:String) : void;
      
      function get focusGroupId() : String;
   }
}

