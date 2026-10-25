package net.bigpoint.darkorbit.managers
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.tooltip.StandaloneToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.MapViewProxy;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.minimap.MiniMap;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.vo.ViewportResizeValuesVO;
   import net.bigpoint.darkorbit.mvc.common.view.ScreenNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.hints.HintsNotifications;
   import net.bigpoint.darkorbit.mvc.hints.view.HintsMediator;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ScreenManager
   {
      
      public static var halfScreenWidth:int;
      
      public static var halfScreenHeight:int;
      
      private static var _instance:ScreenManager;
      
      private static var windowLayer:Sprite;
      
      private static var observersLength:int;
      
      public static var CAMERA_LOCKED_TO_HERO:int = 0;
      
      public static var CAMERA_TWEENING_TO_HERO:int = 1;
      
      public static var CAMERA_LOCKED_TO_SHIP:int = 2;
      
      public static var CAMERA_TWEENING_TO_SHIP:int = 3;
      
      public static var CAMERA_LOCKED_TO_COORDINATE:int = 4;
      
      public static var CAMERA_TWEENING_TO_COORDINATE:int = 5;
      
      public static var camera:Point = new Point();
      
      public static var lockedShipUserID:int = -1;
      
      public static var cameraLock:int = 0;
      
      private static var screenWidth:int = MIN_SCREEN_WIDTH;
      
      private static var screenHeight:int = MIN_SCREEN_HEIGHT;
      
      private static const CAPTAIN_TIMER_INTERVAL:uint = 1000;
      
      private static const REMINDER_TIMEOUT:uint = 10000;
      
      private static const RESIZE_DELAY:int = 250;
      
      public static const MIN_SCREEN_WIDTH:int = 750;
      
      public static const MIN_SCREEN_HEIGHT:int = 600;
      
      private static const observers:Vector.<IFrameObserver> = new Vector.<IFrameObserver>();
      
      public const resized:ISignal = new Signal();
      
      private var _hitLayer:Sprite;
      
      private var guiLayer0:Sprite;
      
      private var guiLayer1:Sprite;
      
      private var windowLayer2:Sprite;
      
      private var popupLayer:DisplayObjectContainer;
      
      private var tooltipLayer:Sprite;
      
      private var mouseCursorLayer:Sprite;
      
      private var dragNdropLayer:Sprite;
      
      private var multiSelectionLayer:Sprite;
      
      private var iconLayer:Sprite;
      
      private var _topmenuLayer:Sprite;
      
      private var _mainmenuLayer:Sprite;
      
      private var flashShape:Sprite;
      
      private var currTime:Number = 0;
      
      private var prevTime:Number = 0;
      
      private var tpf:Number = 0;
      
      private var gameFacade:GameFacade;
      
      private var _nazContainer:Sprite;
      
      private var fullscreenActiveAcceptTimer:Timer;
      
      private var _hasFocus:Boolean;
      
      internal var captainTimerId:int = -1;
      
      private var _viewportResizeValues:ViewportResizeValuesVO;
      
      private var _resizeTimeout:int;
      
      private var shakeTime:Number = 0;
      
      private var shakeTimerOn:Boolean = false;
      
      private var cnt:int;
      
      private var shakeFactor:int = 5;
      
      private var _eventManager:EventManager;
      
      private var _mapViewLoader:MapViewProxy;
      
      private var _mapView:IMapView;
      
      private var _miniMap:MiniMap;
      
      private var _mainContainer:Sprite;
      
      private var _hero:Ship;
      
      private var _initLayersCallback:Function;
      
      private var _map:Map = new Map(-1);
      
      public const mapChanged:ISignal = new Signal();
      
      private var _mapUpdatables:EntityTraitContainer = new EntityTraitContainer();
      
      public function ScreenManager(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("ScreenManager is a Singleton and can only be accessed through ScreenManager.getInstance()");
         }
         Hero.cargo.changed.add(this.handleHeroCargoChanged);
         Hero.maxCargo.changed.add(this.handleHeroCargoChanged);
         Hero.captainEnergy.changed.add(this.handleHeroCaptainChanged);
         Hero.maxCaptainEnergy.changed.add(this.handleHeroCaptainChanged);
         Hero.captainPerkInfo.changed.add(this.handleHeroCaptainChanged);
         Hero.captainEnergyDrain.changed.add(this.startCaptainTimer);
      }
      
      public static function getInstance() : ScreenManager
      {
         if(_instance == null)
         {
            _instance = new ScreenManager(hidden);
         }
         return _instance;
      }
      
      public static function getWindowLayer() : Sprite
      {
         return windowLayer;
      }
      
      public static function getScreenWidth() : int
      {
         return screenWidth;
      }
      
      public static function getScreenHeight() : int
      {
         return screenHeight;
      }
      
      public static function getHalfScreenWidth() : int
      {
         return halfScreenWidth;
      }
      
      public static function getHalfScreenHeight() : int
      {
         return halfScreenHeight;
      }
      
      private static function hidden() : void
      {
      }
      
      public static function addObserver(param1:IFrameObserver) : void
      {
         removeObserver(param1);
         observers.push(param1);
         ++observersLength;
      }
      
      public static function removeObserver(param1:IFrameObserver) : void
      {
         var _loc2_:int = observers.indexOf(param1);
         if(_loc2_ != -1)
         {
            observers.splice(_loc2_,1);
            --observersLength;
         }
      }
      
      public static function containsObserver(param1:IFrameObserver) : Boolean
      {
         return observers.indexOf(param1) != -1;
      }
      
      public function get map() : Map
      {
         return this._map;
      }
      
      public function set map(param1:Map) : void
      {
         var _loc2_:int = 0;
         if(this._map)
         {
            this._map.getShipManager().heroChanged.remove(this.handleHeroChanged);
            _loc2_ = this._map.mapID;
            if(_loc2_ != param1.mapID || _loc2_ != 1 && _loc2_ != 5 && _loc2_ != 9)
            {
               this._map.cleanup();
            }
            TooltipControl.getInstance().hideAllToolTips();
            AudioManager.cleanup();
         }
         this._map = param1;
         cameraLock = CAMERA_LOCKED_TO_SHIP;
         TweenLite.killTweensOf(ScreenManager.camera);
         this._eventManager.map = this._map;
         this._mapView.load(this._map);
         AudioManager.mapManager.map = this._map;
         this.minimap.map = this._map;
         if(this._map)
         {
            this._mapUpdatables = this._map.getTraitsList(IUpdatable);
            this._map.getShipManager().heroChanged.add(this.handleHeroChanged);
            this.handleHeroChanged(this._map.hero);
         }
         this.mapChanged.dispatch();
      }
      
      public function init(param1:Sprite) : void
      {
         this._mainContainer = param1;
         this.stage.addEventListener("fullScreenInteractiveAccepted",this.fullscreenInterActiveAccepted);
         this.gameFacade = GameFacade.getInstance();
         this.stage.addEventListener(Event.RESIZE,this.onDelayedResize);
         this.stage.addEventListener(Event.DEACTIVATE,this.handleDeativate);
         this.stage.addEventListener(Event.ACTIVATE,this.handleActivate);
         this._viewportResizeValues = new ViewportResizeValuesVO(new PointLite(this.stageWidth,this.stageHeight));
         this._hitLayer = new Sprite();
         this._hitLayer.graphics.clear();
         this._hitLayer.graphics.beginFill(255,0);
         this._hitLayer.graphics.drawRect(0,0,100,100);
         this._hitLayer.graphics.endFill();
         this._mainContainer.addChildAt(this._hitLayer,0);
         this._eventManager = new EventManager(this.stage,this._hitLayer);
         this.stageResizeHandler();
      }
      
      public function shakeScreen(param1:Number = 40, param2:Number = 5) : void
      {
         this.cnt = param1;
         this.shakeFactor = param2;
         this.shakeTimerOn = true;
      }
      
      public function flashScreen(param1:uint, param2:Number = 0.4, param3:Number = 0.25, param4:Number = 0.75) : void
      {
         if(this.flashShape == null)
         {
            this.flashShape = new Sprite();
            this.flashShape.mouseEnabled = false;
            this.flashShape.mouseChildren = false;
            this.flashShape.graphics.beginFill(param1);
            this.flashShape.graphics.drawRect(0,0,screenWidth,screenHeight);
            this.flashShape.alpha = 0;
            this._mainContainer.addChild(this.flashShape);
            TweenLite.to(this.flashShape,param3,{
               "alpha":param2,
               "onComplete":this.handleColorScreen,
               "onCompleteParams":[param4]
            });
         }
      }
      
      private function handleActivate(param1:Event) : void
      {
         this._hasFocus = true;
      }
      
      private function handleDeativate(param1:Event) : void
      {
         this._hasFocus = false;
      }
      
      public function createLayers(param1:Function) : void
      {
         this._initLayersCallback = param1;
         this._mapViewLoader = new MapViewProxy(this.stage,this._mainContainer);
         this._mapViewLoader.mapViewReady.add(this.handleMapViewReadyTmp);
         this._mapViewLoader.mapViewReady.add(this.handleFirstMapViewReady);
         this.reloadMapView(Settings.FORCE_2D.value);
      }
      
      public function reloadMapView(param1:Boolean) : void
      {
         this._mapView = null;
         this._mapViewLoader.loadMapView(param1);
      }
      
      public function fullscreenToggle() : void
      {
         var _loc1_:Boolean = this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE;
         if(_loc1_)
         {
            this._viewportResizeValues.beforeResize = new PointLite(this.stageWidth,this.stageHeight);
            this.stage.displayState = StageDisplayState.NORMAL;
            _loc1_ = false;
            this.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenChangeHandler);
         }
         else
         {
            this._viewportResizeValues.beforeResize = new PointLite(this.stageWidth,this.stageHeight);
            this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            _loc1_ = true;
            this.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenChangeHandler);
            EventStreamClient.track("switch_fullscreen",{"fullscreen":1});
         }
         this.gameFacade.sendNotification(FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,_loc1_,FeaturesMenuConstants.FULLSCREEN);
         this.updateAcceptReminder(_loc1_);
      }
      
      public function stageResizeHandler() : void
      {
         var _loc1_:Rectangle = null;
         if(Settings.resizeOnTheFly)
         {
            clearTimeout(this._resizeTimeout);
            this._resizeTimeout = 0;
            if(!this.stage)
            {
               return;
            }
            this.updateScreenSize();
            TooltipControl.getInstance().setBounds(new Rectangle(0,0,this.stageWidth,this.stageHeight));
            this.gameFacade.forwardNotification(HintsNotifications.CENTER_HINTS);
            this.gameFacade.forwardNotification(GuiNotifications.UPDATE_MENUS_CONFIG_MODE);
            _loc1_ = new Rectangle();
            _loc1_.width = this.stage.stageWidth;
            _loc1_.height = this.stage.stageHeight;
            this.viewportResizeValues.afterResize = new PointLite(this.stageWidth,this.stageHeight);
            this.gameFacade.sendNotification(ScreenNotifications.SCREEN_VIEWPORT_RESIZED);
            this.viewportResizeValues.beforeResize = new PointLite(this.stageWidth,this.stageHeight);
            this.resized.dispatch();
         }
      }
      
      public function getGUILayer0() : Sprite
      {
         return this.guiLayer0;
      }
      
      public function getMouseCursorLayer() : Sprite
      {
         return this.mouseCursorLayer;
      }
      
      public function getDragNDropLayer() : Sprite
      {
         return this.dragNdropLayer;
      }
      
      public function getMultiSelectionLayer() : Sprite
      {
         return this.multiSelectionLayer;
      }
      
      public function getTooltipLayer() : Sprite
      {
         return this.tooltipLayer;
      }
      
      public function getWindowLayer2() : Sprite
      {
         return this.windowLayer2;
      }
      
      public function getIconLayer() : Sprite
      {
         return this.iconLayer;
      }
      
      private function handleColorScreen(param1:Number) : void
      {
         if(this.flashShape != null)
         {
            TweenLite.to(this.flashShape,param1,{
               "alpha":0,
               "onComplete":this.handleRemoveFlashShape
            });
         }
      }
      
      private function handleRemoveFlashShape() : void
      {
         if(this.flashShape != null)
         {
            if(this._mainContainer.contains(this.flashShape))
            {
               this._mainContainer.removeChild(this.flashShape);
            }
            this.flashShape = null;
         }
      }
      
      private function handleMapViewReadyTmp() : void
      {
         this._mapView = this._mapViewLoader.mapView;
         this.updateScreenSize();
         if(this._map)
         {
            this._mapView.load(this._map);
         }
      }
      
      public function handleFirstMapViewReady() : void
      {
         if(this._mapViewLoader)
         {
            this._mapViewLoader.mapViewReady.remove(this.handleFirstMapViewReady);
         }
         this._miniMap = new MiniMap();
         this.guiLayer0 = new Sprite();
         this.guiLayer0.mouseEnabled = false;
         this.guiLayer0.mouseChildren = false;
         this._mainContainer.addChild(this.guiLayer0);
         this.guiLayer1 = new Sprite();
         this.guiLayer1.mouseEnabled = false;
         this.guiLayer1.mouseChildren = false;
         this._mainContainer.addChild(this.guiLayer1);
         this._mainmenuLayer = new Sprite();
         this._mainmenuLayer.mouseEnabled = Main.mouseEventsEnabled;
         this._mainContainer.addChild(this._mainmenuLayer);
         windowLayer = new Sprite();
         windowLayer.mouseEnabled = Main.mouseEventsEnabled;
         this._mainContainer.addChild(windowLayer);
         this._topmenuLayer = new Sprite();
         this._topmenuLayer.mouseEnabled = Main.mouseEventsEnabled;
         this._mainContainer.addChild(this._topmenuLayer);
         this.iconLayer = new Sprite();
         this.iconLayer.mouseEnabled = Main.mouseEventsEnabled;
         this._mainContainer.addChild(this.iconLayer);
         this.popupLayer = new Sprite();
         this.popupLayer.mouseEnabled = Main.mouseEventsEnabled;
         this._mainContainer.stage.addChild(this.popupLayer);
         this.windowLayer2 = new Sprite();
         this.windowLayer2.mouseEnabled = Main.mouseEventsEnabled;
         this._mainContainer.stage.addChild(this.windowLayer2);
         this.dragNdropLayer = new Sprite();
         this.dragNdropLayer.mouseEnabled = false;
         this._mainContainer.stage.addChild(this.dragNdropLayer);
         this.multiSelectionLayer = new Sprite();
         this.multiSelectionLayer.mouseEnabled = false;
         this._mainContainer.stage.addChild(this.multiSelectionLayer);
         this.tooltipLayer = new Sprite();
         this.tooltipLayer.mouseEnabled = false;
         this._mainContainer.stage.addChild(this.tooltipLayer);
         StandaloneToolTipHook.getInstance().init(this.tooltipLayer);
         this.mouseCursorLayer = new Sprite();
         this.mouseCursorLayer.mouseEnabled = false;
         this._mainContainer.stage.addChild(this.mouseCursorLayer);
         Settings.showUI.changed.add(this.updateUIVisible);
         this.updateUIVisible();
         this.gameFacade.registerMediator(new HintsMediator(this.guiLayer1));
         this.gameFacade.sendNotification(ScreenNotifications.SCREEN_VIEWPORT_RESIZED);
         this.stage.addEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
         this.stage.addEventListener(Event.RENDER,this.renderFrame);
         if(this._initLayersCallback != null)
         {
            this._initLayersCallback();
            this._initLayersCallback = null;
         }
      }
      
      private function updateUIVisible() : void
      {
         this.guiLayer0.visible = this.guiLayer1.visible = windowLayer.visible = this._topmenuLayer.visible = this._mainmenuLayer.visible = this.iconLayer.visible = this.popupLayer.visible = this.windowLayer2.visible = this.tooltipLayer.visible = this.dragNdropLayer.visible = this.mouseCursorLayer.visible = Settings.showUI.value;
      }
      
      private function startCaptainTimer() : void
      {
         if(this.captainTimerId >= 0)
         {
            this.killCaptainTimer();
         }
         if(Hero.captainEnergyDrain.value === 0 || Hero.captainEnergy.value === 0)
         {
            return;
         }
         this.captainTimerId = setInterval(this.tickCaptainEnergy,CAPTAIN_TIMER_INTERVAL);
      }
      
      private function killCaptainTimer() : void
      {
         clearInterval(this.captainTimerId);
         this.captainTimerId = -1;
      }
      
      private function tickCaptainEnergy() : void
      {
         Hero.captainEnergy.value = Math.max(0,Hero.captainEnergy.value - Hero.captainEnergyDrain.value);
      }
      
      private function killFullscreenActiveAcceptReminder() : void
      {
         if(this.fullscreenActiveAcceptTimer)
         {
            this.fullscreenActiveAcceptTimer.removeEventListener(TimerEvent.TIMER,this.handleStartFullscreenActiveAccept);
            this.fullscreenActiveAcceptTimer.stop();
            this.fullscreenActiveAcceptTimer = null;
         }
      }
      
      private function startFullscreenActiveAcceptReminder() : void
      {
         this.fullscreenActiveAcceptTimer = new Timer(REMINDER_TIMEOUT,3);
         this.fullscreenActiveAcceptTimer.addEventListener(TimerEvent.TIMER,this.handleStartFullscreenActiveAccept);
         this.fullscreenActiveAcceptTimer.start();
      }
      
      private function updateAcceptReminder(param1:Boolean) : void
      {
         if(param1)
         {
            this.startFullscreenActiveAcceptReminder();
         }
         else
         {
            this.killFullscreenActiveAcceptReminder();
         }
      }
      
      private function updateScreenSize() : void
      {
         screenWidth = this.stageWidth;
         halfScreenWidth = screenWidth / 2;
         screenHeight = this.stageHeight;
         halfScreenHeight = screenHeight / 2;
         if(this._mapView)
         {
            this._hitLayer.width = screenWidth;
            this._hitLayer.height = screenHeight;
            this._mapView.setViewportSize(screenWidth,screenHeight);
         }
      }
      
      private function onDelayedResize(param1:Event) : void
      {
         clearTimeout(this._resizeTimeout);
         this._resizeTimeout = setTimeout(this.stageResizeHandler,RESIZE_DELAY);
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         this.stage.invalidate();
      }
      
      private function fullScreenChangeHandler(param1:FullScreenEvent) : void
      {
         this._viewportResizeValues.beforeResize = new PointLite(this._viewportResizeValues.afterResize.x,this.viewportResizeValues.afterResize.y);
         if(this.stage.displayState == StageDisplayState.NORMAL)
         {
            this.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenChangeHandler);
            TweenMax.delayedCall(0.25,this.stageResizeHandler);
            this.updateAcceptReminder(false);
            this.gameFacade.sendNotification(FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,false,FeaturesMenuConstants.FULLSCREEN);
            EventStreamClient.track("switch_fullscreen",{"fullscreen":0});
         }
      }
      
      private function fullscreenInterActiveAccepted(param1:FullScreenEvent) : void
      {
         this.killFullscreenActiveAcceptReminder();
      }
      
      private function handleStartFullscreenActiveAccept(param1:TimerEvent) : void
      {
         this.gameFacade.sendNotification(GuiNotifications.ADD_GLOBAL_NOTIFICATION_MESSAGE,new MessageCommandParams().setMessage("\n \n \n" + BPLocale.getItem("msg_fullscreen_active_accept_reminder")));
      }
      
      public function get frameTime() : int
      {
         return int(this.currTime);
      }
      
      private function renderFrame(param1:Event = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:* = 0;
         var _loc5_:Ship = null;
         this.currTime = getTimer();
         this.tpf = this.currTime - this.prevTime;
         var _loc2_:int = 0;
         while(_loc2_ < observersLength)
         {
            observers[_loc2_].updateTimer(this.tpf);
            _loc2_++;
         }
         this.prevTime = this.currTime;
         if(this._map != null)
         {
            if(cameraLock == CAMERA_LOCKED_TO_SHIP)
            {
               _loc5_ = this.map.getShipManager().getShip(lockedShipUserID);
               if(_loc5_ != null)
               {
                  camera.x = _loc5_.x;
                  camera.y = _loc5_.y;
               }
               else
               {
                  cameraLock = CAMERA_LOCKED_TO_HERO;
               }
            }
            if(this.map.hero != null && cameraLock == CAMERA_LOCKED_TO_HERO)
            {
               camera.x = int(this.map.hero.x);
               camera.y = int(this.map.hero.y);
            }
            if(this.shakeTimerOn)
            {
               this.shakeTime += this.tpf;
               if(this.shakeTime > 24)
               {
                  --this.cnt;
                  if(this.cnt % 10 == 0)
                  {
                     --this.shakeFactor;
                  }
                  if(this.cnt < 0)
                  {
                     this.shakeTimerOn = false;
                  }
                  else
                  {
                     camera.x += this.shakeFactor * Math.cos(this.cnt);
                     camera.y += this.shakeFactor * Math.sin(this.cnt);
                  }
                  this.shakeTime = 0;
               }
            }
            _loc3_ = this.tpf / 1000;
            _loc4_ = int(this._mapUpdatables.traits.length - 1);
            while(_loc4_ >= 0)
            {
               IUpdatable(this._mapUpdatables.traits[_loc4_]).updateObj(_loc3_);
               _loc4_--;
            }
            if(this._mapView)
            {
               this._mapView.update(camera.x,camera.y,_loc3_);
            }
         }
      }
      
      private function handleHeroChanged(param1:Ship) : void
      {
         if(this._hero)
         {
            this._hero.hp.changed.remove(this.handleHeroHPChanged);
         }
         this._hero = param1;
         if(this._hero)
         {
            this._hero.hp.changed.add(this.handleHeroHPChanged);
            this.handleHeroHPChanged();
         }
      }
      
      private function handleHeroHPChanged() : void
      {
         if(!GuiManager.instance)
         {
            return;
         }
         GuiManager.instance.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_HITPOINTS);
         GuiManager.instance.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_NANOHULL);
         GuiManager.instance.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_SHIELD);
      }
      
      private function handleHeroCargoChanged() : void
      {
         GuiManager.instance.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_1,SimpleElement.TYPE_CARGO);
      }
      
      private function handleHeroCaptainChanged() : void
      {
         GuiManager.instance.updateInfoField(GuiConstants.USER_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_2,SimpleElement.TYPE_CAPTAIN_ENERGY);
      }
      
      public function get topmenuLayer() : Sprite
      {
         return this._topmenuLayer;
      }
      
      public function get mainmenuLayer() : Sprite
      {
         return this._mainmenuLayer;
      }
      
      public function get nazContainer() : DisplayObjectContainer
      {
         if(!this._nazContainer)
         {
            this._nazContainer = new Sprite();
         }
         if(!this.guiLayer1.contains(this._nazContainer))
         {
            this.guiLayer1.addChild(this._nazContainer);
         }
         this._nazContainer.x = ScreenManager.halfScreenWidth;
         return this._nazContainer;
      }
      
      public function turnFullscreenOff() : void
      {
         if(this.stage.displayState != StageDisplayState.NORMAL)
         {
            this.stage.displayState = StageDisplayState.NORMAL;
         }
         else
         {
            this.gameFacade.forwardNotification(ScreenNotifications.FULLSCREEN_CHANGE_COMPLETE);
         }
      }
      
      public function get viewportResizeValues() : ViewportResizeValuesVO
      {
         return this._viewportResizeValues;
      }
      
      public function get stageWidth() : Number
      {
         return this.stage ? this.stage.stageWidth : 0;
      }
      
      public function get stageHeight() : Number
      {
         return this.stage ? Math.max(MIN_SCREEN_HEIGHT,this.stage.stageHeight) : 0;
      }
      
      public function get stageSize() : PointLite
      {
         return new PointLite(this.stageWidth,this.stageHeight);
      }
      
      public function get stage() : Stage
      {
         return this._mainContainer ? this._mainContainer.stage : null;
      }
      
      public function get duringRrsize() : Boolean
      {
         return this._resizeTimeout > 0;
      }
      
      public function getPopupLayer() : DisplayObjectContainer
      {
         return this.popupLayer;
      }
      
      public function screen2game(param1:int, param2:int, param3:PointLite = null) : PointLite
      {
         return this._mapView.screen2game(param1,param2,param3);
      }
      
      public function get minimap() : MiniMap
      {
         return this._miniMap;
      }
      
      public function get mapView() : IMapView
      {
         return this._mapView;
      }
      
      public function get eventManager() : EventManager
      {
         return this._eventManager;
      }
      
      public function get hasFocus() : Boolean
      {
         return this._hasFocus;
      }
      
      public function get hitLayer() : Sprite
      {
         return this._hitLayer;
      }
      
      public function set mapView(param1:IMapView) : void
      {
         this._mapView = param1;
      }
   }
}

