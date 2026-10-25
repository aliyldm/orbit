package net.bigpoint.darkorbit.map.view3D.utils
{
   import away3d.cameras.Camera3D;
   import away3d.cameras.lenses.PerspectiveLens;
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.poizones.IPOIZoneCollisionArea;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class CameraManager3D
   {
      
      private static var camZoneID:Number = 0;
      
      private const START_PAN:Number = 25;
      
      private const START_ZOOM:Number = 0;
      
      private var _ship:MapUberAsset3D;
      
      private var _map:Map;
      
      private var _t:Number = 0;
      
      private var _camera:Camera3D;
      
      private var _stage:Stage;
      
      private var _mouseEventsSource:EventDispatcher;
      
      private var _draggingCamera:Boolean;
      
      private var _lastMouseX:Number;
      
      private var _lastMouseY:Number;
      
      private var _mapIs3D:Boolean;
      
      private var _mapView:MapView3D;
      
      private var updateCamera:Boolean = false;
      
      private var _zones:Vector.<POIZone> = new Vector.<POIZone>();
      
      private var _inZone:Boolean = false;
      
      private var _cam:Observer3D = new Observer3D();
      
      public function CameraManager3D(param1:Camera3D, param2:MapView3D)
      {
         super();
         this._camera = param1;
         this._mapView = param2;
         Settings.show_debug_objects.changed.add(this.drawDebg);
      }
      
      public function get zones() : Vector.<POIZone>
      {
         return this._zones;
      }
      
      public function get inZone() : Boolean
      {
         return this._inZone;
      }
      
      public function get cam() : Observer3D
      {
         return this._cam;
      }
      
      public function get zoom() : Number
      {
         return this._cam.zoom;
      }
      
      public function set zoom(param1:Number) : void
      {
         this._cam.zoom = param1;
      }
      
      private function get pan() : Number
      {
         return this._cam.pan.value;
      }
      
      private function set pan(param1:Number) : void
      {
         if(Settings3D.limitCameraAngle.value)
         {
            param1 %= 360;
            while(param1 < 0)
            {
               param1 += 360;
            }
         }
         this._cam.pan.value = param1;
      }
      
      public function get tilt() : Number
      {
         return this._cam.tilt.value;
      }
      
      public function set tilt(param1:Number) : void
      {
         if(Settings3D.limitCameraAngle.value)
         {
            if(param1 > this._cam.maxTilt)
            {
               param1 = this._cam.maxTilt;
            }
            if(param1 < this._cam.minTilt)
            {
               param1 = this._cam.minTilt;
            }
         }
         this._cam.tilt.value = param1;
      }
      
      private function get hero() : Ship
      {
         return this._map.hero;
      }
      
      public function init(param1:Stage, param2:EventDispatcher) : void
      {
         this._stage = param1;
         this._mouseEventsSource = param2;
         this._stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN || "rightMouseDown",this.stageMouseDownHandler,true,1000);
         this._mouseEventsSource.addEventListener(MouseEvent.MOUSE_WHEEL,this.stageMouseWheelHandler);
         this._stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP || "rightMouseUp",this.stageMouseUpHandler);
      }
      
      public function dispose() : void
      {
         this._stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN || "rightMouseDown",this.stageMouseDownHandler,true);
         this._mouseEventsSource.removeEventListener(MouseEvent.MOUSE_WHEEL,this.stageMouseWheelHandler);
         this._stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP || "rightMouseUp",this.stageMouseUpHandler);
         this.stopDragging();
      }
      
      public function updateObj(param1:Number) : void
      {
      }
      
      public function setMap(param1:Map, param2:Boolean) : void
      {
         if(this._map)
         {
            this._map.mapXmlChanged.remove(this.updateZones);
            this._map.entityAdded.remove(this.onElementAddedToMap);
            if(this._ship)
            {
               this._ship.ready.remove(this.onHeroViewLoaded);
               this._ship = null;
            }
         }
         this._map = param1;
         if(param1)
         {
            this._map.mapXmlChanged.add(this.updateZones);
         }
         this.stopDragging();
         this.updateZones();
         this._mapIs3D = param2;
         this._cam.mapIs3D = param2;
         if(this._mapIs3D)
         {
            this._cam.immediateZoom = this.START_ZOOM;
            this._cam.pan.value = this.START_PAN;
            if(this._map.hero)
            {
               this.onElementAddedToMap(this._map.hero.id);
            }
            else
            {
               this._map.entityAdded.add(this.onElementAddedToMap);
            }
         }
         else
         {
            this._cam.restoreDefaults(true);
         }
      }
      
      public function update(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:IPOIZoneCollisionArea = null;
         this._t += param1;
         if(this._t > 1 && this._mapIs3D && this.updateCamera)
         {
            this._t = 0;
            _loc4_ = this.getCurrentCameraZone();
            if(this._inZone != Boolean(_loc4_))
            {
               if(Boolean(_loc4_) && this._map.storage[_loc4_] != true)
               {
                  this._map.storage[_loc4_] = true;
                  this._cam.zoomIn();
               }
               else
               {
                  this.stopDragging();
                  this._cam.restoreDefaults(false,true);
               }
            }
            this._inZone = Boolean(_loc4_);
         }
         if(this.inZone || Settings3D.limitCameraAngle.value == false)
         {
            if(this._draggingCamera)
            {
               this.pan -= 0.5 * (this._stage.mouseX - this._lastMouseX);
               this.tilt += 0.5 * (this._stage.mouseY - this._lastMouseY);
               this._lastMouseX = this._stage.mouseX;
               this._lastMouseY = this._stage.mouseY;
            }
         }
         this._cam.lookAt(param2,0,-param3);
         this._camera.position = this._cam.position;
         this._camera.lookAt(this._cam.lookAtPosition,Vector3D.Y_AXIS);
         this._camera.lens.near = 10;
         this._camera.lens.far = 80000;
         PerspectiveLens(this._camera.lens).fieldOfView = this.cam.fov.value;
      }
      
      public function zoomIn() : void
      {
         if(this.zoomChangeAvailable())
         {
            this._cam.zoom *= 1.2;
         }
      }
      
      public function zoomOut() : void
      {
         if(this.zoomChangeAvailable())
         {
            this._cam.zoom *= 0.8;
         }
      }
      
      public function zoomTo(param1:Number, param2:Number) : void
      {
         if(this.zoomChangeAvailable())
         {
            this._cam.animateZoom(param1,param2);
         }
      }
      
      private function onElementAddedToMap(param1:Number) : void
      {
         if(param1 == Hero.userID)
         {
            if(this._ship)
            {
               this._ship.ready.remove(this.onHeroViewLoaded);
               this._ship = null;
            }
            this._map.entityAdded.remove(this.onElementAddedToMap);
            this._ship = this._mapView.mainContainer.getViewByTrait(this._map.hero.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
            this._ship.ready.add(this.onHeroViewLoaded);
         }
      }
      
      private function onHeroViewLoaded() : void
      {
         if(this._ship)
         {
            this._ship.ready.remove(this.onHeroViewLoaded);
            this._ship = null;
         }
         TweenLite.delayedCall(0.2,function():void
         {
            var _loc1_:IPOIZoneCollisionArea = getCurrentCameraZone();
            if(_loc1_)
            {
               _map.storage[_loc1_] = true;
               _inZone = true;
               _cam.zoomIn();
            }
            else
            {
               _cam.restoreDefaults(false,true);
            }
            updateCamera = true;
         });
      }
      
      private function getCurrentCameraZone() : IPOIZoneCollisionArea
      {
         var _loc4_:POIZone = null;
         var _loc5_:IPOIZoneCollisionArea = null;
         if(!this.hero)
         {
            return null;
         }
         var _loc1_:Number = this._zones.length;
         var _loc2_:Point = this.hero.position.toPoint();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this._zones[_loc3_];
            _loc5_ = _loc4_.getFirstTrait(IPOIZoneCollisionArea) as IPOIZoneCollisionArea;
            if(_loc5_.contains(_loc2_))
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function updateZones() : void
      {
         var _loc1_:XML = null;
         var _loc2_:XML = null;
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:CircleZone = null;
         this._zones.length = 0;
         if(Boolean(this._map) && this._map.mapXml.display3D.length() > 0)
         {
            _loc1_ = UberAssetsLib.instance.getDescriptor(String(this._map.mapXml.display3D.@templateId),UberAssetsLib.LIB_MAPS);
            if(_loc1_)
            {
               _loc3_ = _loc1_.display3D[0].child("cameraZone");
               for each(_loc4_ in _loc3_)
               {
                  _loc2_ = _loc4_;
                  _loc5_ = Number(_loc2_.@x);
                  _loc6_ = Number(_loc2_.@y);
                  _loc7_ = Number(_loc2_.@scale);
                  _loc8_ = new CircleZone(Map.NEXT_FREE_ID,POIZone.ZONE_TYPE_CAMERA_ZONE,new PointLite(_loc5_,_loc6_,0),_loc7_,false,0);
                  this._zones.push(_loc8_);
               }
            }
         }
         this.drawDebg();
      }
      
      private function drawDebg() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         if(Settings.show_debug_objects.value)
         {
            _loc1_ = this._zones.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this._map.poiManager.registerZone("cameraZone" + camZoneID++,this._zones[_loc2_],"");
               _loc2_++;
            }
         }
         else
         {
            _loc1_ = this._zones.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this._map.poiManager.removeZone("cameraZone" + --camZoneID);
               _loc2_++;
            }
            camZoneID = 0;
         }
      }
      
      private function stopDragging() : void
      {
         if(this._draggingCamera)
         {
            if(Settings3D.limitCameraAngle.value)
            {
               this._cam.restoreDefaults(false,false);
            }
            this._draggingCamera = false;
         }
      }
      
      private function stageMouseDownHandler(param1:MouseEvent) : void
      {
         if(param1.target == this._mouseEventsSource && (this._mapIs3D && this.inZone || Settings3D.limitCameraAngle.value == false))
         {
            this._draggingCamera = true;
            this._lastMouseX = this._stage.mouseX;
            this._lastMouseY = this._stage.mouseY;
            param1.stopImmediatePropagation();
            this._cam.killAnimation();
         }
      }
      
      private function stageMouseUpHandler(param1:MouseEvent) : void
      {
         this.stopDragging();
      }
      
      private function stageMouseWheelHandler(param1:MouseEvent) : void
      {
         if(param1.altKey == false && this.zoomChangeAvailable())
         {
            this._cam.zoom *= param1.delta < 0 ? 0.8 : 1.2;
         }
      }
      
      private function zoomChangeAvailable() : Boolean
      {
         return true;
      }
   }
}

