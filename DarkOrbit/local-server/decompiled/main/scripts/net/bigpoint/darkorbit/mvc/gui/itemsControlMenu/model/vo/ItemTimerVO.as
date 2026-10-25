package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo
{
   import com.bigpoint.utils.countDownTimer.CountDownEvent;
   import com.bigpoint.utils.countDownTimer.CountDownTimer;
   import flash.utils.getDefinitionByName;
   import net.bigpoint.darkorbit.com.module.MenuItemCooldownGroupTimerCommand;
   import net.bigpoint.darkorbit.com.module.MenuItemTimerCommand;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   
   public class ItemTimerVO
   {
      
      private var _time:Number;
      
      private var _maxTime:Number;
      
      private var _timerState:String;
      
      private var _countDownTimer:CountDownTimer;
      
      public function ItemTimerVO(param1:Number, param2:Number, param3:String)
      {
         super();
         this._time = param1;
         this._maxTime = param2;
         this._timerState = param3;
         if(Boolean(this._time) && this._timerState != ItemsControlMenuConstants.TIMER_STATE_READY)
         {
            this._countDownTimer = new CountDownTimer(this._time);
            this._countDownTimer.addEventListener(CountDownEvent.COUNT_DOWN_FINISH,this.countDownFinishHandler,false,0,true);
            this._countDownTimer.start();
         }
      }
      
      public static function parseTimer(param1:MenuItemTimerCommand) : ItemTimerVO
      {
         return new ItemTimerVO(param1.time,param1.maxTime,ItemsControlMenuConstants.TIMER_STATES_MAP[param1.timerState.timerStateValue]);
      }
      
      public static function parseCooldownGroupTimer(param1:MenuItemCooldownGroupTimerCommand) : ItemTimerVO
      {
         return new ItemTimerVO(param1.time,param1.maxTime,ItemsControlMenuConstants.TIMER_STATES_MAP[param1.timerState.timerStateValue]);
      }
      
      private function countDownFinishHandler(param1:CountDownEvent) : void
      {
         this._countDownTimer = null;
      }
      
      public function get time() : Number
      {
         return this._time;
      }
      
      public function get maxTime() : Number
      {
         return this._maxTime;
      }
      
      public function get timerState() : String
      {
         return this._timerState;
      }
      
      public function get countDownTimer() : CountDownTimer
      {
         return this._countDownTimer;
      }
   }
}

