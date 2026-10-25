package com.bigpoint.utils.ui.lists.layoutedList.layouts
{
   import flash.geom.Point;
   
   public class HorizontalListLayout extends AbstractListLayout
   {
      
      public static const ID:String = "horizontalListLayout";
      
      public function HorizontalListLayout()
      {
         super();
      }
      
      override public function getItemPosition(param1:int, param2:int) : Point
      {
         var _loc3_:int = param2 * param1;
         return new Point(_loc3_ + _xOffset,0 + _yOffset);
      }
      
      override public function getFixItemPosition(param1:int, param2:int, param3:int) : Point
      {
         var _loc4_:int = param2 * param1;
         return new Point(_loc4_ + _xOffset,param3 + _yOffset);
      }
      
      override public function getContainerPosition(param1:int, param2:int) : Point
      {
         var _loc3_:int = param2 * param1;
         return new Point(_loc3_,0);
      }
      
      override public function get id() : String
      {
         return ID;
      }
   }
}

