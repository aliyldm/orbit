package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.components.scrollbar
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class Scrollbar extends Sprite
   {
      
      public var slider:Slider;
      
      protected var upArrow:MovieClip;
      
      protected var downArrow:MovieClip;
      
      protected var scrollSpeed:Number = 0.1;
      
      private var _visibleViewHeight:int;
      
      public function Scrollbar(param1:int)
      {
         super();
         this._visibleViewHeight = param1;
      }
      
      public function init() : void
      {
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc2_:SWFFinisher = SWFFinisher(_loc1_.getLib("scrollbar"));
         this.upArrow = _loc2_.getEmbeddedMovieClip("upArrow");
         this.downArrow = _loc2_.getEmbeddedMovieClip("downArrow");
         this.createElements();
      }
      
      protected function createElements() : void
      {
         this.alignElements();
         this.upArrow.addEventListener(MouseEvent.MOUSE_DOWN,this.arrowPressed);
         this.downArrow.addEventListener(MouseEvent.MOUSE_DOWN,this.arrowPressed);
         addChild(this.slider);
         addChild(this.upArrow);
         addChild(this.downArrow);
      }
      
      private function alignElements() : void
      {
         this.slider.viewableHeight = this._visibleViewHeight;
         this.slider.scrollbarHeight = this._visibleViewHeight - this.upArrow.height * 2;
         this.slider.y = this.upArrow.height;
         this.downArrow.y = this._visibleViewHeight - this.downArrow.height;
      }
      
      public function get percent() : Number
      {
         return this.slider.percent;
      }
      
      public function set percent(param1:Number) : void
      {
         this.slider.percent = param1;
      }
      
      protected function arrowPressed(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.target == this.upArrow ? -1 : 1;
         this.slider.percent += _loc2_ * this.scrollSpeed;
      }
      
      public function handleMouseWheelMovement(param1:MouseEvent) : void
      {
         param1.preventDefault();
         var _loc2_:int = param1.delta > 0 ? -1 : 1;
         this.slider.percent += _loc2_ * this.scrollSpeed;
      }
      
      public function manuallySetSliderPosition(param1:int) : void
      {
         if(this.slider == null)
         {
            return;
         }
         switch(param1)
         {
            case ScrollController.TOP:
               this.slider.forcePercentSetting(ScrollController.TOP);
               break;
            case ScrollController.BOTTOM:
               this.slider.forcePercentSetting(ScrollController.BOTTOM);
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(param1 === SliderEvent.CHANGE)
         {
            this.slider.addEventListener(SliderEvent.CHANGE,param2,param3,param4,param5);
            return;
         }
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(param1 === SliderEvent.CHANGE)
         {
            this.slider.removeEventListener(SliderEvent.CHANGE,param2,param3);
            return;
         }
         super.removeEventListener(param1,param2,param3);
      }
      
      public function set visibleViewHeight(param1:int) : void
      {
         this._visibleViewHeight = param1;
         this.alignElements();
      }
   }
}

