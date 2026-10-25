package net.bigpoint.darkorbit.loadingscreen.utils
{
   import flash.display.BitmapData;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ImageUtils
   {
      
      public function ImageUtils()
      {
         super();
      }
      
      public static function setGrayScale(param1:BitmapData) : void
      {
         var _loc2_:Number = 0.2225;
         var _loc3_:Number = 0.7169;
         var _loc4_:Number = 0.0606;
         var _loc5_:Array = [_loc2_,_loc3_,_loc4_,0,0,_loc2_,_loc3_,_loc4_,0,0,_loc2_,_loc3_,_loc4_,0,0,0,0,0,1,0];
         var _loc6_:ColorMatrixFilter = new ColorMatrixFilter(_loc5_);
         param1.applyFilter(param1,new Rectangle(0,0,param1.width,param1.height),new Point(0,0),_loc6_);
      }
   }
}

