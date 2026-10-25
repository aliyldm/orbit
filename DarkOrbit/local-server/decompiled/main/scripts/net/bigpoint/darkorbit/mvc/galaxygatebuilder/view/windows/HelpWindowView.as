package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.windows
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.GalaxyGateBuilderDecorator;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.IGalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.components.scrollbar.ScrollController;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.components.scrollbar.Scrollbar;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class HelpWindowView extends AbstractWindowView
   {
      
      private var scrollbar:Scrollbar;
      
      private var scrollController:ScrollController;
      
      public function HelpWindowView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case ApplicationEvent.HELP_ON:
               this.show();
               break;
            case ApplicationEvent.HELP_OFF:
               this.hide();
            case ApplicationEvent.HELP_COMPLETE:
               if(contains(win))
               {
                  contentTextArea.htmlText = (model as IGalaxyGateBuilderModel).getHelp();
                  this.updateContent();
                  if(contentTextArea.length < 10)
                  {
                     getProxy().showLoadingAnimationHandler();
                  }
                  else
                  {
                     getProxy().hideLoadingAnimationHandler();
                  }
               }
         }
      }
      
      override protected function show() : void
      {
         if(win == null)
         {
            this.init();
         }
         if(!contains(lightboxBackground))
         {
            addChild(lightboxBackground);
         }
         if(!contains(win))
         {
            addChild(win);
            contentTextArea.htmlText = (model as IGalaxyGateBuilderModel).getHelp();
            this.updateContent();
            if(contentTextArea.length < 10)
            {
               getProxy().showLoadingAnimationHandler();
            }
         }
      }
      
      private function updateContent() : void
      {
         this.scrollController.updateScrollbarSizing(contentTextArea.height);
      }
      
      override protected function hide() : void
      {
         super.hide();
         getProxy().hideLoadingAnimationHandler();
      }
      
      public function init() : void
      {
         super.initialize();
         win = commonLib.getEmbeddedMovieClip("help_win");
         win.x = GalaxyGateBuilderDecorator.STAGE_WIDTH / 2 - win.width / 2;
         win.y = GalaxyGateBuilderDecorator.STAGE_HEIGHT / 2 - win.height / 2;
         win.filters = [shadowFilter];
         addChild(win);
         initHeadline("title_application");
         initContentContainer();
         createContentTextArea();
         contentContainer.addChild(contentTextArea);
         var _loc1_:Rectangle = new Rectangle(0,0,contentTextArea.width,212);
         this.scrollController = new ScrollController(contentContainer,_loc1_,this);
         this.scrollbar = this.scrollController.getScrollbar();
         this.scrollbar.x = contentContainer.x + contentContainer.width;
         this.scrollbar.y = contentContainer.y;
         win.addChild(this.scrollbar);
         initCloseButton();
         contentTextArea.htmlText = (model as IGalaxyGateBuilderModel).getHelp();
         this.updateContent();
         if(contentTextArea.length < 10)
         {
            getProxy().showLoadingAnimationHandler();
         }
      }
      
      override protected function handleMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         switch(_loc2_)
         {
            case closeBtn:
               getProxy().hideHelpHandler();
         }
      }
   }
}

