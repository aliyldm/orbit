package net.bigpoint.darkorbit.fui.components.core.interfaces
{
   public interface IDraggable
   {
      
      function set dragenabled(param1:Boolean) : void;
      
      function isDraggable() : Boolean;
      
      function set dragType(param1:Object) : void;
      
      function get dragType() : Object;
   }
}

