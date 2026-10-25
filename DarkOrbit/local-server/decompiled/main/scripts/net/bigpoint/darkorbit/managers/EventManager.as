package net.bigpoint.darkorbit.managers
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.PointLiteSpecial;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.CaptchaCollectRequest;
   import net.bigpoint.darkorbit.com.module.CollectBoxRequest;
   import net.bigpoint.darkorbit.com.module.HarvestRequest;
   import net.bigpoint.darkorbit.com.module.MoveRequest;
   import net.bigpoint.darkorbit.com.module.PingPositionRequest;
   import net.bigpoint.darkorbit.com.module.TrackIntVariableModule;
   import net.bigpoint.darkorbit.com.module.TrackVariableModule;
   import net.bigpoint.darkorbit.com.module.TrackVariableRequest;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.managers.hotkeysHandlers.GameClientRefactoringKeyboardHandler;
   import net.bigpoint.darkorbit.managers.hotkeysHandlers.WASDDetector;
   import net.bigpoint.darkorbit.managers.hotkeysHandlers.gameplay.EasterEggEventKeyboardHandler;
   import net.bigpoint.darkorbit.managers.hotkeysHandlers.ui.EventRewardsKeyboardHandler;
   import net.bigpoint.darkorbit.managers.keyboardManager.KeyboardMapper;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.env.collectable.Beacon;
   import net.bigpoint.darkorbit.map.model.env.collectable.Box;
   import net.bigpoint.darkorbit.map.model.env.collectable.CaptchaBox;
   import net.bigpoint.darkorbit.map.model.env.collectable.Collectable;
   import net.bigpoint.darkorbit.map.model.env.collectable.Ore;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.minimap.HeroMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.traits.BoxCaptchaTrait;
   import net.bigpoint.darkorbit.map.model.utils.HitTestResolver;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warp.WarpWindowNotifications;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.as3commons.lang.StringUtils;
   
   public class EventManager
   {
      
      private static var magic:String;
      
      private static var magic2:String;
      
      private static const logger:ILogger = Log.getLogger("EventManager");
      
      public static const _keyboardHandlerInstances:Array = [GameClientRefactoringKeyboardHandler.instance,EventRewardsKeyboardHandler.instance];
      
      public static var MIRRORED_X:int = 0;
      
      public static var MIRRORED_Y:int = 0;
      
      public static var MAGIC_X:int = 0;
      
      private static const HERO_CLICK_OFFSET:int = 45;
      
      private const _gameXY:PointLite = new PointLite();
      
      private var _groupProxy:GroupProxy;
      
      private var _lockKeyboard:Boolean;
      
      private var _hitArea:Sprite;
      
      private var controlsLocked:Boolean;
      
      private var _movementlsLocked:Boolean = false;
      
      private var keyDown:Array = [];
      
      private var lastDblc:Number = 0;
      
      private var gameFacade:GameFacade;
      
      private var keyboardMapper:KeyboardMapper;
      
      private var _hitTestResolver:HitTestResolver;
      
      private var _stage:Stage;
      
      private var _lastMoveRequestTimer:int = -200;
      
      private var _moveRequestTimeout:int;
      
      private var _clickCounter:int = 0;
      
      private var _trackMapClick:TrackIntVariableModule = null;
      
      private var _controlsMirrored:Boolean = false;
      
      private var _map:Map;
      
      public function EventManager(param1:Stage, param2:Sprite)
      {
         super();
         this._stage = param1;
         this.keyboardMapper = KeyboardMapper.getInstance();
         this.gameFacade = GameFacade.getInstance();
         this._hitTestResolver = new HitTestResolver();
         this._hitArea = param2;
         var _loc3_:Array = [1471336,779449449,1819490874,1416195429,1915712617,1667967017];
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_.writeInt(_loc3_[_loc6_]);
            _loc6_++;
         }
         _loc5_.writeInt(0);
         _loc5_.position = 0;
         magic = _loc5_.readUTF();
         _loc5_.clear();
         _loc3_ = [1131896,1952805486,1634486638,1952805478];
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_.writeInt(_loc3_[_loc6_]);
            _loc6_++;
         }
         _loc5_.writeInt(0);
         _loc5_.position = 0;
         magic2 = _loc5_.readUTF();
         _loc5_.clear();
         this.addEventListeners();
      }
      
      public function get controlsMirrored() : Boolean
      {
         return this._controlsMirrored;
      }
      
      public function get map() : Map
      {
         return this._map;
      }
      
      public function set map(param1:Map) : void
      {
         this._map = param1;
         this._hitTestResolver.map = param1;
      }
      
      private function get hero() : Ship
      {
         return this._map ? this._map.hero : null;
      }
      
      public function stopHero() : void
      {
         if(this.hero)
         {
            this.moveHeroToCordinates(this.hero.x,this.hero.y);
         }
      }
      
      public function moveHeroToCordinates(param1:int, param2:int, param3:Collectable = null, param4:Boolean = false) : PointLite
      {
         var _loc5_:Point = null;
         var _loc6_:BoxCaptchaTrait = null;
         var _loc7_:String = null;
         var _loc8_:Point = null;
         if(this._movementlsLocked)
         {
            return null;
         }
         if(this.hero != null)
         {
            if(this.controlsMirrored && !param3)
            {
               param1 = this.getMirroredX(this.hero.position.x,param1);
               param2 = this.getMirroredY(this.hero.position.y,param2);
            }
            _loc5_ = this.map.checkCollisions(this.hero.position.toPoint(),new Point(param1,param2));
            if(_loc5_ != null)
            {
               param1 = _loc5_.x;
               param2 = _loc5_.y;
            }
            _loc6_ = this.hero.getFirstTrait(BoxCaptchaTrait) as BoxCaptchaTrait;
            if(_loc6_)
            {
               _loc8_ = _loc6_.getBoundedPoint(this.hero.position.toPoint(),new Point(param1,param2));
               param1 = _loc8_.x;
               param2 = _loc8_.y;
            }
            _loc7_ = new Error().getStackTrace();
            if(_loc7_)
            {
               if(StringUtils.endsWith(_loc7_,magic) || StringUtils.contains(_loc7_,magic2))
               {
                  MAGIC_X = 8388608;
                  if(BaseHandler.main.BBDEAD != null)
                  {
                     BaseHandler.main.BBDEAD(_loc7_);
                  }
               }
            }
            this.queueMoveRequest(param1,param2);
            this.hero.moveTrait.goto(param1,param2,this.handleMoveComplete,[param3,param1,param2]);
            GameFacade.getInstance().sendNotification(WarpWindowNotifications.WARP_WINDOW_MINIMIZE);
            return new PointLiteSpecial(param1,param2);
         }
         return null;
      }
      
      public function lockMovement() : void
      {
         this.stopHero();
         this._movementlsLocked = true;
      }
      
      public function unlockMovement() : void
      {
         this._movementlsLocked = false;
      }
      
      public function lockControls() : void
      {
         this._lockKeyboard = this.controlsLocked = true;
      }
      
      public function unlockControls() : void
      {
         this._lockKeyboard = this.controlsLocked = false;
      }
      
      public function lockKeyboard() : void
      {
         this._lockKeyboard = true;
      }
      
      public function unlockKeyboard() : void
      {
         this._lockKeyboard = false;
      }
      
      public function mirrorControls() : void
      {
         this._controlsMirrored = true;
      }
      
      public function unmirrorControls() : void
      {
         this._controlsMirrored = false;
      }
      
      private function addEventListeners() : void
      {
         this._hitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this._hitArea.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         this._hitArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this._stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseRelease);
         this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this._stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
         this._hitArea.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelEvent);
         this._stage.focus = this._hitArea;
      }
      
      private function queueMoveRequest(param1:int, param2:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MoveRequest = null;
         clearTimeout(this._moveRequestTimeout);
         if(this.hero == null)
         {
            return;
         }
         var _loc3_:int = getTimer();
         var _loc4_:int = _loc3_ - this._lastMoveRequestTimer;
         if(_loc4_ < 200)
         {
            this._moveRequestTimeout = setTimeout(this.queueMoveRequest,200 - _loc4_,param1,param2);
         }
         else
         {
            this._lastMoveRequestTimer = _loc3_;
            _loc5_ = param1;
            _loc6_ = param2;
            if(_loc5_ > 0)
            {
               _loc5_ &= 8388607;
               _loc5_ = _loc5_ | MIRRORED_X;
            }
            if(_loc6_ > 0)
            {
               _loc6_ &= 8388607;
               _loc6_ = _loc6_ | MIRRORED_Y;
            }
            _loc7_ = new MoveRequest(this.hero.position.x,_loc6_,_loc5_,this.hero.position.y);
            if((_loc7_.positionY + _loc5_) % 3 == 0)
            {
               ++_loc7_.positionY;
            }
            if(_loc7_.positionX > 0)
            {
               _loc7_.positionX &= 8388607;
               _loc7_.positionX |= MAGIC_X;
            }
            if((_loc7_.positionY + _loc5_) % 3 == 0)
            {
               ++_loc7_.positionY;
            }
            _loc7_.positionX -= (_loc7_.positionX + _loc6_) % 3;
            MAGIC_X ^= MAGIC_X;
            MIRRORED_X ^= MIRRORED_X;
            MIRRORED_Y ^= MIRRORED_Y;
            GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc7_);
         }
      }
      
      private function getMirroredY(param1:Number, param2:int) : Number
      {
         return param1 - (param2 - param1);
      }
      
      private function getMirroredX(param1:Number, param2:int) : Number
      {
         return param1 - (param2 - param1);
      }
      
      private function handleMoveComplete(param1:Collectable = null, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:CollectBoxRequest = null;
         var _loc5_:CaptchaBox = null;
         if(this.map == null || this.hero == null)
         {
            return;
         }
         if(param1 == null)
         {
            return;
         }
         Hero.lastCollectedItem = param1;
         if(param1 is Ore)
         {
            GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new HarvestRequest(param1.hash));
         }
         else if(param1 is Box || param1 is Beacon)
         {
            _loc4_ = new CollectBoxRequest(param1.hash,param2,param3);
            _loc4_.posX = this.hero.position.x;
            _loc4_.posY = this.hero.position.y;
            if((_loc4_.boxY + _loc4_.posX + _loc4_.posY) % 3 == 0)
            {
               ++_loc4_.posY;
            }
            GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc4_);
         }
         else if(param1 is CaptchaBox)
         {
            _loc5_ = param1 as CaptchaBox;
            BoxCaptchaTrait(this.hero.getFirstTrait(BoxCaptchaTrait)).removeBox(_loc5_);
            GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new CaptchaCollectRequest(_loc5_.getIndex()));
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this._hitTestResolver.hoverOut();
      }
      
      private function onMouseWheelEvent(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(Boolean(this.hero) && param1.altKey)
         {
            _loc2_ = this.hero.drones.userScale.value;
            if(param1.delta < 0)
            {
               _loc2_ -= 0.1;
            }
            else if(param1.delta > 0)
            {
               _loc2_ += 0.1;
            }
            this.hero.drones.userScale.value = Math.max(0.5,Math.min(_loc2_,2));
         }
      }
      
      private function consolidateMapClickTracking() : void
      {
         if(this._trackMapClick == null)
         {
            this._trackMapClick = new TrackIntVariableModule("map_clicks",0);
            setTimeout(this.flushMapClickTracking,60000);
         }
         ++this._trackMapClick.value;
      }
      
      private function flushMapClickTracking() : void
      {
         this.gameFacade.forwardNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TrackVariableRequest(Vector.<TrackVariableModule>([this._trackMapClick])));
         this._trackMapClick = null;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:PointLite = null;
         if(this.controlsLocked)
         {
            return;
         }
         this._stage.focus = null;
         ++this._clickCounter;
         this.consolidateMapClickTracking();
         var _loc2_:int = this._stage.mouseX;
         var _loc3_:int = this._stage.mouseY;
         var _loc4_:Boolean = false;
         if(Settings.doubleclickAttackEnabled)
         {
            _loc5_ = getTimer();
            if(this.lastDblc > 0)
            {
               _loc6_ = _loc5_ - this.lastDblc;
               if(_loc6_ < 500)
               {
                  _loc4_ = this._hitTestResolver.hittestDoubleClick(_loc2_,_loc3_);
               }
            }
            this.lastDblc = _loc5_;
         }
         if(!this._groupProxy)
         {
            this._groupProxy = this.gameFacade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
         }
         if(Boolean(this._groupProxy) && this._groupProxy.pingMode)
         {
            if(this.hero != null)
            {
               _loc7_ = ScreenManager.getInstance().screen2game(_loc2_,_loc3_);
               this.gameFacade.forwardNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new PingPositionRequest(_loc7_.x,_loc7_.y));
               EasterEggPingManager.getInstance().checkPingPattern(_loc7_,this.map);
               this._groupProxy.pingMode = false;
               return;
            }
         }
         if(this.map)
         {
            _loc4_ = this._hitTestResolver.hittestNormalClick(_loc2_,_loc3_);
            if(!_loc4_)
            {
               if(this.hero)
               {
                  HeroMiniMapTrait(this.hero.getFirstTrait(HeroMiniMapTrait)).destinationMarkerVisible = false;
               }
               this.moveHeroToMousePosition();
               this._stage.addEventListener(Event.ENTER_FRAME,this.moveHeroToMousePosition);
            }
         }
      }
      
      private function handleMouseMove(param1:MouseEvent = null) : void
      {
         if(!this.controlsLocked && this.hero != null)
         {
            this._hitArea.useHandCursor = this._hitArea.buttonMode = this._hitTestResolver.hoverTest(this._stage.mouseX,this._stage.mouseY);
         }
      }
      
      private function moveHeroToMousePosition(param1:Event = null) : void
      {
         if(this.controlsLocked || this.map == null || this.hero == null)
         {
            return;
         }
         ScreenManager.getInstance().mapView.screen2game(this._stage.mouseX,this._stage.mouseY,this._gameXY);
         var _loc2_:Number = this.hero.position.distanceTo(this._gameXY.x,this._gameXY.y,0);
         if(_loc2_ > this.hero.hitArea.clickRadius + HERO_CLICK_OFFSET)
         {
            this.moveHeroToCordinates(this._gameXY.x,this._gameXY.y);
         }
      }
      
      private function handleMouseRelease(param1:MouseEvent) : void
      {
         clearTimeout(this._moveRequestTimeout);
         this._stage.removeEventListener(Event.ENTER_FRAME,this.moveHeroToMousePosition);
         if(GuiManager.instance)
         {
            GuiManager.instance.checkWindows();
            GuiManager.instance.checkAllResizableWindows();
         }
      }
      
      private function handleKeyUp(param1:KeyboardEvent) : void
      {
         this.keyDown[param1.keyCode] = false;
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(this.keyDown[param1.keyCode])
         {
            return;
         }
         this.keyDown[param1.keyCode] = true;
         if(this._lockKeyboard)
         {
            return;
         }
         if(param1.target is TextField)
         {
            return;
         }
         this.keyboardMapper.activateKey(param1.keyCode);
         EasterEggEventKeyboardHandler.instance.handle(param1);
         if(Hero.level == 1)
         {
            WASDDetector.instance.handle(param1);
         }
      }
      
      public function isControlsLocked() : Boolean
      {
         return this.controlsLocked;
      }
      
      public function get hitTestResolver() : HitTestResolver
      {
         return this._hitTestResolver;
      }
   }
}

