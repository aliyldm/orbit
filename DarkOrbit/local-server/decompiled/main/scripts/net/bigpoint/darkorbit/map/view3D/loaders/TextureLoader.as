package net.bigpoint.darkorbit.map.view3D.loaders
{
   import away3d.core.managers.Stage3DProxy;
   import away3d.textures.TextureProxyBase;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import org.osflash.signals.Promise;
   
   public class TextureLoader extends AbstractLoader
   {
      
      private var _stage3DProxy:Stage3DProxy;
      
      public function TextureLoader(param1:Stage3DProxy)
      {
         super(this.disposeTexture,5);
         this._stage3DProxy = param1;
      }
      
      public function isTextureLoaded(param1:String) : Boolean
      {
         return Boolean(_loaders[param1]) && SingleTextureLoader(_loaders[param1]).content != null;
      }
      
      public function loadTexture(param1:String, param2:uint, param3:FileCollection = null) : Promise
      {
         var _loc4_:SingleTextureLoader = _loaders[param1] as SingleTextureLoader;
         if(_loc4_ == null || Settings3D.cacheDisabled.value)
         {
            _loaders[param1] = _loc4_ = new SingleTextureLoader(this._stage3DProxy,param1,param3 || World3D.instance.fileCollection);
            _loc4_.load();
         }
         _loc4_.lifetime = Math.max(_loc4_.lifetime,param2);
         return _loc4_.ready;
      }
      
      public function loadTextureBytes(param1:ByteArray) : Promise
      {
         var _loc2_:SingleTextureLoader = new SingleTextureLoader(this._stage3DProxy,null,null);
         _loc2_.loadData(param1);
         return _loc2_.ready;
      }
      
      public function useTexture(param1:TextureProxyBase) : void
      {
         useObj(param1);
      }
      
      public function freeTexture(param1:TextureProxyBase) : void
      {
         freeObj(param1);
      }
      
      override public function reset(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:SingleTextureLoader = null;
         for(_loc2_ in _loaders)
         {
            _loc3_ = _loaders[_loc2_];
            if(_loc3_.lifetime <= param1)
            {
               _loc3_.dispose();
               _loaders[_loc2_] = null;
               delete _loaders[_loc2_];
            }
         }
         super.reset(param1);
      }
      
      private function disposeTexture(param1:TextureProxyBase) : void
      {
         var _loc2_:String = null;
         var _loc3_:SingleTextureLoader = null;
         for(_loc2_ in _loaders)
         {
            _loc3_ = _loaders[_loc2_];
            if(_loc3_.content == param1 && _loc3_.lifetime <= World3D.LIFETIME_USE_COUNTER)
            {
               _loc3_.dispose();
               _loaders[_loc2_] = null;
               delete _loaders[_loc2_];
               return;
            }
         }
      }
   }
}

import away3d.core.managers.Stage3DProxy;
import away3d.textures.ATFTexture;
import away3d.textures.BitmapTexture;
import away3d.textures.TextureProxyBase;
import flash.utils.ByteArray;
import net.bigpoint.as3toolbox.filecollection.FileCollection;
import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
import org.osflash.signals.Promise;

class SingleTextureLoader
{
   
   public const ready:Promise = new Promise(TextureProxyBase);
   
   public var lifetime:uint = World3D.LIFETIME_USE_COUNTER;
   
   private var _stage3DProxy:Stage3DProxy;
   
   private var _resKey:String;
   
   private var _content:TextureProxyBase;
   
   private var _fileCollection:FileCollection;
   
   public function SingleTextureLoader(param1:Stage3DProxy, param2:String, param3:FileCollection)
   {
      super();
      this._stage3DProxy = param1;
      this._resKey = param2;
      this._fileCollection = param3;
   }
   
   public function load() : void
   {
      this._fileCollection.load(this._resKey,this.handleBytesLoadComplete,this.handleLoadError);
   }
   
   public function loadData(param1:ByteArray) : void
   {
      var data:ByteArray = param1;
      this.dispose();
      this._content = new ATFTexture(data,true);
      if(Boolean(this._stage3DProxy.recoverFromDisposal()) && Boolean(this._stage3DProxy.context3D))
      {
         try
         {
            this._content.getTextureForStage3D(this._stage3DProxy);
            ATFTexture(this._content).ready.addOnce(this.dispatchReady);
         }
         catch(e:Error)
         {
            dispatchReady();
         }
      }
      else
      {
         this.dispatchReady();
      }
   }
   
   public function dispose() : void
   {
      if(this._content)
      {
         this._content.dispose();
         this._content = null;
      }
   }
   
   public function get content() : TextureProxyBase
   {
      return this._content;
   }
   
   public function get resKey() : String
   {
      return this._resKey;
   }
   
   private function handleBytesLoadComplete(param1:FileCollectionFinisher) : void
   {
      if(param1 is DefaultFinisher)
      {
         this.loadData(DefaultFinisher(param1).data);
         this._content.name = this.resKey;
         param1.dispose();
      }
      else if(param1 is ImageFinisher)
      {
         this._content = new BitmapTexture(ImageFinisher(param1).getBitmap().bitmapData);
         this._content.name = this.resKey;
         param1.dispose();
         this.ready.dispatch(this._content);
      }
   }
   
   private function dispatchReady() : void
   {
      this.ready.dispatch(this._content);
   }
   
   private function handleLoadError(... rest) : void
   {
      if(Boolean(this._resKey) && this._resKey.indexOf("alpha_") == -1)
      {
      }
      this.ready.dispatch(null);
   }
}
