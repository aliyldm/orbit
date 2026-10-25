package com.bigpoint.filecollection.finish
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.system.ImageDecodingPolicy;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class ImageFinisher extends FileCollectionFinisher
   {
      
      private var loader:Loader;
      
      public function ImageFinisher()
      {
         super();
      }
      
      public function getBitmap() : Bitmap
      {
         return Bitmap(this.loader.content);
      }
      
      override protected function start() : void
      {
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.handleLoaderInit);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleLoadComplete);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoaderError);
         var _loc1_:LoaderContext = new LoaderContext();
         _loc1_.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
         this.loader.loadBytes(_data as ByteArray,_loc1_);
      }
      
      override protected function disposeFinisher() : void
      {
         if(this.loader)
         {
            if(this.loader.content is Bitmap && Bitmap(this.loader.content).bitmapData != null)
            {
               Bitmap(this.loader.content).bitmapData.dispose();
            }
            this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.handleLoaderInit);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleLoadComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoaderError);
            this.loader.unloadAndStop(true);
            this.loader = null;
         }
      }
      
      private function handleLoaderInit(param1:Event) : void
      {
      }
      
      private function handleLoaderError(param1:IOErrorEvent) : void
      {
      }
      
      protected function handleLoadComplete(param1:Event) : void
      {
         finish();
      }
   }
}

