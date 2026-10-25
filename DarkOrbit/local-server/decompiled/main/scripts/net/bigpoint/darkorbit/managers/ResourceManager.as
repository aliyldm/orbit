package net.bigpoint.darkorbit.managers
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import flash.utils.getTimer;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.lazyload.LazyLoadVO;
   
   public class ResourceManager
   {
      
      public static var fileCollection:FileCollection;
      
      private static const MAX_TRIES:int = 4;
      
      private static var lazyLoaderObjects:Array = [];
      
      private static var lazyLoaderObjectsTries:Array = [];
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function removeLazyLoaderObject(param1:String) : void
      {
         lazyLoaderObjects[param1] = null;
      }
      
      public static function loadAndCall(param1:String, param2:Function, param3:Array, param4:int = 0) : void
      {
         var time:int = 0;
         var resKey:String = param1;
         var call:Function = param2;
         var callArgs:Array = param3;
         var maxdelay:int = param4;
         time = maxdelay > 0 ? getTimer() : 0;
         fileCollection.load(resKey,function(param1:FileCollectionFinisher):void
         {
            if(maxdelay == 0 || getTimer() - time < maxdelay)
            {
               call.apply(undefined,callArgs);
            }
         },null);
      }
      
      public static function init(param1:FileCollection) : void
      {
         fileCollection = param1;
      }
      
      public static function getDisplayObject(param1:String, param2:String) : DisplayObject
      {
         var _loc3_:SWFFinisher = SWFFinisher(fileCollection.getFinisher(param1));
         if(_loc3_.hasEmbeddedObject(param2))
         {
            return _loc3_.getEmbeddedMovieClip(param2) || _loc3_.getEmbeddedBitmap(param2);
         }
         return null;
      }
      
      public static function getMovieClip(param1:String, param2:String) : MovieClip
      {
         if(SWFFinisher(fileCollection.getFinisher(param1)).hasEmbeddedObject(param2))
         {
            return SWFFinisher(fileCollection.getFinisher(param1)).getEmbeddedMovieClip(param2);
         }
         return null;
      }
      
      public static function getBitmap(param1:String, param2:String) : Bitmap
      {
         return SWFFinisher(fileCollection.getFinisher(param1)).getEmbeddedBitmap(param2);
      }
      
      public static function getBitmapData(param1:String, param2:String) : BitmapData
      {
         return SWFFinisher(fileCollection.getFinisher(param1)).getEmbeddedBitmapData(param2);
      }
      
      public static function getSound(param1:String, param2:String) : Sound
      {
         var _loc3_:SWFFinisher = fileCollection.getFinisher(param1) as SWFFinisher;
         if(Boolean(_loc3_) && _loc3_.hasEmbeddedObject(param2))
         {
            return _loc3_.getEmbeddedSound(param2);
         }
         return null;
      }
      
      public static function getImage(param1:String) : DisplayObject
      {
         return ImageFinisher(fileCollection.getFinisher(param1)).getBitmap();
      }
      
      public static function lazyGetAsset(param1:String, param2:Function, param3:Function) : void
      {
         var _loc5_:LazyLoadVO = null;
         if(fileCollection.isLoaded(param1))
         {
            param2(fileCollection.getFinisher(param1));
            return;
         }
         var _loc4_:LazyLoadVO = lazyLoaderObjects[param1] as LazyLoadVO;
         if(_loc4_ != null)
         {
            _loc4_.addCompleteCallback(param2);
            _loc4_.addErrorCallback(param3);
            if(!_loc4_.inProgress)
            {
               _loc4_.load();
            }
         }
         else
         {
            if(lazyLoaderObjectsTries[param1] != null && lazyLoaderObjectsTries[param1] > MAX_TRIES)
            {
               return;
            }
            _loc5_ = new LazyLoadVO(param1,param2,param3);
            _loc5_.load();
            lazyLoaderObjects[param1] = _loc5_;
            if(lazyLoaderObjectsTries[param1] == null)
            {
               lazyLoaderObjectsTries[param1] = 1;
            }
            else
            {
               lazyLoaderObjectsTries[param1] += 1;
            }
         }
      }
      
      public static function isLoaded(param1:String) : Boolean
      {
         var _loc2_:FileCollectionFinisher = fileCollection.getFinisher(param1);
         return _loc2_ ? _loc2_.isFinished : false;
      }
   }
}

