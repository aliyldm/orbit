package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.ApplicationEvent;
   
   public class LoadingAnimationView extends CompositeView
   {
      
      private static const FONT_COLOR:uint = 16434692;
      
      private static const LABEL_OFFSET:int = 10;
      
      private var animation:MovieClip;
      
      private var label:TextField;
      
      public function LoadingAnimationView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Event = null) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case ApplicationEvent.LANGUAGE_LOADED:
               if(this.label != null)
               {
                  this.label.text = BPLocale.getItemInCategory("galaxyGates","claim_loading");
               }
               break;
            case ApplicationEvent.LOADING_ON:
               this.show();
               break;
            case ApplicationEvent.LOADING_OFF:
               this.hide();
         }
      }
      
      private function init() : void
      {
         var _loc1_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         this.animation = _loc1_.getMovieClip("loadingAnimation","loading_animation");
         this.animation.y = -(this.animation.height / 2);
         this.label = new TextField();
         this.label.defaultTextFormat = Styles.loadingFmt;
         this.label.embedFonts = Styles.loadingEmbed;
         this.label.textColor = 14540253;
         this.label.y = this.animation.y + this.animation.height / 2 + LABEL_OFFSET;
         this.label.width = 220;
         this.label.height = Styles.loadingFontHeight + 6;
         this.label.x = -(this.label.width / 2);
         this.label.antiAliasType = AntiAliasType.ADVANCED;
         this.label.selectable = false;
         this.label.textColor = FONT_COLOR;
      }
      
      private function show() : void
      {
         if(this.animation == null || this.label == null)
         {
            this.init();
         }
         if(!contains(this.animation))
         {
            addChild(this.animation);
         }
         this.animation.gotoAndPlay(1);
         if(!contains(this.label))
         {
            addChild(this.label);
         }
      }
      
      private function hide() : void
      {
         this.animation.gotoAndStop(1);
         if(contains(this.animation))
         {
            removeChild(this.animation);
         }
         if(contains(this.label))
         {
            removeChild(this.label);
         }
      }
   }
}

