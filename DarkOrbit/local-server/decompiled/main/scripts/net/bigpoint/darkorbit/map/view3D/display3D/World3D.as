package net.bigpoint.darkorbit.map.view3D.display3D
{
   import away3d.core.managers.Stage3DProxy;
   import flash.geom.Vector3D;
   import flash.net.SharedObject;
   import flash.utils.clearInterval;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.loaders.GeometryLoader;
   import net.bigpoint.darkorbit.map.view3D.loaders.ParticlesLoader;
   import net.bigpoint.darkorbit.map.view3D.loaders.TextureLoader;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class World3D
   {
      
      public static const instance:World3D = new World3D();
      
      public static const LIFETIME_GLOBAL:uint = 2;
      
      public static const LIFETIME_MAP:uint = 1;
      
      public static const LIFETIME_USE_COUNTER:uint = 0;
      
      public static const CALCULATION_VECTOR3D:Vector3D = new Vector3D();
      
      private var _fileCollection:FileCollection;
      
      private var _particlesFileCollection:FileCollection;
      
      private var _fileCollectionReadyCallback:Function;
      
      private var _mapView:MapView3D;
      
      private var _lights:LightsManager;
      
      private var _textureLoader:TextureLoader;
      
      private var _geometryLoader:GeometryLoader;
      
      private var _particleLoader:ParticlesLoader;
      
      private var _saveSettingsInterval:uint;
      
      private var _so:SharedObject;
      
      private var _resetHandlers:Vector.<Function> = new Vector.<Function>();
      
      public const resetSignal:ISignal = new Signal();
      
      public function World3D()
      {
         super();
      }
      
      public function get fileCollection() : FileCollection
      {
         return this._fileCollection;
      }
      
      public function get particlesFileCollection() : FileCollection
      {
         return this._particlesFileCollection;
      }
      
      public function initFileCollection(param1:Function) : void
      {
         this._fileCollectionReadyCallback = param1;
         var _loc2_:String = "xml/resources_3d.xml?__cv=" + Settings.resources3dXmlHash;
         var _loc3_:String = Settings.staticHost + Settings.basePath;
         this._fileCollection = new FileCollection(_loc3_,true);
         this._fileCollection.addFinisherClass("jxr",ImageFinisher);
         this._fileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleFileCollectionLoaded);
         this._fileCollection.loadResourceFile(_loc2_);
      }
      
      private function handleFileCollectionLoaded(param1:FileCollectionEvent) : void
      {
         (param1.target as FileCollection).removeEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleFileCollectionLoaded);
         var _loc2_:String = "xml/resources_3d_particles.xml?__cv=" + Settings.resources3dparticlesXmlHash;
         var _loc3_:String = Settings.staticHost + Settings.basePath;
         this._particlesFileCollection = new FileCollection(_loc3_,true,true);
         this._particlesFileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handlegameParticlesFileCollectionLoaded);
         this._particlesFileCollection.loadResourceFile(_loc2_);
      }
      
      private function handlegameParticlesFileCollectionLoaded(param1:FileCollectionEvent) : void
      {
         (param1.target as FileCollection).removeEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handlegameParticlesFileCollectionLoaded);
         this._fileCollectionReadyCallback();
         this._fileCollectionReadyCallback = null;
      }
      
      public function init(param1:MapView3D, param2:Stage3DProxy) : void
      {
         this._mapView = param1;
         this._lights = new LightsManager();
         this._textureLoader = new TextureLoader(param2);
         this._geometryLoader = new GeometryLoader();
         this._particleLoader = new ParticlesLoader();
         clearInterval(this._saveSettingsInterval);
      }
      
      public function getCache(param1:String) : Object
      {
         return this.so.data[param1];
      }
      
      public function setCache(param1:String, param2:Object) : void
      {
         this.so.data[param1] = param2;
         this.so.flush();
      }
      
      private function get so() : SharedObject
      {
         return this._so = this._so || SharedObject.getLocal("darkorbit.settings3D","/");
      }
      
      public function dispose() : void
      {
         clearInterval(this._saveSettingsInterval);
         this.reset();
         this._resetHandlers.length = 0;
         this._textureLoader = null;
         this._geometryLoader = null;
         this._particleLoader = null;
         this._lights.dispose();
         this._lights = null;
         this._mapView = null;
      }
      
      public function get mapView() : MapView3D
      {
         return this._mapView;
      }
      
      public function get lights() : LightsManager
      {
         return this._lights;
      }
      
      public function get textureLoader() : TextureLoader
      {
         return this._textureLoader;
      }
      
      public function get geometryLoader() : GeometryLoader
      {
         return this._geometryLoader;
      }
      
      public function get particleLoader() : ParticlesLoader
      {
         return this._particleLoader;
      }
      
      public function reset() : void
      {
         this.resetSignal.dispatch();
         this.textureLoader.reset(World3D.LIFETIME_MAP);
         this.geometryLoader.reset(World3D.LIFETIME_MAP);
         this.particleLoader.reset(World3D.LIFETIME_MAP);
      }
   }
}

