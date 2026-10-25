package com.bigpoint.utils.ui.lists.layoutedList.layouts
{
   import flash.geom.Point;
   
   public class HorizontalGridLayout extends AbstractListLayout
   {
      
      public static const ID:String = "horizontalGridLayout";
      
      public static const Three_columns:int = 3;
      
      public static const Four_columns:int = 4;
      
      public var columnsNum:int = 4;
      
      public function HorizontalGridLayout()
      {
         super();
      }
      
      override public function getItemPosition(param1:int, param2:int) : Point
      {
         var _loc3_:int = int(param2 / this.columnsNum);
         var _loc4_:int = param2 % this.columnsNum;
         return this.getPositionInStep(_loc3_,_loc4_,param1);
      }
      
      override public function getFixItemPosition(param1:int, param2:int, param3:int) : Point
      {
         return this.getItemPosition(param1,param2);
      }
      
      private function getPositionInStep(param1:int, param2:int, param3:int) : Point
      {
         var _loc4_:int = param1 * param3;
         var _loc5_:Point = new Point(0,0);
         if(param2 == 0)
         {
            _loc5_.x = _loc4_;
            _loc5_.y = 0;
         }
         else if(param2 == 1)
         {
            _loc5_.x = _loc4_ + Math.ceil(param3 / 2);
            _loc5_.y = -param3;
         }
         else if(param2 == 2)
         {
            _loc5_.x = _loc4_ + Math.ceil(param3 / 2);
            _loc5_.y = param3;
         }
         else
         {
            _loc5_.x = _loc4_;
            _loc5_.y = param3 * 2;
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

