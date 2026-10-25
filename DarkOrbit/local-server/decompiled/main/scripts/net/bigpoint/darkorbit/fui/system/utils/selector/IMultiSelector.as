package net.bigpoint.darkorbit.fui.system.utils.selector
{
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   
   public interface IMultiSelector
   {
      
      function activate() : void;
      
      function deactivate() : void;
      
      function start() : void;
      
      function stop() : void;
      
      function isSelecting() : Boolean;
      
      function register(param1:ItemList) : void;
      
      function unregister(param1:ItemList) : void;
   }
}

