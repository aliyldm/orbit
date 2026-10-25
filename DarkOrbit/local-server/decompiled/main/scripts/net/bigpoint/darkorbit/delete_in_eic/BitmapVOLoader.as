package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class BitmapVOLoader extends EventDispatcher
   {
      
      private static var loaders:Dictionary = new Dictionary();
      
      private static var map:Dictionary = new Dictionary();
      
      public function BitmapVOLoader()
      {
         super();
      }
      
      public function getRes(param1:String) : void
      {
         var _loc2_:Loader = null;
         if(map[param1])
         {
            this.dispatchEvent(new BitmapVO(param1,map[param1]));
            if(loaders[param1])
            {
               this.unLoad(loaders[param1]);
            }
         }
         else
         {
            if(loaders[param1])
            {
               _loc2_ = loaders[param1];
               _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
               _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
               return;
            }
            _loc2_ = new Loader();
            loaders[param1] = _loc2_;
            _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
            _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            _loc2_.load(new URLRequest(param1));
         }
      }
      
      private function errorHandler(param1:Event) : void
      {
         var _loc2_:Loader = param1.currentTarget.loader;
         this.unLoad(_loc2_);
      }
      
      private function unLoad(param1:Loader) : void
      {
         var _loc2_:String = null;
         param1.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.completeHandler);
         param1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         if(param1.contentLoaderInfo.url)
         {
            loaders[param1.contentLoaderInfo.url] = null;
            delete loaders[param1.contentLoaderInfo.url];
         }
         else
         {
            for(_loc2_ in loaders)
            {
               if(loaders[_loc2_] == param1)
               {
                  loaders[_loc2_] = null;
                  delete loaders[_loc2_];
                  break;
               }
            }
         }
         param1.unload();
      }
      
      private function completeHandler(param1:Event) : void
      {
         var _loc3_:Bitmap = null;
         var _loc4_:MovieClip = null;
         var _loc2_:Loader = param1.currentTarget.loader as Loader;
         if(_loc2_.content as Bitmap)
         {
            _loc3_ = _loc2_.content as Bitmap;
            map[_loc2_.contentLoaderInfo.url] = _loc3_.bitmapData;
         }
         else if(_loc2_.content as MovieClip)
         {
            _loc4_ = _loc2_.content as MovieClip;
            map[_loc2_.contentLoaderInfo.url] = _loc4_;
         }
         this.dispatchEvent(new BitmapVO(_loc2_.contentLoaderInfo.url,map[_loc2_.contentLoaderInfo.url]));
      }
   }
}

