package net.bigpoint.darkorbit.fui.components.scroll
{
   import com.greensock.TweenLite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   
   public class Scrollbar extends Container
   {
      
      protected static const DEFAULT_PIXEL_SPEED:Number = 15;
      
      protected static const DEFAULT_MINIMAL_SLIDER_SIZE:Number = 15;
      
      private var _scrollDirection:uint = 2;
      
      protected var _upButton:Button;
      
      protected var _downButton:Button;
      
      protected var _slider:Button;
      
      protected var _movingSliderTimer:Timer;
      
      protected var _currentSliderPosition:Number = 0;
      
      protected var _currentPositionInPercent:Number = 0;
      
      protected var _previousSliderPosition:Number = NaN;
      
      protected var _scrollPixelSpeed:Number = 15;
      
      protected var _minimalSliderSize:Number = 15;
      
      protected var _viewSize:Number;
      
      protected var _contentSize:Number;
      
      protected var _viewToContentRatio:Number;
      
      public function Scrollbar()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._upButton = this.getChildByName("buttonUp") as Button;
         if(this._upButton)
         {
            this.initUpButton();
         }
         this._downButton = this.getChildByName("buttonDown") as Button;
         if(this._downButton)
         {
            this.initDownButton();
         }
         this._slider = this.getChildByName("buttonSlider") as Button;
         if(this._slider)
         {
            this.initSlider();
         }
      }
      
      override protected function drawSize() : void
      {
         super.drawSize();
         if(this._slider)
         {
            this._updateSliderPostion();
            this.dispatchScrollPositionEvent();
         }
      }
      
      protected function _updateSliderPostion() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = this.getViewContentRatio();
         var _loc2_:Number = 0;
         if(_loc1_ <= 1)
         {
            _loc3_ = this.getSliderMoveRange();
            _loc2_ = this._currentPositionInPercent * _loc3_;
         }
         else
         {
            _loc2_ = 0;
            this._currentPositionInPercent = 0;
         }
         if(this._scrollDirection == ScrollDirection.DIRECTION_HORIZONTAL)
         {
            this._slider.x = this._currentSliderPosition = _loc2_;
         }
         else if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            this._slider.y = this._currentSliderPosition = _loc2_;
         }
         this._slider.forceRedraw();
      }
      
      protected function initSlider() : void
      {
         this._slider.addEventListener(MouseEvent.MOUSE_DOWN,this.handleSliderDown);
         this._slider.addEventListener(MouseEvent.MOUSE_UP,this.handleSliderUp);
         this._slider.forceRedraw();
         this._movingSliderTimer = new Timer(100);
         this._movingSliderTimer.stop();
         this._movingSliderTimer.addEventListener(TimerEvent.TIMER,this.handleMovingSliderTimerEvent);
      }
      
      protected function initUpButton() : void
      {
         this._upButton.addEventListener(MouseEvent.MOUSE_DOWN,this.handleUpButtonDown);
      }
      
      protected function initDownButton() : void
      {
         this._downButton.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDownButtonDown);
      }
      
      override public function dispose() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleSliderUp);
         if(this._slider)
         {
            this._slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleSliderDown);
            this._slider.removeEventListener(MouseEvent.MOUSE_UP,this.handleSliderUp);
            this._slider.dispose();
            this._slider = null;
         }
         if(this._movingSliderTimer)
         {
            this._movingSliderTimer.stop();
            this._movingSliderTimer.removeEventListener(TimerEvent.TIMER,this.handleMovingSliderTimerEvent);
            this._movingSliderTimer = null;
         }
         super.dispose();
      }
      
      private function handleSliderDown(param1:MouseEvent) : void
      {
         UISystem.getInstance().multiSelector.stop();
         var _loc2_:Rectangle = this.getSliderMoveRangeAsRectangle();
         this._slider.startDrag(false,_loc2_);
         this._movingSliderTimer.start();
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleSliderUp);
      }
      
      private function handleSliderUp(param1:MouseEvent) : void
      {
         UISystem.getInstance().multiSelector.start();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleSliderUp);
         this._movingSliderTimer.stop();
         this._slider.stopDrag();
      }
      
      private function handleMovingSliderTimerEvent(param1:TimerEvent) : void
      {
         if(this._scrollDirection == ScrollDirection.DIRECTION_HORIZONTAL)
         {
            this._currentSliderPosition = this._slider.getExplicitX();
         }
         else if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            this._currentSliderPosition = this._slider.getExplicitY();
         }
         this.dispatchScrollPositionEvent();
      }
      
      private function handleUpButtonDown(param1:MouseEvent) : void
      {
      }
      
      private function handleDownButtonDown(param1:MouseEvent) : void
      {
      }
      
      protected function dispatchScrollPositionEvent() : void
      {
         if(this._previousSliderPosition != this._currentSliderPosition)
         {
            this._previousSliderPosition = this._currentSliderPosition;
            this._currentPositionInPercent = this.getScrollPositionInPercent();
            dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_POSITION_CHANGED,this._currentPositionInPercent));
         }
      }
      
      public function getScrollPositionInPercent() : Number
      {
         var _loc1_:Number = this.getSliderMoveRange();
         var _loc2_:Number = this.getButtonSize();
         var _loc3_:Number = (this._currentSliderPosition - _loc2_) / _loc1_;
         return _loc3_ > 1 ? 1 : _loc3_;
      }
      
      public function setScrollPositionInPercent(param1:Number, param2:Boolean = false) : void
      {
         if(param1 <= 0)
         {
            param1 = 0;
         }
         else if(param1 >= 1)
         {
            param1 = 1;
         }
         if(this._currentPositionInPercent == param1 && param2 == false)
         {
            return;
         }
         var _loc3_:Number = this.getSliderMoveRange();
         var _loc4_:Number = this.getButtonSize();
         if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            this._slider.y = _loc4_ + _loc3_ * param1;
         }
         else
         {
            this._slider.x = _loc4_ + _loc3_ * param1;
         }
         this._slider.forceRedraw(InvalidationType.POSITION);
         this._currentSliderPosition = this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL ? this._slider.getExplicitY() : this._slider.getExplicitX();
         this.dispatchScrollPositionEvent();
      }
      
      public function updateScrollPositionByScrollDelta(param1:int) : void
      {
         var _loc2_:Number = this.getScrollPositionInPercent();
         var _loc3_:Number = 0;
         var _loc4_:Number = this.getPercentageScrollSpeedUnit();
         if(param1 > 0)
         {
            _loc3_ = _loc4_ * param1;
         }
         else if(param1 < 0)
         {
            _loc3_ = _loc4_ * param1;
         }
         var _loc5_:Number = _loc2_ - _loc3_;
         this.setScrollPositionInPercent(_loc5_);
      }
      
      public function updateBySizes(param1:Number, param2:Number) : void
      {
         this._viewSize = param1;
         this._contentSize = param2;
         if(param2 <= 0 || param1 <= 0)
         {
            this.visible = false;
            return;
         }
         this.updateSliderSizePositionAndVisibility();
      }
      
      protected function getButtonSize() : Number
      {
         var _loc1_:Number = 0;
         if(this._upButton)
         {
            if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
            {
               _loc1_ = this._upButton.height;
            }
            else if(this._scrollDirection == ScrollDirection.DIRECTION_HORIZONTAL)
            {
               _loc1_ = this._upButton.width;
            }
         }
         return _loc1_;
      }
      
      protected function getPercentageScrollSpeedUnit() : Number
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = 0;
         if(this._contentSize)
         {
            _loc2_ = this._contentSize - this._viewSize;
            if(_loc2_ > 0)
            {
               if(this.scrollPixelSpeed < _loc2_)
               {
                  _loc1_ = this.scrollPixelSpeed / _loc2_;
               }
               else
               {
                  _loc1_ = 0.9;
               }
            }
         }
         else
         {
            _loc1_ = 0.1;
         }
         return _loc1_;
      }
      
      protected function getSliderMoveRange() : Number
      {
         var _loc2_:Number = NaN;
         var _loc1_:Rectangle = this.getSliderMoveRangeAsRectangle();
         if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            _loc2_ = _loc1_.height - _loc1_.top;
         }
         else
         {
            _loc2_ = _loc1_.width;
         }
         return _loc2_;
      }
      
      protected function getSliderMoveRangeAsRectangle() : Rectangle
      {
         var _loc4_:Number = NaN;
         var _loc6_:Rectangle = null;
         var _loc1_:Number = this.getUpSideButtonSize();
         var _loc2_:Number = this.getDownSideButtonSize();
         var _loc3_:Number = 0;
         if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            _loc4_ = this._slider.height;
            _loc3_ = this._slider.getExplicitX();
         }
         else
         {
            _loc4_ = this._slider.width;
            _loc3_ = this._slider.getExplicitY();
         }
         var _loc5_:Number = Math.ceil(this.size - (_loc4_ + _loc1_ + _loc2_));
         if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            _loc6_ = new Rectangle(_loc3_,_loc1_,0,_loc5_);
         }
         else
         {
            _loc6_ = new Rectangle(_loc3_,_loc1_,_loc5_,0);
         }
         return _loc6_;
      }
      
      protected function getSliderBackgroundSize() : Number
      {
         var _loc1_:Number = this.getUpSideButtonSize();
         var _loc2_:Number = this.getDownSideButtonSize();
         return this.size - (_loc1_ + _loc2_);
      }
      
      protected function getUpSideButtonSize() : Number
      {
         var _loc1_:Number = 0;
         if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            _loc1_ = this._upButton != null ? this._upButton.height : 0;
         }
         else if(this._scrollDirection == ScrollDirection.DIRECTION_HORIZONTAL)
         {
            _loc1_ = this._upButton != null ? this._upButton.width : 0;
         }
         return _loc1_;
      }
      
      protected function getDownSideButtonSize() : Number
      {
         var _loc1_:Number = 0;
         if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            _loc1_ = this._downButton != null ? this._downButton.height : 0;
         }
         else if(this._scrollDirection == ScrollDirection.DIRECTION_HORIZONTAL)
         {
            _loc1_ = this._downButton != null ? this._downButton.width : 0;
         }
         return _loc1_;
      }
      
      protected function getViewContentRatio() : Number
      {
         if(this._viewSize > 0 && Boolean(this._contentSize))
         {
            this._viewToContentRatio = this._viewSize / this._contentSize;
         }
         else
         {
            this._viewToContentRatio = uint.MAX_VALUE;
         }
         return this._viewToContentRatio;
      }
      
      protected function updateSliderSizePositionAndVisibility() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._contentSize > 0 && this._viewSize > 0)
         {
            _loc1_ = this._viewSize / this._contentSize;
            _loc2_ = this._minimalSliderSize;
            if(_loc1_ < 1)
            {
               _loc3_ = this.getSliderBackgroundSize();
               _loc2_ = _loc3_ * _loc1_;
               _loc2_ = _loc2_ < DEFAULT_MINIMAL_SLIDER_SIZE ? DEFAULT_MINIMAL_SLIDER_SIZE : _loc2_;
               if(this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
               {
                  this._slider.height = _loc2_;
               }
               else
               {
                  this._slider.width = _loc2_;
               }
               this._slider.forceRedraw(InvalidationType.SIZE);
               this._updateSliderPostion();
               TweenLite.to(this,0.3,{"autoAlpha":1});
            }
            else
            {
               TweenLite.to(this,0.3,{"autoAlpha":0});
            }
         }
      }
      
      public function set scrollPixelSpeed(param1:Number) : void
      {
         this._scrollPixelSpeed = param1;
      }
      
      public function get scrollPixelSpeed() : Number
      {
         return this._scrollPixelSpeed;
      }
      
      public function set minimalSliderSize(param1:Number) : void
      {
         this._minimalSliderSize = param1;
      }
      
      public function get minimalSliderSize() : Number
      {
         return this._minimalSliderSize;
      }
      
      public function set scrollDirection(param1:uint) : void
      {
         this._scrollDirection = param1;
      }
      
      private function get size() : Number
      {
         return this._scrollDirection == ScrollDirection.DIRECTION_VERTICAL ? height : width;
      }
   }
}

