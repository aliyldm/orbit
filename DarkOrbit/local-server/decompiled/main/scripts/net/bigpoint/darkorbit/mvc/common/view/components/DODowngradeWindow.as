package net.bigpoint.darkorbit.mvc.common.view.components
{
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DODownGradWindowSkin;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class DODowngradeWindow extends DOWindow
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _baseWindow:SimpleWindow;
      
      public function DODowngradeWindow()
      {
         super();
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         moveArea.addEventListener(MouseEvent.ROLL_OVER,this.handleMoveAreaMouseOver);
         moveArea.addEventListener(MouseEvent.ROLL_OUT,this.handleMoveAreaMouseOut);
      }
      
      private function handleMoveAreaMouseOut(param1:MouseEvent) : void
      {
         if(!Settings.displayWindowsBackground.value)
         {
            this._baseWindow.fadeOutWindow();
         }
      }
      
      private function handleMoveAreaMouseOver(param1:MouseEvent) : void
      {
         if(!Settings.displayWindowsBackground.value)
         {
            this._baseWindow.fadeInWindow();
         }
      }
      
      override protected function startDragging(param1:MouseEvent) : void
      {
         if(Settings.dragWindowsAlways)
         {
            this._baseWindow.startDrag();
         }
      }
      
      override public function stopDrag() : void
      {
         this._baseWindow.stopDrag();
      }
      
      override protected function handleCloseButtonClick(param1:MouseEvent = null) : void
      {
      }
      
      public function set baseWindow(param1:SimpleWindow) : void
      {
         this._baseWindow = param1;
         this.setSize(width,height);
         if(this._baseWindow.hasTransparencySupport())
         {
            this._baseWindow.addEventListener(SimpleWindowEvent.BG_FADE_IN,this.bgFadeIn);
            this._baseWindow.addEventListener(SimpleWindowEvent.BG_FADE_OUT,this.bgFadeOut);
            if(!Settings.displayWindowsBackground.value)
            {
               this.bgFadeOut();
            }
         }
      }
      
      private function bgFadeOut(param1:SimpleWindowEvent = null) : void
      {
         (skin as DODownGradWindowSkin).bgImageContainer.alpha = 0;
         (skin as DODownGradWindowSkin).scale9Graphic.alpha = 0;
         (skin as DODownGradWindowSkin).titleDisplay.alpha = 0;
      }
      
      private function bgFadeIn(param1:SimpleWindowEvent = null) : void
      {
         (skin as DODownGradWindowSkin).bgImageContainer.alpha = 1;
         (skin as DODownGradWindowSkin).scale9Graphic.alpha = 1;
         (skin as DODownGradWindowSkin).titleDisplay.alpha = 1;
      }
      
      override public function get x() : Number
      {
         if(this._baseWindow)
         {
            return this._baseWindow.x;
         }
         return super.x;
      }
      
      override public function get y() : Number
      {
         if(this._baseWindow)
         {
            return this._baseWindow.y;
         }
         return super.y;
      }
      
      override public function set x(param1:Number) : void
      {
         if(this._baseWindow)
         {
            this._baseWindow.x = int(param1);
         }
         else
         {
            super.x = param1;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         if(this._baseWindow)
         {
            this._baseWindow.y = int(param1);
         }
         else
         {
            super.y = param1;
         }
      }
      
      override protected function handleMouseUpAfterDragComplete() : void
      {
         this._baseWindow.saveWindowSetting(true);
      }
      
      override protected function handleResizeMouseDown(param1:MouseEvent) : void
      {
         this.setSize(ScreenManager.getScreenWidth(),ScreenManager.getScreenHeight());
         super.handleResizeMouseDown(param1);
      }
      
      override protected function handleResizeMouseMove(param1:MouseEvent) : void
      {
         super.handleResizeMouseMove(param1);
         DODownGradWindowSkin(skin).bgMask2.width = width;
         DODownGradWindowSkin(skin).bgMask2.height = height;
      }
      
      private function setSize(param1:Number, param2:Number) : void
      {
         this._baseWindow.setSize(int(param1),int(param2));
      }
      
      override protected function handleResizeMouseUpComplete() : void
      {
         super.handleResizeMouseUpComplete();
         this.setSize(width,height);
         this._baseWindow.saveWindowSetting(true);
      }
      
      override public function set title(param1:String) : void
      {
         super.title = param1;
         this._baseWindow.setTitle("",false);
      }
      
      public function close() : void
      {
         this._baseWindow.cleanup();
      }
      
      public function getBaseWindowID() : String
      {
         return this._baseWindow.id;
      }
      
      override public function get parent() : DisplayObjectContainer
      {
         return this._baseWindow ? this._baseWindow.getRootContainer() : super.parent;
      }
   }
}

