package com.bigpoint.utils.ui.lists.layoutedList.layouts
{
   import flash.geom.Point;
   
   public class ProActionHorizontalGridLayout extends AbstractListLayout
   {
      
      public static const ID:String = "proActionHorizontalGridLayout";
      
      private static const BASE_POSITIONS:Object = {};
      
      BASE_POSITIONS[0] = new Point(1,0);
      BASE_POSITIONS[1] = new Point(2,0);
      BASE_POSITIONS[2] = new Point(3,0);
      BASE_POSITIONS[3] = new Point(0,1);
      BASE_POSITIONS[4] = new Point(1,1);
      BASE_POSITIONS[5] = new Point(3,1);
      BASE_POSITIONS[6] = new Point(4,1);
      BASE_POSITIONS[7] = new Point(1,2);
      BASE_POSITIONS[8] = new Point(2,2);
      BASE_POSITIONS[9] = new Point(3,2);
      BASE_POSITIONS[10] = new Point(5,1);
      
      public function ProActionHorizontalGridLayout()
      {
         super();
      }
      
      override public function getItemPosition(param1:int, param2:int) : Point
      {
         var _loc3_:Point = (BASE_POSITIONS[param2] as Point).clone();
         _loc3_.x *= param1 + _xOffset;
         _loc3_.y *= param1 + _yOffset;
         return _loc3_;
      }
      
      override public function getContainerPosition(param1:int, param2:int) : Point
      {
         var _loc3_:int = param2 * param1;
         return new Point(0,_loc3_);
      }
      
      override public function get id() : String
      {
         return ID;
      }
   }
}

