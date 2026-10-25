package
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol245")]
   public dynamic class CustomCrollBar extends MovieClip
   {
      
      public var DownArrow:SimpleButton;
      
      public var bar:MovieClip;
      
      public var barBg:MovieClip;
      
      public var upArrow:SimpleButton;
      
      public var scrollPosition:Number;
      
      public var maxPosition:uint;
      
      public var stageObj:*;
      
      public function CustomCrollBar()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function handleUp(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("keyUp"));
      }
      
      public function handleDown(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("keyDown"));
      }
      
      public function handleScrollStart(param1:MouseEvent) : void
      {
         this.bar.startDrag(false,new Rectangle(0,0,0,this.maxPosition));
         this.stageObj.addEventListener(MouseEvent.MOUSE_UP,this.handleScrollEnd,false,int.MAX_VALUE);
         this.stageObj.addEventListener(MouseEvent.MOUSE_MOVE,this.handleScroll);
      }
      
      public function handleScrollEnd(param1:MouseEvent) : void
      {
         this.scrollPosition = this.bar.y / this.maxPosition;
         dispatchEvent(new Event("scroll"));
         this.bar.stopDrag();
         this.stageObj.removeEventListener(MouseEvent.MOUSE_UP,this.handleScrollEnd,false);
         this.stageObj.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleScroll);
      }
      
      public function handleScroll(param1:MouseEvent) : void
      {
         if(this.scrollPosition != this.bar.y / this.maxPosition)
         {
            this.scrollPosition = this.bar.y / this.maxPosition;
            dispatchEvent(new Event("scroll"));
         }
      }
      
      public function scrollTo(param1:Number) : *
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 1)
         {
            param1 = 1;
         }
         this.bar.y = Math.floor(param1 * this.maxPosition);
      }
      
      public function handleBarClick(param1:MouseEvent) : *
      {
         if(this.mouseY < this.bar.y)
         {
            dispatchEvent(new Event("pageUp"));
         }
         else
         {
            dispatchEvent(new Event("pageDown"));
         }
      }
      
      public function registerStage(param1:*) : *
      {
         this.stageObj = param1;
      }
      
      internal function frame1() : *
      {
         this.scrollPosition = 0;
         this.maxPosition = 114;
         this.stageObj = this.stage;
         this.upArrow.addEventListener(MouseEvent.CLICK,this.handleUp);
         this.DownArrow.addEventListener(MouseEvent.CLICK,this.handleDown);
         this.bar.addEventListener(MouseEvent.MOUSE_DOWN,this.handleScrollStart);
         this.bar.addEventListener(MouseEvent.MOUSE_UP,this.handleScrollEnd);
         this.barBg.addEventListener(MouseEvent.CLICK,this.handleBarClick);
      }
   }
}

