package away3d.core.managers
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.containers.View3D;
   import away3d.core.pick.IPicker;
   import away3d.core.pick.PickingCollisionVO;
   import away3d.core.pick.PickingType;
   import away3d.events.TouchEvent3D;
   import flash.events.TouchEvent;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class Touch3DManager
   {
      
      protected static var _collidingObjectFromTouchId:Dictionary;
      
      protected static var _previousCollidingObjectFromTouchId:Dictionary;
      
      private static var _queuedEvents:Vector.<TouchEvent3D> = new Vector.<TouchEvent3D>();
      
      private var _updateDirty:Boolean = true;
      
      private var _nullVector:Vector3D = new Vector3D();
      
      private var _numTouchPoints:uint;
      
      private var _touchPoint:TouchPoint;
      
      private var _collidingObject:PickingCollisionVO;
      
      private var _previousCollidingObject:PickingCollisionVO;
      
      private var _touchPoints:Vector.<TouchPoint>;
      
      private var _touchPointFromId:Dictionary;
      
      private var _touchMoveEvent:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE);
      
      private var _forceTouchMove:Boolean;
      
      private var _touchPicker:IPicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;
      
      private var _view:View3D;
      
      public function Touch3DManager()
      {
         super();
         this._touchPoints = new Vector.<TouchPoint>();
         this._touchPointFromId = new Dictionary();
         _collidingObjectFromTouchId = new Dictionary();
         _previousCollidingObjectFromTouchId = new Dictionary();
      }
      
      public function updateCollider() : void
      {
         var _loc1_:uint = 0;
         if(this._forceTouchMove || this._updateDirty)
         {
            while(_loc1_ < this._numTouchPoints)
            {
               this._touchPoint = this._touchPoints[_loc1_];
               this._collidingObject = this._touchPicker.getViewCollision(this._touchPoint.x,this._touchPoint.y,this._view);
               _collidingObjectFromTouchId[this._touchPoint.id] = this._collidingObject;
               _loc1_++;
            }
         }
      }
      
      public function fireTouchEvents() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TouchEvent3D = null;
         var _loc4_:ObjectContainer3D = null;
         _loc1_ = 0;
         while(_loc1_ < this._numTouchPoints)
         {
            this._touchPoint = this._touchPoints[_loc1_];
            this._collidingObject = _collidingObjectFromTouchId[this._touchPoint.id];
            this._previousCollidingObject = _previousCollidingObjectFromTouchId[this._touchPoint.id];
            if(this._collidingObject != this._previousCollidingObject)
            {
               if(this._previousCollidingObject)
               {
                  this.queueDispatch(TouchEvent3D.TOUCH_OUT,this._touchMoveEvent,this._previousCollidingObject,this._touchPoint);
               }
               if(this._collidingObject)
               {
                  this.queueDispatch(TouchEvent3D.TOUCH_OVER,this._touchMoveEvent,this._collidingObject,this._touchPoint);
               }
            }
            if(this._forceTouchMove && Boolean(this._collidingObject))
            {
               this.queueDispatch(TouchEvent3D.TOUCH_MOVE,this._touchMoveEvent,this._collidingObject,this._touchPoint);
            }
            _loc1_++;
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
         _loc1_ = 0;
         while(_loc1_ < this._numTouchPoints)
         {
            this._touchPoint = this._touchPoints[_loc1_];
            _previousCollidingObjectFromTouchId[this._touchPoint.id] = _collidingObjectFromTouchId[this._touchPoint.id];
            _loc1_++;
         }
      }
      
      public function enableTouchListeners(param1:View3D) : void
      {
         param1.addEventListener(TouchEvent.TOUCH_BEGIN,this.onTouchBegin);
         param1.addEventListener(TouchEvent.TOUCH_MOVE,this.onTouchMove);
         param1.addEventListener(TouchEvent.TOUCH_END,this.onTouchEnd);
      }
      
      public function disableTouchListeners(param1:View3D) : void
      {
         param1.removeEventListener(TouchEvent.TOUCH_BEGIN,this.onTouchBegin);
         param1.removeEventListener(TouchEvent.TOUCH_MOVE,this.onTouchMove);
         param1.removeEventListener(TouchEvent.TOUCH_END,this.onTouchEnd);
      }
      
      public function dispose() : void
      {
         this._touchPicker.dispose();
         this._touchPoints = null;
         this._touchPointFromId = null;
         _collidingObjectFromTouchId = null;
         _previousCollidingObjectFromTouchId = null;
      }
      
      private function queueDispatch(param1:String, param2:TouchEvent, param3:PickingCollisionVO, param4:TouchPoint) : void
      {
         var _loc5_:TouchEvent3D = new TouchEvent3D(param1);
         _loc5_.ctrlKey = param2.ctrlKey;
         _loc5_.altKey = param2.altKey;
         _loc5_.shiftKey = param2.shiftKey;
         _loc5_.screenX = param4.x;
         _loc5_.screenY = param4.y;
         _loc5_.touchPointID = param4.id;
         if(param3)
         {
            _loc5_.object = param3.entity;
            _loc5_.renderable = param3.renderable;
            _loc5_.uv = param3.uv;
            _loc5_.localPosition = param3.localPosition ? param3.localPosition.clone() : null;
            _loc5_.localNormal = param3.localNormal ? param3.localNormal.clone() : null;
            _loc5_.index = param3.index;
            _loc5_.subGeometryIndex = param3.subGeometryIndex;
         }
         else
         {
            _loc5_.uv = null;
            _loc5_.object = null;
            _loc5_.localPosition = this._nullVector;
            _loc5_.localNormal = this._nullVector;
            _loc5_.index = 0;
            _loc5_.subGeometryIndex = 0;
         }
         _queuedEvents.push(_loc5_);
      }
      
      private function onTouchBegin(param1:TouchEvent) : void
      {
         var _loc2_:TouchPoint = new TouchPoint();
         _loc2_.id = param1.touchPointID;
         _loc2_.x = param1.stageX;
         _loc2_.y = param1.stageY;
         ++this._numTouchPoints;
         this._touchPoints.push(_loc2_);
         this._touchPointFromId[_loc2_.id] = _loc2_;
         this.updateCollider();
         this._collidingObject = _collidingObjectFromTouchId[_loc2_.id];
         if(this._collidingObject)
         {
            this.queueDispatch(TouchEvent3D.TOUCH_BEGIN,param1,this._collidingObject,_loc2_);
         }
         this._updateDirty = true;
      }
      
      private function onTouchMove(param1:TouchEvent) : void
      {
         var _loc2_:TouchPoint = this._touchPointFromId[param1.touchPointID];
         if(!_loc2_)
         {
            return;
         }
         _loc2_.x = param1.stageX;
         _loc2_.y = param1.stageY;
         this._collidingObject = _collidingObjectFromTouchId[_loc2_.id];
         if(this._collidingObject)
         {
            this.queueDispatch(TouchEvent3D.TOUCH_MOVE,this._touchMoveEvent = param1,this._collidingObject,_loc2_);
         }
         this._updateDirty = true;
      }
      
      private function onTouchEnd(param1:TouchEvent) : void
      {
         var _loc2_:TouchPoint = this._touchPointFromId[param1.touchPointID];
         if(!_loc2_)
         {
            return;
         }
         this._collidingObject = _collidingObjectFromTouchId[_loc2_.id];
         if(this._collidingObject)
         {
            this.queueDispatch(TouchEvent3D.TOUCH_END,param1,this._collidingObject,_loc2_);
         }
         this._touchPointFromId[_loc2_.id] = null;
         --this._numTouchPoints;
         this._touchPoints.splice(this._touchPoints.indexOf(_loc2_),1);
         this._updateDirty = true;
      }
      
      public function get forceTouchMove() : Boolean
      {
         return this._forceTouchMove;
      }
      
      public function set forceTouchMove(param1:Boolean) : void
      {
         this._forceTouchMove = param1;
      }
      
      public function get touchPicker() : IPicker
      {
         return this._touchPicker;
      }
      
      public function set touchPicker(param1:IPicker) : void
      {
         this._touchPicker = param1;
      }
      
      public function set view(param1:View3D) : void
      {
         this._view = param1;
      }
   }
}

class TouchPoint
{
   
   public var id:int;
   
   public var x:Number;
   
   public var y:Number;
   
   public function TouchPoint()
   {
      super();
   }
}
