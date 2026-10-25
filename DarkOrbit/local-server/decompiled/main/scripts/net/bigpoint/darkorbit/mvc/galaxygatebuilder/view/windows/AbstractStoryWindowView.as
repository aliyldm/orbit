package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows
{
   import flash.display.Bitmap;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.SpreadMethod;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.common.utils.AlignmentUtils;
   import net.bigpoint.darkorbit.mvc.common.utils.Scale9GridUtils;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.GalaxyGateBuilderDecorator;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderAssets;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class AbstractStoryWindowView extends AbstractWindowView
   {
      
      private static const WIDTH:uint = 598;
      
      private static const HEIGHT:uint = 298;
      
      protected static const TEASER_Y:uint = 38;
      
      private var deltaContentContainerHeight:uint;
      
      private const CONTENCONTAINER_BACKGROUND_COLOR_TOP:uint = 2040355;
      
      private const CONTENCONTAINER_BACKGROUND_COLOR_BOTTOM:uint = 1053719;
      
      private const CONTENCONTAINER_BACKGROUND_LINECOLOR:uint = 2963007;
      
      private const CONTENT_TEXT_AREA_MARGIN_TOP:uint = 20;
      
      private var _eventId:String;
      
      private var _teaser:String;
      
      private var _headline:String;
      
      private var _infoText:String;
      
      private var _shown:Boolean = false;
      
      private var _asset:IGalaxyGateBuilderAssets;
      
      public function AbstractStoryWindowView(param1:String, param2:String, param3:String, param4:String, param5:GalaxyGateBuilderModel, param6:Object, param7:IGalaxyGateBuilderAssets)
      {
         this._eventId = param1;
         this._teaser = param2;
         this._headline = param3;
         this._infoText = param4;
         this._asset = param7;
         super(param5,param6);
         model.addEventListener(ApplicationEvent.ADDITIONALWINDOW_HIDE,this.update);
         model.addEventListener(ApplicationEvent.ADDITIONALWINDOW_SHOW,this.update);
         model.addEventListener(ApplicationEvent.INIT_COMPLETE,this.update);
         model.addEventListener(ApplicationEvent.STATE_ALPHA,this.update);
         model.addEventListener(ApplicationEvent.STATE_BETA,this.update);
         model.addEventListener(ApplicationEvent.STATE_GAMMA,this.update);
         model.addEventListener(ApplicationEvent.STATE_DELTA,this.update);
         model.addEventListener(ApplicationEvent.STATE_EPSILON,this.update);
         model.addEventListener(ApplicationEvent.STATE_ZETA,this.update);
         model.addEventListener(ApplicationEvent.STATE_KAPPA,this.update);
         model.addEventListener(ApplicationEvent.STATE_LAMBDA,this.update);
         model.addEventListener(ApplicationEvent.STATE_KRONOS,this.update);
         model.addEventListener(ApplicationEvent.STATE_HADES,this.update);
         model.addEventListener(ApplicationEvent.STATE_STREUNER,this.update);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         CONTENT_CONTAINER_X = 136;
         CONTENT_CONTAINER_Y = 108;
         CONTENT_CONTAINER_WIDTH = WIDTH - 40 * 2;
         CONTENT_CONTAINER_HEIGHT = 150;
         CONTENT_TEXT_AREA_WIDTH = 440;
         this.initWindowBackground();
         initHeadline(this._headline);
         this.initTeaser();
         this.initContentContainer();
         initCloseButton();
      }
      
      private function initWindowBackground() : void
      {
         win = commonLib.getEmbeddedMovieClip(EXPORT_WINDOW_BACKGROUND);
         Scale9GridUtils.setWidth(win,WIDTH);
         Scale9GridUtils.setHeight(win,HEIGHT);
         win.x = GalaxyGateBuilderDecorator.STAGE_WIDTH / 2 - win.width / 2;
         win.y = GalaxyGateBuilderDecorator.STAGE_HEIGHT / 2 - win.height / 2;
         win.filters = [shadowFilter];
         addChild(win);
      }
      
      private function initTeaser() : void
      {
         var _loc1_:Bitmap = commonLib.getEmbeddedBitmap(this._teaser);
         if(_loc1_)
         {
            win.addChild(_loc1_);
            AlignmentUtils.align(_loc1_,AlignmentUtils.CENTER_HORIZONTAL,-1,TEASER_Y);
         }
      }
      
      override protected function initContentContainer() : void
      {
         super.initContentContainer();
         this.createContentTextArea();
         this.createContentbackground();
         this.addContentTextArea();
         this.resizeAndRealignComponents();
      }
      
      override protected function createContentTextArea() : void
      {
         super.createContentTextArea();
         var _loc1_:String = BPLocale.getItemInCategory("galaxyGates",this._infoText);
         contentTextArea.htmlText = _loc1_;
         this.deltaContentContainerHeight = contentTextArea.height - CONTENT_CONTAINER_HEIGHT;
      }
      
      override protected function addContentTextArea() : void
      {
         contentContainer.addChild(contentTextArea);
         AlignmentUtils.align(contentTextArea,AlignmentUtils.CENTER_HORIZONTAL | AlignmentUtils.CENTER_VERTICAL);
      }
      
      private function createContentbackground() : void
      {
         var _loc1_:uint = CONTENT_CONTAINER_HEIGHT + this.CONTENT_TEXT_AREA_MARGIN_TOP * 2 + 5;
         if(this.deltaContentContainerHeight > 0)
         {
            _loc1_ += this.deltaContentContainerHeight;
         }
         var _loc2_:Graphics = contentContainer.graphics;
         var _loc3_:String = GradientType.LINEAR;
         var _loc4_:Array = [this.CONTENCONTAINER_BACKGROUND_COLOR_TOP,this.CONTENCONTAINER_BACKGROUND_COLOR_BOTTOM];
         var _loc5_:Array = [1,1];
         var _loc6_:Array = [0,255];
         var _loc7_:Matrix = new Matrix();
         _loc7_.createGradientBox(CONTENT_CONTAINER_WIDTH,CONTENT_CONTAINER_HEIGHT,Math.PI / 2,0,0);
         var _loc8_:String = SpreadMethod.PAD;
         _loc2_.clear();
         _loc2_.beginGradientFill(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
         _loc2_.lineStyle(0,this.CONTENCONTAINER_BACKGROUND_LINECOLOR);
         _loc2_.drawRect(0,0,CONTENT_CONTAINER_WIDTH,_loc1_);
         _loc2_.endFill();
      }
      
      override protected function setContentContainerPosition() : void
      {
         contentContainer.x = 0;
         contentContainer.y = 0;
      }
      
      protected function resizeAndRealignComponents() : void
      {
         if(this.deltaContentContainerHeight > 0)
         {
            Scale9GridUtils.setHeight(win,HEIGHT + this.deltaContentContainerHeight + 10 + this.CONTENT_TEXT_AREA_MARGIN_TOP * 2);
            win.y = GalaxyGateBuilderDecorator.STAGE_HEIGHT / 2 - win.height / 2 - GalaxyGateBuilderDecorator.ORIGIN_PT_Y;
         }
         AlignmentUtils.align(contentContainer,AlignmentUtils.CENTER_HORIZONTAL,-2,CONTENT_CONTAINER_Y);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case this._eventId:
               if(this._shown == false && GalaxyGateBuilderModel(model).showGateStoryWindow && GalaxyGateBuilderModel(model).currentAssets == this._asset)
               {
                  this._shown = true;
                  this.show();
               }
               else
               {
                  this.hide();
               }
               break;
            case ApplicationEvent.ADDITIONALWINDOW_SHOW:
               if(GalaxyGateBuilderModel(model).currentAssets == this._asset)
               {
                  this.show();
               }
               break;
            case ApplicationEvent.ADDITIONALWINDOW_HIDE:
               if(GalaxyGateBuilderModel(model).currentAssets == this._asset)
               {
                  this.hide();
               }
               break;
            default:
               this.hide();
         }
      }
      
      override protected function show() : void
      {
         super.show();
         if(!contains(win))
         {
            addChild(win);
            this.updateContent();
         }
      }
      
      override protected function hide() : void
      {
         super.hide();
      }
      
      override protected function handleMouseClick(param1:MouseEvent) : void
      {
         this.hide();
      }
      
      protected function updateContent() : void
      {
      }
   }
}

