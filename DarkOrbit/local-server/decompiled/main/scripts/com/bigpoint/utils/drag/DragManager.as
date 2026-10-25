package com.bigpoint.utils.drag
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DragManager extends EventDispatcher
   {
      
      private var _container:DisplayObjectContainer;
      
      private var _duringDrag:Boolean;
      
      private var _dropTarget:IDropable;
      
      private var _draggingPreview:IDragablePreview;
      
      private var _draggingItem:IDraggable;
      
      private var _startPosition:Point;
      
      private var _withPreview:Boolean;
      
      public function DragManager(param1:DisplayObjectContainer)
      {
         super();
         this._container = param1;
      }
      
      public function startDrag(param1:IDraggable, param2:Boolean = true, param3:Point = null) : void
      {
         this._draggingItem = param1;
         this._withPreview = param2;
         this._startPosition = param3;
         if(this._duringDrag)
         {
            this.stopDrag();
         }
         if(this._withPreview)
         {
            this.createPreview();
         }
         this.move(this._container.mouseX,this._container.mouseY);
         this.addListeners();
         dispatchEvent(new DragEvent(DragEvent.DRAG_START));
      }
      
      private function addListeners() : void
      {
         var _loc1_:Stage = this._container.stage;
         _loc1_.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         _loc1_.addEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
      }
      
      private function removeListeners() : void
      {
         var _loc1_:Stage = this._container.stage;
         _loc1_.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         _loc1_.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeaveHandler);
      }
      
      private function createPreview() : void
      {
         if(Boolean(this._draggingPreview) && this._container.contains(this._draggingPreview.asDisplayObject))
         {
            this._draggingPreview.dispose();
            this._container.removeChild(this._draggingPreview.asDisplayObject);
            this._draggingPreview = null;
         }
         this._draggingPreview = this._draggingItem.preview;
         this._container.addChild(this._draggingPreview.asDisplayObject);
      }
      
      private function mouseLeaveHandler(param1:Event) : void
      {
         this.stopDrag(null);
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         this.stopDrag(param1.target as DisplayObject);
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.move(this._container.mouseX,this._container.mouseY);
         var _loc2_:IDropable = this.getAcceptableDropTarget();
         if(_loc2_)
         {
            if(this._dropTarget)
            {
               this._dropTarget.hideAcceptableState(this._draggingItem);
            }
            this._dropTarget = _loc2_;
            this._dropTarget.showAcceptableState(this._draggingItem);
         }
         else if(this._dropTarget)
         {
            this._dropTarget.hideAcceptableState(this._draggingItem);
         }
      }
      
      private function stopDrag(param1:DisplayObject = null) : void
      {
         var _loc3_:Point = null;
         this.removeListeners();
         if(this._dropTarget)
         {
            this._dropTarget.hideAcceptableState(this._draggingItem);
         }
         var _loc2_:IDropable = param1 ? this.getAcceptableDropTarget() : this._dropTarget;
         if(this._draggingPreview)
         {
            if(_loc2_)
            {
               _loc2_.setAcceptedDragItem(this._draggingItem);
               _loc2_.hideAcceptableState(this._draggingItem);
               if(this._draggingPreview.snapToDropTarget)
               {
                  this.snapPreview(_loc2_);
               }
               this._draggingPreview.dropAccept(this.removePreview);
               dispatchEvent(new DragEvent(DragEvent.DRAG_ACCEPTED,this._draggingItem,_loc2_));
            }
            else
            {
               dispatchEvent(new DragEvent(DragEvent.DRAG_NOT_ACCEPTED,this._draggingItem));
               _loc3_ = this._startPosition ? this.draggableDisplayObject.parent.globalToLocal(new Point(this._startPosition.x,this._startPosition.y)) : null;
               this._draggingPreview.dropNotAccept(this.removePreview,_loc3_);
            }
         }
         dispatchEvent(new DragEvent(DragEvent.DRAG_OVER,this._draggingItem));
         this._duringDrag = false;
         this._draggingItem = null;
         this._dropTarget = null;
      }
      
      private function move(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         if(!this._withPreview)
         {
            _loc3_ = this.draggableDisplayObject.parent.globalToLocal(new Point(param1,param2));
            _loc4_ = this._draggingItem.dragOffset || new Point();
            this.draggableDisplayObject.x = int(_loc3_.x + _loc4_.x);
            this.draggableDisplayObject.y = int(_loc3_.y + _loc4_.y);
         }
         else
         {
            this.draggableDisplayObject.x = int(param1);
            this.draggableDisplayObject.y = int(param2);
         }
      }
      
      private function removePreview() : void
      {
         if(Boolean(this._draggingPreview) && this._container.contains(this._draggingPreview.asDisplayObject))
         {
            this._draggingPreview.dispose();
            this._container.removeChild(this._draggingPreview.asDisplayObject);
            this._draggingPreview = null;
         }
      }
      
      private function getAcceptableDropTarget() : IDropable
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:IDropable = null;
         var _loc1_:Array = this._container.getObjectsUnderPoint(new Point(this.draggableDisplayObject.x,this.draggableDisplayObject.y));
         for each(_loc2_ in _loc1_)
         {
            while(Boolean(_loc2_) && _loc2_.parent != _loc2_.stage)
            {
               _loc3_ = _loc2_ as IDropable;
               if(Boolean(_loc3_) && _loc3_.isDraggingItemAcceptable(this._draggingItem))
               {
                  return _loc3_;
                  break;
               }
               _loc2_ = _loc2_.parent;
            }
         }
         return null;
      }
      
      private function snapPreview(param1:IDropable) : void
      {
         var _loc2_:DisplayObject = this.draggableDisplayObject.parent;
         var _loc3_:Point = param1.asDisplayObject.localToGlobal(new Point(_loc2_.x,_loc2_.y));
         var _loc4_:Point = this._draggingPreview.dropOffset || new Point();
         this._draggingPreview.x = _loc3_.x + _loc4_.x;
         this._draggingPreview.y = _loc3_.y + _loc4_.y;
      }
      
      private function get draggableDisplayObject() : DisplayObject
      {
         if(this._withPreview && Boolean(this._draggingPreview))
         {
            return this._draggingPreview.asDisplayObject;
         }
         return this._draggingItem.asDisplayObject;
      }
      
      public function get duringDrag() : Boolean
      {
         return this._duringDrag;
      }
   }
}

