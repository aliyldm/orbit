package com.bigpoint.utils.drag
{
   import com.bigpoint.utils.ui.IDisplayObjectAccessible;
   import flash.geom.Point;
   
   public interface IDragablePreview extends IDisplayObjectAccessible
   {
      
      function dropAccept(param1:Function) : void;
      
      function dropNotAccept(param1:Function, param2:Point = null) : void;
      
      function dispose() : void;
      
      function get snapToDropTarget() : Boolean;
      
      function get x() : Number;
      
      function get y() : Number;
      
      function set x(param1:Number) : void;
      
      function set y(param1:Number) : void;
      
      function get dropOffset() : Point;
   }
}

