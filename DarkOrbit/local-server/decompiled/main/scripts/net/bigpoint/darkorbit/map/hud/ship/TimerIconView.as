package net.bigpoint.darkorbit.map.hud.ship
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.map.model.traits.hud.TimerIconTrait;
   
   public class TimerIconView extends IconView
   {
      
      private static const OUTER_GLOW_FILTER:Array = [new GlowFilter(0,0.7,5,5,6,BitmapFilterQuality.HIGH)];
      
      private static const TIMER_GLOW_FILTER:Array = [new GlowFilter(0,0.7,5,5,4,BitmapFilterQuality.HIGH)];
      
      private static const DEFAULT_TEXT_COLOUR:uint = 16777215;
      
      private var _timerTrait:TimerIconTrait;
      
      private var _tf:TextField = new TextField();
      
      private var _format:TextFormat = new TextFormat(Styles.nickFmt.font,Styles.nickFontHeight,DEFAULT_TEXT_COLOUR,Styles.nickFmt.bold);
      
      public function TimerIconView(param1:TimerIconTrait)
      {
         super(param1);
         this._timerTrait = param1;
         this.initEffectVisuals();
         param1.seconds.changed.add(this.updateTimer);
      }
      
      private function initEffectVisuals() : void
      {
         this._tf.autoSize = TextFieldAutoSize.CENTER;
         this._tf.textColor = DEFAULT_TEXT_COLOUR;
         this._tf.embedFonts = Styles.nickEmbed;
         if(this._timerTrait.iconId.length == 0)
         {
            this._tf.text = TimeFormatter.formatTime(this._timerTrait.seconds.value);
            this._tf.filters = OUTER_GLOW_FILTER;
         }
         else
         {
            this._format.size = 10;
            this._tf.text = TextFormatter.roundInteger(this._timerTrait.seconds.value);
            this._tf.filters = TIMER_GLOW_FILTER;
            this._tf.x = 18;
            this._tf.y = 22;
         }
         this._tf.defaultTextFormat = this._format;
         addChild(this._tf);
         setChildIndex(this._tf,numChildren - 1);
      }
      
      private function updateTimer() : void
      {
         this._tf.text = this._timerTrait.iconId.length > 0 ? TextFormatter.roundInteger(this._timerTrait.seconds.value) : TimeFormatter.formatTime(this._timerTrait.seconds.value);
         setChildIndex(this._tf,numChildren - 1);
      }
   }
}

