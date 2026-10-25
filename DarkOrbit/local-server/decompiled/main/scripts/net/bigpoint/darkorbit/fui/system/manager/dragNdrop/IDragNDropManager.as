package net.bigpoint.darkorbit.fui.system.manager.dragNdrop
{
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.interfaces.IDropable;
   
   public interface IDragNDropManager
   {
      
      function set dragProxy(param1:IDragProxy) : void;
      
      function get dragProxy() : IDragProxy;
      
      function dragStart(param1:Vector.<ICoreponent>, param2:int = 0, param3:int = 0, param4:ICoreponent = null) : void;
      
      function stopStartDragTimer() : void;
      
      function registerDropable(param1:IDropable) : void;
      
      function unregisterDropable(param1:IDropable) : void;
      
      function removeAllDropables() : void;
      
      function isDragging() : Boolean;
   }
}

