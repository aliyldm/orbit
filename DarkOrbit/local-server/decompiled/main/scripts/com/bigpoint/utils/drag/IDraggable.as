package com.bigpoint.utils.drag
{
   import com.bigpoint.utils.ui.IDisplayObjectAccessible;
   import flash.geom.Point;
   
   public interface IDraggable extends IDisplayObjectAccessible
   {
      
      function get dragOffset() : Point;
      
      function get preview() : IDragablePreview;
      
      function get data() : Object;
   }
}

