package net.bigpoint.darkorbit.map.hud.effects.impl
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.utils.getTimer;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.effects.impl.TimerCountdownEffect;
   
   public class TimerCountdownEffect2D extends AbstractHUDElement
   {
      
      private var _spinningLoadAnimation:Bitmap;
      
      private var _tween:TweenMax;
      
      private var _spinningHolster:Sprite;
      
      private var _countdownText:TextField;
      
      private var _startTime:int = getTimer().valueOf();
      
      private var _effect:TimerCountdownEffect;
      
      private var countdownTime:Number;
      
      public function TimerCountdownEffect2D(param1:IMapView, param2:TimerCountdownEffect)
      {
         this._effect = param2;
         this.countdownTime = param2.countdownTime;
         super(param1,param2.source.position);
         ResourceManager.fileCollection.load("ui",this.handleExtraAssetLoaded);
      }
      
      private function handleExtraAssetLoaded(param1:SWFFinisher) : void
      {
         this._spinningLoadAnimation = param1.getEmbeddedBitmap("loot_countdown_with_bg");
         this._spinningHolster = new Sprite();
         this._spinningHolster.addChild(this._spinningLoadAnimation);
         this._spinningLoadAnimation.x = -this._spinningLoadAnimation.width * 0.5;
         this._spinningLoadAnimation.y = -this._spinningLoadAnimation.height * 0.5;
         this._spinningHolster.y = 145;
         this._countdownText = new TextField();
         this._countdownText.defaultTextFormat = Styles.h2Fmt;
         this._countdownText.setTextFormat(Styles.h2Fmt);
         this._countdownText.type = TextFieldType.DYNAMIC;
         this._countdownText.textColor = 15327936;
         this._countdownText.embedFonts = Styles.baseEmbed;
         this._countdownText.autoSize = TextFieldAutoSize.CENTER;
         this._countdownText.antiAliasType = AntiAliasType.ADVANCED;
         this._countdownText.selectable = false;
         this._countdownText.width = 40;
         this._countdownText.x = this._spinningHolster.x - 2;
         this._countdownText.y = this._spinningHolster.y - 9;
         this._countdownText.text = "-";
         addChild(this._spinningHolster);
         addChild(this._countdownText);
         this.countdownTime -= (getTimer().valueOf() - this._startTime) / 1000;
         this._tween = TweenMax.to(this._spinningHolster,this.countdownTime,{
            "ease":Linear.easeNone,
            "rotation":180 * this.countdownTime,
            "onUpdate":this.setCountdownText,
            "onUpdateParams":[this._countdownText],
            "onComplete":this.handleCompleted
         });
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._tween)
         {
            this._tween.kill();
            this._tween = null;
         }
         super.disposeView(param1);
      }
      
      private function setCountdownText(param1:TextField) : void
      {
         param1.text = Math.ceil(this._tween.duration - this._tween.currentTime).toString();
      }
      
      private function handleCompleted() : void
      {
         this.disposeView();
      }
   }
}

