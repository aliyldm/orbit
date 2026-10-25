package net.bigpoint.darkorbit.fireworks
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class LightningMaskCache2D
   {
      
      private static var bytes:int;
      
      private static var count:int;
      
      private static var entries:Object = {};
      
      private static var shapes:Dictionary = new Dictionary(true);
      
      private static const ZERO:Point = new Point();
      
      private static const MAX_BYTES:int = 1024 * 1024;
      
      private static const MAX_ENTRIES:int = 512;
      
      public function LightningMaskCache2D()
      {
         super();
      }
      
      public static function define(param1:Sprite, param2:String) : void
      {
         shapes[param1] = param2;
      }
      
      public static function apply(param1:BitmapData, param2:Sprite, param3:int, param4:String) : void
      {
         var _loc7_:Matrix = null;
         var _loc5_:String = shapes[param2] + ":" + param3 + ":" + param4;
         var _loc6_:BitmapData = entries[_loc5_];
         if(!_loc6_)
         {
            if(count >= MAX_ENTRIES || bytes + param3 * 4 > MAX_BYTES)
            {
               clear();
            }
            _loc6_ = new BitmapData(param3,1,true,0);
            _loc7_ = new Matrix();
            _loc7_.scale(param3 / param2.width,1);
            _loc6_.draw(param2,_loc7_);
            entries[_loc5_] = _loc6_;
            ++count;
            bytes += param3 * 4;
         }
         param1.copyPixels(_loc6_,_loc6_.rect,ZERO,null,null,true);
      }
      
      public static function invalidate(param1:Sprite) : void
      {
         delete shapes[param1];
      }
      
      public static function clear() : void
      {
         var _loc1_:BitmapData = null;
         for each(_loc1_ in entries)
         {
            _loc1_.dispose();
         }
         entries = {};
         bytes = count = 0;
      }
   }
}

