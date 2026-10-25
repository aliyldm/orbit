package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.components.scrollbar
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.lazyload.LazyLoadVO;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class ScrollController extends Sprite
   {
      
      public static const TOP:int = 0;
      
      public static const BOTTOM:int = 1;
      
      public var content:DisplayObject;
      
      private var contentScrollRect:Rectangle;
      
      private var scrollbar:Scrollbar;
      
      private var contentHeight:Number;
      
      private var mouseWheelCatcher:DisplayObject;
      
      public function ScrollController(param1:DisplayObject, param2:Rectangle, param3:Sprite = null)
      {
         var _loc5_:LazyLoadVO = null;
         super();
         this.content = param1;
         if(param3)
         {
            this.mouseWheelCatcher = param3;
         }
         else
         {
            this.mouseWheelCatcher = this.content;
         }
         this.contentHeight = param1.height;
         this.contentScrollRect = param2;
         this.content.scrollRect = this.contentScrollRect;
         this.scrollbar = new Scrollbar(this.contentScrollRect.height);
         var _loc4_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         if(_loc4_.isLoaded("scrollbar"))
         {
            this.handleAssetsLoaded();
         }
         else
         {
            _loc5_ = new LazyLoadVO("scrollbar",this.handleAssetsLoaded,this.handleAssetLoadError);
            _loc5_.load();
         }
      }
      
      private function handleAssetsLoaded(param1:SWFFinisher = null) : void
      {
         var _loc2_:Slider = new Slider();
         this.scrollbar.slider = _loc2_;
         this.scrollbar.init();
         this.scrollbar.slider.contentHeight = this.contentHeight;
         this.scrollbar.slider.createElements();
         this.scrollbar.addEventListener(SliderEvent.CHANGE,this.updateContent);
         this.mouseWheelCatcher.addEventListener(MouseEvent.MOUSE_WHEEL,this.scrollbar.handleMouseWheelMovement);
      }
      
      private function handleAssetLoadError() : void
      {
      }
      
      public function getScrollbar() : Scrollbar
      {
         return this.scrollbar;
      }
      
      public function setContentPosition(param1:int) : void
      {
         this.scrollbar.manuallySetSliderPosition(param1);
      }
      
      public function updateScrollbarSizing(param1:Number = -1) : void
      {
         var _loc2_:Number = this.content.height;
         if(param1 != -1)
         {
            _loc2_ = param1;
         }
         this.contentHeight = _loc2_;
         if(this.scrollbar.slider == null)
         {
            return;
         }
         this.scrollbar.slider.contentHeight = _loc2_;
         this.scrollbar.slider.updateSliderVisual();
      }
      
      public function updateHeight(param1:Number) : void
      {
         this.contentScrollRect.height = param1;
         this.content.scrollRect = this.contentScrollRect;
         this.scrollbar.visibleViewHeight = param1;
         this.scrollbar.slider.updateSliderVisual();
      }
      
      public function updateContent(param1:SliderEvent) : void
      {
         var _loc2_:Number = this.contentHeight - this.content.scrollRect.height;
         var _loc3_:Rectangle = this.content.scrollRect.clone();
         _loc3_.y = _loc2_ * param1.percent;
         this.content.scrollRect = _loc3_;
      }
   }
}

