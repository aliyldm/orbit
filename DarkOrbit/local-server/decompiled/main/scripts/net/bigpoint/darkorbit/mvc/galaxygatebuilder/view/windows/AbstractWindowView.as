package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.AntiAliasType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flashx.textLayout.formats.TextAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.utils.AlignmentUtils;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.GalaxyGateBuilderDecorator;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   
   public class AbstractWindowView extends CompositeView
   {
      
      protected static const LIB_NAME:String = "common";
      
      protected static const EXPORT_WINDOW_BACKGROUND:String = "win_background";
      
      protected static const EXPORT_CLOSE_BUTTON:String = "popup_close_btn";
      
      protected var CONTENT_CONTAINER_X:uint = 36;
      
      protected var CONTENT_CONTAINER_Y:uint = 50;
      
      protected var CONTENT_CONTAINER_WIDTH:uint = 320;
      
      protected var CONTENT_CONTAINER_HEIGHT:uint = 210;
      
      protected var CONTENT_TEXT_AREA_WIDTH:uint = 502;
      
      protected var VERSION_LABEL_X:uint = 36;
      
      protected var VERSION_LABEL_Y:uint = 272;
      
      protected var VERSION_LABEL_COLOR:uint = 6317419;
      
      protected var CLOSE_BUTTON_STATE_NORMAL:String = "std";
      
      protected var CLOSE_BUTTON_STATE_OVER:String = "hover";
      
      protected var commonLib:SWFFinisher;
      
      protected var lightboxBackground:Sprite;
      
      protected var win:MovieClip;
      
      protected var contentContainer:Sprite;
      
      protected var contentTextArea:TextField;
      
      protected var versionLabel:TextField;
      
      protected var closeBtn:MovieClip;
      
      protected var shadowFilter:DropShadowFilter;
      
      public function AbstractWindowView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      protected function initialize() : void
      {
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         this.commonLib = SWFFinisher(_loc1_.getLib(LIB_NAME));
         this.initShadowEffect();
         this.initLightboxbackground();
      }
      
      protected function initShadowEffect() : void
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.angle = 90;
         _loc1_.alpha = 1;
         _loc1_.distance = 18;
         _loc1_.color = 0;
         _loc1_.blurX = 13;
         _loc1_.blurY = 13;
         _loc1_.strength = 1;
         _loc1_.quality = 3;
         this.shadowFilter = _loc1_;
      }
      
      protected function initLightboxbackground() : void
      {
         this.lightboxBackground = new Sprite();
         this.lightboxBackground.addChild(new Bitmap(new BitmapData(GalaxyGateBuilderDecorator.STAGE_WIDTH,GalaxyGateBuilderDecorator.STAGE_HEIGHT,true,2281701376)));
         addChild(this.lightboxBackground);
      }
      
      protected function initContentContainer() : void
      {
         this.createContentContainer();
         this.setContentContainerPosition();
      }
      
      protected function createContentContainer() : void
      {
         this.contentContainer = new Sprite();
         this.win.addChild(this.contentContainer);
      }
      
      protected function setContentContainerPosition() : void
      {
         this.contentContainer.x = this.CONTENT_CONTAINER_X;
         this.contentContainer.y = this.CONTENT_CONTAINER_Y;
      }
      
      protected function initCloseButton() : void
      {
         this.closeBtn = this.commonLib.getEmbeddedMovieClip(EXPORT_CLOSE_BUTTON);
         this.win.addChild(this.closeBtn);
         this.closeBtn.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.closeBtn.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
         this.closeBtn.buttonMode = true;
         this.closeBtn.gotoAndStop(this.CLOSE_BUTTON_STATE_NORMAL);
         AlignmentUtils.align(this.closeBtn,AlignmentUtils.TOP | AlignmentUtils.RIGHT,14,10);
      }
      
      protected function initVersionline() : void
      {
         var _loc1_:TextFormat = null;
         _loc1_ = Styles.ggBuilderPlainStdFmt;
         _loc1_.align = TextFormatAlign.LEFT;
         this.versionLabel = new TextField();
         this.versionLabel.defaultTextFormat = _loc1_;
         this.versionLabel.embedFonts = Styles.ggBuilderPlainStdEmbed;
         this.versionLabel.height = Styles.ggBuilderPlainStdFontHeight + 4;
         this.versionLabel.text = Main.VERSION;
         this.versionLabel.autoSize = TextFieldAutoSize.LEFT;
         this.versionLabel.textColor = this.VERSION_LABEL_COLOR;
         this.versionLabel.x = this.VERSION_LABEL_X;
         this.versionLabel.y = this.VERSION_LABEL_Y;
         this.win.addChild(this.versionLabel);
      }
      
      protected function initHeadline(param1:String) : void
      {
         var _loc3_:TextFormat = null;
         var _loc2_:TextField = new TextField();
         _loc2_.x = 26;
         _loc2_.y = 10;
         _loc3_ = Styles.h1Fmt;
         _loc3_.align = TextAlign.LEFT;
         _loc2_.selectable = false;
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.embedFonts = Styles.h1Embed;
         _loc2_.height = Styles.h1FontHeight + 4;
         _loc2_.antiAliasType = AntiAliasType.ADVANCED;
         _loc2_.textColor = 16777215;
         _loc2_.text = BPLocale.getItemInCategory("galaxyGates",param1);
         this.win.addChild(_loc2_);
      }
      
      protected function createContentTextArea() : void
      {
         var _loc1_:TextFormat = null;
         this.contentTextArea = new TextField();
         this.contentTextArea.width = this.CONTENT_TEXT_AREA_WIDTH;
         _loc1_ = Styles.helpTextFmt;
         this.contentTextArea.selectable = false;
         this.contentTextArea.autoSize = TextFieldAutoSize.LEFT;
         this.contentTextArea.embedFonts = Styles.helpTextEmbed;
         this.contentTextArea.textColor = 16777215;
         this.contentTextArea.multiline = true;
         this.contentTextArea.wordWrap = true;
         this.contentTextArea.defaultTextFormat = _loc1_;
         var _loc2_:Object = {
            "fontSize":Styles.h1FontHeight,
            "fontWeight":"bold"
         };
         var _loc3_:Object = {
            "fontSize":Styles.h2FontHeight,
            "fontWeight":"bold"
         };
         var _loc4_:Object = {"fontSize":Styles.ggBuilderPlainStdFontHeight};
         var _loc5_:StyleSheet = new StyleSheet();
         _loc5_.setStyle(".h1",_loc2_);
         _loc5_.setStyle(".h2",_loc3_);
         _loc5_.setStyle("p",_loc4_);
         this.contentTextArea.styleSheet = _loc5_;
      }
      
      protected function addContentTextArea() : void
      {
         this.contentContainer.addChild(this.contentTextArea);
         AlignmentUtils.align(this.contentTextArea,AlignmentUtils.CENTER_HORIZONTAL);
      }
      
      protected function handleMouseClick(param1:MouseEvent) : void
      {
      }
      
      protected function handleMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop(this.CLOSE_BUTTON_STATE_OVER);
      }
      
      protected function handleMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop(this.CLOSE_BUTTON_STATE_NORMAL);
      }
      
      protected function show() : void
      {
         if(this.win == null)
         {
            this.initialize();
         }
         if(!contains(this.lightboxBackground))
         {
            addChild(this.lightboxBackground);
         }
      }
      
      protected function hide() : void
      {
         if(this.lightboxBackground)
         {
            if(contains(this.lightboxBackground))
            {
               removeChild(this.lightboxBackground);
            }
         }
         if(this.win)
         {
            if(contains(this.win))
            {
               removeChild(this.win);
            }
         }
      }
   }
}

