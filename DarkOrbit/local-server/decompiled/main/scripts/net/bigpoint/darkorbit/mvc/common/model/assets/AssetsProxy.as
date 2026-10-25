package net.bigpoint.darkorbit.mvc.common.model.assets
{
   import com.bigpoint.utils.BitmapAtlas;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.system.loader.IAssetLoader;
   import net.bigpoint.darkorbit.mvc.common.model.assets.newLazyLoader.NewLazyFileCollectionLoader;
   import net.bigpoint.darkorbit.mvc.common.model.external.ExternalLoader;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class AssetsProxy extends Proxy implements IProxy, IAssetLoader
   {
      
      public static const NAME:String = "AssetsProxy";
      
      public static const ACHIEVEMENTS:String = "ACHIEVEMENTS";
      
      public static const ITEMS:String = "ITEMS";
      
      public static const GAME:String = "GAME";
      
      public static const NEWS:String = "NEWS";
      
      public static const EVENTS:String = "EVENTS";
      
      public static const JUMPGATE:String = "JUMPGATE";
      
      private var _loadingQueueRunning:Boolean;
      
      private var _loadingQueue:Vector.<String> = new Vector.<String>();
      
      private var _lazyLoaderObjects:Dictionary = new Dictionary();
      
      private var _externalLoader:ExternalLoader = new ExternalLoader();
      
      private var _fileCollcetionDict:Dictionary = new Dictionary();
      
      private var _bitmapAtlases:Dictionary = new Dictionary();
      
      public function AssetsProxy()
      {
         super(NAME,null);
      }
      
      public function addFileCollection(param1:FileCollection = null, param2:String = "GAME") : void
      {
         this._fileCollcetionDict[param2] = param1;
      }
      
      public function getMovieClip(param1:String, param2:String, param3:String = "GAME") : MovieClip
      {
         var _loc4_:FileCollection = this.getFileCollectionByInstanceName(param3);
         var _loc5_:SWFFinisher = SWFFinisher(_loc4_.getFinisher(param1));
         if(_loc5_.hasEmbeddedObject(param2))
         {
            return _loc5_.getEmbeddedMovieClip(param2);
         }
         return null;
      }
      
      public function getFileCollectionByInstanceName(param1:String) : FileCollection
      {
         return this._fileCollcetionDict[param1] as FileCollection;
      }
      
      public function getBitmap(param1:String, param2:String, param3:String = "GAME") : Bitmap
      {
         var _loc4_:FileCollection = this.getFileCollectionByInstanceName(param3);
         return SWFFinisher(_loc4_.getFinisher(param1)).getEmbeddedBitmap(param2);
      }
      
      public function getBitmapData(param1:String, param2:String, param3:String = "GAME") : BitmapData
      {
         var _loc4_:FileCollection = this.getFileCollectionByInstanceName(param3);
         return SWFFinisher(_loc4_.getFinisher(param1)).getEmbeddedBitmapData(param2);
      }
      
      public function getSound(param1:String, param2:String, param3:String = "GAME") : Sound
      {
         var _loc4_:FileCollection = this.getFileCollectionByInstanceName(param3);
         if(SWFFinisher(_loc4_.getFinisher(param1)).hasEmbeddedObject(param2))
         {
            return SWFFinisher(_loc4_.getFinisher(param1)).getEmbeddedSound(param2);
         }
         return null;
      }
      
      public function getImage(param1:String, param2:String = "GAME") : DisplayObject
      {
         var _loc3_:FileCollection = this.getFileCollectionByInstanceName(param2);
         return ImageFinisher(_loc3_.getFinisher(param1)).getBitmap();
      }
      
      public function isLoaded(param1:String, param2:String = "GAME") : Boolean
      {
         var _loc3_:FileCollection = this.getFileCollectionByInstanceName(param2);
         var _loc4_:FileCollectionFinisher = _loc3_.getFinisher(param1);
         return _loc4_ ? _loc4_.isFinished : false;
      }
      
      public function loadAsset(param1:String, param2:Function, param3:Function = null) : void
      {
         this.load(param1,param2,param3);
      }
      
      public function load(param1:String, param2:Function, param3:Function = null, param4:String = "GAME") : void
      {
         var _loc5_:FileCollection = this.getFileCollectionByInstanceName(param4);
         _loc5_.load(param1,param2,param3);
      }
      
      public function lazyLoad(param1:String, param2:Function, param3:Function = null, param4:String = "GAME") : void
      {
         var _loc7_:NewLazyFileCollectionLoader = null;
         var _loc5_:FileCollection = this.getFileCollectionByInstanceName(param4);
         if(_loc5_.isLoaded(param1))
         {
            param2(_loc5_.getFinisher(param1));
            return;
         }
         var _loc6_:NewLazyFileCollectionLoader = this._lazyLoaderObjects[param1] as NewLazyFileCollectionLoader;
         if(_loc6_ != null)
         {
            _loc6_.addCompleteCallback(param2);
            _loc6_.addErrorCallback(param3);
            if(!_loc6_.inProgress)
            {
               _loc6_.load();
            }
         }
         else
         {
            _loc7_ = new NewLazyFileCollectionLoader(param1,param2,param3,_loc5_,this.onRemoveNewLazyFileCollectionLoaderCallback);
            _loc7_.load();
            this._lazyLoaderObjects[_loc7_] = _loc7_;
         }
      }
      
      private function onRemoveNewLazyFileCollectionLoaderCallback(param1:NewLazyFileCollectionLoader) : void
      {
         delete this._lazyLoaderObjects[param1];
      }
      
      public function getLib(param1:String, param2:String = "GAME") : FileCollectionFinisher
      {
         var _loc3_:FileCollection = this.getFileCollectionByInstanceName(param2);
         return _loc3_.getFinisher(param1) as FileCollectionFinisher;
      }
      
      public function clearFileCollection(param1:String) : void
      {
         var _loc2_:FileCollection = this.getFileCollectionByInstanceName(param1);
         if(_loc2_)
         {
            _loc2_.cleanUpAllFinishers();
         }
      }
      
      public function loadAndCall(param1:String, param2:Function, param3:Array, param4:String = "GAME", param5:int = 0) : void
      {
         var time:int = 0;
         var resKey:String = param1;
         var call:Function = param2;
         var callArgs:Array = param3;
         var instanceName:String = param4;
         var maxdelay:int = param5;
         time = maxdelay > 0 ? getTimer() : 0;
         this.lazyLoad(resKey,function(param1:FileCollectionFinisher):void
         {
            if(maxdelay == 0 || getTimer() - time < maxdelay)
            {
               call.apply(undefined,callArgs);
            }
         },null,instanceName);
      }
      
      public function addBitmapAtlas(param1:String, param2:BitmapAtlas) : void
      {
         this._bitmapAtlases[param1] = param2;
      }
      
      public function getBitmapDataFromAtlas(param1:String, param2:String) : BitmapData
      {
         var _loc3_:BitmapAtlas = this.getBitmapAtlasById(param2);
         return _loc3_.getBitmapDataByName(param1);
      }
      
      public function getBitmapAtlasById(param1:String) : BitmapAtlas
      {
         return this._bitmapAtlases[param1] as BitmapAtlas;
      }
      
      public function loaderExternal(param1:String, param2:Function) : void
      {
         this._externalLoader.load(param1,param2);
      }
      
      public function cleanupExternalLoader() : void
      {
         this._externalLoader.cleanup();
      }
      
      public function addToPreloadList(param1:String, param2:Boolean = false) : void
      {
         if(this._loadingQueueRunning)
         {
            if(param2)
            {
               this._loadingQueue.push(param1);
            }
            else
            {
               this._loadingQueue.unshift(param1);
            }
         }
         else
         {
            this._loadingQueueRunning = true;
            this.lazyLoad(param1,this.assetQueueHandelLoaded,this.assetQueueHandelFailed);
         }
      }
      
      private function assetQueueHandelFailed(param1:Object) : void
      {
         this.continueLoading();
      }
      
      private function assetQueueHandelLoaded(param1:FileCollectionFinisher) : void
      {
         this.continueLoading();
      }
      
      private function continueLoading() : void
      {
         if(this._loadingQueue.length > 0)
         {
            this.lazyLoad(this._loadingQueue.pop(),this.assetQueueHandelLoaded);
         }
         else
         {
            this._loadingQueueRunning = false;
         }
      }
      
      public function getDisplayObject(param1:String, param2:String, param3:String = "GAME") : DisplayObject
      {
         var _loc6_:DisplayObject = null;
         var _loc4_:SWFFinisher = this.getLib(param1,param3) as SWFFinisher;
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:Object = _loc4_.getEmbeddedObject(param2);
         if(_loc5_ is BitmapData)
         {
            _loc6_ = new Bitmap(_loc5_ as BitmapData);
         }
         else
         {
            _loc6_ = _loc5_ as DisplayObject;
         }
         return _loc6_;
      }
      
      public function removeCallback(param1:String, param2:Function, param3:String = "GAME") : void
      {
         this.getFileCollectionByInstanceName(param3).removeCallbacks(param1,param2);
      }
      
      public function hasFile(param1:String, param2:String = "GAME") : Boolean
      {
         return this.getFileCollectionByInstanceName(param2).listOfFiles[param1] != null;
      }
   }
}

