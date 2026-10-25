package net.bigpoint.darkorbit.fui.components.core.interfaces
{
   public interface ISelectable
   {
      
      function select() : void;
      
      function unselect() : void;
      
      function deselect() : void;
      
      function set selected(param1:Boolean) : void;
      
      function isSelected() : Boolean;
   }
}

