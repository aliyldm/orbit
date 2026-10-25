package net.bigpoint.darkorbit.fui.system.manager.dragNdrop
{
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   
   public interface IDragProxy
   {
      
      function create() : void;
      
      function destroy() : void;
      
      function set dragables(param1:Vector.<DisplayObject>) : void;
      
      function set dragStartCoreponent(param1:ICoreponent) : void;
      
      function set enableDragZoneEventHandling(param1:Boolean) : void;
      
      function onMouseMove() : void;
      
      function onDragZoneEnter() : void;
      
      function onDragZoneLeave() : void;
      
      function onDropFailed() : void;
      
      function onDropSuccess() : void;
   }
}

