package net.bigpoint.darkorbit.map.hud.effects.impl
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.AlertEffect;
   
   public class AlertEffect2D extends Sprite implements IDisposable
   {
      
      private var alertText:TextField;
      
      private var _alertEffect:AlertEffect;
      
      public function AlertEffect2D(param1:IMapView, param2:AlertEffect)
      {
         super();
         this._alertEffect = param2;
         param2.text.changed.add(this.updateText);
         this.updateText();
         this.onWarning();
      }
      
      private function updateText() : void
      {
         if(this._alertEffect.text.value)
         {
            if(this.alertText == null)
            {
               this.createAlertText();
            }
            this.alertText.text = this._alertEffect.text.value;
            this.alertText.x = -this.alertText.width / 2;
         }
         else if(this.alertText)
         {
            this.alertText.parent.removeChild(this.alertText);
            this.alertText = null;
         }
      }
      
      private function createAlertText() : void
      {
         this.alertText = new TextField();
         this.alertText.defaultTextFormat = Styles.systemSplashFmt;
         this.alertText.embedFonts = Styles.systemSplashEmbed;
         this.alertText.autoSize = TextFieldAutoSize.LEFT;
         this.alertText.height = Styles.systemSplashFontHeight + 6;
         this.alertText.textColor = 16777215;
         this.alertText.antiAliasType = "advanced";
         this.alertText.selectable = false;
         this.alertText.filters = [new GlowFilter(255,1,1,1,1)];
         this.setRadiationBitmapPosition();
         this.alertText.alpha = 0;
         TweenLite.to(this.alertText,1,{"alpha":1});
         addChild(this.alertText);
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._alertEffect.text.changed.remove(this.updateText);
         if(this.alertText)
         {
            TweenLite.to(this.alertText,0.5,{
               "alpha":0,
               "onComplete":this.alertText.parent.removeChild,
               "onCompleteParams":[this.alertText]
            });
         }
         TweenLite.killDelayedCallsTo(this.onWarning);
      }
      
      private function setRadiationBitmapPosition() : void
      {
         x = ScreenManager.getHalfScreenWidth();
         y = ScreenManager.getHalfScreenHeight() - 200;
      }
      
      private function onWarning() : void
      {
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_VOICE_WARNING);
         ScreenManager.getInstance().flashScreen(267386880);
         TweenLite.delayedCall(2,this.onWarning);
      }
   }
}

