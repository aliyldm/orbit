package net.bigpoint.darkorbit.loadingscreen.mvc.assets.model
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.notifications.AssetNotification;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class AssetsProxy extends Proxy implements IProxy
   {
      
      public static const PROXY_NAME:String = "AssetsProxy";
      
      private static var _resourceLoaders:Dictionary = new Dictionary();
      
      public static var libs:Dictionary = new Dictionary();
      
      private var loadedEventName:String;
      
      private var fileCollection:FileCollection;
      
      private var callbacks:Dictionary = new Dictionary();
      
      public function AssetsProxy(param1:String, param2:String)
      {
         super(param1,null);
         this.loadedEventName = param2;
      }
      
      public static function registerLib(param1:Class, param2:String) : void
      {
         libs[param2] = param1;
      }
      
      public static function loadResource(param1:String, param2:Function) : void
      {
         var _loc3_:URLRequest = new URLRequest(param1);
         var _loc4_:Loader = new Loader();
         _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,resourceLoadedHandler);
         _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleResourceIOError);
         _loc4_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleResourceSecurityError);
         _resourceLoaders[_loc4_.contentLoaderInfo] = param2;
         _loc4_.load(_loc3_);
      }
      
      private static function resourceLoadedHandler(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:Function = _resourceLoaders[_loc2_];
         _loc3_.call(null,param1);
         cleanUpResourceLoader(_loc2_,_loc3_);
      }
      
      private static function handleResourceIOError(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:Function = _resourceLoaders[_loc2_];
         cleanUpResourceLoader(_loc2_,_loc3_);
      }
      
      private static function handleResourceSecurityError(param1:SecurityErrorEvent) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:Function = _resourceLoaders[_loc2_];
         cleanUpResourceLoader(_loc2_,_loc3_);
      }
      
      private static function cleanUpResourceLoader(param1:LoaderInfo, param2:Function) : void
      {
         if(param1.hasEventListener(Event.COMPLETE))
         {
            param1.removeEventListener(Event.COMPLETE,param2);
         }
         if(param1.hasEventListener(IOErrorEvent.IO_ERROR))
         {
            param1.removeEventListener(IOErrorEvent.IO_ERROR,handleResourceIOError);
         }
         if(param1.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
         {
            param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,handleResourceSecurityError);
         }
         delete _resourceLoaders[param1];
      }
      
      public function init() : void
      {
         var _loc1_:String = Session.cdnHost + "spacemap/";
         var _loc2_:Boolean = true;
         this.fileCollection = new FileCollection(_loc1_,_loc2_);
         this.fileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleConfigXMLLoaded);
         this.fileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_SECURITY_BREACH,this.handleConfigXMLLoadingError);
         this.fileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_FORMAT_ERROR,this.handleConfigXMLLoadingError);
         this.fileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_NOT_FOUND,this.handleConfigXMLLoadingError);
         var _loc3_:String = "xml/assets_loadingScreen.xml?__cv=" + Session.loadingscreenAssetsXmlHash;
         JavascriptProxy.log("load assets",_loc3_);
         this.fileCollection.loadResourceFile(_loc3_);
      }
      
      public function handleConfigXMLLoaded(param1:FileCollectionEvent) : void
      {
         sendNotification(AssetNotification.READY);
      }
      
      private function handleConfigXMLLoadingError(param1:FileCollectionEvent) : void
      {
      }
      
      public function getMovieClip(param1:String, param2:String) : MovieClip
      {
         return SWFFinisher(this.fileCollection.getFinisher(param1)).getEmbeddedMovieClip(param2);
      }
      
      public function getBitmap(param1:String, param2:String) : Bitmap
      {
         return SWFFinisher(this.fileCollection.getFinisher(param1)).getEmbeddedBitmap(param2);
      }
      
      public function getBitmapData(param1:String, param2:String) : BitmapData
      {
         return SWFFinisher(this.fileCollection.getFinisher(param1)).getEmbeddedBitmapData(param2);
      }
      
      public function getSound(param1:String, param2:String) : Sound
      {
         return SWFFinisher(this.fileCollection.getFinisher(param1)).getEmbeddedSound(param2);
      }
      
      public function getImage(param1:String) : DisplayObject
      {
         return ImageFinisher(this.fileCollection.getFinisher(param1)).getBitmap();
      }
      
      public function isLoaded(param1:String) : Boolean
      {
         return this.fileCollection.isLoaded(param1);
      }
      
      public function load(param1:String, param2:Function, param3:Function = null) : void
      {
         this.fileCollection.load(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         if(this.callbacks[param1] == null)
         {
            this.callbacks[param1] = [];
         }
         (this.callbacks[param1] as Array).push(param2);
      }
      
      public function getLib(param1:String) : SWFFinisher
      {
         return this.fileCollection.getFinisher(param1) as SWFFinisher;
      }
      
      public function cleanup() : void
      {
         this.callbacks = null;
         libs = null;
         this.fileCollection.clearCollection();
         this.fileCollection = null;
      }
   }
}

