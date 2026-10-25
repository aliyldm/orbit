package net.bigpoint.darkorbit.equipment.view.components.scroller
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quart;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.view.components.items.MultiSelectionComponent;
   import net.bigpoint.utils.PredefinedFilters;
   
   public class ScrollBar extends Sprite
   {
      
      public static const EVENT_DEACTIVATED:String = "ScrollBar.EVENT_DEACTIVATED";
      
      public static const EVENT_ACTIVATED:String = "ScrollBar.EVENT_ACTIVATED";
      
      public static const EVENT_SCROLL_TOP_POSITION:String = "ScrollBar.EVENT_SCROLL_TOP_POSITION";
      
      public static const EVENT_SCROLL_BOTTOM_POSITION:String = "ScrollBar.EVENT_SCROLL_BOTTOM_POSITION";
      
      public static const EVENT_SCROLL_POSITION_CHANGED:String = "ScrollBar.EVENT_SCROLL_POSITION_CHANGED";
      
      public static const SCROLL_STEPSIZE_DIRECTION_DOWN:String = "down";
      
      public static const SCROLL_STEPSIZE_DIRECTION_UP:String = "up";
      
      private static const MIN_BAR_HEIGHT:int = 25;
      
      public var movement:Number = 0;
      
      public var movementPercentage:Number = 0;
      
      private var _scrollbarPositionPercentage:Number;
      
      public var isMouseWheelActivcated:Boolean = false;
      
      public var scrollFactor:Number = 20;
      
      private var _scrollMenuObject:DisplayObject;
      
      public var scrollMenuHeight:Number;
      
      public var scrollMenuRange:Number;
      
      public var topBound:Number;
      
      public var bottomBound:Number;
      
      public var topBoundConst:Number;
      
      public var bottomBoundConst:Number;
      
      public var visibleViewHeight:Number;
      
      public var scrollMenuMovementRange:Number;
      
      public var scrollAmount:Number;
      
      private var scrollUpBtn:MovieClip;
      
      private var scrollDownBtn:MovieClip;
      
      private var scrollBarBtn:MovieClip;
      
      private var scrollBarBitmapData:BitmapData;
      
      private var scrollBarBackgroundBitmapData:BitmapData;
      
      private var scrollBarBitmap:Bitmap;
      
      private var scrollBarSprite:Sprite = new Sprite();
      
      private var scrollBarBackgroundSprite:Sprite = new Sprite();
      
      private var initialClickPoint:Number;
      
      private var menuScrollBarPositionOnClick:Number;
      
      private var scrollBarTopBound:Number;
      
      private var leftBound:Number;
      
      private var topButton:BitmapData;
      
      private var scrollBarTop:Bitmap;
      
      private var scrollBarBot:Bitmap;
      
      public var scrollBarExternalXPos:Number;
      
      private var topBoundOffSet:Number;
      
      private var addToParent:Boolean;
      
      private var _targetParent:DisplayObjectContainer;
      
      private var _disposeStack:String;
      
      public function ScrollBar(param1:Number, param2:Number, param3:Number, param4:Number, param5:DisplayObject, param6:Boolean = false)
      {
         super();
         this.topBound = this.topBoundConst = param1;
         this.bottomBound = this.bottomBoundConst = param4;
         this.leftBound = param3;
         this.topBoundOffSet = param2;
         this.addToParent = param6;
         this._scrollMenuObject = param5;
         this.visibleViewHeight = Math.abs(param4 - param1);
         this._targetParent = this._scrollMenuObject.parent;
         if(!this._targetParent)
         {
            this._scrollMenuObject.addEventListener(Event.ADDED,this.handleAddedToParent);
         }
         this.setupScrollBarGraphic();
         this.setScrollBarConditions();
         this.addEventListeners();
      }
      
      private function handleAddedToParent(param1:Event = null) : void
      {
         this._targetParent = this._scrollMenuObject.parent;
         this._scrollMenuObject.removeEventListener(Event.ADDED,this.handleAddedToParent);
      }
      
      private function addEventListeners() : void
      {
         if(this.addToParent)
         {
            this._scrollMenuObject.addEventListener(Event.REMOVED,this.handleRemoved);
            this._targetParent.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelMove);
         }
         else
         {
            this._scrollMenuObject.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelMove);
         }
      }
      
      private function removeEventListeners() : void
      {
         this._scrollMenuObject.removeEventListener(Event.ADDED,this.handleAddedToParent);
         if(this.addToParent)
         {
            this._scrollMenuObject.removeEventListener(Event.REMOVED,this.handleRemoved);
            if(this._targetParent)
            {
               this._targetParent.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelMove);
            }
         }
         else
         {
            this._scrollMenuObject.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelMove);
         }
      }
      
      private function handleRemoved(param1:Event) : void
      {
         this.removeEventListeners();
      }
      
      private function setupScrollBarGraphic() : void
      {
         this.scrollUpBtn = AssetProxy.getMovieClip("scrollComponents","upArrow");
         this.scrollDownBtn = AssetProxy.getMovieClip("scrollComponents","downArrow");
         this.scrollUpBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleScrollButtonHover);
         this.scrollUpBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleScrollButtonOut);
         this.scrollUpBtn.addEventListener(MouseEvent.CLICK,this.handleScrollUpButtonClicked);
         this.scrollDownBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleScrollButtonHover);
         this.scrollDownBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleScrollButtonOut);
         this.scrollDownBtn.addEventListener(MouseEvent.CLICK,this.handleScrollDownButtonClicked);
         this.scrollBarBtn = AssetProxy.getMovieClip("scrollComponents","scrollbar");
         this.scrollBarBackgroundBitmapData = AssetProxy.getBitmapData("scrollComponents","bg.png");
         this.scrollBarBitmapData = AssetProxy.getBitmapData("scrollComponents","bar.png");
         this.scrollBarTop = AssetProxy.getBitmap("scrollComponents","bar_top.png");
         this.scrollBarBot = AssetProxy.getBitmap("scrollComponents","bar_down.png");
         this.scrollBarBackgroundSprite.graphics.beginBitmapFill(this.scrollBarBackgroundBitmapData);
         this.scrollBarBackgroundSprite.graphics.drawRect(0,0,this.scrollBarBackgroundBitmapData.width,this.bottomBound - (this.topBound + this.topBoundOffSet));
         this.scrollBarBackgroundSprite.graphics.endFill();
         this.scrollBarBackgroundSprite.addEventListener(MouseEvent.CLICK,this.handleScrollBarBackgroundMouseClick);
         this.scrollBarSprite.graphics.beginBitmapFill(this.scrollBarBitmapData);
         this.scrollBarSprite.graphics.drawRect(0,0,this.scrollBarBitmapData.width,200);
         this.scrollBarSprite.graphics.endFill();
         this.scrollBarSprite.addChild(this.scrollBarTop);
         this.scrollBarSprite.addChild(this.scrollBarBot);
         this.scrollBarBot.y = Math.max(this.scrollBarSprite.height - this.scrollBarBot.height,this.scrollBarTop.height);
         addChild(this.scrollBarBackgroundSprite);
         addChild(this.scrollUpBtn);
         addChild(this.scrollDownBtn);
         this.scrollBarBackgroundSprite.x = Math.round(this.leftBound + this._scrollMenuObject.width);
         this.scrollBarBackgroundSprite.y = this.topBound + this.topBoundOffSet;
         this.scrollUpBtn.x = this.scrollDownBtn.x = Math.round(this.leftBound + this._scrollMenuObject.width);
         this.scrollUpBtn.y = this.topBound + this.topBoundOffSet;
         this.scrollDownBtn.y = this.bottomBound - this.scrollDownBtn.height;
         this.topBound = this.scrollUpBtn.y + this.scrollUpBtn.height;
         this.bottomBound = this.scrollDownBtn.y;
         addChild(this.scrollBarSprite);
         this.scrollBarSprite.y = this.topBound;
         this.scrollBarSprite.x = Math.round(this.leftBound + this._scrollMenuObject.width);
         this.scrollBarExternalXPos = this.scrollBarSprite.x;
      }
      
      public function setScrollBarConditions(param1:Number = -1) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         if(param1 == -1)
         {
            _loc2_ = this._scrollMenuObject.height;
         }
         else
         {
            _loc2_ = param1;
         }
         var _loc3_:Number = this.visibleViewHeight;
         this.scrollMenuMovementRange = _loc2_ - _loc3_;
         if(this.scrollMenuMovementRange > 0)
         {
            _loc4_ = _loc3_ / _loc2_;
            _loc5_ = _loc3_ - (this.scrollUpBtn.height + this.scrollDownBtn.height + this.topBoundOffSet);
            _loc6_ = Math.round(_loc4_ * _loc5_);
            this.activate(_loc6_);
            return false;
         }
         this.deactivate();
         return true;
      }
      
      private function activate(param1:Number) : void
      {
         this.scrollFactor = param1 / 5;
         this.adjustScrollBarLength(param1);
         this.scrollBarBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.handleClickedOnScrollBar);
         this.scrollBarSprite.addEventListener(MouseEvent.MOUSE_DOWN,this.handleClickedOnScrollBar);
         this.changeMouseWheelListening(true);
         this.scrollBarSprite.alpha = 1;
         this.addScrollUpAndDownButtonListeners();
         TweenMax.to(this.scrollBarBtn,0.5,{
            "height":param1,
            "alpha":1,
            "ease":Quart.easeOut
         });
         TweenMax.to(this,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORED);
         dispatchEvent(new Event(EVENT_ACTIVATED));
      }
      
      private function deactivate() : void
      {
         this.scrollBarBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleClickedOnScrollBar);
         this.scrollBarSprite.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleClickedOnScrollBar);
         this.changeMouseWheelListening(false);
         this.scrollBarSprite.alpha = 0;
         this.removeScrollUpAndDownButtonListeners();
         TweenMax.to(this,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORLESS);
         TweenMax.to(this.scrollBarBtn,0.5,{
            "alpha":0,
            "ease":Quart.easeOut
         });
         dispatchEvent(new Event(EVENT_DEACTIVATED));
      }
      
      private function addScrollUpAndDownButtonListeners() : void
      {
         this.removeScrollUpAndDownButtonListeners();
         this.scrollUpBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleScrollButtonHover);
         this.scrollUpBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleScrollButtonOut);
         this.scrollUpBtn.addEventListener(MouseEvent.CLICK,this.handleScrollUpButtonClicked);
         this.scrollDownBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleScrollButtonHover);
         this.scrollDownBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleScrollButtonOut);
         this.scrollDownBtn.addEventListener(MouseEvent.CLICK,this.handleScrollDownButtonClicked);
      }
      
      private function removeScrollUpAndDownButtonListeners() : void
      {
         this.scrollUpBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.handleScrollButtonHover);
         this.scrollUpBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.handleScrollButtonOut);
         this.scrollUpBtn.removeEventListener(MouseEvent.CLICK,this.handleScrollUpButtonClicked);
         this.scrollDownBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.handleScrollButtonHover);
         this.scrollDownBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.handleScrollButtonOut);
         this.scrollDownBtn.removeEventListener(MouseEvent.CLICK,this.handleScrollDownButtonClicked);
      }
      
      private function changeMouseWheelListening(param1:Boolean) : void
      {
         switch(param1)
         {
            case true:
               if(this.addToParent)
               {
                  this._targetParent.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelMove);
               }
               else
               {
                  this._scrollMenuObject.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelMove);
               }
               break;
            case false:
               if(this.addToParent)
               {
                  this._targetParent.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelMove);
               }
               else
               {
                  this._scrollMenuObject.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelMove);
               }
         }
      }
      
      private function adjustScrollBarLength(param1:Number) : void
      {
         param1 = Math.max(param1,MIN_BAR_HEIGHT);
         this.scrollBarSprite.graphics.clear();
         this.scrollBarSprite.graphics.beginBitmapFill(this.scrollBarBitmapData);
         this.scrollBarSprite.graphics.drawRect(0,0,this.scrollBarBitmapData.width,param1);
         this.scrollBarBot.y = Math.max(param1 - this.scrollBarBot.height,this.scrollBarTop.height);
         this.scrollBarSprite.graphics.endFill();
         this.scrollBarSprite.addChild(this.scrollBarTop);
         this.scrollBarSprite.addChild(this.scrollBarBot);
      }
      
      private function handleScrollButtonOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         _loc2_.gotoAndStop(1);
      }
      
      private function handleScrollButtonHover(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         _loc2_.gotoAndStop(2);
      }
      
      private function handleClickedOnScrollBar(param1:MouseEvent) : void
      {
         var _loc2_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         this.initialClickPoint = mouseY;
         this.menuScrollBarPositionOnClick = this.scrollBarSprite.y;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleScrollBarMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseButtonReleased);
      }
      
      private function handleScrollBarMove(param1:MouseEvent) : void
      {
         this.scrollBarSprite.y = -(this.initialClickPoint - mouseY) + this.menuScrollBarPositionOnClick;
         this.movement = this.calculateScrollMovements();
         this._scrollMenuObject.y = -this.movement;
      }
      
      private function handleScrollUpButtonClicked(param1:MouseEvent) : void
      {
         if(this._scrollMenuObject.height > this.visibleViewHeight)
         {
            this.scrollBarSprite.y -= this.scrollFactor;
            this.movement = this.calculateScrollMovements();
            this._scrollMenuObject.y = -this.movement;
         }
      }
      
      private function handleScrollDownButtonClicked(param1:MouseEvent) : void
      {
         if(this._scrollMenuObject.height > this.visibleViewHeight)
         {
            param1.preventDefault();
            this.scrollBarSprite.y += this.scrollFactor;
            this.movement = this.calculateScrollMovements();
            this._scrollMenuObject.y = -this.movement;
         }
      }
      
      private function handleScrollBarBackgroundMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Number = this.scrollBarBackgroundSprite.mouseY + this.topBound - this.scrollUpBtn.height;
         var _loc3_:Number = this.bottomBound - this.scrollBarSprite.height;
         _loc2_ = _loc2_ > _loc3_ ? _loc3_ : _loc2_;
         this.scrollBarSprite.y = _loc2_;
         this.movement = this.calculateScrollMovements();
         this._scrollMenuObject.y = -this.movement;
      }
      
      private function handleMouseWheelMove(param1:MouseEvent) : void
      {
         if(this.isMouseWheelActivcated)
         {
            param1.preventDefault();
            if(this._scrollMenuObject.height > this.visibleViewHeight)
            {
               if(param1.delta > 0)
               {
                  this.scrollBarSprite.y -= this.scrollFactor;
               }
               else if(param1.delta < 0)
               {
                  this.scrollBarSprite.y += this.scrollFactor;
               }
            }
         }
         this.movement = this.calculateScrollMovements();
         this._scrollMenuObject.y = -this.movement;
      }
      
      private function handleMouseButtonReleased(param1:MouseEvent) : void
      {
         if(this._scrollMenuObject.y < this.topBound - 0.5 && this._scrollMenuObject.y > this.topBound + 0.5)
         {
            this._scrollMenuObject.y = this.topBound;
         }
         try
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleScrollBarMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseButtonReleased);
         }
         catch(error:Error)
         {
         }
      }
      
      private function calculateScrollMovements(param1:Number = -1) : Number
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = -(this.topBound - this.bottomBound) - this.scrollBarSprite.height;
         if(this.scrollBarSprite.y < this.topBound)
         {
            this.scrollBarSprite.y = this.topBound;
         }
         else if(this.scrollBarSprite.y + this.scrollBarSprite.height > this.bottomBound)
         {
            this.scrollBarSprite.y = this.bottomBound - this.scrollBarSprite.height;
         }
         if(param1 >= 0)
         {
            _loc3_ = _loc2_ * param1;
         }
         else
         {
            _loc3_ = this.scrollBarSprite.y - this.topBound;
         }
         this.movementPercentage = _loc3_ / _loc2_;
         var _loc4_:Number = -this.topBoundConst + this.movementPercentage * this.scrollMenuMovementRange;
         this.checkAndDispatchEvents(this.movementPercentage);
         return Math.round(_loc4_);
      }
      
      public function resetAllElementsToStartingPositions(param1:Boolean = true) : void
      {
         this.scrollBarSprite.y = this.topBound;
         this.movement = this.calculateScrollMovements();
         if(param1)
         {
            this._scrollMenuObject.y = -this.movement;
         }
      }
      
      private function checkScrollBarBounds() : void
      {
         if(this.scrollBarSprite.y < this.topBound)
         {
            this.scrollBarSprite.y = this.topBound;
         }
         else if(this.scrollBarSprite.y + this.scrollBarSprite.height > this.bottomBound)
         {
            this.scrollBarSprite.y = this.bottomBound - this.scrollBarSprite.height;
         }
      }
      
      public function checkScrollBarWithinBounds() : void
      {
         if(this.scrollBarSprite.y + this.scrollBarSprite.height > this.bottomBound)
         {
            this.scrollBarSprite.y = this.bottomBound - this.scrollBarSprite.height;
         }
         var _loc1_:Number = this.calculateScrollMovements();
         this._scrollMenuObject.y = -_loc1_;
      }
      
      public function setPercentage(param1:Number) : void
      {
         this.calculateScrollbarPosition(param1);
         this.movement = this.calculateScrollMovements(param1);
         this._scrollMenuObject.y = -this.movement;
         this.checkAndDispatchEvents(param1);
      }
      
      private function calculateScrollbarPosition(param1:Number) : void
      {
         var _loc2_:Number = -(this.topBound - this.bottomBound) - this.scrollBarSprite.height;
         this.scrollBarSprite.y = this.topBound;
         if(this.scrollBarSprite.y < this.topBound)
         {
            this.scrollBarSprite.y = this.topBound;
         }
         else if(this.scrollBarSprite.y + this.scrollBarSprite.height > this.bottomBound)
         {
            this.scrollBarSprite.y = this.bottomBound - this.scrollBarSprite.height;
         }
         this.scrollBarSprite.y = this.topBound + param1 * _loc2_;
         this.checkAndDispatchEvents(param1);
      }
      
      public function scrollStepSize(param1:Number, param2:String) : void
      {
         var _loc3_:Number = NaN;
         _loc3_ = Math.abs(this._scrollMenuObject.y);
         var _loc4_:int = Math.floor(_loc3_ / param1);
         var _loc5_:Number = this.bottomBound - this.topBound;
         var _loc6_:Number = this._scrollMenuObject.height - _loc5_;
         var _loc7_:int = Math.floor(_loc6_ / param1);
         switch(param2)
         {
            case SCROLL_STEPSIZE_DIRECTION_UP:
               if(--_loc4_ < 0)
               {
                  _loc4_ = 0;
               }
               _loc3_ = param1 * _loc4_;
               break;
            case SCROLL_STEPSIZE_DIRECTION_DOWN:
               if(_loc4_ < _loc7_)
               {
                  _loc4_++;
               }
               _loc3_ = param1 * _loc4_;
         }
         var _loc8_:Number = _loc4_ / _loc7_;
         this.calculateScrollbarPosition(_loc8_);
         this._scrollMenuObject.y = -_loc3_;
         this.checkAndDispatchEvents(_loc8_);
      }
      
      private function checkAndDispatchEvents(param1:Number) : void
      {
         dispatchEvent(new Event(ScrollBar.EVENT_SCROLL_POSITION_CHANGED));
         if(param1 <= 0)
         {
            dispatchEvent(new Event(ScrollBar.EVENT_SCROLL_TOP_POSITION));
         }
         else if(param1 >= 1)
         {
            dispatchEvent(new Event(ScrollBar.EVENT_SCROLL_BOTTOM_POSITION));
         }
      }
      
      public function dispose() : void
      {
         this.removeEventListeners();
         this.changeMouseWheelListening(false);
         this._targetParent = null;
         this._scrollMenuObject = null;
      }
      
      public function get scrollMenuObject() : DisplayObject
      {
         return this._scrollMenuObject;
      }
   }
}

