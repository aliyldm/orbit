package net.bigpoint.darkorbit.fui.components.text.input.validators
{
   import flash.events.IEventDispatcher;
   
   public interface IInputValidator extends IEventDispatcher
   {
      
      function isValid() : Boolean;
      
      function set source(param1:Object) : void;
      
      function get source() : Object;
      
      function dispose() : void;
   }
}

