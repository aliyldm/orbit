package net.bigpoint.darkorbit.loadingscreen.mvc.application.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.ids.LinkageId;
   import net.bigpoint.darkorbit.loadingscreen.utils.Styles;
   
   public class FlashLoadingBarView extends Sprite
   {
      
      public static const MIN_LOADER_SCREEN_HEIGHT:int = 720;
      
      private var loadingBtnLabel:TextField;
      
      private var startBtnContainer:Sprite;
      
      private var startBtn:MovieClip;
      
      private var startBtnLabel:TextField;
      
      private var loadingBtn:Sprite;
      
      private var loadingBtnMask:Sprite;
      
      private var _oldHeight:Number = NaN;
      
      public function FlashLoadingBarView()
      {
         super();
         this.loadingBtn = new Sprite();
         this.startBtnContainer = new Sprite();
         this.startBtnContainer.visible = false;
         this.addChild(this.loadingBtn);
         this.addChild(this.startBtnContainer);
      }
      
      public function initComponent(param1:SWFFinisher) : void
      {
         var _loc2_:BitmapData = param1.getEmbeddedBitmapData(LinkageId.LOADINGBAR_EMPTY);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         this.loadingBtn.addChild(_loc3_);
         this.loadingBtnMask = new Sprite();
         this.loadingBtnMask.graphics.beginFill(16711680);
         this.loadingBtnMask.graphics.drawRect(0,0,208,53);
         this.loadingBtnMask.graphics.endFill();
         this.loadingBtnMask.scaleX = 0;
         this.loadingBtn.addChild(this.loadingBtnMask);
         _loc2_ = param1.getEmbeddedBitmapData(LinkageId.LOADINGBAR_FULL);
         _loc3_ = new Bitmap(_loc2_);
         _loc3_.mask = this.loadingBtnMask;
         this.loadingBtn.addChild(_loc3_);
         this.loadingBtnLabel = new TextField();
         this.loadingBtnLabel.width = 208;
         this.loadingBtnLabel.defaultTextFormat = Styles.loadingBtnFmt;
         this.loadingBtnLabel.embedFonts = Styles.loadingBtnEmbed;
         this.loadingBtnLabel.autoSize = TextFieldAutoSize.CENTER;
         this.loadingBtnLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.loadingBtnLabel.selectable = false;
         this.loadingBtnLabel.mouseEnabled = false;
         this.loadingBtnLabel.filters = [new GlowFilter(16777215,0.2,4,4,6,1)];
         this.loadingBtnLabel.text = BPLocale.getItem("btn_label_loading");
         this.loadingBtnLabel.y = 14;
         this.loadingBtn.addChild(this.loadingBtnLabel);
         this.startBtn = param1.getEmbeddedMovieClip(LinkageId.LOADINGBAR_START);
         this.startBtn.gotoAndStop("default");
         this.startBtnContainer.addChild(this.startBtn);
         this.startBtnContainer.buttonMode = true;
         this.startBtnLabel = new TextField();
         this.startBtnLabel.width = 208;
         this.startBtnLabel.defaultTextFormat = Styles.loadingStartBtnFmt;
         this.startBtnLabel.embedFonts = Styles.loadingStartBtnEmbed;
         this.startBtnLabel.autoSize = TextFieldAutoSize.CENTER;
         this.startBtnLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.startBtnLabel.selectable = false;
         this.startBtnLabel.mouseEnabled = false;
         this.startBtnLabel.filters = [new GlowFilter(16777215,0.2,4,4,6,1)];
         this.startBtnLabel.text = BPLocale.getItem("btn_label_start");
         this.startBtnLabel.y = 12;
         this.startBtnContainer.addChild(this.startBtnLabel);
         this.addChild(this.startBtnContainer);
      }
      
      public function dailyLoginBonusActive() : void
      {
         this.startBtnLabel.text = BPLocale.getItem("btn_label_claim");
      }
      
      public function updateLoadPercentage(param1:int) : void
      {
         var _loc2_:Number = NaN;
         if(this.loadingBtnMask != null)
         {
            _loc2_ = param1 / 100;
            this.loadingBtnMask.scaleX = _loc2_;
         }
      }
      
      public function clientFullyLoaded() : void
      {
         this.loadingBtn.visible = false;
         this.startBtnContainer.visible = true;
         this.startBtnContainer.addEventListener(MouseEvent.CLICK,this.handleStartBtnClicked);
         this.startBtnContainer.addEventListener(MouseEvent.ROLL_OVER,this.handleStartBtnRollover);
         this.startBtnContainer.addEventListener(MouseEvent.ROLL_OUT,this.handleStartBtnRollOut);
         this.addGlowToStartBtn();
      }
      
      private function addGlowToStartBtn() : void
      {
         TweenMax.to(this.startBtn,0.5,{
            "glowFilter":{
               "color":7995158,
               "alpha":0.9,
               "blurX":18,
               "blurY":18
            },
            "onComplete":this.removeGlowFromStartBtn,
            "ease":Sine.easeIn
         });
      }
      
      private function removeGlowFromStartBtn() : void
      {
         TweenMax.to(this.startBtn,0.65,{
            "glowFilter":{
               "color":7995158,
               "alpha":0.5,
               "blurX":12,
               "blurY":12
            },
            "onComplete":this.addGlowToStartBtn,
            "ease":Sine.easeOut
         });
      }
      
      private function handleStartBtnClicked(param1:MouseEvent) : void
      {
         TweenMax.killTweensOf(this.startBtn);
         this.startBtn.gotoAndStop("active");
         this.startBtnContainer.removeEventListener(MouseEvent.CLICK,this.handleStartBtnClicked);
         this.startBtnContainer.removeEventListener(MouseEvent.ROLL_OVER,this.handleStartBtnRollover);
         this.startBtnContainer.removeEventListener(MouseEvent.ROLL_OUT,this.handleStartBtnRollOut);
         this.startBtn.gotoAndStop("visited");
         this.startBtnLabel.textColor = 11776947;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function handleStartBtnRollover(param1:MouseEvent) : void
      {
         this.startBtn.gotoAndStop("hover");
      }
      
      private function handleStartBtnRollOut(param1:MouseEvent) : void
      {
         this.startBtn.gotoAndStop("default");
      }
   }
}

