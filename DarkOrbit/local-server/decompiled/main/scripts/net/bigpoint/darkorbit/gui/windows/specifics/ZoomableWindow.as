package net.bigpoint.darkorbit.gui.windows.specifics
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ZoomableWindow extends SimpleWindow
   {
      
      protected var _zoomInBtn:StatesButtonDecorator;
      
      protected var _zoomOutBtn:StatesButtonDecorator;
      
      protected var _zoomable:Boolean;
      
      public function ZoomableWindow()
      {
         super();
      }
      
      override public function assignValuesFromFeatureWindowVO(param1:FeatureWindowVO) : void
      {
         super.assignValuesFromFeatureWindowVO(param1);
         if(param1.definition.zoomable)
         {
            this._zoomable = param1.definition.zoomable;
         }
      }
      
      override protected function getWindowContainerInstance(param1:SWFFinisher) : MovieClip
      {
         if(this._zoomable)
         {
            _windowContainer = MovieClip(param1.getEmbeddedMovieClip("backgroundWithBottomControls"));
         }
         return _windowContainer;
      }
      
      override protected function buildWindowContainerComponents() : void
      {
         super.buildWindowContainerComponents();
         if(this._zoomable)
         {
            this._zoomInBtn = getStateBtnByViewName("zoomInBtn");
            _zoomInBtnInitDistance = _window.width - this._zoomInBtn.x;
            this._zoomOutBtn = getStateBtnByViewName("zoomOutBtn");
            _zoomOutBtnInitDistance = _window.width - this._zoomOutBtn.x;
            if(!Settings.displayWindowsBackground.value && _transparencySupport)
            {
               this.setZoomButtonListeners();
            }
            if(this._zoomInBtn)
            {
               this._zoomInBtn.cacheAsBitmap = true;
            }
            if(this._zoomOutBtn)
            {
               this._zoomOutBtn.cacheAsBitmap = true;
            }
            this.setZoomButtonListeners();
         }
      }
      
      override public function cleanup(param1:Boolean = true) : void
      {
         super.cleanup(param1);
         if(this._zoomable)
         {
            this.removeZoomButtonTransparencyListeners();
         }
      }
      
      private function setZoomButtonListeners() : void
      {
         if(this._zoomInBtn)
         {
            this._zoomInBtn.addEventListener(MouseEvent.CLICK,this.handleZoomInButtonClickEvent);
            this._zoomInBtn.addEventListener(MouseEvent.MOUSE_OVER,handleMouseOverMinimizeIcon);
            this._zoomInBtn.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOutMinimizeIcon);
         }
         if(this._zoomOutBtn)
         {
            this._zoomOutBtn.addEventListener(MouseEvent.CLICK,this.handleZoomOutButtonClickEvent);
            this._zoomOutBtn.addEventListener(MouseEvent.MOUSE_OVER,handleMouseOverMinimizeIcon);
            this._zoomOutBtn.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOutMinimizeIcon);
         }
      }
      
      private function removeZoomButtonTransparencyListeners() : void
      {
         if(this._zoomInBtn)
         {
            this._zoomInBtn.removeEventListener(MouseEvent.CLICK,this.handleZoomInButtonClickEvent);
            this._zoomInBtn.removeEventListener(MouseEvent.MOUSE_OVER,handleMouseOverMinimizeIcon);
            this._zoomInBtn.removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOutMinimizeIcon);
         }
         if(this._zoomOutBtn)
         {
            this._zoomOutBtn.removeEventListener(MouseEvent.CLICK,this.handleZoomOutButtonClickEvent);
            this._zoomOutBtn.removeEventListener(MouseEvent.MOUSE_OVER,handleMouseOverMinimizeIcon);
            this._zoomOutBtn.removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOutMinimizeIcon);
         }
      }
      
      private function handleZoomInButtonClickEvent(param1:MouseEvent) : void
      {
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ZOOM_IN));
         saveWindowSetting();
         GameFacade.getInstance().sendNotification(GuiNotifications.SAVE_BARS_SETTINGS);
      }
      
      private function handleZoomOutButtonClickEvent(param1:MouseEvent) : void
      {
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ZOOM_OUT));
         saveWindowSetting();
         GameFacade.getInstance().sendNotification(GuiNotifications.SAVE_BARS_SETTINGS);
      }
      
      override protected function _updateElementPositionsAfterResize(param1:Event = null) : void
      {
         super._updateElementPositionsAfterResize(param1);
         if(this._zoomable)
         {
            this._zoomInBtn.x = _window.width - _zoomInBtnInitDistance;
            this._zoomOutBtn.x = _window.width - _zoomOutBtnInitDistance;
         }
      }
      
      override public function get size() : PointLite
      {
         if(this._zoomable)
         {
            return resizeDimension;
         }
         return _size;
      }
      
      override protected function canResize() : Boolean
      {
         return _resizable || this._zoomable || _expandable;
      }
   }
}

