package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.components.scrollbar
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class Slider extends Sprite
   {
      
      protected var track:Sprite;
      
      protected var marker:Sprite;
      
      protected var percentage:Number = 0;
      
      public var contentHeight:Number;
      
      public var viewableHeight:Number;
      
      private var trackBgBitmapData:BitmapData;
      
      private var markerMiddleBitmapData:BitmapData;
      
      private var markerTopEndBitmap:Bitmap;
      
      private var markerBottomEndBitmap:Bitmap;
      
      private var _scrollbarHeight:int;
      
      private var sliderActive:Boolean = false;
      
      public function Slider()
      {
         super();
      }
      
      public function createElements() : void
      {
         this.track = new Sprite();
         this.marker = new Sprite();
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc2_:SWFFinisher = SWFFinisher(_loc1_.getLib("scrollbar"));
         this.trackBgBitmapData = _loc2_.getEmbeddedBitmapData("bg.png");
         this.markerMiddleBitmapData = _loc2_.getEmbeddedBitmapData("bar.png");
         this.markerTopEndBitmap = _loc2_.getEmbeddedBitmap("bar_top.png");
         this.markerBottomEndBitmap = _loc2_.getEmbeddedBitmap("bar_down.png");
         this.marker.addEventListener(MouseEvent.MOUSE_DOWN,this.markerPress);
         addChild(this.track);
         addChild(this.marker);
         this.updateSliderVisual();
      }
      
      public function updateSliderVisual() : void
      {
         var _loc1_:Number = NaN;
         this.marker.graphics.clear();
         if(this.marker.contains(this.markerTopEndBitmap))
         {
            this.marker.removeChild(this.markerTopEndBitmap);
         }
         if(this.marker.contains(this.markerBottomEndBitmap))
         {
            this.marker.removeChild(this.markerBottomEndBitmap);
         }
         this.track.graphics.clear();
         this.track.graphics.beginBitmapFill(this.trackBgBitmapData);
         this.track.graphics.drawRect(0,0,this.trackBgBitmapData.width,this._scrollbarHeight);
         this.track.graphics.endFill();
         var _loc2_:Number = this.viewableHeight / this.contentHeight * 100;
         _loc1_ = _loc2_ / 100 * this.track.height;
         var _loc3_:Number = this.markerTopEndBitmap.height + this.markerBottomEndBitmap.height;
         if(_loc1_ < _loc3_)
         {
            _loc1_ = _loc3_;
         }
         if(_loc1_ < this.track.height)
         {
            this.sliderActive = true;
            this.marker.graphics.clear();
            this.marker.graphics.beginBitmapFill(this.markerMiddleBitmapData);
            this.marker.graphics.drawRect(0,0,this.markerMiddleBitmapData.width,_loc1_);
            this.marker.graphics.endFill();
            this.marker.addChild(this.markerTopEndBitmap);
            this.marker.addChild(this.markerBottomEndBitmap);
            this.markerBottomEndBitmap.y = _loc1_ - this.markerBottomEndBitmap.height;
         }
         else
         {
            this.sliderActive = false;
         }
      }
      
      public function get percent() : Number
      {
         return this.percentage;
      }
      
      public function set percent(param1:Number) : void
      {
         if(this.sliderActive)
         {
            this.percentage = Math.min(1,Math.max(0,param1));
            this.marker.y = this.percentage * (this.track.height - this.marker.height);
            dispatchEvent(new SliderEvent(SliderEvent.CHANGE,this.percentage));
         }
      }
      
      public function forcePercentSetting(param1:Number) : void
      {
         this.percentage = Math.min(1,Math.max(0,param1));
         this.marker.y = this.percentage * (this.track.height - this.marker.height);
         dispatchEvent(new SliderEvent(SliderEvent.CHANGE,this.percentage));
      }
      
      protected function stopSliding(param1:MouseEvent) : void
      {
         this.marker.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.updatePercent);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopSliding);
      }
      
      protected function updatePercent(param1:MouseEvent) : void
      {
         param1.updateAfterEvent();
         this.percentage = this.marker.y / (this.track.height - this.marker.height);
         dispatchEvent(new SliderEvent(SliderEvent.CHANGE,this.percentage));
      }
      
      protected function markerPress(param1:MouseEvent) : void
      {
         this.marker.startDrag(false,new Rectangle(0,0,0,this.track.height - this.marker.height));
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.updatePercent);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopSliding);
      }
      
      public function set scrollbarHeight(param1:int) : void
      {
         this._scrollbarHeight = param1;
      }
   }
}

