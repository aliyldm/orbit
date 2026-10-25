package net.bigpoint.darkorbit.preloader.loaders
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class SimpleLoadingAnimation extends Sprite
   {
      
      private static var loadingFmt:TextFormat;
      
      private static var loadingFontHeight:int = 24;
      
      private static var loadingEmbed:Boolean = true;
      
      private static const FONT_COLOR:uint = 16434692;
      
      private static const LABEL_OFFSET:int = 10;
      
      private var clip:MovieClip;
      
      private var label:TextField;
      
      private var LoadingAnimation:Class = SimpleLoadingAnimation_LoadingAnimation;
      
      private var _labelText:String;
      
      public function SimpleLoadingAnimation(param1:String)
      {
         super();
         this.clip = new this.LoadingAnimation();
         this._labelText = param1 || "LOADING...";
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         stage.addEventListener(Event.RESIZE,this.handleStageResize);
         this.handleStageResize();
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.handleStageResize);
      }
      
      private function handleStageResize(param1:Event = null) : void
      {
         x = stage.stageWidth * 0.5;
         y = stage.stageHeight * 0.5;
      }
      
      public function init() : void
      {
         loadingFmt = new TextFormat("EurostileHeaFl",loadingFontHeight,16434692);
         loadingFmt.align = TextFormatAlign.CENTER;
         this.clip.y = -(this.clip.height / 2);
         this.label = new TextField();
         this.label.defaultTextFormat = loadingFmt;
         this.label.embedFonts = loadingEmbed;
         this.label.y = this.clip.y + this.clip.height / 2 + LABEL_OFFSET;
         this.label.width = 220;
         this.label.height = loadingFontHeight + 6;
         this.label.x = -(this.label.width / 2);
         this.label.antiAliasType = AntiAliasType.ADVANCED;
         this.label.selectable = false;
         this.label.textColor = FONT_COLOR;
         this.label.text = this._labelText;
      }
      
      public function show() : void
      {
         if(this.clip == null || this.label == null)
         {
            this.init();
         }
         if(!contains(this.clip))
         {
            addChild(this.clip);
         }
         this.clip.gotoAndPlay(1);
         if(!contains(this.label))
         {
            addChild(this.label);
         }
      }
      
      public function hide() : void
      {
         if(this.clip == null || this.label == null)
         {
            return;
         }
         this.clip.gotoAndStop(1);
         if(contains(this.clip))
         {
            removeChild(this.clip);
         }
         if(contains(this.label))
         {
            removeChild(this.label);
         }
      }
   }
}

