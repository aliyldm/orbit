package net.bigpoint.darkorbit.map.view2D.display.ship.drones
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class DroneFrameCache2D
   {
      
      private static var entries:Object = {};
      
      private static var owners:int = 0;
      
      private static var bytes:Number = 0;
      
      private static const MAX_BYTES:Number = 64 * 1024 * 1024;
      
      public function DroneFrameCache2D()
      {
         super();
      }
      
      public static function acquire() : void
      {
         ++owners;
      }
      
      public static function release() : void
      {
         var _loc1_:Object = null;
         if(owners > 0)
         {
            --owners;
         }
         if(owners == 0)
         {
            for each(_loc1_ in entries)
            {
               BitmapData(_loc1_.pixels).dispose();
            }
            entries = {};
            bytes = 0;
         }
      }
      
      public static function frame(param1:String, param2:int, param3:MovieClip) : Object
      {
         var rect:Rectangle;
         var pixels:BitmapData = null;
         var key:String = param1;
         var index:int = param2;
         var clip:MovieClip = param3;
         key += ":" + index;
         var entry:Object = entries[key];
         if(entry)
         {
            return entry;
         }
         clip.gotoAndStop(index);
         rect = clip.getBounds(clip);
         rect.left = Math.floor(rect.left) - 1;
         rect.top = Math.floor(rect.top) - 1;
         rect.right = Math.ceil(rect.right) + 1;
         rect.bottom = Math.ceil(rect.bottom) + 1;
         if(rect.width <= 0 || rect.height <= 0 || rect.width > 512 || rect.height > 512 || bytes + rect.width * rect.height * 4 > MAX_BYTES)
         {
            return null;
         }
         pixels = new BitmapData(rect.width,rect.height,true,0);
         try
         {
            pixels.drawWithQuality(clip,new Matrix(1,0,0,1,-rect.x,-rect.y),null,null,null,false,"high");
         }
         catch(error:Error)
         {
            pixels.dispose();
            return null;
         }
         entry = {
            "pixels":pixels,
            "x":rect.x,
            "y":rect.y
         };
         entries[key] = entry;
         bytes += rect.width * rect.height * 4;
         return entry;
      }
   }
}

