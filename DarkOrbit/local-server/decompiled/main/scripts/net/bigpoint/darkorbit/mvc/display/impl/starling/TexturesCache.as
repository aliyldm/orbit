package net.bigpoint.darkorbit.mvc.display.impl.starling
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import net.bigpoint.eventstream.EventStreamClient;
   import starling.textures.Texture;
   
   public class TexturesCache
   {
      
      private static var EMPTY:Texture;
      
      private static const CACHE:Dictionary = new Dictionary(true);
      
      public function TexturesCache()
      {
         super();
      }
      
      public static function getTexture(param1:*, param2:Rectangle = null) : Texture
      {
         if(param1 == null)
         {
            return EMPTY = EMPTY || Texture.empty(8,8);
         }
         var _loc3_:Texture = CACHE[param1] as Texture;
         if(_loc3_ == null)
         {
            _loc3_ = Texture.fromData(param1);
            CACHE[param1] = _loc3_;
         }
         if(param2)
         {
            param2 = param2.clone();
            param2.left = Math.max(param2.left,0);
            param2.right = Math.min(param2.right,_loc3_.width);
            param2.top = Math.max(param2.top,0);
            param2.bottom = Math.min(param2.bottom,_loc3_.height);
            _loc3_ = Texture.fromTexture(_loc3_,param2);
         }
         return _loc3_;
      }
      
      public static function cleanup() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:* = undefined;
         for(_loc2_ in CACHE)
         {
            _loc1_ = CACHE[_loc2_];
            _loc1_.dispose();
            _loc1_.root.dispose();
            CACHE[_loc2_] = null;
            delete CACHE[_loc2_];
         }
      }
      
      public static function reupload(param1:Texture, param2:Object) : void
      {
         var texture:Texture = param1;
         var data:Object = param2;
         if(texture == null || data == null)
         {
            return;
         }
         if(data is Bitmap)
         {
            data = (data as Bitmap).bitmapData;
         }
         if(data is Class)
         {
            data = new data();
         }
         try
         {
            if(data is BitmapData)
            {
               texture.root.uploadBitmapData(data as BitmapData);
            }
            else if(data is ByteArray)
            {
               texture.root.uploadAtfData(data as ByteArray,0);
            }
         }
         catch(e:Error)
         {
            EventStreamClient.track("flash.warning",{
               "message":"TexturesCache.reupload failed",
               "errorMessage":e.message,
               "errorID":e.errorID
            });
         }
      }
   }
}

