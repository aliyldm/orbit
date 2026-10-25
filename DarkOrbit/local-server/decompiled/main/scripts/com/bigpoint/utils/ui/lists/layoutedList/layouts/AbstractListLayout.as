package com.bigpoint.utils.ui.lists.layoutedList.layouts
{
   import com.bigpoint.utils.ui.lists.layoutedList.IListLayout;
   import flash.geom.Point;
   
   public class AbstractListLayout implements IListLayout
   {
      
      protected var _xOffset:int = 0;
      
      protected var _yOffset:int = 0;
      
      public function AbstractListLayout()
      {
         super();
      }
      
      public function getItemPosition(param1:int, param2:int) : Point
      {
         throw new Error("Error: executed getItemPosition in AbstractLayout");
      }
      
      public function getContainerPosition(param1:int, param2:int) : Point
      {
         throw new Error("Error: executed getContainerPosition in AbstractLayout");
      }
      
      public function get id() : String
      {
         throw new Error("Error: executed get id in AbstractLayout");
      }
      
      public function set xOffset(param1:int) : void
      {
         this._xOffset = param1;
      }
      
      public function set yOffset(param1:int) : void
      {
         this._yOffset = param1;
      }
      
      public function getFixItemPosition(param1:int, param2:int, param3:int) : Point
      {
         throw new Error("Error: executed getItemPositionAndSetPoxY in AbstractLayout");
      }
   }
}

