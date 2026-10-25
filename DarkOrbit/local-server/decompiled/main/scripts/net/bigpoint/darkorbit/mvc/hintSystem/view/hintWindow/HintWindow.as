package net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quart;
   import com.greensock.easing.Sine;
   import flash.display.Bitmap;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.image.ImageSlideShow;
   import net.bigpoint.darkorbit.fui.components.image.ImageSlideShowElement;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.GhostTyperEffect;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class HintWindow extends Sprite
   {
      
      public static const EVENT_CLOSE_WINDOW_ANIMATION_FINISHED:String = "closeAnimationFinished";
      
      public static const EVENT_FADE_TO_EXTENDEDVIEW_FINISHED:String = "fadeToExtendedViewFinished";
      
      public static const EVENT_OPEN_URL:String = "openURL";
      
      public static const EVENT_CLOSE:String = "closeButtonClicked";
      
      public static const EVENT_CONFIRMATION01_CLICKED:String = "confirmation01Clicked";
      
      public static const EVENT_CONFIRMATION02_CLICKED:String = "confirmation02Clicked";
      
      private static const X_ICON_OFFSET_WINDOW_MODIFICATION:int = 6;
      
      private static const Y_ICON_OFFSET_WINDOW_MODIFICATION:int = 6;
      
      private static const NOTIFICATIONBAR_VIEW_Y_SHOW:Number = 54;
      
      private static const NOTIFICATIONBAR_VIEW_Y_START:Number = 74;
      
      private static const EXTENDED_VIEW_Y:Number = 8;
      
      private static const EXTENDED_VIEW_WIDTH:Number = 621 - 29;
      
      private static const NOTIFICATIONBAR_VIEW_HEIGHT:Number = 34;
      
      private static const EXTENDED_VIEW_HEIGHT:Number = 479;
      
      private var _hintDialogView:Coreponent;
      
      private var _title:String;
      
      private var _currentViewState:uint;
      
      private var notificationbar:Container;
      
      private var notificationbarBackground:Coreponent;
      
      private var notificationbarIcon:Coreponent;
      
      private var notificationbarIconBackground:Coreponent;
      
      private var notificationbarLabel:Label;
      
      private var notificationbarCloseButton:Button;
      
      private var notificationbarBorderTR:Coreponent;
      
      private var notificationbarBorderBR:Coreponent;
      
      private var notificationbarDisplayTime:Number = 12;
      
      private var ghostTextTyperEffect:GhostTyperEffect;
      
      private var _notificationbarLabel_XStart:Number;
      
      private var _notificationbarLabel_XEnd:Number;
      
      private var window:Coreponent;
      
      private var windowBackground:Coreponent;
      
      private var windowIconBackground:Coreponent;
      
      private var closeButton:Button;
      
      private var contentContainer:Sprite;
      
      private var characterContainer:Coreponent;
      
      private var characterBackgroundContainer:Coreponent;
      
      private var character:Bitmap;
      
      private var characterBgnd:Bitmap;
      
      private var textboxContainer:Container;
      
      private var scrollContainer:ScrollContainer;
      
      private var messageHeaderLabel:Label;
      
      private var messageLabel:Label;
      
      private var windowHeaderLabel:Label;
      
      private var windowHeaderBackground:Coreponent;
      
      private var scrollbar:Scrollbar;
      
      private var slider:Button;
      
      private var imageSlideShow:ImageSlideShow;
      
      private var confirmationButton01:Button;
      
      private var confirmationButton02:Button;
      
      private var _windowHeaderLabel_XStart:Number;
      
      private var _windowHeaderLabel_XEnd:Number;
      
      private var tOutNotificationbar:Number = 0.3;
      
      private var tInExtendedView:Number = 0.3;
      
      public function HintWindow()
      {
         super();
      }
      
      public function build(param1:XML) : void
      {
         UISystem.getInstance().build(param1,this);
         this._hintDialogView = this.getChildByName("hintDialogView") as Coreponent;
         this._hintDialogView.mouseEnabled = false;
         this.mouseEnabled = false;
         this.initMinibarView();
         this.initExtendedView();
      }
      
      override public function get width() : Number
      {
         return this._hintDialogView.width;
      }
      
      override public function get height() : Number
      {
         return this._hintDialogView.height;
      }
      
      private function initMinibarView() : void
      {
         this.notificationbar = this._hintDialogView.getChildByName("minibar") as Container;
         this.notificationbarBackground = this.notificationbar.getChildByName("background") as Coreponent;
         this.notificationbarLabel = this.notificationbar.getChildByName("infoLabel") as Label;
         this.notificationbarLabel.mouseChildren = false;
         this.notificationbarLabel.mouseEnabled = false;
         this.notificationbarLabel.useHTML = HintSystemConstants.USE_HTML_FOR_THE_GHOSTTYPER_EFFECT;
         this.ghostTextTyperEffect = new GhostTyperEffect();
         this.notificationbarIcon = this.notificationbar.getChildByName("infoIcon") as Coreponent;
         this.notificationbarIconBackground = this.notificationbar.getChildByName("infoIconbackground") as Coreponent;
         this.notificationbarCloseButton = this.notificationbar.getChildByName("closeButton") as Button;
         this.notificationbarCloseButton.addEventListener(MouseEvent.CLICK,this.handleNotificationbarCloseButtonClickEvent);
         this.notificationbarCloseButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleNotificationbarRolloverButtonClickEvent);
         this.notificationbarCloseButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleNotificationbarRolloutButtonClickEvent);
         this.addMouseEventListeners();
         this.notificationbar.buttonMode = true;
         this.notificationbarBorderTR = this.notificationbar.getChildByName("borderTR") as Coreponent;
         this.notificationbarBorderBR = this.notificationbar.getChildByName("borderBR") as Coreponent;
         this._notificationbarLabel_XStart = this.notificationbarLabel.marginLeft + 10;
         this._notificationbarLabel_XEnd = this.notificationbarLabel.marginLeft;
      }
      
      private function addMouseEventListeners() : void
      {
         this.notificationbar.addEventListener(MouseEvent.CLICK,this.handleNotificationbarClickEvent);
         this.notificationbar.addEventListener(MouseEvent.MOUSE_OUT,this.handleNotificationbarMouseOutEvent);
         this.notificationbar.addEventListener(MouseEvent.MOUSE_OVER,this.handleNotificationbarMouseOverEvent);
      }
      
      private function removeMouseEventListeners() : void
      {
         this.notificationbar.removeEventListener(MouseEvent.CLICK,this.handleNotificationbarClickEvent);
         this.notificationbar.removeEventListener(MouseEvent.MOUSE_OUT,this.handleNotificationbarMouseOutEvent);
         this.notificationbar.removeEventListener(MouseEvent.MOUSE_OVER,this.handleNotificationbarMouseOverEvent);
      }
      
      private function handleNotificationbarClickEvent(param1:MouseEvent) : void
      {
         this.setActivation(this.notificationbar,false);
         this.fadeMinibarToExtendedView();
      }
      
      private function handleNotificationbarMouseOutEvent(param1:MouseEvent) : void
      {
         TweenMax.to(this.notificationbar,0.3,{"colorMatrixFilter":{
            "amount":1,
            "contrast":1,
            "brightness":1,
            "saturation":1
         }});
      }
      
      private function handleNotificationbarMouseOverEvent(param1:MouseEvent) : void
      {
         TweenMax.to(this.notificationbar,0.3,{"colorMatrixFilter":{
            "amount":1.7,
            "contrast":1.8,
            "brightness":1.5,
            "saturation":1.5
         }});
      }
      
      private function handleNotificationbarCloseButtonClickEvent(param1:MouseEvent) : void
      {
         this.hideNotificationBar();
      }
      
      private function handleNotificationbarRolloverButtonClickEvent(param1:MouseEvent) : void
      {
         this.removeMouseEventListeners();
      }
      
      private function handleNotificationbarRolloutButtonClickEvent(param1:MouseEvent) : void
      {
         this.addMouseEventListeners();
      }
      
      private function initExtendedView() : void
      {
         this.window = this._hintDialogView.getChildByName("hintWindow") as Coreponent;
         this.window.alpha = 0;
         this.windowIconBackground = this.window.getChildByName("iconBackground") as Coreponent;
         this.windowBackground = this.window.getChildByName("windowContainer") as Coreponent;
         this.closeButton = this.window.getChildByName("closeButton") as Button;
         if(this.closeButton)
         {
            this.closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseButtonClicked);
         }
         this.contentContainer = this.window.getChildByName("contentContainer") as Sprite;
         var _loc1_:Sprite = this.contentContainer.getChildByName("confirmationContainer") as Sprite;
         this.confirmationButton01 = _loc1_.getChildByName("confirmationButton01") as Button;
         this.confirmationButton02 = _loc1_.getChildByName("confirmationButton02") as Button;
         if(this.confirmationButton01)
         {
            this.confirmationButton01.addEventListener(MouseEvent.CLICK,this.handleConfirmationButton01Clicked);
         }
         if(this.confirmationButton02)
         {
            this.confirmationButton02.addEventListener(MouseEvent.CLICK,this.handleConfirmationButton02Clicked);
         }
         var _loc2_:Coreponent = this.contentContainer.getChildByName("messageContainer") as Coreponent;
         this.characterContainer = _loc2_.getChildByName("characterContainer") as Coreponent;
         this.characterBackgroundContainer = _loc2_.getChildByName("characterBackground") as Coreponent;
         this.textboxContainer = _loc2_.getChildByName("textBoxContainer") as Container;
         this.messageHeaderLabel = this.textboxContainer.getChildByName("header") as Label;
         this.scrollContainer = this.textboxContainer.getChildByName("scrollContainer") as ScrollContainer;
         this.scrollbar = this.textboxContainer.getChildByName("scrollbar") as Scrollbar;
         this.slider = this.scrollbar.getChildByName("buttonSlider") as Button;
         this.messageLabel = this.scrollContainer.content as Label;
         this.messageLabel.useHTML = HintSystemConstants.USE_HTML_FOR_MESSAGE_LABEL;
         this.windowHeaderLabel = this.window.getChildByName("windowHeaderLabel") as Label;
         this.windowHeaderLabel.useHTML = HintSystemConstants.USE_HTML_FOR_THE_GHOSTTYPER_EFFECT;
         this._windowHeaderLabel_XStart = this.windowHeaderLabel.marginLeft + 10;
         this._windowHeaderLabel_XEnd = this.windowHeaderLabel.marginLeft;
         this.windowHeaderBackground = this.window.getChildByName("windowHeaderBackground") as Coreponent;
         this.scrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollbarPositionChangeEvent);
         this.scrollContainer.addEventListener(ScrollEvent.SCROLLCONTAINER_VERTICAL_SIZE_CHANGED,this.handleVerticalScrollcontainerSizeChangeEvent);
         this.scrollContainer.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollContainerMouseWheelEvent);
         this.scrollContainer.mouseEnabled = true;
         var _loc3_:Container = this.contentContainer.getChildByName("slideShowContainer") as Container;
         if(_loc3_)
         {
            _loc3_.mouseEnabled = false;
            _loc3_.mouseChildren = false;
            this.imageSlideShow = _loc3_.getChildByName("imageSlideShow") as ImageSlideShow;
         }
      }
      
      private function handleConfirmationButton01Clicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(HintWindow.EVENT_CONFIRMATION01_CLICKED));
      }
      
      private function handleConfirmationButton02Clicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(HintWindow.EVENT_CONFIRMATION02_CLICKED));
      }
      
      protected function handleScrollbarPositionChangeEvent(param1:ScrollEvent) : void
      {
         var _loc2_:Number = this.scrollbar.getScrollPositionInPercent();
         this.scrollContainer.setScrollPositionInPercent(_loc2_);
      }
      
      protected function handleVerticalScrollcontainerSizeChangeEvent(param1:ScrollEvent) : void
      {
         this.scrollbar.updateBySizes(param1.viewSize,param1.contentSize);
      }
      
      private function handleScrollContainerMouseWheelEvent(param1:MouseEvent) : void
      {
         this.scrollbar.updateScrollPositionByScrollDelta(param1.delta);
      }
      
      protected function handleCloseButtonClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(EVENT_CLOSE));
      }
      
      protected function handleOpenURLButtononClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(EVENT_OPEN_URL));
      }
      
      public function cleanUp() : void
      {
         if(this.imageSlideShow)
         {
            this.imageSlideShow.dispose();
         }
         this.stopCommanderBackgroundAnimation();
      }
      
      protected function fadeMinibarToExtendedView() : void
      {
         this.setActivation(this.notificationbar,false);
         TweenLite.killDelayedCallsTo(this.hideNotificationBar);
         this.window.height = NOTIFICATIONBAR_VIEW_HEIGHT;
         this.window.alpha = 0;
         this.windowHeaderBackground.alpha = 0;
         TweenLite.to(this.notificationbar,this.tInExtendedView + 0.1,{
            "width":EXTENDED_VIEW_WIDTH,
            "height":NOTIFICATIONBAR_VIEW_HEIGHT,
            "marginTop":EXTENDED_VIEW_Y,
            "ease":Sine.easeInOut,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.notificationbar,false],
            "onComplete":this.fadeToExtendedWindowState
         });
         TweenLite.to(this.notificationbarIcon,this.tInExtendedView,{
            "x":-7,
            "y":-2,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.notificationbarLabel,false]
         });
         TweenLite.to(this.notificationbarLabel,this.tInExtendedView,{
            "alpha":0,
            "marginLeft":52,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.notificationbarLabel,false]
         });
         TweenLite.to(this.notificationbarBorderTR,this.tInExtendedView,{
            "alpha":0,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.notificationbarBorderTR,false]
         });
         TweenLite.to(this.notificationbarBorderBR,this.tInExtendedView,{
            "alpha":0,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.notificationbarBorderBR,false]
         });
         TweenLite.to(this.notificationbarCloseButton,this.tInExtendedView,{
            "alpha":0,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.notificationbarCloseButton,false]
         });
      }
      
      protected function handlefadeMinibarToExtendedViewComplete() : void
      {
         TweenLite.killTweensOf(this.notificationbarLabel);
         this.fadeToExtendedWindowState();
      }
      
      protected function fadeToExtendedWindowState() : void
      {
         var _loc1_:Number = this.tOutNotificationbar * 0.15;
         TweenLite.to(this.notificationbarIcon,this.tOutNotificationbar,{"alpha":0});
         TweenLite.to(this.notificationbar,this.tOutNotificationbar,{"autoAlpha":0});
         this.windowBackground.alpha = 0;
         this.window.alpha = 0.3;
         this.contentContainer.alpha = 0;
         TweenLite.to(this.windowBackground,this.tOutNotificationbar,{
            "alpha":1,
            "delay":_loc1_
         });
         TweenLite.to(this.windowHeaderBackground,this.tOutNotificationbar,{"alpha":1});
         TweenLite.to(this.window,this.tOutNotificationbar + 0.1,{
            "alpha":1,
            "height":EXTENDED_VIEW_HEIGHT,
            "ease":Sine.easeInOut,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.window,true],
            "onComplete":this.handlefadeToExtendedWindowStateComplete
         });
      }
      
      protected function handlefadeToExtendedWindowStateComplete() : void
      {
         dispatchEvent(new Event(EVENT_FADE_TO_EXTENDEDVIEW_FINISHED));
         TweenLite.to(this.contentContainer,this.tOutNotificationbar,{"alpha":1});
         this.showExtended();
      }
      
      private function forceRedrawPosition(param1:Coreponent, param2:Boolean) : void
      {
         param1.forceRedraws([InvalidationType.POSITION,InvalidationType.SIZE],param2);
      }
      
      protected function setActivation(param1:Sprite, param2:Boolean) : void
      {
         param1.mouseEnabled = param2;
         param1.mouseChildren = param2;
      }
      
      public function show(param1:uint) : void
      {
         this.notificationbar.alpha = 0;
         this.setActivation(this.notificationbar,false);
         this.window.alpha = 0;
         this.setActivation(this.window,false);
         switch(param1)
         {
            case HintWindowAddComand.HINTWINDOWVISIBILITY_NOTIFICATION_BAR:
               this.showNotificationBar();
               break;
            case HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN:
               this.showExtended();
         }
      }
      
      public function showExtended() : void
      {
         this._currentViewState = HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN;
         this.setActivation(this.notificationbar,false);
         this.setActivation(this.window,true);
         this.window.visible = true;
         TweenLite.to(this.window,0.4,{"alpha":1});
      }
      
      public function showNotificationBar() : void
      {
         this._currentViewState = HintWindowAddComand.HINTWINDOWVISIBILITY_NOTIFICATION_BAR;
         TweenLite.killDelayedCallsTo(this.hideNotificationBar);
         TweenLite.delayedCall(this.notificationbarDisplayTime,this.hideNotificationBar);
         this.setActivation(this.notificationbar,true);
         this.setActivation(this.window,false);
         this.notificationbar.visible = true;
         this.notificationbar.marginTop = NOTIFICATIONBAR_VIEW_Y_START;
         TweenLite.to(this.notificationbar,0.5,{
            "alpha":1,
            "marginTop":NOTIFICATIONBAR_VIEW_Y_SHOW
         });
         TweenMax.to(this.notificationbarLabel,1,{
            "repeat":-1,
            "yoyo":true,
            "glowFilter":{
               "color":15459009,
               "alpha":1,
               "blurX":20,
               "blurY":20
            }
         });
      }
      
      protected function hideNotificationBar() : void
      {
         TweenLite.killDelayedCallsTo(this.hideNotificationBar);
         this.setActivation(this.notificationbar,false);
         this.setActivation(this.window,false);
         dispatchEvent(new Event(EVENT_CLOSE));
      }
      
      public function update(param1:IHintSystemContentDescription, param2:Boolean = true) : void
      {
         var _loc3_:HintSystemContentVO = param1.content;
         this._title = _loc3_.title;
         this.messageHeaderLabel.text = _loc3_.title;
         var _loc4_:String = HtmlTextUtils.replaceFontTagsInLocalisedTextWithSpanTags(_loc3_.message,HintSystemConstants.TEMPORARY_HTML_TAG_SOLUTION);
         this.messageLabel.text = _loc4_;
         if(param2)
         {
            this.startGhostTyperTipTextEffect();
         }
      }
      
      public function setCharacter(param1:Bitmap) : void
      {
         if(this.characterContainer == null)
         {
            return;
         }
         if(this.character)
         {
            this.characterContainer.removeChild(this.character);
         }
         this.character = param1;
         this.characterContainer.addChild(this.character);
      }
      
      public function setCharacterBackground(param1:Bitmap) : void
      {
         if(this.characterBackgroundContainer == null)
         {
            return;
         }
         if(this.characterBgnd)
         {
            this.stopCommanderBackgroundAnimation();
            this.characterBackgroundContainer.removeChild(this.characterBgnd);
         }
         this.characterBgnd = param1;
         this.characterBgnd.scaleX = 0.99;
         this.characterBgnd.smoothing = true;
         this.characterBgnd.pixelSnapping = PixelSnapping.NEVER;
         this.characterBackgroundContainer.addChild(this.characterBgnd);
         this.startCommanderBackgroundAnimation();
      }
      
      public function setPlaylist(param1:Vector.<ImageSlideShowElement>, param2:Boolean = true, param3:Boolean = true) : void
      {
         this.imageSlideShow.playlist = param1;
         this.imageSlideShow.repeat = param2;
         if(param3)
         {
            this.imageSlideShow.start();
         }
      }
      
      protected function startCommanderBackgroundAnimation() : void
      {
         var _loc1_:Number = this.characterBgnd.width - this.characterBackgroundContainer.width;
         this.characterBgnd.x = 0;
         TweenMax.to(this.characterBgnd,24,{
            "x":-_loc1_,
            "yoyo":true,
            "repeat":-1,
            "ease":Sine.easeInOut
         });
         var _loc2_:Number = this.characterBgnd.height - this.characterBackgroundContainer.height;
         this.characterBgnd.y = 0;
         TweenMax.to(this.characterBgnd,24,{
            "y":-_loc2_,
            "yoyo":true,
            "repeat":-1,
            "ease":Sine.easeInOut
         });
      }
      
      protected function stopCommanderBackgroundAnimation() : void
      {
         TweenLite.killTweensOf(this.characterBgnd);
      }
      
      protected function handleShowTipGhostTyperEffectFinished() : void
      {
         TweenLite.killDelayedCallsTo(this.startGhostTyperTitleTextEffect);
         TweenLite.delayedCall(1.5,this.startGhostTyperTitleTextEffect);
      }
      
      protected function startGhostTyperTipTextEffect() : void
      {
         var _loc1_:String = BPLocale.getItem("gameentry_hintwindow_tip");
         this.notificationbarLabel.text = "";
         this.windowHeaderLabel.text = "";
         this.ghostTextTyperEffect.updateInterval = 50;
         this.ghostTextTyperEffect.stop();
         this.ghostTextTyperEffect.text = _loc1_;
         this.ghostTextTyperEffect.htmlColor = "#" + HintSystemConstants.TITLE_COLOR.toString(16);
         this.ghostTextTyperEffect.htmlColorRandom = "#" + HintSystemConstants.TITLE_COLOR_BRIGHTER.toString(16);
         this.ghostTextTyperEffect.useHtml = HintSystemConstants.USE_HTML_FOR_THE_GHOSTTYPER_EFFECT;
         this.ghostTextTyperEffect.updateTargets = [{
            "target":this.notificationbarLabel,
            "property":"text"
         },{
            "target":this.windowHeaderLabel,
            "property":"text"
         }];
         this.ghostTextTyperEffect.start();
         this.ghostTextTyperEffect.start(this.handleShowTipGhostTyperEffectFinished);
      }
      
      protected function startGhostTyperTitleTextEffect() : void
      {
         this.notificationbarLabel.text = "";
         this.windowHeaderLabel.text = "";
         this.ghostTextTyperEffect.text = this._title;
         this.ghostTextTyperEffect.start();
      }
      
      protected function getTitleIconPosition() : Point
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         switch(this._currentViewState)
         {
            case HintWindowAddComand.HINTWINDOWVISIBILITY_NOTIFICATION_BAR:
               _loc1_ = this.notificationbar.getExplicitX();
               _loc2_ = this.notificationbar.getExplicitY();
               break;
            case HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN:
               _loc1_ = this.window.getExplicitX() + this.windowIconBackground.getExplicitX();
               _loc2_ = this.window.getExplicitY() + this.windowIconBackground.getExplicitY();
         }
         return new Point(_loc1_,_loc2_);
      }
      
      protected function dispose() : void
      {
         dispatchEvent(new Event(HintWindow.EVENT_CLOSE_WINDOW_ANIMATION_FINISHED));
         this.ghostTextTyperEffect.dispose();
         this._hintDialogView.dispose();
      }
      
      public function startCloseAnimation(param1:Point) : void
      {
         switch(this._currentViewState)
         {
            case HintWindowAddComand.HINTWINDOWVISIBILITY_NOTIFICATION_BAR:
               this.startNotificationCloseAnimation(param1);
               break;
            case HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN:
               this.startWindowCloseAnimation(param1);
         }
      }
      
      protected function startNotificationCloseAnimation(param1:Point) : void
      {
         var _loc2_:int = -20;
         TweenLite.to(this.notificationbarLabel,0.4,{
            "autoAlpha":0,
            "y":_loc2_
         });
         TweenLite.to(this.notificationbarBackground,0.4,{
            "autoAlpha":0,
            "y":_loc2_
         });
         TweenLite.to(this.notificationbarCloseButton,0.4,{
            "autoAlpha":0,
            "y":_loc2_
         });
         TweenLite.to(this.notificationbarIconBackground,0.4,{
            "autoAlpha":0,
            "y":_loc2_,
            "onComplete":this.startWindowTitleIconAnimation,
            "onCompleteParams":[param1,-8,-6]
         });
         TweenLite.to(this.notificationbarBorderTR,0.4,{
            "alpha":0,
            "x":this.notificationbarBorderTR.x + 12,
            "y":this.notificationbarBorderTR.y - 12,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.notificationbarBorderTR,false]
         });
         TweenLite.to(this.notificationbarBorderBR,0.4,{
            "alpha":0,
            "x":this.notificationbarBorderTR.x + 12,
            "y":this.notificationbarBorderTR.y + 12,
            "onUpdate":this.forceRedrawPosition,
            "onUpdateParams":[this.notificationbarBorderBR,false]
         });
      }
      
      protected function startWindowCloseAnimation(param1:Point) : void
      {
         var _loc2_:Number = 0.25;
         TweenLite.to(this.contentContainer,_loc2_,{
            "autoAlpha":0,
            "onComplete":this.startWindowTitleIconAnimation,
            "onCompleteParams":[param1,X_ICON_OFFSET_WINDOW_MODIFICATION,Y_ICON_OFFSET_WINDOW_MODIFICATION]
         });
         TweenLite.to(this.closeButton,_loc2_,{"autoAlpha":0});
         TweenLite.to(this.windowHeaderBackground,_loc2_,{"autoAlpha":0});
         TweenLite.to(this.windowBackground,_loc2_,{"autoAlpha":0});
         TweenLite.to(this.windowHeaderLabel,_loc2_,{"autoAlpha":0});
      }
      
      protected function startWindowTitleIconAnimation(param1:Point, param2:Number = 0, param3:Number = 0) : void
      {
         var _loc4_:Point = this.getTitleIconPosition();
         _loc4_.x += param2;
         _loc4_.y += param3;
         var _loc5_:int = int(param1.x - _loc4_.x);
         var _loc6_:int = int(param1.y - _loc4_.y);
         var _loc7_:Number = 0.5;
         var _loc8_:Number = 0.2;
         TweenLite.to(this,_loc7_,{
            "x":_loc5_,
            "y":_loc6_,
            "delay":_loc8_,
            "onComplete":this.dispose,
            "ease":Quart.easeIn
         });
         TweenLite.to(this.windowIconBackground,_loc7_ - 0.05,{
            "autoAlpha":0,
            "delay":_loc8_
         });
      }
   }
}

