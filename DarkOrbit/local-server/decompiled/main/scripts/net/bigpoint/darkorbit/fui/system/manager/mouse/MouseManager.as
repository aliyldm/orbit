package net.bigpoint.darkorbit.fui.system.manager.mouse
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.fui.system.utils.FlashPlayerCapabilities;
   
   public class MouseManager extends EventDispatcher implements IMouseManagerImpl
   {
      
      private var _useNativeCursors:Boolean;
      
      private var _manager:IMouseManager;
      
      public function MouseManager(param1:DisplayObjectContainer = null)
      {
         super();
         if(param1 == null)
         {
            this._useNativeCursors = this.supportsNativeCursors();
            if(!this._useNativeCursors)
            {
               throw new Error("Couldn´t initialize MouseManager --> layer=" + param1 + "  nativeCursor supported=" + this.supportsNativeCursors());
            }
         }
         else
         {
            this._useNativeCursors = this.supportsNativeCursors();
         }
         if(this._useNativeCursors)
         {
            this._manager = new NativeMouseCursorManager(param1);
         }
         else
         {
            this._manager = new SoftwareRenderedMouseCursorManager(param1);
         }
      }
      
      private function supportsNativeCursors() : Boolean
      {
         var _loc1_:uint = FlashPlayerCapabilities.playerVersionMajor;
         var _loc2_:uint = FlashPlayerCapabilities.playerVersionMinor;
         if(_loc1_ == 10 && _loc2_ >= 2 || _loc1_ >= 11)
         {
            return true;
         }
         return false;
      }
      
      public function isCursorRegistered(param1:String) : Boolean
      {
         return this._manager.isCursorRegistered(param1);
      }
      
      public function registerMouseCursorViaReskey(param1:String, param2:String, param3:String, param4:Number = 0, param5:Number = 0) : void
      {
         this._manager.registerMouseCursorViaReskey(param1,param2,param3,param4,param5);
      }
      
      public function registerMouseCursor(param1:String, param2:DisplayObject, param3:Number = 0, param4:Number = 0) : void
      {
         this._manager.registerMouseCursor(param1,param2,param3,param4);
      }
      
      public function unregisterMouseCursor(param1:String) : void
      {
         this._manager.unregisterMouseCursor(param1);
      }
      
      public function showCustomCursor(param1:String) : void
      {
         this._manager.showCustomCursor(param1);
      }
      
      public function hideCustomCursor() : void
      {
         this._manager.hideCustomCursor();
      }
      
      public function showDragNDropCursor() : void
      {
      }
      
      public function showRegularCursor() : void
      {
      }
      
      public function showResizeCursor() : void
      {
      }
      
      public function showMoveCursor() : void
      {
      }
      
      public function showCrossCursor() : void
      {
      }
      
      public function showHandCursor() : void
      {
      }
      
      public function get cursorDefinition() : MouseCursorDefinition
      {
         return this._manager.cursorDefinition;
      }
   }
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.ui.MouseCursorData;
import flash.utils.Dictionary;
import flash.utils.Timer;
import net.bigpoint.darkorbit.fui.UISystem;
import net.bigpoint.darkorbit.fui.system.manager.mouse.IMouseManager;
import net.bigpoint.darkorbit.fui.system.manager.mouse.MouseCursorDefinition;
import net.bigpoint.darkorbit.fui.system.manager.mouse.MouseCursorLibraryNames;

class NullCursorData extends MouseCursorDefinition
{
   
   public static const NAME:String = "cursor.NULL";
   
   public function NullCursorData()
   {
      super(NAME,new Sprite());
   }
}

class AbstractCursorManager
{
   
   protected static const NULL_CURSOR_DATA:NullCursorData = new NullCursorData();
   
   protected var _currentCursorData:MouseCursorDefinition = NULL_CURSOR_DATA;
   
   protected var _mouseCursors:Dictionary = new Dictionary();
   
   protected var _mouseLayer:DisplayObjectContainer;
   
   public function AbstractCursorManager(param1:DisplayObjectContainer)
   {
      super();
      this._mouseLayer = param1;
   }
   
   public function unregisterMouseCursor(param1:String) : void
   {
      if(this._mouseCursors[param1] != null)
      {
         if(this._mouseCursors[param1] == this._currentCursorData && this._currentCursorData == null)
         {
            this.hideCustomCursor();
         }
         this._mouseCursors[param1] = null;
         delete this._mouseCursors[param1];
      }
   }
   
   public function hideCustomCursor() : void
   {
   }
   
   public function isCursorRegistered(param1:String) : Boolean
   {
      return this._mouseCursors[param1] != null ? true : false;
   }
   
   public function get cursorDefinition() : MouseCursorDefinition
   {
      return this._currentCursorData;
   }
}

class NativeMouseCursorManager extends AbstractCursorManager implements IMouseManager
{
   
   private const _mouseCursorChangeTimer:Timer = new Timer(20);
   
   private var _stage_:Stage;
   
   private var _mouseStagePoint:Point;
   
   private var _instancesUnderMouse:Array;
   
   private var _topIndex:int;
   
   public function NativeMouseCursorManager(param1:DisplayObjectContainer)
   {
      super(param1);
      if(param1.stage)
      {
         this._mouseStagePoint = new Point();
         this._stage_ = param1.stage;
      }
   }
   
   private function handleMouseChangeTimerEvent(param1:TimerEvent) : void
   {
      this._mouseStagePoint.x = this._mouseStagePoint.y = -1;
      this.checkOjectUnderMousePointerAndChangePointer(this._stage_.mouseX,this._stage_.mouseY);
   }
   
   private function handleMouseMoveEvent(param1:MouseEvent) : void
   {
      this.checkOjectUnderMousePointerAndChangePointer(param1.stageX,param1.stageY);
   }
   
   private function checkOjectUnderMousePointerAndChangePointer(param1:uint, param2:uint) : void
   {
      var _loc3_:Sprite = null;
      if(param1 != this._mouseStagePoint.x || param2 != this._mouseStagePoint.y)
      {
         this._mouseStagePoint.x = param1;
         this._mouseStagePoint.y = param2;
         this._instancesUnderMouse = this._stage_.getObjectsUnderPoint(this._mouseStagePoint);
         if(this._instancesUnderMouse.length > 0)
         {
            this._topIndex = this._instancesUnderMouse.length - 1;
            while(this._topIndex > 0)
            {
               _loc3_ = this._instancesUnderMouse[this._topIndex] as Sprite;
               if(_loc3_)
               {
                  if(_loc3_.useHandCursor && _loc3_.buttonMode)
                  {
                     this.showCustomCursor(MouseCursorLibraryNames.HAND);
                     this._mouseCursorChangeTimer.start();
                     return;
                  }
               }
               --this._topIndex;
            }
            this.showCustomCursor(MouseCursorLibraryNames.REGULAR);
            this._mouseCursorChangeTimer.stop();
         }
      }
   }
   
   public function registerMouseCursorViaReskey(param1:String, param2:String, param3:String, param4:Number = 0, param5:Number = 0) : void
   {
      var _loc6_:Bitmap = UISystem.getInstance().uiloader.getBitmap(param2,param3) as Bitmap;
      if(_loc6_)
      {
         this.registerMouseCursor(param1,_loc6_,param4,param5);
      }
   }
   
   public function registerMouseCursor(param1:String, param2:DisplayObject, param3:Number = 0, param4:Number = 0) : void
   {
      if(_mouseCursors[param1] == null)
      {
         _mouseCursors[param1] = new MouseCursorDefinition(param1,param2,param3,param4);
      }
      else
      {
         UISystem.log("A mouse cursor with the ID= " + param1 + " has been already registered.",UISystem.LOG_LEVEL_WARN);
      }
   }
   
   public function showCustomCursor(param1:String) : void
   {
      var _loc3_:MouseCursorData = null;
      var _loc4_:Vector.<BitmapData> = null;
      var _loc5_:Bitmap = null;
      var _loc2_:MouseCursorDefinition = _mouseCursors[param1];
      if(_loc2_)
      {
         if(_currentCursorData == _loc2_)
         {
            return;
         }
         if(_loc2_.view)
         {
            _currentCursorData = _loc2_;
            _loc3_ = new MouseCursorData();
            _loc4_ = new Vector.<BitmapData>();
            _loc5_ = _loc2_.view as Bitmap;
            if(_loc5_)
            {
               _loc4_.push(_loc5_.bitmapData);
               _loc3_.data = _loc4_;
               _loc3_.hotSpot = new Point(_loc2_.offsetX,_loc2_.offsetY);
               Mouse.registerCursor(_loc2_.id,_loc3_);
               Mouse.cursor = _loc2_.id;
            }
         }
      }
   }
   
   override public function hideCustomCursor() : void
   {
      Mouse.cursor = MouseCursor.AUTO;
      _currentCursorData = NULL_CURSOR_DATA;
   }
}

class SoftwareRenderedMouseCursorManager extends AbstractCursorManager implements IMouseManager
{
   
   public function SoftwareRenderedMouseCursorManager(param1:DisplayObjectContainer)
   {
      super(param1);
   }
   
   public function registerMouseCursorViaReskey(param1:String, param2:String, param3:String, param4:Number = 0, param5:Number = 0) : void
   {
   }
   
   public function registerMouseCursor(param1:String, param2:DisplayObject, param3:Number = 0, param4:Number = 0) : void
   {
   }
   
   override public function unregisterMouseCursor(param1:String) : void
   {
      super.unregisterMouseCursor(param1);
   }
   
   public function showCustomCursor(param1:String) : void
   {
   }
   
   override public function hideCustomCursor() : void
   {
   }
   
   private function updateCursorPosition() : void
   {
      var _loc1_:DisplayObject = null;
      if(_currentCursorData)
      {
         _loc1_ = _currentCursorData.view;
         _loc1_.x = this._stage_.mouseX + _currentCursorData.offsetX;
         _loc1_.y = this._stage_.mouseY + _currentCursorData.offsetY;
      }
   }
   
   private function startEnterFrameHandling() : void
   {
      this._stage_.addEventListener(Event.ENTER_FRAME,this.handleEnterFrameEvent);
   }
   
   private function stopEnterFrameHandling() : void
   {
      this._stage_.removeEventListener(Event.ENTER_FRAME,this.handleEnterFrameEvent);
   }
   
   private function handleEnterFrameEvent(param1:Event) : void
   {
      this.updateCursorPosition();
   }
   
   private function get _stage_() : Stage
   {
      return this._mouseLayer.stage;
   }
   
   public function get mouseLayer() : DisplayObjectContainer
   {
      return _mouseLayer;
   }
   
   public function set mouseLayer(param1:DisplayObjectContainer) : void
   {
      _mouseLayer = param1;
   }
   
   protected function addCurrentMouseCursor() : void
   {
      var _loc1_:DisplayObject = null;
      if(Boolean(_mouseLayer) && Boolean(_currentCursorData))
      {
         _loc1_ = _currentCursorData.view;
         if(_mouseLayer.contains(_loc1_))
         {
            _mouseLayer.removeChild(_loc1_);
         }
         _mouseLayer.addChild(_loc1_);
         this.updateCursorPosition();
      }
      else
      {
         UISystem.log("Tried to add mouse cursor. But no mouse layer was specified.",UISystem.LOG_LEVEL_WARN);
      }
   }
   
   protected function removeCurrentMouseCursor() : void
   {
      var _loc1_:DisplayObject = null;
      if(_mouseLayer)
      {
         if(_currentCursorData == null)
         {
            UISystem.log("No custom cursor activated. So, it´s not possible to remove mouse cursor instance.",UISystem.LOG_LEVEL_WARN);
            return;
         }
         _loc1_ = _currentCursorData.view;
         if(_mouseLayer.contains(_loc1_))
         {
            _mouseLayer.removeChild(_loc1_);
         }
         else
         {
            UISystem.log("Tried to remove current mouse cursor.",UISystem.LOG_LEVEL_WARN);
         }
         _currentCursorData = null;
      }
      else
      {
         UISystem.log("Tried to remove mouse cursor. But no mouse layer was specified.",UISystem.LOG_LEVEL_WARN);
      }
   }
}
