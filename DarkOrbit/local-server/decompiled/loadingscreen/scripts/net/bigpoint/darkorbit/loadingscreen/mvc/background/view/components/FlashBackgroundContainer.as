package net.bigpoint.darkorbit.loadingscreen.mvc.background.view.components
{
   import com.greensock.TweenMax;
   import com.greensock.layout.AlignMode;
   import com.greensock.layout.AutoFitArea;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   
   public class FlashBackgroundContainer extends Sprite
   {
      
      public static const LOGO_MIN_HEIGHT:uint = 65;
      
      public static const LOGO_MAX_HEIGHT:uint = 115;
      
      private var _autoFitarea:AutoFitArea;
      
      private var _logo:Bitmap;
      
      private var _loader:Bitmap;
      
      private var _laserAutoFitarea:AutoFitArea;
      
      private var _laserContainer:Sprite;
      
      private var _laserTopLeft:Bitmap;
      
      private var _laserTopRight:Bitmap;
      
      private var _laserBottomLeft:Bitmap;
      
      private var _laserBottomRight:Bitmap;
      
      private var _oldHeight:Number = NaN;
      
      public function FlashBackgroundContainer()
      {
         super();
         this._autoFitarea = new AutoFitArea(this,0,0,10,10,13369344);
         this._laserContainer = new Sprite();
         addChild(this._laserContainer);
         this._laserAutoFitarea = new AutoFitArea(this._laserContainer,0,0,10,10,52224);
      }
      
      public function clientFullyLoaded() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.handleBackgroundClicked);
      }
      
      private function handleBackgroundClicked(param1:MouseEvent) : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.handleBackgroundClicked);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function scaleLogo(param1:int) : void
      {
         if(param1 <= LOGO_MIN_HEIGHT)
         {
            this._logo.visible = false;
            return;
         }
         if(param1 < LOGO_MAX_HEIGHT)
         {
            this._autoFitarea.height = param1;
         }
         else
         {
            this._autoFitarea.height = LOGO_MAX_HEIGHT;
         }
         this._logo.visible = true;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this._autoFitarea.width = param1;
         this._autoFitarea.height = param2;
         this._laserAutoFitarea.width = param1;
         this._laserAutoFitarea.height = param2;
         this.checkElementVisibility();
         if(isNaN(this._oldHeight))
         {
            this._oldHeight = param2;
         }
         var _loc3_:Number = this._oldHeight - param2;
         this._oldHeight = param2;
      }
      
      private function checkElementVisibility() : void
      {
         if((this._autoFitarea.width < Session.bgWidthThreshold || this._autoFitarea.height < Session.bgHeightThreshold) && !TweenMax.isTweening(this._laserContainer))
         {
            TweenMax.to(this._laserContainer,1,{
               "alpha":0,
               "onComplete":this.validateBackgroundElementsAlignment,
               "onCompleteParams":[this._autoFitarea.width,this._autoFitarea.height]
            });
         }
         else if(this._laserContainer.alpha < 1 && !TweenMax.isTweening(this._laserContainer))
         {
            TweenMax.to(this._laserContainer,1,{
               "alpha":1,
               "onComplete":this.validateBackgroundElementsAlignment,
               "onCompleteParams":[this._autoFitarea.width,this._autoFitarea.height]
            });
         }
      }
      
      private function validateBackgroundElementsAlignment(param1:uint, param2:uint) : void
      {
         if(param1 < Session.bgWidthThreshold || param2 < Session.bgHeightThreshold)
         {
            this._laserContainer.alpha = 0;
         }
         else if(this._laserContainer.alpha < 1)
         {
            this._laserContainer.alpha = 1;
         }
      }
      
      public function set logo(param1:BitmapData) : void
      {
         this._logo = new Bitmap(param1,PixelSnapping.ALWAYS,true);
         this.addChild(this._logo);
         this._autoFitarea.attach(this._logo,{
            "hAlign":AlignMode.CENTER,
            "vAlign":AlignMode.TOP,
            "minWidth":this._logo.width >> 4,
            "minHeight":this._logo.height >> 4,
            "maxWidth":this._logo.width,
            "maxHeight":this._logo.height
         });
      }
      
      public function getLogoAsDisplayObject() : Bitmap
      {
         return this._logo;
      }
      
      public function set loader(param1:BitmapData) : void
      {
         this._loader = new Bitmap(param1);
         this.addChild(this._loader);
         this._autoFitarea.attach(this._loader,{
            "hAlign":AlignMode.CENTER,
            "vAlign":AlignMode.BOTTOM,
            "minWidth":this._loader.width >> 4,
            "minHeight":this._loader.height >> 4,
            "maxWidth":this._loader.width,
            "maxHeight":this._loader.height
         });
      }
      
      public function set topLeft(param1:BitmapData) : void
      {
         this._laserTopLeft = new Bitmap(param1);
         this._laserContainer.addChild(this._laserTopLeft);
         this._laserAutoFitarea.attach(this._laserTopLeft,{
            "hAlign":AlignMode.LEFT,
            "vAlign":AlignMode.TOP,
            "minWidth":this._laserTopLeft.width >> 4,
            "minHeight":this._laserTopLeft.height >> 4,
            "maxWidth":this._laserTopLeft.width,
            "maxHeight":this._laserTopLeft.height
         });
      }
      
      public function set topRight(param1:BitmapData) : void
      {
         this._laserTopRight = new Bitmap(param1);
         this._laserContainer.addChild(this._laserTopRight);
         this._laserAutoFitarea.attach(this._laserTopRight,{
            "hAlign":AlignMode.RIGHT,
            "vAlign":AlignMode.TOP,
            "minWidth":this._laserTopRight.width >> 4,
            "minHeight":this._laserTopRight.height >> 4,
            "maxWidth":this._laserTopRight.width,
            "maxHeight":this._laserTopRight.height
         });
      }
      
      public function set bottomLeft(param1:BitmapData) : void
      {
         this._laserBottomLeft = new Bitmap(param1);
         this._laserContainer.addChild(this._laserBottomLeft);
         this._laserAutoFitarea.attach(this._laserBottomLeft,{
            "hAlign":AlignMode.LEFT,
            "vAlign":AlignMode.BOTTOM,
            "minWidth":this._laserBottomLeft.width >> 4,
            "minHeight":this._laserBottomLeft.height >> 4,
            "maxWidth":this._laserBottomLeft.width,
            "maxHeight":this._laserBottomLeft.height
         });
      }
      
      public function set bottomRight(param1:BitmapData) : void
      {
         this._laserBottomRight = new Bitmap(param1);
         this._laserContainer.addChild(this._laserBottomRight);
         this._laserAutoFitarea.attach(this._laserBottomRight,{
            "hAlign":AlignMode.RIGHT,
            "vAlign":AlignMode.BOTTOM,
            "minWidth":this._laserBottomRight.width >> 4,
            "minHeight":this._laserBottomRight.height >> 4,
            "maxWidth":this._laserBottomRight.width,
            "maxHeight":this._laserBottomRight.height
         });
      }
      
      public function cleanup() : void
      {
         if(this._laserTopLeft)
         {
            this._laserTopLeft.bitmapData.dispose();
            this._laserTopLeft = null;
         }
         if(this._laserTopRight)
         {
            this._laserTopRight.bitmapData.dispose();
            this._laserTopRight = null;
         }
         if(this._laserBottomLeft)
         {
            this._laserBottomLeft.bitmapData.dispose();
            this._laserBottomLeft = null;
         }
         if(this._laserBottomRight)
         {
            this._laserBottomRight.bitmapData.dispose();
            this._laserBottomRight = null;
         }
         if(this._laserContainer)
         {
            if(this.contains(this._laserContainer))
            {
               this.removeChild(this._laserContainer);
            }
            this._laserContainer = null;
         }
         if(this._laserAutoFitarea)
         {
            this._laserAutoFitarea.destroy();
            this._laserAutoFitarea = null;
         }
         if(this._logo)
         {
            if(this.contains(this._logo))
            {
               this.removeChild(this._logo);
            }
            this._logo.bitmapData.dispose();
            this._logo = null;
         }
         if(this._loader)
         {
            if(this.contains(this._loader))
            {
               this.removeChild(this._loader);
            }
            this._loader.bitmapData.dispose();
            this._loader = null;
         }
         if(this._autoFitarea)
         {
            this._autoFitarea.destroy();
            this._autoFitarea = null;
         }
      }
   }
}

