package net.bigpoint.darkorbit.map.view3D
{
   import away3d.core.managers.Stage3DManager;
   import away3d.core.managers.Stage3DProxy;
   import away3d.events.Stage3DEvent;
   import com.bigpoint.utils.PointLite;
   import flash.display.Sprite;
   import flash.display3D.Context3DRenderMode;
   import flash.events.Event;
   import flash.geom.Vector3D;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.com.module.ReadyRequest;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.EffectRangeTicker;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.hud.HUD;
   import net.bigpoint.darkorbit.map.hud.effects.HudEffectsManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.mvc.display.DisplayObjectsBuilder;
   import net.bigpoint.darkorbit.mvc.display.StarlingSprite;
   import net.bigpoint.darkorbit.settings.BindableSettings;
   import org.osflash.signals.IOnceSignal;
   import org.osflash.signals.Promise;
   import starling.core.Starling;
   import starling.events.Event;
   
   public class DarkOrbitMapView3D extends Sprite implements IMapView
   {
      
      private const _tmp:Vector3D = new Vector3D();
      
      private var _starling:Starling;
      
      private var _hud:HUD;
      
      private var _map:MapView3D;
      
      private var _viewportWidth:int = 0;
      
      private var _viewportHeight:int = 0;
      
      private var _mapModel:Map;
      
      private var _densityPollAt:int;
      
      private var _waitingForContext:Boolean = false;
      
      private var _initViewOnContext:Boolean = false;
      
      private var _stage3DManager:Stage3DManager;
      
      private var _stage3DProxy:Stage3DProxy;
      
      private var _hudEffects:HudEffectsManager;
      
      private var _itemsToLoad:int = 0;
      
      private var _ready:IOnceSignal = new Promise();
      
      public function DarkOrbitMapView3D()
      {
         super();
         try
         {
            Starling.handleLostContext = true;
         }
         catch(e:Error)
         {
         }
         mouseEnabled = mouseChildren = false;
         addEventListener(flash.events.Event.ADDED_TO_STAGE,this.handleFirstAddedToStage);
      }
      
      public function get ready() : IOnceSignal
      {
         return this._ready;
      }
      
      public function get zoom() : Number
      {
         return this._map ? this._map.zoom : 1;
      }
      
      public function get readyRequestType() : uint
      {
         return ReadyRequest.READYMESSAGE_MAP_LOADED_3D;
      }
      
      public function load(param1:Map) : void
      {
         this._mapModel = param1;
         DenseEffectPolicy3D.clear();
         this._densityPollAt = 0;
         World3D.instance.reset();
         if(this._stage3DProxy.context3D)
         {
            if(this._stage3DProxy.context3D.dispose.length == 0)
            {
               this._stage3DProxy.context3D.dispose();
            }
            else
            {
               this._stage3DProxy.context3D.dispose(false);
            }
         }
         this._waitingForContext = true;
         this._initViewOnContext = true;
         this._stage3DProxy.requestContext(false,"baseline");
      }
      
      public function setViewportSize(param1:int, param2:int) : void
      {
         this._viewportWidth = param1;
         this._viewportHeight = param2;
         this._stage3DProxy.width = this._viewportWidth;
         this._stage3DProxy.height = this._viewportHeight;
         if(Boolean(this._starling) && Boolean(this._starling.stage))
         {
            this._starling.stage.stageWidth = this._viewportWidth;
            this._starling.stage.stageHeight = this._viewportHeight;
         }
         if(this._map)
         {
            this._map.setViewportSize(this._viewportWidth,this._viewportHeight);
         }
      }
      
      public function update(param1:int, param2:int, param3:Number) : void
      {
         var _loc5_:Ship = null;
         var _loc6_:int = 0;
         var _loc7_:MapEntity = null;
         var _loc8_:Ship = null;
         var _loc4_:int = getTimer();
         EffectRangeTicker.tick(_loc4_);
         if(Boolean(_loc4_ >= this._densityPollAt) && Boolean(this._mapModel) && Boolean(this._mapModel.hero))
         {
            this._densityPollAt = _loc4_ + 250;
            _loc5_ = this._mapModel.hero;
            _loc6_ = 0;
            for each(_loc7_ in this._mapModel.entities)
            {
               _loc8_ = _loc7_ as Ship;
               if((Boolean(_loc8_)) && DenseEffectPolicy3D.includes(_loc8_.position.x - _loc5_.position.x,_loc8_.position.y - _loc5_.position.y,_loc8_.isNPC,_loc8_ is Pet,_loc8_ === _loc5_))
               {
                  _loc6_++;
               }
            }
            DenseEffectPolicy3D.update(_loc6_,_loc4_);
         }
         if(this._map)
         {
            Stage3DStats.drawCalls = 0;
            Stage3DStats.starlingDrawCalls = 0;
            this._map.update(param3,param1,param2);
            if(Settings3D.render.value)
            {
               if(Boolean(this._stage3DProxy.context3D) && this._stage3DProxy.context3D.driverInfo != "Disposed")
               {
                  this._stage3DProxy.clear();
                  this._starling.render();
                  this._map.render();
                  this._stage3DProxy.present();
               }
               else if(!this._waitingForContext)
               {
                  this._waitingForContext = true;
                  this._stage3DProxy.requestContext(false,"baseline");
               }
            }
         }
      }
      
      public function zoomTo(param1:Number, param2:Number) : void
      {
         if(this._map)
         {
            this._map.zoomTo(param1,param2);
         }
      }
      
      public function restoreUserZoom(param1:Number) : void
      {
      }
      
      public function zoomIn(param1:Number = 0.3) : void
      {
         if(this._map)
         {
            this._map.zoomIn(param1);
         }
      }
      
      public function zoomOut(param1:Number = 0.3) : void
      {
         if(this._map)
         {
            this._map.zoomOut(param1);
         }
      }
      
      public function screen2game(param1:int, param2:int, param3:PointLite = null) : PointLite
      {
         if(param3 == null)
         {
            param3 = new PointLite();
         }
         var _loc4_:Vector3D = this._map.screen2game(param1,param2,0,this._tmp);
         if(_loc4_)
         {
            param3.x = _loc4_.x;
            param3.y = _loc4_.y;
         }
         return param3;
      }
      
      public function game2screen(param1:int, param2:int, param3:int = 0, param4:PointLite = null) : PointLite
      {
         return this._map.game2screen(param1,param2,param3,param4);
      }
      
      public function dispose() : void
      {
         EffectRangeTicker.clear();
         this.load(null);
         if(this._stage3DProxy)
         {
            this._stage3DProxy.dispose();
            this._stage3DProxy = null;
         }
         World3D.instance.dispose();
      }
      
      public function addUpdatable(param1:IUpdatable) : void
      {
         this._map.addUpdatable(param1);
      }
      
      public function removeUpdatable(param1:IUpdatable) : void
      {
         this._map.removeUpdatable(param1);
      }
      
      private function handleFileCollectionReady() : void
      {
         if(this._viewportWidth == 0)
         {
            this._viewportWidth = stage.stageWidth;
            this._viewportHeight = stage.stageHeight;
         }
         this._stage3DManager = Stage3DManager.getInstance(stage);
         this._stage3DProxy = this._stage3DManager.getFreeStage3DProxy(false);
         this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED,this.handleFirstContextCreated);
         this._stage3DProxy.color = 0;
         this._stage3DProxy.width = this._viewportWidth;
         this._stage3DProxy.height = this._viewportHeight;
         this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED,this.handleContextCreated);
         this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.handleContextCreated);
         Settings3D.antialiasing.changed.add(this.updateAntiAliasing);
         this.updateAntiAliasing();
      }
      
      private function updateAntiAliasing() : void
      {
         var _loc1_:Object = {};
         _loc1_[BindableSettings.MEDIUM] = 2;
         _loc1_[BindableSettings.HIGH] = 8;
         _loc1_[BindableSettings.ULTRA] = 16;
         this._stage3DProxy.antiAlias = int(_loc1_[Settings3D.antialiasing.value]) || 0;
      }
      
      private function preload() : void
      {
         var xmlList:XMLList = null;
         var node:XML = null;
         xmlList = Main.gameXML.patterns.preloadLists.pack.(@id == "3D").children();
         for each(node in xmlList)
         {
            switch(node.name().toString())
            {
               case "geometry":
                  ++this._itemsToLoad;
                  World3D.instance.geometryLoader.loadGeometry(node.text(),World3D.LIFETIME_GLOBAL).addOnce(this.handleResourceLoadComplete);
                  break;
               case "texture":
                  ++this._itemsToLoad;
                  World3D.instance.textureLoader.loadTexture(node.text(),World3D.LIFETIME_GLOBAL).addOnce(this.handleResourceLoadComplete);
                  break;
               case "particles":
                  ++this._itemsToLoad;
                  World3D.instance.particleLoader.loadParticleByUrl(node.text(),World3D.LIFETIME_GLOBAL).addOnce(this.handleResourceLoadComplete);
            }
         }
         if(this._itemsToLoad == 0)
         {
            this.handleResourceLoadComplete();
         }
      }
      
      private function handleContextCreated(param1:flash.events.Event) : void
      {
         this._waitingForContext = false;
         if(this._initViewOnContext)
         {
            this._initViewOnContext = false;
            this._map.load(this._mapModel);
            this._hud.map = this._mapModel;
            this._hudEffects.map = this._mapModel;
         }
      }
      
      private function handleFirstAddedToStage(param1:flash.events.Event) : void
      {
         removeEventListener(flash.events.Event.ADDED_TO_STAGE,this.handleFirstAddedToStage);
         World3D.instance.initFileCollection(this.handleFileCollectionReady);
      }
      
      private function handleFirstContextCreated(param1:Stage3DEvent) : void
      {
         this._stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED,this.handleFirstContextCreated);
         this._map = new MapView3D(this,this._stage3DProxy,DisplayObjectsBuilder.starlingViewBuilder);
         this._starling = new Starling(StarlingSprite,stage,this._stage3DProxy.viewPort,this._stage3DProxy.stage3D,Context3DRenderMode.AUTO,"baseline");
         this._starling.shareContext = true;
         this._starling.enableErrorChecking = false;
         this._starling.addEventListener(starling.events.Event.ROOT_CREATED,this.handleStarlingRootCreated);
      }
      
      private function handleStarlingRootCreated(param1:starling.events.Event) : void
      {
         this._starling.removeEventListener(starling.events.Event.ROOT_CREATED,this.handleStarlingRootCreated);
         StarlingSprite(this._starling.root).addUntypedChild(this._map.background2DContainer);
         addChild(this._map);
         this._map.setViewportSize(this._viewportWidth,this._viewportHeight);
         this._hud = new HUD(this);
         addChild(this._hud);
         this._hudEffects = new HudEffectsManager(this,this._hud);
         this.preload();
      }
      
      private function handleResourceLoadComplete(... rest) : void
      {
         if(--this._itemsToLoad <= 0)
         {
            this._ready.dispatch();
         }
      }
      
      override public function toString() : String
      {
         var _loc1_:* = this;
         var _loc2_:Array = [_loc1_.name];
         while(_loc1_.parent)
         {
            _loc1_ = _loc1_.parent;
            _loc2_.unshift(_loc1_.name);
         }
         return "3D " + stage.stageWidth + "x" + stage.stageHeight + " " + _loc2_.join(".");
      }
   }
}

