package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentDecorator;
   
   public class TimerOverlay extends DOAbstractComponentDecorator
   {
      
      private static const OVERLAY_MASK:String = "overlayMask";
      
      private static const BACKGROUND:String = "background";
      
      public var overlayMask:MovieClip;
      
      public var background:Sprite;
      
      public function TimerOverlay(param1:DisplayObjectContainer)
      {
         super(param1);
         this.background.mask = this.overlayMask;
         this.overlayMask.gotoAndStop(1);
         mouseChildren = false;
         mouseEnabled = false;
         visible = false;
      }
      
      override public function decorate() : void
      {
         addViewChild(this.overlayMask = getSpriteChild(OVERLAY_MASK) as MovieClip);
         addViewChild(this.background = getSpriteChild(BACKGROUND));
      }
      
      public function set progress(param1:int) : void
      {
         visible = param1 > 0 && param1 < 100;
         this.overlayMask.gotoAndStop(param1);
      }
      
      public function init(param1:Number, param2:Number) : void
      {
         TweenMax.to(this.background,0,{
            "tint":param1,
            "alpha":param2
         });
      }
      
      override public function get width() : Number
      {
         return this.background.width;
      }
      
      override public function get height() : Number
      {
         return this.background.height;
      }
   }
}

