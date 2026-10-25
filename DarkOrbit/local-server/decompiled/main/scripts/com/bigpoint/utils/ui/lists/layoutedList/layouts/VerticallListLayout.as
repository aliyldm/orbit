package com.bigpoint.utils.ui.lists.layoutedList.layouts
{
   import flash.geom.Point;
   
   public class VerticallListLayout extends AbstractListLayout
   {
      
      public static const ID:String = "verticallListLayout";
      
      public function VerticallListLayout()
      {
         super();
      }
      
      override public function getItemPosition(param1:int, param2:int) : Point
      {
         var _loc3_:int = param2 * param1;
         return new Point(0 + _xOffset,_loc3_ + _yOffset);
      }
      
      override public function getContainerPosition(param1:int, param2:int) : Point
      {
         var _loc3_:int = param2 * param1;
         return new Point(0,_loc3_);
      }
      
      override public function getFixItemPosition(param1:int, param2:int, param3:int) : Point
      {
         var _loc4_:Point = this.getItemPosition(param1,param2);
         _loc4_.x = param3;
         return _loc4_;
      }
      
      override public function get id() : String
      {
         return ID;
      }
   }
}

