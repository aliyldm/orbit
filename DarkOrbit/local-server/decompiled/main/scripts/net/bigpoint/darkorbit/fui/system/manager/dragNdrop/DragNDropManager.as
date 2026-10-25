package net.bigpoint.darkorbit.fui.system.manager.dragNdrop
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.interfaces.IDraggable;
   import net.bigpoint.darkorbit.fui.components.core.interfaces.IDropable;
   
   public class DragNDropManager implements IDragNDropManager
   {
      
      public static const DRAGGER_PROXY_NAME:String = "draggerVisualPresentation";
      
      private static const MAX_STACKABLE_ITEMS:uint = 5;
      
      private var _layer:DisplayObjectContainer;
      
      private var _startDragTimer:Timer;
      
      private var _startDragTime:Number = 500;
      
      private var _dragTimer:Timer;
      
      private var _dragTimerUpdateInterval:Number = 10;
      
      private var _draggables:Vector.<ICoreponent>;
      
      private var _dragProxyClass:Class = DefaultDragProxy;
      
      private var _dragProxy:IDragProxy;
      
      private var _dragProxyOffsetX:int = 0;
      
      private var _dragProxyOffsetY:int = 0;
      
      private var _parentDraggableCoreponent:ICoreponent;
      
      private var _isDragging:Boolean = false;
      
      private var _dropables:Vector.<IDropable> = new Vector.<IDropable>();
      
      private var _decoratedTypeAcceptableDrobables:Vector.<ICoreponent>;
      
      private var _currentDropTarget:IDropable;
      
      private var _startDragDistance:uint = 5;
      
      private var _draggableXStart:int;
      
      private var _draggableYStart:int;
      
      public function DragNDropManager(param1:DisplayObjectContainer)
      {
         super();
         this._layer = param1;
         this._layer.mouseEnabled = false;
         this._layer.mouseChildren = false;
         this._startDragTimer = new Timer(this._startDragTime,1);
         this._startDragTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleStartDragTimerEventComplete);
         this._dragTimer = new Timer(this._dragTimerUpdateInterval);
         this._dragTimer.addEventListener(TimerEvent.TIMER,this.handleDragTimerEvent);
      }
      
      private function addListeners() : void
      {
         var _loc1_:Stage = this._layer.stage;
         _loc1_.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
         _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUpEvent);
         _loc1_.addEventListener(Event.MOUSE_LEAVE,this.handleMouseLeaveEvent);
      }
      
      private function removeListeners() : void
      {
         var _loc1_:Stage = this._layer.stage;
         _loc1_.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
         _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUpEvent);
         _loc1_.removeEventListener(Event.MOUSE_LEAVE,this.handleMouseLeaveEvent);
      }
      
      private function handleMouseLeaveEvent(param1:Event) : void
      {
         this.dragEnd();
      }
      
      private function handleMouseUpEvent(param1:MouseEvent) : void
      {
         this.dragEnd();
      }
      
      private function handleMouseMoveEvent(param1:MouseEvent) : void
      {
      }
      
      public function dragStart(param1:Vector.<ICoreponent>, param2:int = 0, param3:int = 0, param4:ICoreponent = null) : void
      {
         if(param1 != null)
         {
            if(param1.length >= 1)
            {
               this._parentDraggableCoreponent = param4;
               this.stopStartDragTimer();
               this._draggables = param1;
               this._dragProxyOffsetX = param2;
               this._dragProxyOffsetY = param3;
               this.addMouseMoveEventListener();
               this._startDragTimer.start();
            }
         }
      }
      
      protected function addMouseMoveEventListener() : void
      {
         var _loc1_:Coreponent = null;
         if(this._draggables)
         {
            if(this._draggables.length > 0)
            {
               _loc1_ = this._draggables[0] as Coreponent;
               this._draggableXStart = _loc1_.globalPosition.x + _loc1_.mouseX;
               this._draggableYStart = _loc1_.globalPosition.y + _loc1_.mouseY;
               this._layer.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEventToStartDragOperation);
            }
         }
      }
      
      protected function removeMouseMoveEventListener() : void
      {
         if(this._layer)
         {
            this._layer.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEventToStartDragOperation);
         }
      }
      
      protected function handleMouseMoveEventToStartDragOperation(param1:MouseEvent) : void
      {
         var _loc2_:Number = Math.abs(param1.stageX - this._draggableXStart);
         var _loc3_:Number = Math.abs(param1.stageY - this._draggableYStart);
         var _loc4_:Number = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
         if(_loc4_ > this._startDragDistance)
         {
            this._dragStart();
            this.removeMouseMoveEventListener();
         }
      }
      
      protected function handleStartDragTimerEventComplete(param1:TimerEvent) : void
      {
         this._dragStart();
      }
      
      protected function _dragStart() : void
      {
         UISystem.getInstance().mouseManager.showDragNDropCursor();
         this.createDragProxy();
         this.addListeners();
         this.stopStartDragTimer();
         if(!this._dragTimer.running)
         {
            this._dragTimer.start();
            this._isDragging = true;
         }
         this.decorateTypeAcceptableDropables();
      }
      
      protected function handleDragTimerEvent(param1:TimerEvent) : void
      {
         this.drag();
      }
      
      protected function drag() : void
      {
         this.updateDraggerProxyPosition();
         this.checkDropablesCollision();
      }
      
      public function stopStartDragTimer() : void
      {
         if(this._isDragging)
         {
            return;
         }
         if(this._startDragTimer.running)
         {
            this._startDragTimer.stop();
            this._startDragTimer.reset();
         }
         this.removeMouseMoveEventListener();
      }
      
      private function isMouseOverDragStartComponent() : Boolean
      {
         var _loc1_:DisplayObject = this._dragProxy as DisplayObject;
         var _loc2_:ICoreponent = this.parentDraggableCoreponent as ICoreponent;
         if(Boolean(_loc2_) && Boolean(_loc1_))
         {
            if(_loc1_.x < _loc2_.globalPosition.x || _loc1_.x > _loc2_.globalPosition.x + _loc2_.width)
            {
               return false;
            }
            if(_loc1_.y < _loc2_.globalPosition.y || _loc1_.y > _loc2_.globalPosition.y + _loc2_.height)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public function dragEnd() : void
      {
         if(!this.isMouseOverDragStartComponent())
         {
            if(Boolean(this._currentDropTarget) && Boolean(this._draggables) && this._currentDropTarget.canReceiveDropables())
            {
               this._currentDropTarget.handleDrop(this._draggables,this._parentDraggableCoreponent,this._dragProxy);
               this._dragProxy.onDropSuccess();
            }
            else
            {
               this._dragProxy.onDropFailed();
            }
         }
         else
         {
            this._dragProxy.destroy();
         }
         this._dragTimer.stop();
         this.removeListeners();
         this.removeMouseMoveEventListener();
         this.clearDecoratedTypeAcceptableDropables();
         UISystem.getInstance().mouseManager.showRegularCursor();
         UISystem.getInstance().multiSelector.start();
         this._draggables = null;
         this._isDragging = false;
      }
      
      protected function createDragProxy() : void
      {
         if(this._draggables == null)
         {
            return;
         }
         this.removeAllDragProxy();
         this._dragProxy = new this._dragProxyClass();
         this._layer.addChild(this._dragProxy as DisplayObject);
         this._dragProxy.dragStartCoreponent = this._parentDraggableCoreponent;
         this._dragProxy.dragables = Vector.<DisplayObject>(this._draggables);
         this._dragProxy.create();
         this.updateDraggerProxyPosition();
      }
      
      protected function removeAllDragProxy() : void
      {
         var _loc1_:Sprite = this._layer.getChildByName(DRAGGER_PROXY_NAME) as Sprite;
         if(_loc1_)
         {
            this._layer.removeChild(_loc1_);
            this._dragProxy = null;
         }
      }
      
      protected function updateDraggerProxyPosition() : void
      {
         var _loc1_:DisplayObject = this._dragProxy as DisplayObject;
         if(_loc1_)
         {
            _loc1_.x = this._layer.stage.mouseX + this._dragProxyOffsetX;
            _loc1_.y = this._layer.stage.mouseY + this._dragProxyOffsetY;
         }
      }
      
      protected function checkDropablesCollision() : void
      {
         var _loc3_:Vector.<IDropable> = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:Coreponent = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc1_:uint = this._layer.stage.mouseX;
         var _loc2_:uint = this._layer.stage.mouseY;
         var _loc4_:Dictionary = this.getDragTypes();
         var _loc5_:Vector.<ICoreponent> = new Vector.<ICoreponent>();
         for(_loc6_ in _loc4_)
         {
            _loc5_ = _loc5_.concat(this.getDropablesForType(_loc6_));
         }
         _loc3_ = Vector.<IDropable>(_loc5_);
         _loc7_ = _loc3_.length;
         this._currentDropTarget = null;
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = _loc3_[_loc8_] as Coreponent;
            if(!_loc9_.visible)
            {
               return;
            }
            _loc10_ = _loc9_.globalPosition.x;
            _loc11_ = _loc9_.width + _loc10_;
            _loc12_ = _loc9_.globalPosition.y;
            _loc13_ = _loc9_.height + _loc12_;
            if(_loc1_ >= _loc10_ && _loc1_ <= _loc11_ && _loc2_ >= _loc12_ && _loc2_ <= _loc13_)
            {
               if(!_loc9_.areDroppablesInDragZone())
               {
                  this._dragProxy.onDragZoneEnter();
               }
               _loc9_.handleDragZoneEnter(this._draggables,this._parentDraggableCoreponent,this._dragProxy);
               this._currentDropTarget = _loc9_;
            }
            else
            {
               if(_loc9_.areDroppablesInDragZone())
               {
                  this._dragProxy.onDragZoneLeave();
               }
               _loc9_.handleDragZoneLeave(this._draggables,this._parentDraggableCoreponent,this._dragProxy);
            }
            _loc8_++;
         }
      }
      
      public function set startDragDistance(param1:uint) : void
      {
         this._startDragDistance = param1;
      }
      
      public function set startDragTime(param1:Number) : void
      {
         if(param1 > 100)
         {
            this.stopStartDragTimer();
            this._startDragTime = param1;
            this._startDragTimer.delay = this._startDragTime;
         }
      }
      
      public function isDragging() : Boolean
      {
         return this._isDragging;
      }
      
      public function registerDropable(param1:IDropable) : void
      {
         this._dropables.push(param1);
      }
      
      public function unregisterDropable(param1:IDropable) : void
      {
         var _loc3_:IDropable = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._dropables.length)
         {
            _loc3_ = this._dropables[_loc2_];
            if(_loc3_ == param1)
            {
               this._dropables.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function removeAllDropables() : void
      {
         this._dropables.length = 0;
         this._dropables = new Vector.<IDropable>();
      }
      
      public function getDropablesForType(param1:Object) : Vector.<ICoreponent>
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:ICoreponent = null;
         var _loc6_:ICoreponent = null;
         var _loc7_:IDropable = null;
         var _loc8_:String = null;
         var _loc2_:Vector.<ICoreponent> = new Vector.<ICoreponent>();
         _loc3_ = 0;
         for(; _loc3_ < this._dropables.length; _loc3_++)
         {
            _loc7_ = this._dropables[_loc3_];
            if(this._parentDraggableCoreponent)
            {
               _loc8_ = this._parentDraggableCoreponent["multiSelectGroupId"];
               if(_loc7_["multiSelectGroupId"] != null)
               {
                  if(_loc7_["multiSelectGroupId"] == _loc8_)
                  {
                     continue;
                  }
               }
            }
            if(_loc7_.acceptType(param1))
            {
               _loc2_.push(_loc7_);
            }
         }
         if(this._draggables)
         {
            _loc4_ = 0;
            while(_loc4_ < this._draggables.length)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc5_ = _loc2_[_loc3_] as ICoreponent;
                  _loc6_ = this._draggables[_loc4_] as ICoreponent;
                  if(_loc5_ == _loc6_ || _loc5_ == this.parentDraggableCoreponent)
                  {
                     _loc2_.splice(_loc3_,1);
                  }
                  _loc3_++;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function getDropablesForTypeUnderMouse(param1:Object) : Vector.<ICoreponent>
      {
         var _loc5_:Coreponent = null;
         var _loc2_:Vector.<ICoreponent> = this.getDropablesForType(param1);
         var _loc3_:Vector.<ICoreponent> = new Vector.<ICoreponent>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_] as Coreponent;
            if(_loc5_)
            {
               if(_loc5_.globalRectangle.contains(this._layer.stage.mouseX,this._layer.stage.mouseY))
               {
                  _loc3_.push(_loc5_);
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      protected function getDragTypes() : Dictionary
      {
         var _loc2_:IDraggable = null;
         var _loc1_:Dictionary = new Dictionary();
         if(this._draggables)
         {
            for each(_loc2_ in this._draggables)
            {
               if(_loc1_[_loc2_.dragType] == null)
               {
                  _loc1_[_loc2_.dragType] = _loc2_.dragType;
               }
            }
         }
         return _loc1_;
      }
      
      protected function decorateTypeAcceptableDropables() : void
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<ICoreponent> = null;
         var _loc4_:int = 0;
         var _loc5_:ICoreponent = null;
         this._decoratedTypeAcceptableDrobables = new Vector.<ICoreponent>();
         var _loc1_:Dictionary = this.getDragTypes();
         for(_loc2_ in _loc1_)
         {
            _loc3_ = this.getDropablesForType(_loc2_);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               this._decoratedTypeAcceptableDrobables.push(_loc5_);
               _loc5_.handleDragStart(this._draggables,this._parentDraggableCoreponent,this._dragProxy);
               _loc4_++;
            }
         }
      }
      
      protected function clearDecoratedTypeAcceptableDropables() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:ICoreponent = null;
         if(this._decoratedTypeAcceptableDrobables)
         {
            _loc1_ = this._decoratedTypeAcceptableDrobables.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._decoratedTypeAcceptableDrobables[_loc2_];
               _loc3_.handleDragStop(this._draggables,this._parentDraggableCoreponent,this._dragProxy);
               _loc2_++;
            }
         }
         this._decoratedTypeAcceptableDrobables = null;
      }
      
      public function get parentDraggableCoreponent() : ICoreponent
      {
         return this._parentDraggableCoreponent;
      }
      
      public function set dragProxy(param1:IDragProxy) : void
      {
         if(this._dragProxy)
         {
            this._dragProxy.destroy();
         }
         this._dragProxy = param1;
      }
      
      public function get dragProxy() : IDragProxy
      {
         return this._dragProxy;
      }
   }
}

