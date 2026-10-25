package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class StrikeAndExitOverviewData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      private var _inSession:Boolean;
      
      private var _nextOpenSeconds:int;
      
      private var _stellarCoinLimit:int;
      
      private var _currentGetStellarCoin:int;
      
      private var _inDouble:Boolean;
      
      public const attemptsLeft:BindableCountDown = new BindableCountDown();
      
      public function StrikeAndExitOverviewData()
      {
         super();
      }
      
      public function get inSession() : Boolean
      {
         return this._inSession;
      }
      
      public function get nextOpenSeconds() : int
      {
         return this._nextOpenSeconds;
      }
      
      public function get stellarCoinLimit() : int
      {
         return this._stellarCoinLimit;
      }
      
      public function get currentGetStellarCoin() : int
      {
         return this._currentGetStellarCoin;
      }
      
      public function get inDouble() : Boolean
      {
         return this._inDouble;
      }
      
      public function updateData(param1:Boolean, param2:int, param3:int, param4:int, param5:Boolean) : void
      {
         this._inSession = param1;
         this._nextOpenSeconds = param2;
         this._stellarCoinLimit = param3;
         this._currentGetStellarCoin = param4;
         this._inDouble = param5;
         this.attemptsLeft.value = this.nextOpenSeconds;
         this.changed.dispatch();
      }
   }
}

