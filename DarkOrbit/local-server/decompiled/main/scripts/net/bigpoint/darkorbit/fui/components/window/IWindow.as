package net.bigpoint.darkorbit.fui.components.window
{
   import flash.events.IEventDispatcher;
   import net.bigpoint.darkorbit.fui.components.core.interfaces.IFocusable;
   
   public interface IWindow extends IEventDispatcher, IFocusable
   {
      
      function get id() : String;
      
      function set x(param1:Number) : void;
      
      function set y(param1:Number) : void;
      
      function setSize(param1:Number, param2:Number) : void;
      
      function showInProgressOverlay() : void;
      
      function hideInProgressOverlay() : void;
   }
}

