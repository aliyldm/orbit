package net.bigpoint.darkorbit.mvc.hints.view.effects.interfaces
{
   import flash.display.DisplayObject;
   
   public interface IShowHideEffect
   {
      
      function show(param1:DisplayObject) : void;
      
      function hide(param1:DisplayObject, param2:Function) : void;
   }
}

