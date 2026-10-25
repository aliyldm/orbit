package net.bigpoint.darkorbit.map
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.sampler.getSampleCount;
   import flash.system.Capabilities;
   import net.bigpoint.darkorbit.map.view2D.DarkOrbitMapView2D;
   import net.bigpoint.darkorbit.map.view3D.DarkOrbitMapView3D;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.osflash.signals.Signal;
   
   public class MapViewProxy
   {
      
      private var _stage:Stage;
      
      private var _container:Sprite;
      
      private var _mapView:IMapView;
      
      private var _mapViewReady:Signal = new Signal();
      
      public function MapViewProxy(param1:Stage, param2:Sprite)
      {
         super();
         this._stage = param1;
         this._container = param2;
      }
      
      public function loadMapView(param1:Boolean = false) : void
      {
         if(this._mapView)
         {
            this._mapView.dispose();
            DisplayObject(this._mapView).parent.removeChild(this._mapView as DisplayObject);
         }
         var _loc2_:Object = {
            "fp":Capabilities.version,
            "hw_acc":(Settings.gpuSupport ? 1 : 0),
            "driver":Settings.driverInfo,
            "profile":Settings.stage3DProfile,
            "available_3D":(Settings.has3DCapabilities ? 1 : 0),
            "use_2D":(param1 ? 1 : 0)
         };
         try
         {
            _loc2_.lp = this._container.stage.loaderInfo.bytes.length;
            _loc2_.lm = this._container.loaderInfo.bytes.length;
            _loc2_.counter = getSampleCount();
         }
         catch(e:Error)
         {
         }
         if(param1 || Settings.has3DCapabilities == false)
         {
            this.initMapView(new DarkOrbitMapView2D());
         }
         else
         {
            this.initMapView(new DarkOrbitMapView3D());
         }
         _loc2_.view = this._mapView.toString();
         EventStreamClient.track("flash.stage3dstats",_loc2_);
      }
      
      public function get mapView() : IMapView
      {
         return this._mapView;
      }
      
      public function get mapViewReady() : Signal
      {
         return this._mapViewReady;
      }
      
      private function initMapView(param1:IMapView) : void
      {
         this._mapView = param1;
         this._mapView.ready.addOnce(this.handleMapViewReady);
         this._container.addChildAt(this._mapView as DisplayObject,0);
      }
      
      private function handleMapViewReady() : void
      {
         this._mapView.ready.remove(this.handleMapViewReady);
         this._mapViewReady.dispatch();
      }
   }
}

