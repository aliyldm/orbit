package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.loadingscreen.utils.Styles;
   import net.bigpoint.darkorbit.loadingscreen.utils.TimeFormatter;
   
   public class TimerLabel extends Sprite
   {
      
      private static var dayFontHeight:int = 16;
      
      private static var dayInfoFmt:TextFormat = new TextFormat("Verdana",dayFontHeight,16777215);
      
      private static var timerFontHeight:int = 19;
      
      private static var timerFmt:TextFormat = new TextFormat(Styles.boldFontName,timerFontHeight,16763904);
      
      dayInfoFmt.align = TextFormatAlign.RIGHT;
      timerFmt.align = TextFormatAlign.LEFT;
      
      private var _delay:Number = 1000;
      
      private var _t:Number;
      
      private var _timer:Timer;
      
      private const TIME_IS_OVER_MAN:String = "TimerIsOver";
      
      private var _titleTextField:TextField;
      
      private var _timerTextField:TextField;
      
      public function TimerLabel()
      {
         super();
         this._timer = new Timer(this._delay);
         this._timer.addEventListener(TimerEvent.TIMER,this.handleTimerEvent);
         this._timerTextField = new TextField();
         this._timerTextField.defaultTextFormat = timerFmt;
         this._timerTextField.embedFonts = true;
         this._timerTextField.height = 24;
         this._timerTextField.selectable = false;
         addChild(this._timerTextField);
         this.createTextField();
      }
      
      private function createTextField() : void
      {
         this._titleTextField = new TextField();
         this._titleTextField.defaultTextFormat = dayInfoFmt;
         this._titleTextField.embedFonts = false;
         this._titleTextField.text = BPLocale.getItem("login_bonus_calendar_expires").replace("%VALUE%"," ");
         this._titleTextField.height = 24;
         this._titleTextField.y = 1;
         this._titleTextField.selectable = false;
         addChild(this._titleTextField);
         this.updateLabel();
      }
      
      public function set time(param1:Number) : void
      {
         this._t = param1;
         this.updateLabel();
         this.start();
      }
      
      private function handleTimerEvent(param1:TimerEvent) : void
      {
         --this._t;
         if(this._t > 0)
         {
            this.updateLabel();
         }
         else
         {
            dispatchEvent(new Event(this.TIME_IS_OVER_MAN));
         }
      }
      
      private function updateLabel() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = Math.floor(this._t / 60 / 1440);
         if(_loc2_ > 0)
         {
            _loc1_ = TimeFormatter.formatTimeDMY(this._t);
         }
         else
         {
            _loc1_ = TimeFormatter.formatTime(this._t);
         }
         this._timerTextField.text = _loc1_;
      }
      
      public function start() : void
      {
         if(this._timer != null)
         {
            this._timer.start();
         }
      }
      
      public function stop() : void
      {
         if(this._timer != null && this._timer.running)
         {
            this._timer.stop();
         }
      }
      
      public function set w(param1:uint) : void
      {
         var _loc2_:int = 16;
         this._titleTextField.width = param1 / 2 + _loc2_;
         this._timerTextField.width = param1 / 2 - _loc2_;
         this._timerTextField.x = this._titleTextField.width;
      }
      
      public function dispose() : void
      {
         this.stop();
         if(this._timer.hasEventListener(TimerEvent.TIMER))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.handleTimerEvent);
         }
         this._timer = null;
      }
   }
}

