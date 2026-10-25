package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events
{
   import flash.events.Event;
   
   public class ApplicationEvent extends Event
   {
      
      public static const INIT_START:String = "ApplicationEvent.initStart";
      
      public static const INIT_PROGRESS:String = "ApplicationEvent.initProgress";
      
      public static const INIT_COMPLETE:String = "ApplicationEvent.initComplete";
      
      public static const TRANSFER_START:String = "ApplicationEvent.transferStart";
      
      public static const TRANSFER_PROGRESS:String = "ApplicationEvent.transferProgress";
      
      public static const TRANSFER_COMPLETE:String = "ApplicationEvent.transferComplete";
      
      public static const LANGUAGE_LOADED:String = "ApplicationEvent.languageLoaded";
      
      public static const HOLD:String = "ApplicationEvent.hold";
      
      public static const RUN:String = "ApplicationEvent.run";
      
      public static const STOP:String = "ApplicationEvent.stop";
      
      public static const NUMBERS_UPDATE:String = "ApplicationEvent.numbersUpdate";
      
      public static const URIDIUM_UPDATE:String = "ApplicationEvent.uridiumUpdate";
      
      public static const LIFE_PRICE_UPDATE:String = "ApplicationEvent.lifePriceUpdate";
      
      public static const LIVES_LEFT_UPDATE:String = "ApplicationEvent.livesLeftUpdate";
      
      public static const SPIN_AMOUNT_UPDATE:String = "ApplicationEvent.spinAmountUpdate";
      
      public static const BUY_BUTTON_VISIBILITY:String = "ApplicationEvent.buyButtonVisibility";
      
      public static const JUMP_BUTTON_VISIBILITY:String = "ApplicationEvent.jumpButtonVisibility";
      
      public static const LOADING_ON:String = "ApplicationEvent.loadingOn";
      
      public static const LOADING_OFF:String = "ApplicationEvent.loadingOff";
      
      public static const HELP_ON:String = "ApplicationEvent.helpOn";
      
      public static const HELP_OFF:String = "ApplicationEvent.helpOff";
      
      public static const HELP_COMPLETE:String = "ApplicationEvent.helpComplete";
      
      public static const URIDIUM_PURCHASE_INIT:String = "ApplicationEvent.uridiumPurchaseInit";
      
      public static const URIDIUM_PURCHASE_COMPLETE:String = "ApplicationEvent.uridiumPurchaseComplete";
      
      public static const WAVES_UPDATE:String = "ApplicationEvent.updateWaves";
      
      public static const STATE_ALPHA:String = "ApplicationEvent.stateAlpha";
      
      public static const STATE_BETA:String = "ApplicationEvent.stateBeta";
      
      public static const STATE_GAMMA:String = "ApplicationEvent.stateGamma";
      
      public static const STATE_DELTA:String = "ApplicationEvent.stateDelta";
      
      public static const STATE_EPSILON:String = "ApplicationEvent.stateEpsilon";
      
      public static const STATE_ZETA:String = "ApplicationEvent.stateZeta";
      
      public static const STATE_KAPPA:String = "ApplicationEvent.stateKappa";
      
      public static const STATE_LAMBDA:String = "ApplicationEvent.stateLambda";
      
      public static const STATE_KRONOS:String = "ApplicationEvent.stateKronos";
      
      public static const STATE_HADES:String = "ApplicationEvent.stateHades";
      
      public static const STATE_STREUNER:String = "ApplicationEvent.stateStreuner";
      
      public static const MATERIALIZE:String = "ApplicationEvent.materialize";
      
      public static const REWARD_SHOW:String = "ApplicationEvent.showReward";
      
      public static const REWARD_HIDE:String = "ApplicationEvent.hideReward";
      
      public static const ADDITIONALWINDOW_SHOW:String = "ApplicationEvent.showAdditionalWindow";
      
      public static const ADDITIONALWINDOW_HIDE:String = "ApplicationEvent.hideAdditionalWindow";
      
      private var _data:Object;
      
      public function ApplicationEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

