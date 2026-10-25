package net.bigpoint.darkorbit.map.view3D.loaders
{
   import away3d.animators.VertexAnimator;
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.Mesh;
   import away3d.entities.ParticleGroup;
   import away3d.library.AssetLibrary;
   import away3d.loaders.parsers.AWDParser;
   import away3d.loaders.parsers.OBJParser;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import org.osflash.signals.Promise;
   
   public class GeometryLoader extends AbstractLoader
   {
      
      AssetLibrary.enableParser(AWDParser);
      AssetLibrary.enableParser(OBJParser);
      
      public function GeometryLoader()
      {
         super(this.disposeGeometry,5);
      }
      
      public static function disposeResource(param1:ObjectContainer3D) : void
      {
         var _loc3_:ParticleGroup = null;
         var _loc4_:Mesh = null;
         var _loc5_:Mesh = null;
         if(param1 is ParticleGroup)
         {
            _loc3_ = param1 as ParticleGroup;
            for each(_loc4_ in _loc3_.particleMeshes)
            {
               disposeResource(_loc4_);
            }
         }
         if(param1 is Mesh)
         {
            _loc5_ = param1 as Mesh;
            if(_loc5_.geometry)
            {
               _loc5_.geometry.dispose();
            }
            if(_loc5_.material)
            {
               _loc5_.material.dispose();
            }
            if(_loc5_.animator)
            {
               if(_loc5_.animator is VertexAnimator)
               {
                  VertexAnimator(_loc5_.animator).disposeAsset();
               }
               else
               {
                  _loc5_.animator.dispose();
               }
            }
         }
         param1.dispose();
         var _loc2_:* = int(param1.numChildren - 1);
         while(_loc2_ >= 0)
         {
            disposeResource(param1.getChildAt(_loc2_));
            _loc2_--;
         }
      }
      
      override public function reset(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:SingleGeometryLoader = null;
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
      
      public function loadGeometry(param1:String, param2:uint, param3:FileCollection = null) : Promise
      {
         var _loc4_:SingleGeometryLoader = _loaders[param1] as SingleGeometryLoader;
         if(_loc4_ == null || Settings3D.cacheDisabled.value)
         {
            _loaders[param1] = _loc4_ = new SingleGeometryLoader(param1,param3 || World3D.instance.fileCollection);
            _loc4_.load();
         }
         _loc4_.lifetime = Math.max(_loc4_.lifetime,param2);
         return _loc4_.ready;
      }
      
      public function loadGeometryBytes(param1:ByteArray) : Promise
      {
         var _loc2_:SingleGeometryLoader = new SingleGeometryLoader(null,null);
         _loc2_.loadData(param1);
         return _loc2_.ready;
      }
      
      public function useGeometry(param1:ObjectContainer3D) : void
      {
         useObj(param1);
      }
      
      public function freeGeometry(param1:ObjectContainer3D) : void
      {
         freeObj(param1);
      }
      
      private function disposeGeometry(param1:ObjectContainer3D) : void
      {
         var _loc2_:Object = null;
         var _loc3_:SingleGeometryLoader = null;
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

import away3d.containers.ObjectContainer3D;
import away3d.events.LoaderEvent;
import away3d.loaders.Loader3D;
import flash.net.URLRequest;
import net.bigpoint.as3toolbox.filecollection.FileCollection;
import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
import net.bigpoint.darkorbit.map.view3D.loaders.GeometryLoader;
import net.bigpoint.darkorbit.mvc.application.GameFacade;
import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
import org.osflash.signals.Promise;

class SingleGeometryLoader
{
   
   public const ready:Promise = new Promise(ObjectContainer3D);
   
   public var lifetime:uint = 0;
   
   private var _resKey:String;
   
   private var _loader:Loader3D;
   
   private var _content:ObjectContainer3D;
   
   private var _fileCollection:FileCollection;
   
   public function SingleGeometryLoader(param1:String, param2:FileCollection)
   {
      super();
      this._resKey = param1;
      this._fileCollection = param2;
   }
   
   public function load() : void
   {
      this._fileCollection.load(this._resKey,this.handleBytesLoadComplete,this.handleBytesLoadError);
   }
   
   public function loadData(param1:*) : void
   {
      this.dispose();
      this._loader = new Loader3D(false);
      this._loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE,this.handleLoadComplete);
      this._loader.addEventListener(LoaderEvent.LOAD_ERROR,this.handleLoadError);
      if(param1 is String)
      {
         this._loader.load(new URLRequest(param1 as String));
      }
      else
      {
         this._loader.loadData(param1);
      }
   }
   
   public function dispose() : void
   {
      if(this._loader)
      {
         this._loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE,this.handleLoadComplete);
         this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.handleLoadError);
         this._loader.dispose();
         this._loader = null;
      }
      if(this._content)
      {
         GeometryLoader.disposeResource(this._content);
         this._content = null;
      }
   }
   
   public function get content() : ObjectContainer3D
   {
      return this._content;
   }
   
   public function get resKey() : String
   {
      return this._resKey;
   }
   
   private function handleBytesLoadComplete(param1:DefaultFinisher) : void
   {
      if(param1)
      {
         this.loadData(param1.data);
         GameFacade.getInstance().forwardNotification(AssetNotifications.ADD_UNLOAD_FINISHER,param1);
         param1.dispose();
      }
      else
      {
         this.ready.dispatch(null);
      }
   }
   
   private function handleBytesLoadError(param1:String) : void
   {
      this.ready.dispatch(null);
   }
   
   private function handleLoadComplete(param1:LoaderEvent) : void
   {
      this._content = param1.target as ObjectContainer3D;
      this._content.name = this.resKey;
      this.ready.dispatch(this._content);
   }
   
   private function handleLoadError(param1:LoaderEvent) : void
   {
      this.ready.dispatch(null);
   }
}
