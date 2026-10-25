package net.bigpoint.darkorbit.map.view2D.display.ship
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public final class ReducedShipIcon2D
   {
      
      private static var _bitmapData:BitmapData;
      
      private static const GrayShipAsset:Class = ReducedShipIcon2D_GrayShipAsset;
      
      private static const SIZE:int = 100;
      
      public function ReducedShipIcon2D()
      {
         super();
      }
      
      public static function create() : Bitmap
      {
         if(!_bitmapData)
         {
            bake();
         }
         var _loc1_:Bitmap = new Bitmap(_bitmapData);
         _loc1_.x = _loc1_.y = -SIZE * 0.5;
         _loc1_.smoothing = true;
         _loc1_.alpha = 0.75;
         return _loc1_;
      }
      
      public static function orient(param1:Bitmap, param2:Number) : void
      {
         var _loc3_:Number = (param2 + 90) * Math.PI / 180;
         var _loc4_:Number = Math.cos(_loc3_);
         var _loc5_:Number = Math.sin(_loc3_);
         var _loc6_:Number = SIZE * 0.5;
         param1.transform.matrix = new Matrix(_loc4_,_loc5_,-_loc5_,_loc4_,-_loc6_ * (_loc4_ - _loc5_),-_loc6_ * (_loc5_ + _loc4_));
      }
      
      private static function bake() : void
      {
         var _loc1_:Bitmap = new GrayShipAsset() as Bitmap;
         var _loc2_:Rectangle = _loc1_.bitmapData.getColorBoundsRect(4278190080,0,false);
         var _loc3_:Number = (SIZE - 4) / Math.max(_loc2_.width,_loc2_.height);
         var _loc4_:Matrix = new Matrix(_loc3_,0,0,_loc3_,SIZE * 0.5 - (_loc2_.x + _loc2_.width * 0.5) * _loc3_,SIZE * 0.5 - (_loc2_.y + _loc2_.height * 0.5) * _loc3_);
         _bitmapData = new BitmapData(SIZE,SIZE,true,0);
         _bitmapData.draw(_loc1_.bitmapData,_loc4_,null,null,null,true);
         _loc1_.bitmapData.dispose();
      }
   }
}

