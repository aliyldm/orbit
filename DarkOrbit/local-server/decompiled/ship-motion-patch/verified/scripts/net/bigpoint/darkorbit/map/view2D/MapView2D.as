package net.bigpoint.darkorbit.map.view2D
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import fl.controls.Button;
   import flash.display.Loader;
   import flash.display.Shader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ShaderFilter;
   import flash.net.FileReference;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.MiniMapViewportBounds;
   import net.bigpoint.darkorbit.map.common.lensflares.ILensFlareCollider;
   import net.bigpoint.darkorbit.map.common.lensflares.LensFlaresLayer;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.view.Background2D;
   import net.bigpoint.darkorbit.map.view2D.display.MapDisplayLayer2D;
   import net.bigpoint.darkorbit.map.view2D.effects.EffectsManager2D;
   import net.bigpoint.darkorbit.map.view2D.effects.SharedAreaAnimation2D;
   import net.bigpoint.darkorbit.map.view2D.starfield.Starfield2D;
   import net.bigpoint.darkorbit.map.view2D.zones.tilemap.TileMapsContainer;
   import net.bigpoint.darkorbit.mvc.display.DisplayObjectsBuilder;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   
   public class MapView2D extends Sprite implements ILensFlareCollider
   {
      
      public static var fxLayer:Sprite;
      
      private static const MAX_RES_WIDTH:int = 1280;
      
      private var _viewBuilder:DisplayObjectsBuilder;
      
      private var _backgroundsContainer:IDOSprite;
      
      private var _background:Background2D;
      
      private var _starfield:Starfield2D;
      
      private var _lensflares:LensFlaresLayer;
      
      private var _flashMovingContainer:Sprite;
      
      private var _entitiesLayer:MapDisplayLayer2D;
      
      private var _zoneTileMaps:TileMapsContainer;
      
      private var _fxLayer:Sprite;
      
      private var _projectileLayer:Sprite;
      
      private var _eff:EffectsManager2D;
      
      private var _viewportWidth:int;
      
      private var _viewportHeight:int;
      
      private var _viewportHalfWidth:int;
      
      private var _viewportHalfHeight:int;
      
      private var _map:Map;
      
      private var _minimapBackgroundProvider:MiniMapViewportBounds;
      
      private var fr:FileReference;
      
      private var shader:Shader;
      
      private var shaderFilter:ShaderFilter;
      
      private var loader:Loader;
      
      private var _cameraLookAtWorldX:int = 0;
      
      private var _cameraLookAtWorldY:int = 0;
      
      private var _nextShipPoll:int;
      
      private var _shipBudgetEnableAt:int;
      
      private var _lastTweenCleanup:int;
      
      private var _zoom:Number = 1;
      
      private var _zoomInv:Number = 1;
      
      private var _minZoom:Number = 0.25;
      
      private var _userZoom:Number = 1;
      
      private var _zoomInitialized:Boolean;
      
      public function MapView2D(param1:IMapView, param2:DisplayObjectsBuilder)
      {
         var btn:Button;
         var mapView:IMapView = param1;
         var viewBuilder:DisplayObjectsBuilder = param2;
         super();
         this._viewBuilder = viewBuilder;
         this._backgroundsContainer = this._viewBuilder.buildSprite();
         this._backgroundsContainer["name"] = "bg";
         this._background = new Background2D(this._viewBuilder,mapView);
         this._backgroundsContainer.addUntypedChild(this._background.view);
         this._starfield = new Starfield2D(this._viewBuilder);
         this._backgroundsContainer.addUntypedChild(this._starfield.container);
         this.initMovingLayers();
         this._lensflares = new LensFlaresLayer(Vector.<ILensFlareCollider>([this]));
         addChild(this._lensflares);
         this._eff = new EffectsManager2D(this);
         this._zoneTileMaps = new TileMapsContainer(this._background,this);
         this._minimapBackgroundProvider = new MiniMapViewportBounds();
         btn = new Button();
         btn.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            fr = new FileReference();
            fr.addEventListener(Event.SELECT,onSelect);
            fr.addEventListener(Event.COMPLETE,onComplete);
            fr.browse();
         });
      }
      
      private function onComplete(param1:Event) : void
      {
         this.shader = new Shader(this.fr.data);
         this.shaderFilter = new ShaderFilter();
         this.shaderFilter.shader = this.shader;
         this.filters = [this.shaderFilter];
      }
      
      private function onSelect(param1:Event) : void
      {
         this.fr.load();
      }
      
      public function load(param1:Map) : void
      {
         if(this._map)
         {
            this._map.removeEntity(this._minimapBackgroundProvider);
         }
         this._map = param1;
         SharedAreaAnimation2D.clear();
         DenseEffectPolicy2D.clear();
         ShipVisualBudget2D.clear();
         this._nextShipPoll = 0;
         this._shipBudgetEnableAt = getTimer() + 3000;
         if(this._map)
         {
            this._map.addEntity(this._minimapBackgroundProvider);
         }
         while(this.fxLayer.numChildren > 0)
         {
            this.fxLayer.removeChildAt(this.fxLayer.numChildren - 1);
         }
         this._background.map = param1;
         this._zoneTileMaps.map = param1;
         this._entitiesLayer.map = param1;
         this._lensflares.provider = this._background;
         this._starfield.reset();
         this._eff.map = param1;
      }
      
      public function screen2game(param1:int, param2:int, param3:PointLite = null) : PointLite
      {
         if(param3 == null)
         {
            param3 = new PointLite();
         }
         param3.x = this._cameraLookAtWorldX + int((param1 - this._viewportHalfWidth) * this._zoomInv);
         param3.y = this._cameraLookAtWorldY + int((param2 - this._viewportHalfHeight) * this._zoomInv);
         return param3;
      }
      
      public function game2screen(param1:int, param2:int, param3:PointLite = null) : PointLite
      {
         if(param3 == null)
         {
            param3 = new PointLite();
         }
         param3.x = (param1 - this._cameraLookAtWorldX) * this._zoom + this._viewportHalfWidth;
         param3.y = (param2 - this._cameraLookAtWorldY) * this._zoom + this._viewportHalfHeight;
         param3.z = 1;
         return param3;
      }
      
      public function setViewportSize(param1:int, param2:int) : void
      {
         this._viewportWidth = param1;
         this._viewportHeight = param2;
         this._viewportHalfWidth = this._viewportWidth >> 1;
         this._viewportHalfHeight = this._viewportHeight >> 1;
         this._minZoom = 0.25;
         if(!this._zoomInitialized)
         {
            this._userZoom = 1;
            this._zoomInitialized = true;
         }
         this.zoom = this._userZoom;
         this.updateViewports();
      }
      
      public function update(param1:int, param2:int, param3:Number) : void
      {
         var _loc7_:int = 0;
         var _loc8_:MapEntity = null;
         var _loc9_:Ship = null;
         SharedAreaAnimation2D.tick();
         this._cameraLookAtWorldX = param1;
         this._cameraLookAtWorldY = param2;
         var _loc4_:int = getTimer();
         if(_loc4_ >= this._shipBudgetEnableAt && _loc4_ >= this._nextShipPoll && Boolean(this._map) && Boolean(this._map.hero))
         {
            this._nextShipPoll = _loc4_ + ShipVisualBudget2D.POLL_MS;
            ShipVisualBudget2D.begin(this._map.hero);
            _loc7_ = 0;
            for each(_loc8_ in this._map.entities)
            {
               _loc9_ = _loc8_ as Ship;
               if(_loc9_)
               {
                  ShipVisualBudget2D.consider(_loc9_);
                  if(DenseEffectPolicy2D.includes(_loc9_.position.x - this._map.hero.position.x,_loc9_.position.y - this._map.hero.position.y,_loc9_.isNPC,_loc9_ is Pet,_loc9_ === this._map.hero))
                  {
                     _loc7_++;
                  }
               }
            }
            ShipVisualBudget2D.commit();
            DenseEffectPolicy2D.update(_loc7_,_loc4_);
         }
         var _loc5_:int = Math.round(this._viewportHalfWidth * this._zoomInv);
         var _loc6_:int = Math.round(this._viewportHalfHeight * this._zoomInv);
         this._background.update(param1,param2,_loc5_,_loc6_);
         this._flashMovingContainer.x = int(_loc5_ - param1);
         this._flashMovingContainer.y = int(_loc6_ - param2);
         this._entitiesLayer.updateObj(param3);
         this._starfield.update(param1,param2,_loc5_,_loc6_,param3);
         this._lensflares.updateObj(param3);
         this._minimapBackgroundProvider.setViewport(param1 - this._viewportHalfWidth,param2 - this._viewportHalfHeight,param1 + this._viewportHalfWidth,param2 - this._viewportHalfHeight,param1 + this._viewportHalfWidth,param2 + this._viewportHalfHeight,param1 - this._viewportHalfWidth,param2 + this._viewportHalfHeight);
         if(uint(_loc4_ - this._lastTweenCleanup) >= 1000)
         {
            this._lastTweenCleanup = _loc4_;
            TweenLite.collectRetiredTweens();
         }
      }
      
      public function get projectileLayer() : Sprite
      {
         return this._projectileLayer;
      }
      
      public function get fxLayer() : Sprite
      {
         return this._fxLayer;
      }
      
      public function zoomTo(param1:Number, param2:Number) : void
      {
         TweenLite.killTweensOf(this);
         param1 = Math.max(this._minZoom,Math.min(param1,2));
         if(this.zoom != param1)
         {
            TweenLite.to(this,param2,{
               "zoom":param1,
               "onComplete":this.updateViewports
            });
         }
      }
      
      public function zoomIn(param1:Number) : void
      {
         this._userZoom = Math.min(2,this._userZoom * 1.2);
         this.zoomTo(this._userZoom,param1);
      }
      
      public function zoomOut(param1:Number) : void
      {
         this._userZoom = Math.max(this._minZoom,this._userZoom / 1.2);
         this.zoomTo(this._userZoom,param1);
      }
      
      public function restoreUserZoom(param1:Number) : void
      {
         this.zoomTo(this._userZoom,param1);
      }
      
      public function get zoom() : Number
      {
         return this._zoom;
      }
      
      public function set zoom(param1:Number) : void
      {
         param1 = Math.max(this._minZoom,Math.min(param1,2));
         if(this._zoom != param1)
         {
            this._zoom = param1;
            this._zoomInv = 1 / this._zoom;
            scaleX = scaleY = this._zoom;
            this._backgroundsContainer.scaleX = this._backgroundsContainer.scaleY = this._zoom;
            this.updateViewports(false);
         }
      }
      
      private function updateViewports(param1:Boolean = true) : void
      {
         var _loc2_:int = this._viewportWidth * this._zoomInv;
         var _loc3_:int = this._viewportHeight * this._zoomInv;
         this._lensflares.setViewportSize(_loc2_,_loc3_);
         if(param1)
         {
            this._starfield.setViewportSize(_loc2_,_loc3_);
            this._background.setViewportSize(_loc2_,_loc3_);
         }
      }
      
      internal function get backgroundContainer() : IDOSprite
      {
         return this._backgroundsContainer;
      }
      
      private function initMovingLayers() : void
      {
         this._flashMovingContainer = new Sprite();
         this._entitiesLayer = new MapDisplayLayer2D();
         this._entitiesLayer.addEventListener(Event.ADDED,function(param1:Event):void
         {
            param1.stopPropagation();
         },true,int.MAX_VALUE);
         this._flashMovingContainer.addChild(this._entitiesLayer);
         this._fxLayer = new Sprite();
         this._fxLayer.name = "fxLayer";
         this._flashMovingContainer.addChild(this._fxLayer);
         this._projectileLayer = new Sprite();
         this._flashMovingContainer.addChild(this._projectileLayer);
         this._fxLayer.addEventListener(Event.ADDED,this.containEffectLifecycle);
         this._fxLayer.addEventListener(Event.REMOVED,this.containEffectLifecycle);
         this._projectileLayer.addEventListener(Event.ADDED,this.containEffectLifecycle);
         this._projectileLayer.addEventListener(Event.REMOVED,this.containEffectLifecycle);
         MapView2D.fxLayer = this._fxLayer;
         addChild(this._flashMovingContainer);
      }
      
      private function containEffectLifecycle(param1:Event) : void
      {
         if(param1.target != this._fxLayer)
         {
            param1.stopPropagation();
         }
      }
      
      public function get entitiesLayer() : MapDisplayLayer2D
      {
         return this._entitiesLayer;
      }
      
      public function get effectViewManager() : EffectsManager2D
      {
         return this._eff;
      }
      
      public function testLensFlareCollision(param1:int, param2:int) : Boolean
      {
         return this._background.testLensFlareCollision(param1,param2) || this._entitiesLayer.testLensFlareCollision(param1,param2);
      }
   }
}

