package away3d.core.managers
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.containers.View3D;
   import away3d.core.pick.IPicker;
   import away3d.core.pick.PickingCollisionVO;
   import away3d.core.pick.PickingType;
   import away3d.events.MouseEvent3D;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class Mouse3DManager
   {
      
      private static var _view3Ds:Dictionary;
      
      private static var _view3DLookup:Vector.<View3D>;
      
      protected static var _collidingObject:PickingCollisionVO;
      
      private static var _previousCollidingObject:PickingCollisionVO;
      
      private static var _collidingViewObjects:Vector.<PickingCollisionVO>;
      
      private static var _viewCount:int = 0;
      
      private static var _queuedEvents:Vector.<MouseEvent3D> = new Vector.<MouseEvent3D>();
      
      private static var _mouseUp:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_UP);
      
      private static var _mouseClick:MouseEvent3D = new MouseEvent3D(MouseEvent3D.CLICK);
      
      private static var _mouseOut:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_OUT);
      
      private static var _mouseDown:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_DOWN);
      
      private static var _mouseMove:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_MOVE);
      
      private static var _mouseOver:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_OVER);
      
      private static var _mouseWheel:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_WHEEL);
      
      private static var _mouseDoubleClick:MouseEvent3D = new MouseEvent3D(MouseEvent3D.DOUBLE_CLICK);
      
      private static var _previousCollidingView:int = -1;
      
      private static var _collidingView:int = -1;
      
      private var _activeView:View3D;
      
      private var _updateDirty:Boolean = true;
      
      private var _nullVector:Vector3D = new Vector3D();
      
      private var _mouseMoveEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_MOVE);
      
      private var _forceMouseMove:Boolean;
      
      private var _mousePicker:IPicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;
      
      private var _childDepth:int = 0;
      
      private var _collidingDownObject:PickingCollisionVO;
      
      private var _collidingUpObject:PickingCollisionVO;
      
      public function Mouse3DManager()
      {
         super();
         if(!_view3Ds)
         {
            _view3Ds = new Dictionary();
            _view3DLookup = new Vector.<View3D>();
         }
      }
      
      public function updateCollider(param1:View3D) : void
      {
         _previousCollidingView = _collidingView;
         if(param1)
         {
            if(param1.stage3DProxy.bufferClear)
            {
               _collidingViewObjects = new Vector.<PickingCollisionVO>(_viewCount);
            }
            if(!param1.shareContext)
            {
               if(param1 == this._activeView && (this._forceMouseMove || this._updateDirty))
               {
                  _collidingObject = this._mousePicker.getViewCollision(param1.mouseX,param1.mouseY,param1);
               }
            }
            else if(param1.getBounds(param1.parent).contains(param1.mouseX + param1.x,param1.mouseY + param1.y))
            {
               if(!_collidingViewObjects)
               {
                  _collidingViewObjects = new Vector.<PickingCollisionVO>(_viewCount);
               }
               _collidingObject = _collidingViewObjects[_view3Ds[param1]] = this._mousePicker.getViewCollision(param1.mouseX,param1.mouseY,param1);
            }
         }
      }
      
      public function fireMouseEvents() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MouseEvent3D = null;
         var _loc4_:ObjectContainer3D = null;
         var _loc5_:Number = NaN;
         var _loc6_:View3D = null;
         var _loc7_:* = 0;
         if(_collidingViewObjects)
         {
            _collidingObject = null;
            _loc5_ = Infinity;
            _loc7_ = int(_viewCount - 1);
            while(_loc7_ >= 0)
            {
               _loc6_ = _view3DLookup[_loc7_];
               if(Boolean(_collidingViewObjects[_loc7_]) && (_loc6_.layeredView || _collidingViewObjects[_loc7_].rayEntryDistance < _loc5_))
               {
                  _loc5_ = _collidingViewObjects[_loc7_].rayEntryDistance;
                  _collidingObject = _collidingViewObjects[_loc7_];
                  if(_loc6_.layeredView)
                  {
                     break;
                  }
               }
               _loc7_--;
            }
         }
         if(_collidingObject != _previousCollidingObject)
         {
            if(_previousCollidingObject)
            {
               this.queueDispatch(_mouseOut,this._mouseMoveEvent,_previousCollidingObject);
            }
            if(_collidingObject)
            {
               this.queueDispatch(_mouseOver,this._mouseMoveEvent,_collidingObject);
            }
         }
         if(this._forceMouseMove && Boolean(_collidingObject))
         {
            this.queueDispatch(_mouseMove,this._mouseMoveEvent,_collidingObject);
         }
         _loc2_ = _queuedEvents.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _queuedEvents[_loc1_];
            _loc4_ = _loc3_.object;
            while(Boolean(_loc4_) && !_loc4_._ancestorsAllowMouseEnabled)
            {
               _loc4_ = _loc4_.parent;
            }
            if(_loc4_)
            {
               _loc4_.dispatchEvent(_loc3_);
            }
            _loc1_++;
         }
         _queuedEvents.length = 0;
         this._updateDirty = false;
         _previousCollidingObject = _collidingObject;
      }
      
      public function addViewLayer(param1:View3D) : void
      {
         var _loc2_:Stage = param1.stage;
         if(!param1.stage3DProxy.mouse3DManager)
         {
            param1.stage3DProxy.mouse3DManager = this;
         }
         if(!this.hasKey(param1))
         {
            _view3Ds[param1] = 0;
         }
         this._childDepth = 0;
         this.traverseDisplayObjects(_loc2_);
         _viewCount = this._childDepth;
      }
      
      public function enableMouseListeners(param1:View3D) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onClick);
         param1.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         param1.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         param1.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function disableMouseListeners(param1:View3D) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.onClick);
         param1.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         param1.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function dispose() : void
      {
         this._mousePicker.dispose();
      }
      
      private function queueDispatch(param1:MouseEvent3D, param2:MouseEvent, param3:PickingCollisionVO = null) : void
      {
         param1.ctrlKey = param2.ctrlKey;
         param1.altKey = param2.altKey;
         param1.shiftKey = param2.shiftKey;
         param1.delta = param2.delta;
         param1.screenX = param2.localX;
         param1.screenY = param2.localY;
         param3 ||= _collidingObject;
         if(param3)
         {
            param1.object = param3.entity;
            param1.renderable = param3.renderable;
            param1.uv = param3.uv;
            param1.localPosition = param3.localPosition ? param3.localPosition.clone() : null;
            param1.localNormal = param3.localNormal ? param3.localNormal.clone() : null;
            param1.index = param3.index;
            param1.subGeometryIndex = param3.subGeometryIndex;
         }
         else
         {
            param1.uv = null;
            param1.object = null;
            param1.localPosition = this._nullVector;
            param1.localNormal = this._nullVector;
            param1.index = 0;
            param1.subGeometryIndex = 0;
         }
         _queuedEvents.push(param1);
      }
      
      private function reThrowEvent(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         if(!this._activeView || Boolean(this._activeView) && Boolean(!this._activeView.shareContext))
         {
            return;
         }
         for(_loc2_ in _view3Ds)
         {
            if(_loc2_ != this._activeView && _view3Ds[_loc2_] < _view3Ds[this._activeView])
            {
               _loc2_.dispatchEvent(param1);
            }
         }
      }
      
      private function hasKey(param1:View3D) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in _view3Ds)
         {
            if(_loc2_ === param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function traverseDisplayObjects(param1:DisplayObjectContainer) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:* = undefined;
         var _loc2_:int = param1.numChildren;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            for(_loc5_ in _view3Ds)
            {
               if(_loc4_ == _loc5_)
               {
                  _view3Ds[_loc4_] = this._childDepth;
                  _view3DLookup[this._childDepth] = _loc5_;
                  ++this._childDepth;
               }
            }
            if(_loc4_ is DisplayObjectContainer)
            {
               this.traverseDisplayObjects(_loc4_ as DisplayObjectContainer);
            }
            _loc3_++;
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         if(_collidingObject)
         {
            this.queueDispatch(_mouseMove,this._mouseMoveEvent = param1);
         }
         else
         {
            this.reThrowEvent(param1);
         }
         this._updateDirty = true;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this._activeView = null;
         if(_collidingObject)
         {
            this.queueDispatch(_mouseOut,param1,_collidingObject);
         }
         this._updateDirty = true;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this._activeView = param1.currentTarget as View3D;
         if(Boolean(_collidingObject) && _previousCollidingObject != _collidingObject)
         {
            this.queueDispatch(_mouseOver,param1,_collidingObject);
         }
         else
         {
            this.reThrowEvent(param1);
         }
         this._updateDirty = true;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(_collidingObject)
         {
            this.queueDispatch(_mouseClick,param1);
         }
         else
         {
            this.reThrowEvent(param1);
         }
         this._updateDirty = true;
      }
      
      private function onDoubleClick(param1:MouseEvent) : void
      {
         if(_collidingObject)
         {
            this.queueDispatch(_mouseDoubleClick,param1);
         }
         else
         {
            this.reThrowEvent(param1);
         }
         this._updateDirty = true;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this._activeView = param1.currentTarget as View3D;
         this.updateCollider(this._activeView);
         if(_collidingObject)
         {
            this.queueDispatch(_mouseDown,param1);
            _previousCollidingObject = _collidingObject;
         }
         else
         {
            this.reThrowEvent(param1);
         }
         this._updateDirty = true;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(_collidingObject)
         {
            this.queueDispatch(_mouseUp,param1);
            _previousCollidingObject = _collidingObject;
         }
         else
         {
            this.reThrowEvent(param1);
         }
         this._updateDirty = true;
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         if(_collidingObject)
         {
            this.queueDispatch(_mouseWheel,param1);
         }
         else
         {
            this.reThrowEvent(param1);
         }
         this._updateDirty = true;
      }
      
      public function get forceMouseMove() : Boolean
      {
         return this._forceMouseMove;
      }
      
      public function set forceMouseMove(param1:Boolean) : void
      {
         this._forceMouseMove = param1;
      }
      
      public function get mousePicker() : IPicker
      {
         return this._mousePicker;
      }
      
      public function set mousePicker(param1:IPicker) : void
      {
         this._mousePicker = param1;
      }
   }
}

