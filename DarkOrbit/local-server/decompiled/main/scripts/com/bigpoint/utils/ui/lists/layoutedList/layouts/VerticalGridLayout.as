package com.bigpoint.utils.ui.lists.layoutedList.layouts
{
   import flash.geom.Point;
   
   public class VerticalGridLayout extends AbstractListLayout
   {
      
      public static const ID:String = "verticalGridLayout";
      
      public function VerticalGridLayout()
      {
         super();
      }
      
      override public function getItemPosition(param1:int, param2:int) : Point
      {
         var _loc3_:int = int(param2 / 3);
         var _loc4_:int = param2 % 3;
         return this.getPositionInStep(_loc3_,_loc4_,param1);
      }
      
      private function getPositionInStep(param1:int, param2:int, param3:int) : Point
      {
         var _loc4_:int = param1 * param3;
         var _loc5_:Point = new Point(0,0);
         if(param2 == 0)
         {
            _loc5_.x = 0;
            _loc5_.y = _loc4_;
         }
         else if(param2 == 1)
         {
            _loc5_.x = -param3;
            _loc5_.y = _loc4_ + Math.ceil(param3 / 2);
         }
         else
         {
            _loc5_.x = param3;
            _loc5_.y = _loc4_ + Math.ceil(param3 / 2);
         }
         _loc5_.x += _xOffset;
         _loc5_.y += _yOffset;
         return _loc5_;
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

