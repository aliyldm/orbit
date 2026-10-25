package com.bigpoint.utils.ui.lists.layoutedList
{
   import flash.geom.Point;
   
   public interface IListLayout
   {
      
      function getItemPosition(param1:int, param2:int) : Point;
      
      function getFixItemPosition(param1:int, param2:int, param3:int) : Point;
      
      function getContainerPosition(param1:int, param2:int) : Point;
      
      function get id() : String;
      
      function set xOffset(param1:int) : void;
      
      function set yOffset(param1:int) : void;
   }
}

