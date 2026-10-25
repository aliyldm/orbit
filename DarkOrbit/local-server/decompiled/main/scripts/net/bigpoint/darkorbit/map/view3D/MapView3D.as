package net.bigpoint.darkorbit.map.view3D
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.cameras.lenses.PerspectiveLens;
   import away3d.containers.ObjectContainer3D;
   import away3d.containers.View3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.pick.PickingCollisionVO;
   import away3d.filters.Filter3DBase;
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IRenderable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.common.MiniMapViewportBounds;
   import net.bigpoint.darkorbit.map.common.lensflares.ILensFlareCollider;
   import net.bigpoint.darkorbit.map.common.lensflares.ILensFlaresProvider;
   import net.bigpoint.darkorbit.map.common.lensflares.LensFlaresLayer;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.view.Background2D;
   import net.bigpoint.darkorbit.map.view3D.display3D.DORaycastPicker;
   import net.bigpoint.darkorbit.map.view3D.display3D.LockDisplay3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapDisplayLayer3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.Starfield3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.background.Background3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.render.DORenderer;
   import net.bigpoint.darkorbit.map.view3D.display3D.zones.TileMapsContainer3D;
   import net.bigpoint.darkorbit.map.view3D.effects.EffectsViewManager3D;
   import net.bigpoint.darkorbit.map.view3D.filter.PixelationFilter3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.map.view3D.utils.CameraManager3D;
   import net.bigpoint.darkorbit.map.view3D.utils.Observer3D;
   import net.bigpoint.darkorbit.mvc.display.DisplayObjectsBuilder;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   import net.bigpoint.darkorbit.settings.Settings;
   
   use namespace arcane;
   
   public class MapView3D extends Sprite implements ILensFlareCollider
   {
      
      private const game2screen_tmpVector1:Vector3D = new Vector3D();
      
      private const game2screen_tmpVector2:Vector3D = new Vector3D();
      
      private const screen2game_tmpVector1:Vector3D = new Vector3D();
      
      private const screen2game_tmpVector2:Vector3D = new Vector3D();
      
      private const screen2game_tmpVector3:Vector3D = new Vector3D();
      
      private var _background2DContainer:IDOSprite;
      
      private var _background2D:Background2D;
      
      private var _background3D:Background3D;
      
      private var _zoneTileMaps:TileMapsContainer3D;
      
      private var _starfield:Starfield3D;
      
      private var _lensflares:LensFlaresLayer;
      
      private var _scale:Number = 1;
      
      private var _viewportWidth:int;
      
      private var _viewportHeight:int;
      
      private var _cameraManager:CameraManager3D;
      
      private var _view3D:View3D;
      
      private var _lens:PerspectiveLens;
      
      private var _gameWorld:ObjectContainer3D;
      
      private var _map:Map;
      
      private var _effectViewManager:EffectsViewManager3D;
      
      private var _mainContainer:MapDisplayLayer3D;
      
      private var _minimapBackgroundProvider:MiniMapViewportBounds;
      
      private var _overlayView3D:View3D;
      
      private var _overlay:ObjectContainer3D;
      
      private var _lockDisplay:LockDisplay3D;
      
      private var _zoom:Number = 1;
      
      private var _zoomInv:Number = 1;
      
      private var _minZoom:Number = 1;
      
      private var _updatables:Vector.<IUpdatable> = new Vector.<IUpdatable>();
      
      private var _renderables:Vector.<IRenderable> = new Vector.<IRenderable>();
      
      private var _renderer:DORenderer;
      
      private const _u:Vector3D = new Vector3D();
      
      private const _w:Vector3D = new Vector3D();
      
      private var _lensFlaresPicker:DORaycastPicker;
      
      private const _updateMiniMapViewport_v1:Vector3D = new Vector3D();
      
      private const _updateMiniMapViewport_v2:Vector3D = new Vector3D();
      
      private const _updateMiniMapViewport_v3:Vector3D = new Vector3D();
      
      private const _updateMiniMapViewport_v4:Vector3D = new Vector3D();
      
      public function MapView3D(param1:IMapView, param2:Stage3DProxy, param3:DisplayObjectsBuilder)
      {
         super();
         World3D.instance.init(this,param2);
         this._background2DContainer = param3.buildSprite();
         this._background2DContainer["name"] = "bg";
         this._background2D = new Background2D(param3,param1);
         this._background2DContainer.addUntypedChild(this._background2D.view);
         this._minimapBackgroundProvider = new MiniMapViewportBounds();
         this._background3D = new Background3D(param1);
         this._zoneTileMaps = new TileMapsContainer3D(this);
         this._lens = new PerspectiveLens(30);
         this._renderer = new DORenderer();
         this._view3D = new View3D(null,new Camera3D(this._lens),this._renderer);
         this._view3D.stage3DProxy = param2;
         this._view3D.shareContext = true;
         this._view3D.layeredView = true;
         this._view3D.mouseChildren = this._view3D.mouseEnabled = true;
         addChild(this._view3D);
         this._gameWorld = new ObjectContainer3D();
         this._gameWorld.rotateTo(0.0001,0.0001,0.0001);
         this._view3D.scene.addChild(this._gameWorld);
         this._overlayView3D = new View3D(null,this._view3D.camera,new DORenderer());
         this._overlayView3D.stage3DProxy = param2;
         this._overlayView3D.shareContext = true;
         this._overlayView3D.layeredView = true;
         this._overlayView3D.mouseChildren = this._overlayView3D.mouseEnabled = true;
         this._overlay = new ObjectContainer3D();
         this._overlay.rotateTo(0.0001,0.0001,0.0001);
         this._overlayView3D.scene.addChild(this._overlay);
         this._lockDisplay = new LockDisplay3D();
         this._gameWorld.addChild(this._lockDisplay);
         this._gameWorld.addChild(this._view3D.camera);
         this._gameWorld.addChild(this._background3D);
         this._mainContainer = new MapDisplayLayer3D(this._gameWorld.addChild(new ObjectContainer3D()));
         this._starfield = new Starfield3D();
         this._gameWorld.addChild(this._starfield);
         this._cameraManager = new CameraManager3D(this._view3D.camera,this);
         this._lensflares = new LensFlaresLayer(Vector.<ILensFlareCollider>([this]));
         addChild(this._lensflares);
         this._effectViewManager = new EffectsViewManager3D(this);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
      }
      
      private function handleEffectsSettingsChanged() : void
      {
         var _loc1_:Vector.<Filter3DBase> = new Vector.<Filter3DBase>();
         if(Settings3D.effects.max.value)
         {
         }
         this._view3D.filters3d = _loc1_;
      }
      
      public function addUpdatable(param1:IUpdatable) : void
      {
         var _loc2_:int = this._updatables.indexOf(param1);
         if(_loc2_ == -1)
         {
            this._updatables.push(param1);
         }
      }
      
      public function removeUpdatable(param1:IUpdatable) : void
      {
         var _loc2_:int = this._updatables.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._updatables.splice(_loc2_,1);
         }
      }
      
      public function addRenderable(param1:IRenderable) : void
      {
         var _loc2_:int = this._renderables.indexOf(param1);
         if(_loc2_ == -1)
         {
            this._renderables.push(param1);
         }
      }
      
      public function removeRenderable(param1:IRenderable) : void
      {
         var _loc2_:int = this._renderables.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._renderables.splice(_loc2_,1);
         }
      }
      
      public function load(param1:Map) : void
      {
         var _loc2_:IUpdatable = null;
         if(this._map)
         {
            this._map.removeEntity(this._minimapBackgroundProvider);
            this._map.mapXmlChanged.remove(this.updateLights);
         }
         while(this._updatables.length)
         {
            _loc2_ = this._updatables.pop();
            if(_loc2_ is IDisposable)
            {
               (_loc2_ as IDisposable).disposeView(true);
            }
         }
         this._renderables.length = 0;
         this._map = param1;
         if(this._map)
         {
            this._map.mapXmlChanged.add(this.updateLights);
            this._map.addEntity(this._minimapBackgroundProvider);
         }
         this._background3D.map = param1;
         this._background2D.map = this._background3D.isAvailableForCurrentMap ? null : param1;
         if(this._view3D.entityCollector)
         {
            this._view3D.entityCollector.clear();
         }
         this._renderer.renderSkybox = this._background3D.isAvailableForCurrentMap;
         this._view3D.stage3DProxy.color = this._background3D.backgroundColor;
         this._zoneTileMaps.map = param1;
         this._mainContainer.map = param1;
         this._starfield.map = param1;
         this._cameraManager.setMap(param1,this._background3D.isAvailableForCurrentMap);
         this._effectViewManager.map = param1;
         this._lockDisplay.map = param1;
         this.updateLights();
         this.addUpdatable(this._starfield);
         this.addUpdatable(this._lensflares);
         this.addUpdatable(this._lockDisplay);
         Settings.displaySettingPixelationMode.changed.add(this.handlePixelationModeChanged);
         Settings.pixelatedRenderingAvailable.changed.add(this.handlePixelationModeChanged);
         this.handlePixelationModeChanged();
      }
      
      private function updateLights() : void
      {
         var _loc1_:XML = null;
         if(this._map)
         {
            _loc1_ = this._map.mapXml.display3D.length() > 0 ? this._map.mapXml.display3D[0].light[0] : null;
            _loc1_ ||= new XML();
            Settings3D.sunLight.color.value = _loc1_.attribute("color").length() > 0 ? uint(_loc1_.@color) : 16777215;
            Settings3D.sunLight.diffuse.value = _loc1_.attribute("diffuse").length() ? Number(_loc1_.@diffuse) : 1;
            Settings3D.sunLight.specular.value = _loc1_.attribute("specular").length() ? Number(_loc1_.@specular) : 0.7;
            Settings3D.sunLight.ambientColor.value = _loc1_.attribute("ambientColor").length() ? uint(_loc1_.@ambientColor) : 16756398;
            Settings3D.sunLight.ambient.value = _loc1_.attribute("ambient").length() ? Number(_loc1_.@ambient) : 0.2;
            Settings3D.sunLight.directionTilt.value = _loc1_.attribute("tilt").length() ? Number(_loc1_.@tilt) : 100;
            Settings3D.sunLight.directionPan.value = _loc1_.attribute("pan").length() ? Number(_loc1_.@pan) : 35;
            Settings3D.sunLight.animateSpeed.value = _loc1_.attribute("animateSpeed").length() ? Number(_loc1_.@animateSpeed) : 0;
            this._lensflares.provider = this._background3D.isAvailableForCurrentMap ? this._background3D : this._background2D;
         }
      }
      
      public function setViewportSize(param1:int, param2:int) : void
      {
         this._viewportWidth = param1;
         this._viewportHeight = param2;
         this._view3D.width = this._viewportWidth;
         this._view3D.height = this._viewportHeight;
         this._overlayView3D.width = this._viewportWidth;
         this._overlayView3D.height = this._viewportHeight;
         this._background2D.setViewportSize(param1,param2);
         this._lensflares.setViewportSize(param1,param2);
      }
      
      public function update(param1:Number, param2:int, param3:int) : void
      {
         this._cameraManager.update(param1,param2,param3);
         var _loc4_:* = int(this._updatables.length - 1);
         while(_loc4_ >= 0)
         {
            this._updatables[_loc4_].updateObj(param1);
            _loc4_--;
         }
         this._background2D.update(param2,param3,Math.round(this._viewportWidth / (2 * this._scale)),Math.round(this._viewportHeight / (2 * this._scale)));
         this.updateMiniMapViewport();
         World3D.instance.lights.update();
      }
      
      public function render() : void
      {
         var _loc1_:* = 0;
         _loc1_ = int(this._renderables.length - 1);
         while(_loc1_ >= 0)
         {
            this._renderables[_loc1_].preRender();
            _loc1_--;
         }
         this._view3D.render();
         Stage3DStats.numTriangles = this._view3D.renderedFacesCount;
         if(this._overlay.numChildren)
         {
            this._overlayView3D.render();
            Stage3DStats.numTriangles += this._overlayView3D.renderedFacesCount;
         }
         _loc1_ = int(this._renderables.length - 1);
         while(_loc1_ >= 0)
         {
            this._renderables[_loc1_].postRender();
            _loc1_--;
         }
      }
      
      public function game2screen(param1:Number, param2:Number, param3:Number = 0, param4:PointLite = null) : PointLite
      {
         if(param4 == null)
         {
            param4 = new PointLite();
         }
         this.game2screen_tmpVector1.x = param1;
         this.game2screen_tmpVector1.y = param3;
         this.game2screen_tmpVector1.z = -param2;
         var _loc5_:Vector3D = this._view3D.camera.project(this.game2screen_tmpVector1,this.game2screen_tmpVector2);
         param4.x = this._viewportWidth * (_loc5_.x + 1) / 2;
         param4.y = this._viewportHeight * (_loc5_.y + 1) / 2;
         param4.z = this._cameraManager.cam.animatedZoom.value;
         return param4;
      }
      
      public function screen2game(param1:Number, param2:Number, param3:Number = 0, param4:Vector3D = null) : Vector3D
      {
         if(param4 == null)
         {
            param4 = new Vector3D();
         }
         var _loc5_:Vector3D = this._view3D.camera.scenePosition;
         var _loc6_:Vector3D = this._view3D.camera.unproject(2 * param1 / this._viewportWidth - 1,2 * param2 / this._viewportHeight - 1,100,this.screen2game_tmpVector1);
         var _loc7_:Vector3D = this.screen2game_tmpVector2;
         _loc7_.x = 0;
         _loc7_.y = param3;
         _loc7_.z = 0;
         var _loc8_:Vector3D = this.screen2game_tmpVector3;
         _loc8_.x = 0;
         _loc8_.y = 1;
         _loc8_.z = 0;
         this._u.setTo(_loc6_.x - _loc5_.x,_loc6_.y - _loc5_.y,_loc6_.z - _loc5_.z);
         this._w.setTo(_loc5_.x - _loc7_.x,_loc5_.y - _loc7_.y,_loc5_.z - _loc7_.z);
         var _loc9_:Number = _loc8_.dotProduct(this._u);
         if(Math.abs(_loc9_) > 0.000001)
         {
            this._u.scaleBy(-_loc8_.dotProduct(this._w) / _loc9_);
            param4.x = _loc5_.x + this._u.x;
            param4.y = -_loc5_.z - this._u.z;
            param4.z = _loc5_.y + this._u.y;
            return param4;
         }
         return null;
      }
      
      public function zoomTo(param1:Number, param2:Number) : void
      {
         this._cameraManager.zoomTo(param1,param2);
      }
      
      public function zoomIn(param1:Number) : void
      {
         this._cameraManager.zoomIn();
      }
      
      public function zoomOut(param1:Number) : void
      {
         this._cameraManager.zoomOut();
      }
      
      private function updateMiniMapViewport() : void
      {
         var _loc1_:Vector3D = this.screen2game(0,0,0,this._updateMiniMapViewport_v1);
         var _loc2_:Vector3D = this.screen2game(this._viewportWidth,0,0,this._updateMiniMapViewport_v2);
         var _loc3_:Vector3D = this.screen2game(this._viewportWidth,this._viewportHeight,0,this._updateMiniMapViewport_v3);
         var _loc4_:Vector3D = this.screen2game(0,this._viewportHeight,0,this._updateMiniMapViewport_v4);
         if(Boolean(_loc1_) && Boolean(_loc2_) && Boolean(_loc3_) && Boolean(_loc4_))
         {
            this._minimapBackgroundProvider.setViewport(_loc1_.x,_loc1_.y,_loc2_.x,_loc2_.y,_loc3_.x,_loc3_.y,_loc4_.x,_loc4_.y);
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this._cameraManager.init(stage,this.mouseEventsSource);
         Settings3D.effects.max.changed.add(this.handleEffectsSettingsChanged);
         this.handleEffectsSettingsChanged();
      }
      
      private function handlePixelationModeChanged() : void
      {
         var _loc2_:PixelationFilter3D = null;
         var _loc1_:Vector.<Filter3DBase> = new Vector.<Filter3DBase>();
         if(Settings.displaySettingPixelationMode.value && Settings.pixelatedRenderingAvailable.value)
         {
            _loc2_ = new PixelationFilter3D(0);
            TweenLite.to(_loc2_,3,{"pixelSize":1.8});
            _loc1_.push(_loc2_);
         }
         this._view3D.filters3d = _loc1_;
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         Settings3D.effects.max.changed.remove(this.handleEffectsSettingsChanged);
         this._cameraManager.dispose();
      }
      
      private function get mouseEventsSource() : EventDispatcher
      {
         return ScreenManager.getInstance().hitLayer;
      }
      
      public function get zoom() : Number
      {
         return this._zoom;
      }
      
      public function set zoom(param1:Number) : void
      {
         param1 = Math.max(this._minZoom,Math.min(param1,1));
         if(this._zoom != param1)
         {
            this._zoom = param1;
            this._zoomInv = 1 / this._zoom;
            scaleX = scaleY = this._zoom;
            this.updateViewports();
            this._cameraManager.zoom = param1;
         }
      }
      
      private function updateViewports(param1:Boolean = true) : void
      {
         var _loc2_:int = this._viewportWidth * this._zoomInv;
         var _loc3_:int = this._viewportHeight * this._zoomInv;
         this._lensflares.setViewportSize(_loc2_,_loc3_);
         if(param1)
         {
            this._background2D.setViewportSize(_loc2_,_loc3_);
         }
      }
      
      public function get gameWorld() : ObjectContainer3D
      {
         return this._gameWorld;
      }
      
      public function get overlay() : ObjectContainer3D
      {
         return this._overlay;
      }
      
      public function get mainContainer() : MapDisplayLayer3D
      {
         return this._mainContainer;
      }
      
      public function get cam() : Observer3D
      {
         return this._cameraManager.cam;
      }
      
      public function get camera() : Camera3D
      {
         return this._view3D.camera;
      }
      
      public function testLensFlareCollision(param1:int, param2:int) : Boolean
      {
         if(this._background2D.testLensFlareCollision(param1,param2))
         {
            return true;
         }
         if(this._lensFlaresPicker == null)
         {
            this._lensFlaresPicker = new DORaycastPicker();
         }
         this._view3D.camera.unproject(2 * param1 / this._viewportWidth - 1,2 * param2 / this._viewportHeight - 1,100,this.screen2game_tmpVector1);
         this.screen2game_tmpVector1.decrementBy(this._view3D.camera.scenePosition);
         var _loc3_:PickingCollisionVO = this._lensFlaresPicker.getSceneCollision(this._view3D.camera.scenePosition,this.screen2game_tmpVector1,this._view3D.scene);
         return _loc3_ != null;
      }
      
      public function get background2DContainer() : IDOSprite
      {
         return this._background2DContainer;
      }
      
      public function get view3D() : View3D
      {
         return this._view3D;
      }
   }
}

