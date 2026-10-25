package net.bigpoint.darkorbit.mvc.display
{
   public interface IDOSprite extends IDODisplayObject
   {
      
      function do_addChild(param1:IDODisplayObject) : void;
      
      function do_addChildAt(param1:IDODisplayObject, param2:int) : void;
      
      function do_removeChild(param1:IDODisplayObject) : IDODisplayObject;
      
      function do_removeChildAt(param1:int) : IDODisplayObject;
      
      function do_contains(param1:IDODisplayObject) : Boolean;
      
      function get mouseEnabled() : Boolean;
      
      function set mouseEnabled(param1:Boolean) : void;
      
      function set useHandCursor(param1:Boolean) : void;
      
      function get mouseX() : Number;
      
      function get mouseY() : Number;
      
      function removeAndDisposeChildren() : void;
      
      function addUntypedChild(param1:Object) : void;
      
      function containsUntypedChild(param1:Object) : Boolean;
      
      function removeUntypedChildAt(param1:int, param2:Boolean = true) : Object;
      
      function removeUntypedChild(param1:Object, param2:Boolean = true) : Object;
   }
}

