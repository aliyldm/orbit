package net.bigpoint.darkorbit.gui.windows.simpleWindow
{
   import com.bigpoint.utils.BitmapAtlas;
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindowIcon;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.animate.ISimpleWindowAnimator;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.animate.SimpleWindowMenuMaximizeAnimator;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.animate.SimpleWindowMenuMinimizeAnimator;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.animate.SimpleWindowUIElementsAccessor;
   import net.bigpoint.darkorbit.gui.windows.simpleWindowPopup.PopupOptionVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindowPopup.SimpleWindowInternalPopup;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SimpleWindow extends Sprite implements IWindow
   {
      
      public static const UICONTAINER_X:uint = 6;
      
      public static const UICONTAINER_Y:uint = 25;
      
      public static const WINDOW_TITLEBAR_HEIGHT:uint = 25;
      
      public static const WINDOW_SHADOW_SIZE_IN_PIXEL:uint = 15;
      
      public static const AUTOSIZE:int = -1;
      
      public static const OPEN_STRATEGY_LAYER_1:int = 1;
      
      public static const OPEN_STRATEGY_LAYER_2:int = 2;
      
      public static const NO_ALIGN:int = 0;
      
      public static const ALIGN_VERTICAL:int = 1;
      
      public static const ALIGN_HORIZONTAL:int = 2;
      
      private static const MAX_WINDOW_WIDTH:int = 750;
      
      private static const MAX_WINDOW_HEIGHT:int = 750;
      
      private static const MIN_WINDOW_HEIGHT:int = 100;
      
      private static const MASK_MARGIN_Y:int = 4;
      
      private static const MASK_MARGIN_X:int = 8;
      
      private static const MINIMIZE_BTN_OFFSET:int = 26;
      
      private static const HELP_BTN_OFFSET:int = 52;
      
      protected static const WINDOWCONTAINER_WINDOWNAME:String = "window";
      
      protected static const WINDOWCONTAINER_DRAGGER:String = "dragger";
      
      protected static const WINDOWCONTAINER_RESIZER:String = "resizer";
      
      protected static const WINDOWCONTAINER_MASK:String = "windowMaskContainer";
      
      protected static const WINDOWCONTAINER_PATTERN:String = "pattern";
      
      protected static const WINDOWCONTAINER_LABEL:String = "label";
      
      protected var _guiManager:GuiManager;
      
      protected var _showTitleLabel:Boolean = true;
      
      protected var _titleLabel:TextField;
      
      private var _internalPopupContainer:Sprite;
      
      protected var _internalPopup:SimpleWindowInternalPopup;
      
      protected var _resizerBtn:MovieClip;
      
      protected var _resizeTimer:Timer;
      
      protected var _dragger:Sprite;
      
      protected var _fullDragger:Sprite;
      
      protected var _lastResizerPosition:Point = new Point();
      
      protected var _oldResizerX:Number;
      
      protected var _oldResizerY:Number;
      
      protected var _closeBtn:StatesButtonDecorator;
      
      protected var _minimizeBtn:StatesButtonDecorator;
      
      protected var _rootContainer:MovieClip = new MovieClip();
      
      protected var _rootContainerMask:Sprite;
      
      protected var _windowContainer:MovieClip;
      
      protected var _window:MovieClip;
      
      protected var _windowMask:MovieClip;
      
      protected var _uiContainer:Sprite;
      
      protected var _inProgressOverLayer:SimpleWindowInProgressLayer;
      
      protected var _modalLayer:Sprite;
      
      protected var _overlay:Sprite;
      
      protected var _containers:Array = [];
      
      protected var _icon:SimpleWindowIcon;
      
      protected var _iconContainer:Sprite;
      
      protected var _closeBtnInitDistance:Number;
      
      protected var _zoomInBtnInitDistance:Number;
      
      protected var _zoomOutBtnInitDistance:Number;
      
      protected var _flashWindowCount:int;
      
      protected var _maximizeClicked:Boolean;
      
      protected var _minimizedWindowCount:int;
      
      protected var _minimizeClicked:Boolean = false;
      
      protected var _saveSettings:Boolean;
      
      protected var _isDragged:Boolean;
      
      protected var _maximizeFunction:Function;
      
      protected var _tweening:Boolean;
      
      private var _helpBtn:StatesButtonDecorator;
      
      protected var _helpText:String;
      
      protected var _size:PointLite;
      
      protected var _positionPercentage:PointLite;
      
      protected var _resizeBounds:Rectangle;
      
      protected var _id:String;
      
      protected var _minimizable:Boolean;
      
      protected var _closeable:Boolean;
      
      protected var _resizable:Boolean;
      
      protected var _draggable:Boolean;
      
      protected var _transparencySupport:Boolean;
      
      protected var _openCloseAnimation:Boolean;
      
      protected var _expandable:Boolean;
      
      protected var _showHelp:Boolean;
      
      protected var _minimizeAnimator:ISimpleWindowAnimator;
      
      protected var _maximizeAnimator:ISimpleWindowAnimator;
      
      private var _featureWindowVO:FeatureWindowVO;
      
      private var _isdisposed:Boolean;
      
      public function SimpleWindow()
      {
         this._maximizeFunction = this.maximizeOnLayer1;
         super();
         this._minimizeAnimator = new SimpleWindowMenuMinimizeAnimator();
         this._minimizeAnimator.UIElementAccesor = this.uiElementsAccessor;
         this._maximizeAnimator = new SimpleWindowMenuMaximizeAnimator();
         this._maximizeAnimator.UIElementAccesor = this.uiElementsAccessor;
      }
      
      public function removeHelpBtnClick() : void
      {
         if(this._helpBtn)
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.handleHelpBtn);
         }
      }
      
      public function get helpBtn() : StatesButtonDecorator
      {
         return this._helpBtn;
      }
      
      protected function get uiElementsAccessor() : SimpleWindowUIElementsAccessor
      {
         return new SimpleWindowUIElementsAccessor();
      }
      
      public function preinitialize(param1:FeatureWindowVO, ... rest) : void
      {
         this.assignValuesFromFeatureWindowVO(param1);
         this._guiManager = rest[0] as GuiManager;
         var _loc3_:SWFFinisher = rest[1] as SWFFinisher;
         this.setOnOpenStrategy(param1.showOnTop);
         cacheAsBitmap = true;
         this.createWindowContainer(_loc3_);
         this.setWindowContainerMask();
         this.buildWindowContainerComponents();
         this.assignRootContainerMask();
         this.addChild(this._rootContainer);
         this._internalPopupContainer = new Sprite();
         this._internalPopup = new SimpleWindowInternalPopup(SWFFinisher(ResourceManager.fileCollection.getFinisher(GuiConstants.LIBRARY_LEGACY_UI)),this._rootContainer);
         this.addChild(this._internalPopupContainer);
         this._internalPopupContainer.addChild(this._internalPopup);
         this._iconContainer = new Sprite();
         this.addChild(this._iconContainer);
         if(param1.titleTextKey)
         {
            this.setTitle(param1.titleTextKey);
         }
         this.setHelpTextByFeatureWindowVO(param1);
         this.updateElementPositionsAfterResize();
         SimpleWindowContentBuilder.addWindowContent(this._guiManager,this,param1,_loc3_);
      }
      
      public function assignValuesFromFeatureWindowVO(param1:FeatureWindowVO) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._featureWindowVO = param1;
         if(this._id != param1.id)
         {
            this._id = param1.id;
         }
         this._size = param1.size;
         this._positionPercentage = param1.position;
         this._resizeBounds = param1.definition.resizeBounds;
         if(this._minimizable != param1.definition.minimizable)
         {
            this._minimizable = param1.definition.minimizable;
         }
         if(this._closeable != param1.definition.closeable)
         {
            this._closeable = param1.definition.closeable;
         }
         if(this._openCloseAnimation != param1.definition.openCloseAnimation)
         {
            this._openCloseAnimation = param1.definition.openCloseAnimation;
         }
         if(this._transparencySupport != param1.definition.transparencySupport)
         {
            this._transparencySupport = param1.definition.transparencySupport;
         }
         if(this._resizable != param1.definition.resizable)
         {
            this._resizable = param1.definition.resizable;
         }
         if(this._draggable != param1.definition.draggable)
         {
            this._draggable = param1.definition.draggable;
         }
         if(this._expandable != param1.definition.expandable)
         {
            this._expandable = param1.definition.expandable;
         }
         if(this._showHelp != param1.definition.showHelp)
         {
            this._showHelp = param1.definition.showHelp;
         }
      }
      
      protected function setHelpTextByFeatureWindowVO(param1:FeatureWindowVO) : void
      {
         var _loc2_:String = null;
         if(param1.helpText != null)
         {
            _loc2_ = TextUtils.getTooltipText(param1.helpText);
            this.setHelpText(_loc2_);
         }
      }
      
      public function setHelpText(param1:String) : void
      {
         if(param1 != null)
         {
            this._helpText = param1;
            TooltipControl.getInstance().addStickyToolTip(this,param1,0,0,220,true);
         }
      }
      
      public function hasHelpText() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._helpText != null)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      protected function assignRootContainerMask() : void
      {
         this._rootContainerMask = new Sprite();
         this._rootContainerMask.graphics.beginFill(16711680,0.4);
         this._rootContainerMask.graphics.drawRect(0,0,100,100);
         this._rootContainerMask.graphics.endFill();
         this._rootContainerMask.mouseEnabled = false;
         this._rootContainer.mask = this._rootContainerMask;
         this._rootContainer.addChild(this._rootContainerMask);
      }
      
      protected function setWindowContainerMask() : void
      {
         var _loc1_:MovieClip = this._windowContainer[WINDOWCONTAINER_MASK];
         _loc1_.mouseEnabled = false;
         _loc1_.cacheAsBitmap = true;
         this._windowMask = _loc1_["windowMask"];
         this._windowMask.mouseEnabled = false;
         var _loc2_:MovieClip = this._windowContainer[WINDOWCONTAINER_PATTERN];
         _loc2_.mouseEnabled = false;
         _loc2_.cacheAsBitmap = true;
         _loc2_.mask = _loc1_;
      }
      
      protected function createWindowContainer(param1:SWFFinisher) : void
      {
         this._windowContainer = this.getWindowContainerInstance(param1);
         this._windowContainer.addEventListener(MouseEvent.CLICK,this.handleWindowToFront);
         this._rootContainer.addChild(this._windowContainer);
         if(!Settings.displayWindowsBackground.value && this._transparencySupport)
         {
            this._windowContainer.alpha = 0;
         }
      }
      
      protected function getWindowContainerInstance(param1:SWFFinisher) : MovieClip
      {
         var _loc2_:MovieClip = null;
         if((this._closeable || this._minimizable) && this._resizable)
         {
            _loc2_ = MovieClip(param1.getEmbeddedMovieClip("backgroundWithTopControlsResizable"));
         }
         else if(this._closeable || this._minimizable)
         {
            if(this._showHelp)
            {
               _loc2_ = MovieClip(param1.getEmbeddedMovieClip("backgroundWithTopControlsAndHelp"));
            }
            else
            {
               _loc2_ = MovieClip(param1.getEmbeddedMovieClip("backgroundWithTopControls"));
            }
         }
         else if(this._resizable)
         {
            _loc2_ = MovieClip(param1.getEmbeddedMovieClip("backgroundNormalResizable"));
         }
         else
         {
            _loc2_ = MovieClip(param1.getEmbeddedMovieClip("backgroundNormal"));
         }
         return _loc2_;
      }
      
      protected function buildWindowContainerComponents() : void
      {
         this._window = this._windowContainer[WINDOWCONTAINER_WINDOWNAME];
         this._dragger = this._windowContainer[WINDOWCONTAINER_DRAGGER];
         this._resizerBtn = this._windowContainer[WINDOWCONTAINER_RESIZER];
         if(this._closeable || this._minimizable)
         {
            this._closeBtn = this.getStateBtnByViewName("closeBtn");
            this._closeBtn.visible = this._closeable;
            if(this._closeable)
            {
               this._closeBtnInitDistance = this._window.width - this._closeBtn.x;
               this._closeBtn.addEventListener(MouseEvent.CLICK,this.handleCloseButtonClickEvent);
            }
            this._minimizeBtn = this.getStateBtnByViewName("minimizeBtn");
            this._minimizeBtn.visible = this._minimizable;
            if(this._windowContainer.getChildByName("helpBtn"))
            {
               this._helpBtn = this.getStateBtnByViewName("helpBtn");
               this._helpBtn.addEventListener(MouseEvent.CLICK,this.handleHelpBtn);
            }
            if(this._minimizable)
            {
               this._minimizeBtn.addEventListener(MouseEvent.CLICK,this.toggleVisibility);
               this._minimizeBtn.addEventListener(MouseEvent.ROLL_OVER,this.minimizeBtnRollOverHandler);
            }
         }
         if(this._draggable)
         {
            this._dragger.alpha = 0;
            this._dragger.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDraggerMouseDownEvent);
            if(!Settings.displayWindowsBackground.value && this._transparencySupport)
            {
               this.setDraggerListeners();
            }
            this.updateDraggerButtonMode();
         }
         else
         {
            this._windowContainer.removeChild(this._dragger);
         }
         if(this._resizable)
         {
            this._resizerBtn.alpha = 0;
            this._resizerBtn.addEventListener(MouseEvent.MOUSE_UP,this.handleResizerMouseUpEvent);
            this._resizerBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.resizerMouseDownHandler);
            if(!Settings.displayWindowsBackground.value && this._transparencySupport)
            {
               this.setResizerListeners();
            }
            this._resizerBtn.buttonMode = true;
         }
         else
         {
            this._windowContainer.removeChild(this._resizerBtn);
         }
         if(this._showTitleLabel)
         {
            this._titleLabel = this._windowContainer[WINDOWCONTAINER_LABEL];
            this._titleLabel.defaultTextFormat = Styles.windowTitleFmt;
            this._titleLabel.embedFonts = Styles.windowTitleEmbed;
            this._titleLabel.height = Styles.windowTitleFontHeight + 8;
            this._titleLabel.autoSize = TextFieldAutoSize.LEFT;
            this._titleLabel.mouseEnabled = false;
         }
         if(this._dragger)
         {
            this._dragger.cacheAsBitmap = true;
         }
         if(this._resizerBtn)
         {
            this._resizerBtn.cacheAsBitmap = true;
         }
         if(this._closeBtn)
         {
            this._closeBtn.cacheAsBitmap = true;
         }
         this.getUIContainer();
         this._inProgressOverLayer = new SimpleWindowInProgressLayer(this);
         this._rootContainer.addChild(this._inProgressOverLayer as DisplayObject);
         this._window.cacheAsBitmap = true;
      }
      
      public function loadAndBuildUI(param1:String, param2:Function = null, ... rest) : void
      {
         var _loc4_:Sprite = this.getUIContainer();
         var _loc5_:Array = [param2,this];
         if(rest != null)
         {
            _loc5_ = _loc5_.concat(rest);
         }
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc4_,this.handleContentLoaded,_loc5_);
      }
      
      protected function handleContentLoaded(... rest) : void
      {
         if(this._isdisposed)
         {
            return;
         }
         var _loc2_:Function = rest.shift() as Function;
         if(_loc2_ != null)
         {
            _loc2_(rest);
         }
      }
      
      public function update(param1:FeatureWindowVO, param2:Boolean) : void
      {
         if(param2)
         {
            if(param1.maximized && !this.maximized)
            {
               this.maximize();
            }
            if(!param1.maximized && this.maximized)
            {
               this.minimize();
            }
         }
         else if(this.maximized)
         {
            this.minimize(false);
         }
         this.assignValuesFromFeatureWindowVO(param1);
      }
      
      public function cleanup(param1:Boolean = true) : void
      {
         this._isdisposed = true;
         this._windowContainer.removeEventListener(MouseEvent.CLICK,this.handleWindowToFront);
         if(this._closeable)
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.handleCloseButtonClickEvent);
         }
         if(this._draggable)
         {
            this._dragger.removeEventListener(MouseEvent.MOUSE_UP,this.handleResizerMouseUpEvent);
            this._dragger.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleDraggerMouseDownEvent);
            this.removeDraggerTransparencyListeners();
         }
         if(this._resizable)
         {
            this._resizerBtn.removeEventListener(MouseEvent.MOUSE_UP,this.handleResizerMouseUpEvent);
            this._resizerBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.resizerMouseDownHandler);
            this.removeResizerTransparencyListeners();
         }
         if(this._iconContainer != null)
         {
            this._iconContainer.removeEventListener(MouseEvent.CLICK,this.toggleVisibility);
            this._iconContainer.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverMinimizeIcon);
            this._iconContainer.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutMinimizeIcon);
            this._iconContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleIconMouseDownEvent);
         }
         if(param1)
         {
            TweenLite.to(this,0.25,{
               "alpha":0,
               "onComplete":this.handleCloseWindowComplete
            });
         }
         else
         {
            this.handleCloseWindowComplete();
         }
      }
      
      public function setListeners() : void
      {
         this.setDraggerListeners();
         this.setResizerListeners();
      }
      
      public function removeListeners() : void
      {
         this.removeDraggerTransparencyListeners();
         this.removeResizerTransparencyListeners();
      }
      
      private function setDraggerListeners() : void
      {
         this._dragger.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverDragger);
         this._dragger.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutDragger);
      }
      
      private function setResizerListeners() : void
      {
         this._resizerBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverResizer);
         this._resizerBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutResizer);
      }
      
      private function removeDraggerTransparencyListeners() : void
      {
         this._dragger.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverDragger);
         this._dragger.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutDragger);
      }
      
      private function removeResizerTransparencyListeners() : void
      {
         this._resizerBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverResizer);
         this._resizerBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutResizer);
      }
      
      protected function handleMouseOverMinimizeIcon(param1:MouseEvent) : void
      {
         if(!Settings.displayWindowsBackground.value && this._transparencySupport)
         {
            this.fadeInWindow();
         }
         if(this.maximized)
         {
            return;
         }
      }
      
      protected function handleMouseOutMinimizeIcon(param1:MouseEvent) : void
      {
         if(!Settings.displayWindowsBackground.value && this._transparencySupport)
         {
            TweenLite.to(this._windowContainer,0.25,{"alpha":0});
            if(this.maximized && !this._minimizeClicked)
            {
               TweenLite.to(this._iconContainer,0.25,{"alpha":0});
            }
            dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.BG_FADE_OUT));
         }
      }
      
      private function handleMouseOverDragger(param1:MouseEvent) : void
      {
         this.fadeInWindow();
      }
      
      private function handleMouseOutDragger(param1:MouseEvent) : void
      {
         this.fadeOutWindow();
      }
      
      protected function handleMouseStageUp(param1:MouseEvent) : void
      {
         this.handleResizerMouseUpEvent();
      }
      
      public function handleMouseOverResizer(param1:MouseEvent) : void
      {
         this.fadeInWindow();
      }
      
      public function handleMouseOutResizer(param1:MouseEvent) : void
      {
         this.fadeOutWindow();
      }
      
      private function handleResizerMouseUpEvent(param1:MouseEvent = null) : void
      {
         this.resizeTimer.stop();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseStageUp);
         stage.removeEventListener(MouseEvent.ROLL_OUT,this.handleMouseStageUp);
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.RESIZE_STOP));
         stopDrag();
         if(this._dragger.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            this._dragger.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleDraggerMouseMoveEvent);
            this._resizerBtn.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleDraggerMouseMoveEvent);
         }
         this.saveWindowPosition();
      }
      
      private function handleDraggerMouseDownEvent(param1:MouseEvent) : void
      {
         if(Settings.dragWindowsAlways)
         {
            this._guiManager.setCheckWindowPositions(true);
            this.startDrag();
            this.parent.swapChildren(this,parent.getChildAt(parent.numChildren - 1));
            this._dragger.addEventListener(MouseEvent.MOUSE_MOVE,this.handleDraggerMouseMoveEvent);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.handleDraggerMouseUpEvent);
            stage.addEventListener(MouseEvent.ROLL_OUT,this.handleDraggerMouseUpEvent);
            dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.START_DRAG));
         }
      }
      
      private function handleDraggerMouseMoveEvent(param1:MouseEvent) : void
      {
         this._isDragged = true;
      }
      
      private function handleDraggerMouseUpEvent(param1:MouseEvent) : void
      {
         stopDrag();
         this.x = int(x);
         this.y = int(y);
         this._positionPercentage = ScreenScaleUtils.getPercentagePosFromRealPos(ScreenManager.getInstance().stageSize,new PointLite(x,y),this._size);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleDraggerMouseUpEvent);
         stage.removeEventListener(MouseEvent.ROLL_OUT,this.handleDraggerMouseUpEvent);
         if(this._dragger)
         {
            this._dragger.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleDraggerMouseMoveEvent);
         }
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.STOP_DRAG));
         this.saveWindowPosition();
      }
      
      private function handleIconMouseDownEvent(param1:MouseEvent) : void
      {
         if(this._rootContainer.visible)
         {
            return;
         }
         if(!this.maximized)
         {
            return;
         }
         this.startDrag();
      }
      
      private function handleCloseButtonClickEvent(param1:MouseEvent) : void
      {
         this.cleanup();
      }
      
      private function handleCloseWindowComplete() : void
      {
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_CLOSE));
         this._guiManager.deleteWindow(this.id);
         this.activateModalLayer(false);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function fadeOutWindow() : void
      {
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.BG_FADE_OUT));
         if(this._transparencySupport)
         {
            TweenLite.to(this._windowContainer,0.25,{"alpha":0});
            TweenLite.to(this._iconContainer,0.25,{"alpha":0});
         }
      }
      
      public function fadeInWindow() : void
      {
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.BG_FADE_IN));
         if(this._transparencySupport)
         {
            this._windowContainer.visible = true;
            TweenLite.to(this._windowContainer,0.25,{"alpha":Settings.maxWindowsTransparency});
            TweenLite.to(this._iconContainer,0.25,{"alpha":Settings.maxWindowsTransparency});
         }
      }
      
      protected function setInvisible(param1:Bitmap) : void
      {
         if(TweenMax.isTweening(param1))
         {
            return;
         }
         param1.visible = false;
      }
      
      public function toggleVisibility(param1:MouseEvent = null) : void
      {
         if(TweenMax.isTweening(this._rootContainer) || TweenMax.isTweening(this._rootContainerMask))
         {
            return;
         }
         if(this._rootContainer.visible)
         {
            this._maximizeClicked = false;
            if(this._minimizable)
            {
               this.minimize();
            }
            dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_MINIMIZE_CLICKED));
         }
         else
         {
            this._maximizeClicked = true;
            if(this._minimizable)
            {
               this.maximize();
            }
            dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_MAXIMIZE_CLICKED));
         }
      }
      
      public function minimize(param1:Boolean = true, param2:Boolean = false) : void
      {
         if(this._icon)
         {
            this._icon.setWindowMode(false,this._openCloseAnimation && !param2);
         }
         this._minimizeClicked = true;
         this._tweening = true;
         this._maximizeClicked = false;
         parent.removeChild(this);
         this._guiManager.getMain().screenManager.getIconLayer().addChild(this);
         TweenLite.killTweensOf(this._rootContainerMask);
         TweenLite.killTweensOf(this._rootContainer);
         TweenLite.killTweensOf(this,true);
         if(param1)
         {
            this._featureWindowVO.maximized = false;
            dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_MINIMIZE));
         }
         if(this._minimizable && this.maximized)
         {
            this._minimizedWindowCount = this._guiManager.getMinimizedWindowCount();
            this._guiManager.increaseMinimizedWindowCount();
         }
         var _loc3_:Boolean = param2 ? false : this._openCloseAnimation;
         if(_loc3_)
         {
            TweenLite.to(this._rootContainerMask,0.25,{
               "ease":Expo.easeOut,
               "height":25,
               "onComplete":this.onMinimizedVertical,
               "onCompleteParams":[_loc3_,param1]
            });
            if(Boolean(this._internalPopup) && this.maximized)
            {
               this._internalPopup.hide(false);
            }
         }
         else
         {
            TweenLite.killTweensOf(this._rootContainerMask);
            this.onMinimizedVertical(_loc3_,param1);
         }
         if(this._overlay != null)
         {
            this._overlay.visible = false;
         }
      }
      
      private function onMinimizedVertical(param1:Boolean, param2:Boolean = true) : void
      {
         if(param1)
         {
            TweenLite.to(this._rootContainerMask,0.25,{
               "ease":Expo.easeOut,
               "width":0,
               "onComplete":this.onMinimized,
               "onCompleteParams":[this._rootContainer,param1,param2]
            });
            TweenLite.to(this._rootContainer,0.25,{"alpha":0});
         }
         else
         {
            this._rootContainerMask.width = 0;
            this._rootContainer.alpha = 0;
            this.onMinimized(this._rootContainer,param1,param2);
         }
      }
      
      private function onMinimized(param1:MovieClip, param2:Boolean, param3:Boolean = true) : void
      {
         this._minimizeClicked = false;
         MovieClipUtils.removeDisplayObject(this._rootContainer);
         if(!Settings.displayWindowsBackground.value && this._transparencySupport)
         {
            this._iconContainer.alpha = Settings.maxWindowsTransparency;
            dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.BG_FADE_OUT));
         }
         param1.visible = false;
         this._tweening = false;
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_MINIMIZED));
         if(param2 && param3)
         {
            this.saveWindowSetting();
         }
         var _loc4_:Point = this._featureWindowVO.minimizedPosition;
         if((Boolean(_loc4_)) && param2)
         {
            TweenLite.to(this,0.25,{
               "x":int(_loc4_.x) + SimpleWindowIcon.OFFSET_X,
               "y":int(_loc4_.y) + SimpleWindowIcon.OFFSET_Y,
               "onComplete":this.hideIcon,
               "ease":Expo.easeOut
            });
         }
         else
         {
            this.hideIcon();
         }
      }
      
      public function maximize(param1:Boolean = true, param2:Boolean = false) : void
      {
         addChildAt(this._rootContainer,0);
         if(param1)
         {
            this._featureWindowVO.maximized = true;
         }
         this._iconContainer.visible = true;
         this._icon.setWindowMode(true,this._openCloseAnimation);
         if(!this.maximized)
         {
            if(param2)
            {
               this._maximizeFunction(false,param1);
            }
            else
            {
               this._maximizeFunction(this._openCloseAnimation,param1);
            }
         }
         var _loc3_:SimpleWindow = this._guiManager.getWindow(GuiConstants.LOGOUT_WINDOW);
         if(Boolean(_loc3_) && _loc3_.maximized)
         {
            this._guiManager.cancelLogout();
         }
      }
      
      private function maximizeOnLayer1(param1:Boolean = true, param2:Boolean = true) : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         ScreenManager.getWindowLayer().addChild(this);
         this.maximizeBase(param1,param2);
      }
      
      private function maximizeOnLayer2(param1:Boolean = true, param2:Boolean = true) : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         this._guiManager.getMain().screenManager.getWindowLayer2().addChild(this);
         this.maximizeBase(param1,param2);
      }
      
      private function maximizeBase(param1:Boolean = true, param2:Boolean = true) : void
      {
         this._tweening = true;
         this._maximizeClicked = true;
         if(this._minimizable && !this.maximized)
         {
            this._guiManager.decreaseMinimizedWindowCount();
         }
         var _loc3_:PointLite = ScreenScaleUtils.getRealPosFromPercentagePos(ScreenManager.getInstance().stageSize,this._size,this._positionPercentage);
         if(param1)
         {
            TweenLite.to(this,0.5,{
               "ease":Expo.easeOut,
               "x":int(_loc3_.x),
               "y":int(_loc3_.y),
               "onComplete":this.onCompleteLastPosition,
               "onCompleteParams":[param1,param2]
            });
         }
         else
         {
            this.x = _loc3_.x;
            this.y = _loc3_.y;
            this.onCompleteLastPosition(param1);
         }
         if(this._overlay != null)
         {
            this._overlay.visible = true;
         }
      }
      
      private function onCompleteLastPosition(param1:Boolean = true, param2:Boolean = true) : void
      {
         this._rootContainer.visible = true;
         this._rootContainerMask.width = 0;
         this._rootContainerMask.height = WINDOW_TITLEBAR_HEIGHT;
         if(param1)
         {
            TweenLite.to(this._rootContainerMask,0.25,{
               "ease":Expo.easeOut,
               "width":this._window.width,
               "onComplete":this.onMaximizedVertical,
               "onCompleteParams":[param1]
            });
            TweenLite.to(this._rootContainer,0.25,{"alpha":1});
            TweenMax.delayedCall(0.25,this.onMaximized3,[param2]);
         }
         else
         {
            this._rootContainerMask.width = this._window.width;
            this.onMaximizedVertical(param1);
            this._rootContainer.alpha = 1;
            this.onMaximized3(param2);
         }
      }
      
      private function onMaximizedVertical(param1:Boolean = true) : void
      {
         if(param1)
         {
            TweenLite.to(this._rootContainerMask,0.25,{
               "ease":Expo.easeOut,
               "height":this._window.height
            });
         }
         else
         {
            this._rootContainerMask.height = this._window.height;
         }
      }
      
      private function onMaximized3(param1:Boolean = true) : void
      {
         if(!Settings.displayWindowsBackground.value && this._transparencySupport)
         {
            TweenLite.to(this._iconContainer,0.25,{"alpha":0});
            TweenLite.to(this._windowContainer,0.25,{"alpha":0});
            dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.BG_FADE_OUT));
         }
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_MAXIMIZED));
         this._tweening = false;
         this.checkAndSavePosition();
         if(param1)
         {
            this.saveWindowSetting();
         }
      }
      
      private function minimizeBtnRollOverHandler(param1:MouseEvent) : void
      {
         this.fadeInWindow();
      }
      
      public function get maximized() : Boolean
      {
         if(this._rootContainer.visible)
         {
            return true;
         }
         return false;
      }
      
      public function checkSize() : void
      {
         this._lastResizerPosition.x = this._resizerBtn.x;
         this._lastResizerPosition.y = this._resizerBtn.y;
      }
      
      public function setTitle(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:String = null;
         if(param2)
         {
            _loc3_ = BPLocale.getItem(param1);
         }
         else
         {
            _loc3_ = param1;
         }
         if(_loc3_ != null)
         {
            if(this._titleLabel)
            {
               this._titleLabel.text = _loc3_;
            }
            if(this._iconContainer != null)
            {
               TooltipControl.getInstance().addToolTip(this._iconContainer,_loc3_);
            }
         }
      }
      
      public function getTitle() : String
      {
         return this._titleLabel.text;
      }
      
      public function setIconTooltipText(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:String = null;
         if(param2)
         {
            _loc3_ = BPLocale.getItem(param1);
         }
         else
         {
            _loc3_ = param1;
         }
         if(_loc3_ != null)
         {
            if(this._iconContainer != null)
            {
               TooltipControl.getInstance().addToolTip(this._iconContainer,_loc3_);
            }
         }
      }
      
      private function saveWindowPosition() : void
      {
         this._guiManager.setCheckWindowPositions(false);
         if(!this._rootContainer.visible)
         {
            return;
         }
         this.checkAndSavePosition();
         this.saveWindowSetting(true);
      }
      
      public function lockWindow() : void
      {
         this._iconContainer.buttonMode = false;
      }
      
      public function isLocked() : Boolean
      {
         if(!this._iconContainer.buttonMode)
         {
            return true;
         }
         return false;
      }
      
      public function unlockWindow() : void
      {
         this._iconContainer.buttonMode = true;
      }
      
      public function isMaximizeClicked() : Boolean
      {
         return this._maximizeClicked;
      }
      
      public function activateModalLayer(param1:Boolean) : void
      {
         if(param1)
         {
            if(!this._modalLayer)
            {
               this._modalLayer = new Sprite();
               this._modalLayer.graphics.beginFill(4278190080);
               this._modalLayer.graphics.drawRect(0,0,ScreenManager.getScreenWidth(),ScreenManager.getScreenHeight());
               this._modalLayer.alpha = 0.5;
            }
            else if(this._modalLayer.parent)
            {
               this._modalLayer.parent.removeChild(this._modalLayer);
            }
            if(!this.maximized)
            {
               this.maximize(this._openCloseAnimation);
            }
            this._modalLayer.mouseEnabled = true;
            parent.addChild(this._modalLayer);
            parent.swapChildren(this,this._modalLayer);
         }
         else if(!param1 && this._modalLayer != null && Boolean(this._modalLayer.parent))
         {
            this._modalLayer.parent.removeChild(this._modalLayer);
            this._modalLayer = null;
         }
      }
      
      public function createFullDragger() : void
      {
         if(this._saveSettings && this.menuProxy.configMode && this.maximized)
         {
            if(this._fullDragger != null && this.contains(this._fullDragger))
            {
               this.removeFullDragger();
            }
            this._fullDragger = new Sprite();
            this._fullDragger.graphics.beginFill(16711680);
            this._fullDragger.graphics.drawRect(0,0,this._window.width,this._window.height);
            this._fullDragger.alpha = 0.3;
            this._fullDragger.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDraggerMouseDownEvent);
            this._fullDragger.buttonMode = true;
            this.addChild(this._fullDragger);
         }
      }
      
      public function removeFullDragger() : void
      {
         if(this._saveSettings && this._fullDragger != null && this.maximized && this.contains(this._fullDragger))
         {
            this._fullDragger.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleDraggerMouseDownEvent);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleDraggerMouseUpEvent);
            stage.removeEventListener(MouseEvent.ROLL_OUT,this.handleDraggerMouseUpEvent);
            this.removeChild(this._fullDragger);
         }
      }
      
      public function updateDraggerButtonMode() : void
      {
         if(this._dragger != null)
         {
            this._dragger.buttonMode = Settings.dragWindowsAlways;
         }
      }
      
      public function get isDragged() : Boolean
      {
         return this._isDragged;
      }
      
      public function get hasBlocker() : Boolean
      {
         return this._modalLayer != null;
      }
      
      public function updateDarkBgSize() : void
      {
         if(this.hasBlocker)
         {
            this._modalLayer.width = ScreenManager.getScreenWidth();
            this._modalLayer.height = ScreenManager.getScreenHeight();
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      private function handleWindowToFront(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = Sprite(this.parent);
         _loc2_.swapChildren(this,_loc2_.getChildAt(_loc2_.numChildren - 1));
      }
      
      public function addContainer(param1:SimpleContainer) : void
      {
         this._containers.push(param1);
         this._rootContainer.addChild(param1.containerView);
      }
      
      public function getWindow() : MovieClip
      {
         return this._window;
      }
      
      public function getRootContainer() : MovieClip
      {
         return this._rootContainer;
      }
      
      public function getUIContainer() : Sprite
      {
         if(this._uiContainer == null)
         {
            this._uiContainer = new Sprite();
            this._uiContainer.x = UICONTAINER_X;
            this._uiContainer.y = UICONTAINER_Y;
            this._rootContainer.addChild(this._uiContainer);
         }
         return this._uiContainer;
      }
      
      public function getContainer(param1:int) : SimpleContainer
      {
         var _loc3_:SimpleContainer = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._containers.length)
         {
            _loc3_ = this._containers[_loc2_];
            if(_loc3_.getClassID() == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeContainerByType(param1:int) : void
      {
         var _loc3_:SimpleContainer = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._containers.length)
         {
            _loc3_ = this._containers[_loc2_];
            if(_loc3_.getClassID() == param1)
            {
               _loc4_ = _loc3_.containerView.parent;
               if(_loc4_)
               {
                  _loc4_.removeChild(_loc3_.containerView);
               }
            }
            _loc2_++;
         }
      }
      
      public function removeAllElements() : void
      {
         var _loc1_:SimpleContainer = null;
         for each(_loc1_ in this._containers)
         {
            _loc1_.removeAllElements();
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this._setWidth(param1);
         this._setHeight(param2);
         this.updateElementPositionsAfterResize();
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.SIZE_CHANGED));
      }
      
      public function setWidth(param1:int, param2:Boolean = false) : void
      {
         this._setWidth(param1,param2);
         this.updateElementPositionsAfterResize();
      }
      
      protected function _setWidth(param1:int, param2:Boolean = false) : void
      {
         if(param1 == AUTOSIZE)
         {
            param1 = this.getAutoWidth();
         }
         this._resizerBtn.x = param1;
         this.saveResizerPosition();
         if(param2)
         {
            this._window.width = param1;
         }
         else
         {
            this._window.width = this._resizerBtn.x + this._resizerBtn.width;
         }
         this._rootContainerMask.width = this._window.width;
         if(this._windowMask != null)
         {
            this._windowMask.width = this._window.width - MASK_MARGIN_X;
         }
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.WIDTH_CHANGED));
      }
      
      public function setHeight(param1:int, param2:Boolean = false) : void
      {
         this._setHeight(param1,param2);
         this.updateElementPositionsAfterResize();
      }
      
      protected function _setHeight(param1:int, param2:Boolean = false) : void
      {
         if(param1 == AUTOSIZE)
         {
            param1 = this.getAutoHeight();
         }
         this._resizerBtn.y = param1;
         this.saveResizerPosition();
         if(param2)
         {
            this._window.height = param1;
         }
         else
         {
            this._window.height = this._resizerBtn.y + this._resizerBtn.height;
         }
         this._rootContainerMask.height = this._window.height;
         if(this._windowMask != null)
         {
            this._windowMask.height = this._window.height - MASK_MARGIN_Y;
         }
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.HEIGHT_CHANGED));
      }
      
      public function get size() : PointLite
      {
         if(this._resizable)
         {
            return this.resizeDimension;
         }
         return this._size;
      }
      
      override public function get width() : Number
      {
         return this._window.width;
      }
      
      override public function get height() : Number
      {
         return this._window.height;
      }
      
      private function get maxWindowWidth() : Number
      {
         return Math.min(this.screenManager.stageWidth - 100,MAX_WINDOW_WIDTH);
      }
      
      private function get maxWindowHeight() : Number
      {
         return Math.min(this.screenManager.stageHeight - 100,MAX_WINDOW_HEIGHT);
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
      }
      
      public function autoSize() : void
      {
         this.setWidth(AUTOSIZE);
         this.setHeight(AUTOSIZE);
      }
      
      private function getAutoHeight() : int
      {
         var _loc3_:SimpleContainer = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._containers.length)
         {
            _loc3_ = this._containers[_loc2_];
            if(_loc3_.height > _loc1_)
            {
               _loc1_ = _loc3_.height;
            }
            _loc2_++;
         }
         return int(_loc1_ + WINDOW_TITLEBAR_HEIGHT);
      }
      
      private function getAutoWidth() : int
      {
         var _loc3_:SimpleContainer = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._containers.length)
         {
            _loc3_ = this._containers[_loc2_];
            _loc1_ += _loc3_.width;
            _loc2_++;
         }
         return int(_loc1_ + 15);
      }
      
      public function refreshMask() : void
      {
         ++this._oldResizerX;
         this.updateElementPositionsAfterResize();
      }
      
      public function resizerMouseDownHandler(param1:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseStageUp);
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.RESIZE_START));
         this._guiManager.setCheckResizableWindows(true);
         if(this._resizeBounds != null)
         {
            this._resizerBtn.startDrag(false,this._resizeBounds);
         }
         else
         {
            this._resizerBtn.startDrag();
         }
         this.resizeTimer.start();
      }
      
      protected function get resizeTimer() : Timer
      {
         if(this._resizeTimer == null)
         {
            this._resizeTimer = new Timer(100);
            this._resizeTimer.addEventListener(TimerEvent.TIMER,this.handleResizeTimerEvent);
         }
         return this._resizeTimer;
      }
      
      protected function handleResizeTimerEvent(param1:TimerEvent) : void
      {
         this.updateElementPositionsAfterResize();
      }
      
      protected function updateElementPositionsAfterResize() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this._updateElementPositionsAfterResize);
      }
      
      protected function canResize() : Boolean
      {
         return this._resizable || this._expandable;
      }
      
      protected function resizeUI() : void
      {
         if(this._resizerBtn.x != this._oldResizerX || this._resizerBtn.y != this._oldResizerY)
         {
            this._resizerBtn.x = Math.max(this._resizerBtn.x,Math.max(150,this._titleLabel.x + this._titleLabel.width));
            if(this._resizerBtn.y < MIN_WINDOW_HEIGHT)
            {
               this._resizerBtn.y = MIN_WINDOW_HEIGHT;
            }
            if(this._resizerBtn.x > this.maxWindowWidth)
            {
               this._resizerBtn.x = this.maxWindowWidth;
            }
            if(this._resizerBtn.y > this.maxWindowHeight)
            {
               this._resizerBtn.y = this.maxWindowHeight;
            }
            this._window.width = this._resizerBtn.x + this._resizerBtn.width;
            this._window.height = this._resizerBtn.y + this._resizerBtn.height;
            if(this._windowMask != null)
            {
               this._windowMask.width = this._window.width - MASK_MARGIN_X;
               this._windowMask.height = this._window.height - MASK_MARGIN_Y;
               this._rootContainerMask.width = this._window.width;
               this._rootContainerMask.height = this._window.height;
            }
            if(this._inProgressOverLayer)
            {
               this._inProgressOverLayer.width = this._window.width;
               this._inProgressOverLayer.height = this._window.height;
            }
            dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_RESIZE));
         }
      }
      
      protected function _updateElementPositionsAfterResize(param1:Event = null) : void
      {
         removeEventListener(Event.ENTER_FRAME,this._updateElementPositionsAfterResize);
         if(this.canResize())
         {
            this.resizeUI();
         }
         this._oldResizerX = this._resizerBtn.x;
         this._oldResizerY = this._resizerBtn.y;
         if(this._draggable)
         {
            this._dragger.width = this._window.width;
         }
         if(this._closeable)
         {
            this._closeBtn.x = this._window.width - this._closeBtnInitDistance;
         }
         if(this._minimizable)
         {
            if(this._minimizeBtn)
            {
               this._minimizeBtn.x = this._window.width - MINIMIZE_BTN_OFFSET;
            }
            if(this._helpBtn)
            {
               this._helpBtn.x = this._window.width - HELP_BTN_OFFSET;
            }
         }
      }
      
      public function get resizeDimension() : PointLite
      {
         return new PointLite(this._resizerBtn.x,this._resizerBtn.y);
      }
      
      private function saveResizerPosition() : void
      {
         if(this._resizable)
         {
            this._lastResizerPosition.x = this._resizerBtn.x;
            this._lastResizerPosition.y = this._resizerBtn.y;
         }
      }
      
      public function get resizerBtn() : MovieClip
      {
         return this._resizerBtn;
      }
      
      public function shopPopup(param1:String, param2:String, param3:Vector.<PopupOptionVO>) : void
      {
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.SHOW_POPUP,false,true));
         this._internalPopup.show(param1,param2,param3,this._window.width,this._window.height);
      }
      
      private function get menuProxy() : ItemsControlMenuProxy
      {
         return GameFacade.getInstance().retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
      
      public function get position() : PointLite
      {
         return new PointLite(x,y);
      }
      
      public function set position(param1:PointLite) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      protected function getStateBtnByViewName(param1:String) : StatesButtonDecorator
      {
         var _loc2_:DisplayObjectContainer = this._windowContainer.getChildByName(param1) as DisplayObjectContainer;
         var _loc3_:StatesButtonDecorator = new StatesButtonDecorator(_loc2_);
         this._windowContainer.addChild(_loc3_);
         return _loc3_;
      }
      
      private function get screenManager() : ScreenManager
      {
         return ScreenManager.getInstance();
      }
      
      private function setOnOpenStrategy(param1:Boolean) : void
      {
         this._maximizeFunction = param1 ? this.maximizeOnLayer2 : this.maximizeOnLayer1;
      }
      
      public function flashWindowIcon(param1:int = -1, param2:Boolean = false) : void
      {
         this._flashWindowCount = param1;
      }
      
      public function checkAndSavePosition() : void
      {
         var _loc1_:PointLite = null;
         if(stage)
         {
            _loc1_ = ScreenScaleUtils.correctOutsideViewportPosition(new Rectangle(this.x,this.y,this.width,this.height),new PointLite(this.screenManager.stageWidth,this.screenManager.stageHeight),false);
            this.x = _loc1_.x;
            this.y = _loc1_.y;
         }
      }
      
      public function initIcon(param1:String, param2:SWFFinisher = null, param3:BitmapAtlas = null) : void
      {
         var _loc4_:BitmapData = param3.getBitmapDataByName(this.id + GuiConstants.NORMAL_SUFFIX);
         var _loc5_:BitmapData = param3.getBitmapDataByName(this.id + GuiConstants.HOVER_SUFFIX);
         if(Boolean(_loc4_) && Boolean(_loc5_))
         {
            if(this._minimizable || this._closeable)
            {
               this._iconContainer.addEventListener(MouseEvent.CLICK,this.toggleVisibility);
               this._iconContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.handleIconMouseDownEvent);
               this._iconContainer.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverMinimizeIcon);
               this._iconContainer.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutMinimizeIcon);
               this._iconContainer.buttonMode = true;
               if(!Settings.displayWindowsBackground.value && this._transparencySupport)
               {
                  this._iconContainer.alpha = 0;
               }
            }
         }
         this._icon = new SimpleWindowIcon(param2,_loc4_,_loc5_,this._minimizable);
         this._iconContainer.addChild(this._icon);
      }
      
      private function hideIcon() : void
      {
         this._iconContainer.visible = false;
      }
      
      public function showInProgressOverlay() : void
      {
         if(this._inProgressOverLayer)
         {
            this._inProgressOverLayer.width = this._window.width;
            this._inProgressOverLayer.height = this._window.height;
            this._inProgressOverLayer.show();
         }
      }
      
      public function hideInProgressOverlay() : void
      {
         if(this._inProgressOverLayer)
         {
            this._inProgressOverLayer.hide();
         }
      }
      
      public function removeInprogressOverLay() : void
      {
         if(this._inProgressOverLayer)
         {
            this._inProgressOverLayer.dispose();
         }
      }
      
      public function addLockOverlay(param1:int, param2:int, param3:int, param4:int, param5:uint = 4473924, param6:Number = 0.7) : void
      {
         this._iconContainer.buttonMode = true;
         if(this._overlay == null)
         {
            this._overlay = new Sprite();
            this._overlay.graphics.beginFill(param5,param6);
            this._overlay.graphics.drawRect(param1,param2 + param4 * 0.65,param3,param4 * 0.35);
            this._overlay.graphics.endFill();
            this._overlay.buttonMode = true;
            this._overlay.useHandCursor = true;
            this._rootContainer.addChild(this._overlay);
         }
      }
      
      public function removeLockOverlay() : void
      {
         if(this._overlay != null)
         {
            this._rootContainer.removeChild(this._overlay);
            this._overlay = null;
         }
         this.unlockWindow();
      }
      
      public function saveWindowSetting(param1:Boolean = false) : void
      {
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.SAVE_WINDOW_SETTINGS,param1));
      }
      
      private function handleHelpBtn(param1:MouseEvent) : void
      {
         dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.OPEN_HINT));
      }
      
      public function isTweening() : Boolean
      {
         return this._tweening;
      }
      
      public function isResizable() : Boolean
      {
         return this._resizable;
      }
      
      public function hasTransparencySupport() : Boolean
      {
         return this._transparencySupport;
      }
      
      public function get internalPopupContainer() : Sprite
      {
         return this._internalPopupContainer;
      }
   }
}

