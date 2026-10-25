package net.bigpoint.darkorbit.map.view2D
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.com.module.ReadyRequest;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.DroneDisplayBudget;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.hud.HUD;
   import net.bigpoint.darkorbit.map.hud.effects.HudEffectsManager;
   import net.bigpoint.darkorbit.map.hud.effects.impl.FlashLightEffect2D;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.display.DisplayObjectsBuilder;
   import net.bigpoint.darkorbit.mvc.display.StarlingSprite;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.osflash.signals.IOnceSignal;
   import org.osflash.signals.Promise;
   import starling.core.Starling;
   import starling.events.Event;
   
   public class DarkOrbitMapView2D extends Sprite implements IMapView
   {
      
      private var _starling:Starling;
      
      private var _wheelStage:Stage;
      
      private var _hudEffects:HudEffectsManager;
      
      private var _hud:HUD;
      
      private var _map:MapView2D;
      
      private var _viewportWidth:int = 0;
      
      private var _viewportHeight:int = 0;
      
      private var _lockDisplay:LockDisplay2D;
      
      private var _mapModel:Map;
      
      private var _waitingForContext:Boolean = false;
      
      private var _initViewOnContext:Boolean = false;
      
      private var _updatables:Vector.<IUpdatable> = new Vector.<IUpdatable>();
      
      private var _preloadList:Vector.<String> = new Vector.<String>();
      
      private var _ready:IOnceSignal = new Promise();
      
      private var _mosaicBitmap:Bitmap;
      
      private const blockSize:Number = 4;
      
      private var _matrix:Matrix = new Matrix();
      
      public function DarkOrbitMapView2D()
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
         addEventListener(flash.events.Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(flash.events.Event.REMOVED_FROM_STAGE,this.handleRemovedToStage);
         this.updateMosaic();
      }
      
      public function get ready() : IOnceSignal
      {
         return this._ready;
      }
      
      public function get zoom() : Number
      {
         return this._map ? this._map.zoom : 1;
      }
      
      public function load(param1:Map) : void
      {
         this._mapModel = param1;
         DroneDisplayBudget.begin(param1);
         if(this._starling)
         {
            if(this._starling.context)
            {
               if(this._starling.context.dispose.length == 0)
               {
                  this._starling.context.dispose();
               }
               else
               {
                  this._starling.context.dispose(false);
               }
            }
            this._waitingForContext = true;
            this._initViewOnContext = true;
            this._starling.requestContext3D(this._starling.stage3D,"auto","baseline");
            return;
         }
         this.loadView();
      }
      
      public function setViewportSize(param1:int, param2:int) : void
      {
         this._viewportWidth = param1;
         this._viewportHeight = param2;
         scrollRect = new Rectangle(0,0,this._viewportWidth,this._viewportHeight);
         if(Boolean(this._starling) && Boolean(this._starling.stage))
         {
            this._starling.viewPort = scrollRect;
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
         DroneDisplayBudget.update(this._mapModel,ScreenManager.getInstance().frameTime);
         if(this._map)
         {
            this._map.update(param1,param2,param3);
         }
         DenseRasterQuality2D.update(stage,DenseEffectPolicy2D.denseScene);
         if(this._lockDisplay)
         {
            this._lockDisplay.updateObj(param3);
         }
         var _loc4_:* = int(this._updatables.length - 1);
         while(_loc4_ >= 0)
         {
            this._updatables[_loc4_].updateObj(param3);
            _loc4_--;
         }
         if(this._starling)
         {
            if(Boolean(this._starling.context) && this._starling.context.driverInfo != "Disposed")
            {
               this._starling.render();
            }
            else if(!this._waitingForContext)
            {
               this._waitingForContext = true;
               this._starling.requestContext3D(this._starling.stage3D,"auto","baseline");
            }
         }
         if(Settings.displaySettingPixelationMode.value && Settings.pixelatedRenderingAvailable.value)
         {
            this.updateMosaic();
         }
         else
         {
            if(this._mosaicBitmap)
            {
               this._mosaicBitmap.visible = false;
            }
            this._map.visible = true;
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
         if(this._map)
         {
            this._map.restoreUserZoom(param1);
         }
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
      
      public function get mapLayer() : MapView2D
      {
         return this._map;
      }
      
      public function screen2game(param1:int, param2:int, param3:PointLite = null) : PointLite
      {
         return this._map.screen2game(param1,param2,param3);
      }
      
      public function game2screen(param1:int, param2:int, param3:int = 0, param4:PointLite = null) : PointLite
      {
         return this._map.game2screen(param1,param2,param4);
      }
      
      public function dispose() : void
      {
         DenseRasterQuality2D.clear();
         DroneDisplayBudget.end(this._mapModel);
         Settings.showDrones.changed.remove(this.preloadAssets);
         Settings.showMyDrones.changed.remove(this.preloadAssets);
         Settings.qualityExplosion.changed.remove(this.preloadAssets);
         this.load(null);
         this._starling.dispose();
         this._starling = null;
      }
      
      public function updateMosaic() : void
      {
         if(this._mosaicBitmap == null)
         {
            this._mosaicBitmap = new Bitmap();
            this._mosaicBitmap.scaleX = this._mosaicBitmap.scaleY = this.blockSize;
            addChild(this._mosaicBitmap);
            this._matrix.scale(1 / this.blockSize,1 / this.blockSize);
         }
         this._mosaicBitmap.visible = true;
         var _loc1_:int = int(int(Math.floor(this._viewportWidth / this.blockSize)) || 1);
         var _loc2_:int = int(int(Math.floor(this._viewportHeight / this.blockSize)) || 1);
         if(Boolean(this._mosaicBitmap.bitmapData) && (this._mosaicBitmap.bitmapData.width != _loc1_ || this._mosaicBitmap.bitmapData.height != _loc2_))
         {
            this._mosaicBitmap.bitmapData.dispose();
            this._mosaicBitmap.bitmapData = null;
         }
         if(this._mosaicBitmap.bitmapData == null)
         {
            this._mosaicBitmap.bitmapData = new BitmapData(_loc1_,_loc2_,true);
            this._mosaicBitmap.smoothing = false;
         }
         if(this._map)
         {
            this._mosaicBitmap.bitmapData.fillRect(new Rectangle(0,0,this._mosaicBitmap.bitmapData.width,this._mosaicBitmap.bitmapData.height),0);
            this._map.visible = true;
            this._mosaicBitmap.bitmapData.draw(this._map,this._matrix);
            this._map.visible = false;
         }
      }
      
      private function loadView() : void
      {
         var staticMapDescriptor:XML;
         var backgroundColor:String = null;
         var color:uint = 0;
         this._map.load(this._mapModel);
         this._hud.map = this._mapModel;
         this._hudEffects.map = this._mapModel;
         this._lockDisplay.map = this._mapModel;
         staticMapDescriptor = Map.getStaticMapDescriptor(this._mapModel.mapID);
         if(staticMapDescriptor)
         {
            backgroundColor = staticMapDescriptor.@backgroundColor;
            if(backgroundColor.length > 0)
            {
               color = uint("0x" + backgroundColor);
            }
            else
            {
               color = 0;
            }
            stage.color = color;
            if(Boolean(this._starling) && Boolean(this._starling.stage))
            {
               this._starling.stage.color = color;
            }
            MovieClipUtils.drawBounds(stage);
         }
         TweenLite.delayedCall(1,function():void
         {
            Settings.displaySettingPixelationMode.changed.add(handlePixelationModeChanged);
            Settings.pixelatedRenderingAvailable.changed.add(handlePixelationModeChanged);
            handlePixelationModeChanged();
         });
      }
      
      private function initMapView() : void
      {
         addChild(this._map);
         this._map.setViewportSize(this._viewportWidth,this._viewportHeight);
         this._hud = new HUD(this);
         this._hudEffects = new HudEffectsManager(this,this._hud);
         this._hudEffects.addMapping(EffectIDList.FLASH_LIGHT,FlashLightEffect2D);
         addChild(this._hud);
         this._hud.addChildOnLayer(this._lockDisplay = new LockDisplay2D(this),1);
         this.preload();
         Settings.showDrones.changed.add(this.preloadAssets);
         Settings.showMyDrones.changed.add(this.preloadAssets);
         Settings.qualityExplosion.changed.add(this.preloadAssets);
      }
      
      private function handlePixelationModeChanged() : void
      {
         if(Settings.displaySettingPixelationMode.value && Settings.pixelatedRenderingAvailable.value)
         {
            if(Settings.gpuSupport)
            {
               StarlingSprite(this._map.backgroundContainer).filter = new StarlingPixelateFilter2D(4);
            }
            this._map.visible = false;
         }
         else
         {
            if(Settings.gpuSupport)
            {
               StarlingSprite(this._map.backgroundContainer).filter = null;
            }
            this._map.visible = true;
         }
      }
      
      private function preload() : void
      {
         this.preloadNext();
      }
      
      private function preloadNext(... rest) : void
      {
         if(this._preloadList.length > 0)
         {
            ResourceManager.fileCollection.load(this._preloadList.pop(),this.preloadNext,this.preloadNext);
         }
         else
         {
            this._ready.dispatch();
         }
      }
      
      private function preloadAssets() : void
      {
         if(Settings.showDrones.value || Settings.showMyDrones.value)
         {
            GameFacade.getInstance().sendNotification(AssetNotifications.PRELOAD_LIST,new <String>["drones"]);
         }
         if(Settings.qualityExplosion.value > Settings.QUALITY_LOW)
         {
            GameFacade.getInstance().sendNotification(AssetNotifications.PRELOAD_LIST,"explosions",AssetNotifications.TYPE_PRELOAD_LIST_TYPE_PATTERN_KEY);
         }
      }
      
      private function handleContextCreated(param1:flash.events.Event) : void
      {
         this._waitingForContext = false;
         if(this._initViewOnContext)
         {
            this._initViewOnContext = false;
            this.loadView();
         }
      }
      
      private function handleFirstAddedToStage(param1:flash.events.Event) : void
      {
         removeEventListener(flash.events.Event.ADDED_TO_STAGE,this.handleFirstAddedToStage);
         Settings.gpuSupport = false;
         if(this._viewportWidth == 0)
         {
            this._viewportWidth = stage.stageWidth;
            this._viewportHeight = stage.stageHeight;
         }
         this._map = new MapView2D(this,DisplayObjectsBuilder.flashViewBuilder);
         if(Settings.gpuSupport)
         {
            this._starling = new Starling(StarlingSprite,stage,null,null,"auto","auto");
            this._starling.enableErrorChecking = false;
            this._starling.stage3D.addEventListener(starling.events.Event.CONTEXT3D_CREATE,this.handleContextCreated);
            this._starling.addEventListener(starling.events.Event.ROOT_CREATED,this.handleStarlingRootCreated);
         }
         else
         {
            addChildAt(this._map.backgroundContainer as DisplayObject,0);
            this.initMapView();
         }
      }
      
      private function handleStarlingRootCreated(param1:starling.events.Event) : void
      {
         this._starling.removeEventListener(starling.events.Event.ROOT_CREATED,this.handleStarlingRootCreated);
         StarlingSprite(this._starling.root).addUntypedChild(this._map.backgroundContainer);
         this.initMapView();
      }
      
      private function handleAddedToStage(param1:flash.events.Event) : void
      {
      }
      
      private function handleRemovedToStage(param1:flash.events.Event) : void
      {
      }
      
      public function get readyRequestType() : uint
      {
         return ReadyRequest.READYMESSAGE_MAP_LOADED_2D;
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
         return "2D " + stage.stageWidth + "x" + stage.stageHeight + " " + _loc2_.join(".");
      }
   }
}

