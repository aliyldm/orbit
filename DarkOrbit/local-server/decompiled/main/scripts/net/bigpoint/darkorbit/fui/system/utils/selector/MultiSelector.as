package net.bigpoint.darkorbit.fui.system.utils.selector
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   
   public class MultiSelector implements IMultiSelector
   {
      
      private var _registeredSelectables:Dictionary = new Dictionary();
      
      private var _currentlySelectedItems:Vector.<Sprite>;
      
      private var _firstIntersectedList:ItemList;
      
      private var _filteredListsWithSameGroupID:Vector.<ItemList>;
      
      private var _startPoint:Point = new Point();
      
      private var _startDeltaPixelsToActivate:uint = 4;
      
      private var _mouseDown:Boolean = false;
      
      private var _currentMouseX:uint;
      
      private var _currentMouseY:uint;
      
      private var _invokeCheckStartPointActivationMethod_:Function;
      
      private var _selectionBorderColor:Number = 52479;
      
      private var _selectionBorderALpha:Number = 1;
      
      private var _selectionFillColor:Number = 3355443;
      
      private var _selectionFillAlpha:Number = 0.3;
      
      private var _layer:Sprite;
      
      private var _stage:Stage;
      
      private var _activated:Boolean = false;
      
      private var _enable:Boolean = true;
      
      public function MultiSelector(param1:Sprite)
      {
         super();
         this._layer = param1;
         this._stage = this._layer.stage;
      }
      
      private function addSelectionUpdateListener() : void
      {
         this._stage.addEventListener(Event.ENTER_FRAME,this.handleEnterFrameEvent);
         this._stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoved);
      }
      
      private function removeSelectionUpdateListener() : void
      {
         this._stage.removeEventListener(Event.ENTER_FRAME,this.handleEnterFrameEvent);
         this._stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoved);
      }
      
      private function handleStageMouseDownEvent(param1:MouseEvent = null) : void
      {
         if(!this._enable)
         {
            return;
         }
         UISystem.getInstance().mouseManager.showCrossCursor();
         this._mouseDown = true;
         this._invokeCheckStartPointActivationMethod_ = this.checkStartPointActivationEnabled;
         this.deselectAllItems();
         this._startPoint.x = this._layer.mouseX;
         this._startPoint.y = this._layer.mouseY;
         this.addSelectionUpdateListener();
      }
      
      private function handleStageMouseUpEvent(param1:Event = null) : void
      {
         if(!this._enable)
         {
            return;
         }
         this.onFinishedSelectionProcess();
      }
      
      private function handleEnterFrameEvent(param1:Event = null) : void
      {
         this.checkStageBounds();
         if(this._invokeCheckStartPointActivationMethod_ != null)
         {
            this._invokeCheckStartPointActivationMethod_();
         }
      }
      
      private function handleMouseMoved(param1:Event = null) : void
      {
         if(this.isSelectionActivated())
         {
            this.drawSelection();
            this.checkCollision();
         }
      }
      
      private function onFinishedSelectionProcess() : void
      {
         UISystem.getInstance().mouseManager.showRegularCursor();
         this._mouseDown = false;
         this._invokeCheckStartPointActivationMethod_ = null;
         this.clearSelectionGraphics();
         this.finishCollision();
         this.removeSelectionUpdateListener();
      }
      
      private function checkStartPointActivationEnabled() : void
      {
         var _loc1_:Number = Math.abs(this._startPoint.x - this._currentMouseX);
         var _loc2_:Number = Math.abs(this._startPoint.y - this._currentMouseY);
         if(_loc1_ > this._startDeltaPixelsToActivate && _loc2_ > this._startDeltaPixelsToActivate)
         {
            this._invokeCheckStartPointActivationMethod_ = null;
         }
      }
      
      private function isSelectionActivated() : Boolean
      {
         return this._invokeCheckStartPointActivationMethod_ == null ? true : false;
      }
      
      private function checkStageBounds() : void
      {
         var _loc1_:int = this._currentMouseX = this._stage.mouseX;
         var _loc2_:int = this._currentMouseY = this._stage.mouseY;
         if(this._mouseDown)
         {
            if(_loc1_ <= 0 || _loc2_ <= 0 || _loc2_ >= this._stage.stageHeight || _loc1_ >= this._stage.stageWidth)
            {
               this.handleStageMouseUpEvent();
            }
         }
      }
      
      private function deselectAllItems() : void
      {
         this._currentlySelectedItems = new Vector.<Sprite>();
      }
      
      private function checkCollision() : void
      {
         var _loc2_:ItemList = null;
         var _loc3_:Rectangle = null;
         var _loc4_:String = null;
         var _loc5_:ItemList = null;
         var _loc6_:ItemList = null;
         var _loc1_:Rectangle = this.getNormalizedSelectionArea();
         if(this._firstIntersectedList == null)
         {
            for each(_loc2_ in this._registeredSelectables)
            {
               _loc3_ = new Rectangle(_loc2_.globalPosition.x,_loc2_.globalPosition.y,_loc2_.width,_loc2_.height);
               if(_loc1_.intersects(_loc3_))
               {
                  this._firstIntersectedList = _loc2_;
                  _loc4_ = this._firstIntersectedList.multiSelectGroupId;
                  if(_loc4_ != null)
                  {
                     this._filteredListsWithSameGroupID = new Vector.<ItemList>();
                     for each(_loc5_ in this._registeredSelectables)
                     {
                        if(_loc4_ == _loc5_.multiSelectGroupId)
                        {
                           this._filteredListsWithSameGroupID.push(_loc5_);
                        }
                     }
                  }
                  break;
               }
            }
         }
         else
         {
            this._firstIntersectedList.checkMultiSelectorAreaCollisions(_loc1_);
         }
         if(Boolean(this._filteredListsWithSameGroupID) && Boolean(this._firstIntersectedList))
         {
            for each(_loc6_ in this._filteredListsWithSameGroupID)
            {
               if(_loc6_.ID != this._firstIntersectedList.ID)
               {
                  _loc6_.checkMultiSelectorAreaCollisions(_loc1_);
               }
            }
         }
      }
      
      private function finishCollision() : void
      {
         if(this._firstIntersectedList)
         {
            this._firstIntersectedList.finishMultiSelectorAreaCollisions();
         }
         this._firstIntersectedList = null;
         this._filteredListsWithSameGroupID = null;
      }
      
      private function drawSelection() : void
      {
         var _loc1_:Graphics = this._layer.graphics;
         _loc1_.clear();
         _loc1_.beginFill(this._selectionFillColor,this._selectionFillAlpha);
         _loc1_.lineStyle(1,this._selectionBorderColor,this._selectionBorderALpha);
         _loc1_.drawRect(this._startPoint.x,this._startPoint.y,this._layer.mouseX - this._startPoint.x,this._layer.mouseY - this._startPoint.y);
         _loc1_.endFill();
      }
      
      private function clearSelectionGraphics() : void
      {
         this._layer.graphics.clear();
      }
      
      private function getNormalizedSelectionArea() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         if(this._startPoint.x < this._layer.mouseX)
         {
            _loc1_.left = this._startPoint.x;
            _loc1_.right = this._layer.mouseX;
         }
         else
         {
            _loc1_.left = this._layer.mouseX;
            _loc1_.right = this._startPoint.x;
         }
         if(this._startPoint.y < this._layer.mouseY)
         {
            _loc1_.top = this._startPoint.y;
            _loc1_.bottom = this._layer.mouseY;
         }
         else
         {
            _loc1_.top = this._layer.mouseY;
            _loc1_.bottom = this._startPoint.y;
         }
         return _loc1_;
      }
      
      public function register(param1:ItemList) : void
      {
         if(this._registeredSelectables[param1.ID] == null)
         {
            this._registeredSelectables[param1.ID] = param1;
         }
         else
         {
            UISystem.log("MultiSelector::register() --> tried to register a component the second time.",UISystem.LOG_LEVEL_WARN);
         }
      }
      
      public function unregister(param1:ItemList) : void
      {
         if(this._registeredSelectables[param1.ID] != null)
         {
            this._registeredSelectables[param1.ID] = null;
            delete this._registeredSelectables[param1.ID];
         }
         else
         {
            UISystem.log("MultiSelector::unregister() --> no component registered with the = {" + param1.ID + "/" + param1.name + "}.",UISystem.LOG_LEVEL_WARN);
         }
      }
      
      public function unregisterAll() : void
      {
         var _loc1_:ItemList = null;
         for each(_loc1_ in this._registeredSelectables)
         {
            this.unregister(_loc1_);
         }
      }
      
      public function activate() : void
      {
         this._activated = this._enable = true;
         this._stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleStageMouseDownEvent);
         this._stage.addEventListener(MouseEvent.MOUSE_UP,this.handleStageMouseUpEvent);
      }
      
      public function deactivate() : void
      {
         this._activated = false;
         this._stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleStageMouseDownEvent);
         this._stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleStageMouseUpEvent);
         this.removeSelectionUpdateListener();
         this.clearSelectionGraphics();
      }
      
      public function isActivated() : Boolean
      {
         return this._activated;
      }
      
      public function start() : void
      {
         this.clearSelectionGraphics();
         this._enable = true;
      }
      
      public function stop() : void
      {
         this._enable = false;
         this.onFinishedSelectionProcess();
      }
      
      public function isSelecting() : Boolean
      {
         return this._mouseDown;
      }
      
      public function get selectionBorderColor() : Number
      {
         return this._selectionBorderColor;
      }
      
      public function set selectionBorderColor(param1:Number) : void
      {
         this._selectionBorderColor = param1;
      }
      
      public function get selectionBorderALpha() : Number
      {
         return this._selectionBorderALpha;
      }
      
      public function set selectionBorderALpha(param1:Number) : void
      {
         this._selectionBorderALpha = param1;
      }
      
      public function get selectionFillColor() : Number
      {
         return this._selectionFillColor;
      }
      
      public function set selectionFillColor(param1:Number) : void
      {
         this._selectionFillColor = param1;
      }
      
      public function get selectionFillAlpha() : Number
      {
         return this._selectionFillAlpha;
      }
      
      public function set selectionFillAlpha(param1:Number) : void
      {
         this._selectionFillAlpha = param1;
      }
      
      public function set startDeltaPixelsToActivate(param1:uint) : void
      {
         this._startDeltaPixelsToActivate = param1;
      }
   }
}

