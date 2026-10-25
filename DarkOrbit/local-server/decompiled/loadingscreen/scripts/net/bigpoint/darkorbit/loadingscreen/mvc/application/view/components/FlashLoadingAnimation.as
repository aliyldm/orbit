package net.bigpoint.darkorbit.loadingscreen.mvc.application.view.components
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.AssetsProxy;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import net.bigpoint.darkorbit.loadingscreen.utils.Styles;
   
   public class FlashLoadingAnimation extends Sprite
   {
      
      private static const LABEL_OFFSET:int = 10;
      
      private var animation:MovieClip;
      
      private var label:TextField;
      
      public function FlashLoadingAnimation()
      {
         super();
      }
      
      public function init() : void
      {
         this.animation = new AssetsProxy.libs["LoadingAnimation"]() as MovieClip;
         this.animation.y = -(this.animation.height / 2);
         this.label = new TextField();
         this.label.defaultTextFormat = Styles.loadingFmt;
         this.label.embedFonts = Styles.loadingEmbed;
         this.label.width = 220;
         this.label.height = Styles.loadingFontHeight + 6;
         this.label.y = this.animation.y + this.animation.height / 2 + LABEL_OFFSET;
         this.label.x = -(this.label.width / 2);
         this.label.antiAliasType = AntiAliasType.ADVANCED;
         this.label.selectable = false;
         this.label.text = Session.loadingClaim;
      }
      
      public function show() : void
      {
         if(this.animation == null || this.label == null)
         {
            this.init();
         }
         if(!this.contains(this.animation))
         {
            this.addChild(this.animation);
         }
         this.animation.gotoAndPlay(1);
         if(!this.contains(this.label))
         {
            this.addChild(this.label);
         }
         this.visible = true;
      }
      
      public function hide() : void
      {
         if(this.animation)
         {
            this.animation.gotoAndStop(1);
            if(this.contains(this.animation))
            {
               this.removeChild(this.animation);
               this.animation = null;
            }
         }
         if(this.label)
         {
            if(this.contains(this.label))
            {
               this.removeChild(this.label);
               this.label = null;
            }
         }
         this.visible = false;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}

