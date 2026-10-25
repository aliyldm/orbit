package net.bigpoint.darkorbit.mvc.gui.windows.uridiumbank.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.UridiumBankInfoCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UridiumBankUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      private var _currentValue:Number;
      
      private var _maxValue:Number;
      
      private var _price:String;
      
      private var _imgKey:String;
      
      private var _textKey:String;
      
      public function UridiumBankUIData()
      {
         super();
      }
      
      public function updateInfo(param1:UridiumBankInfoCommand) : void
      {
         this.updateCurrentValue(param1.currentValue);
         this.updateMaxValue(param1.maxValue);
         this.updatePrice(param1.price);
         this.updateTimer(param1.secondsLeft);
         this.updateImgKey(param1.imgKey);
         this.updateTextKey(param1.textKey);
         this.changed.dispatch();
      }
      
      private function updateCurrentValue(param1:Number) : void
      {
         this._currentValue = param1;
      }
      
      private function updateMaxValue(param1:Number) : void
      {
         this._maxValue = param1;
      }
      
      private function updatePrice(param1:String) : void
      {
         this._price = param1;
      }
      
      private function updateImgKey(param1:String) : void
      {
         this._imgKey = param1;
      }
      
      private function updateTextKey(param1:String) : void
      {
         this._textKey = param1;
      }
      
      private function updateTimer(param1:Number) : void
      {
         this.timer.value = param1;
      }
      
      public function get currentValue() : Number
      {
         return this._currentValue;
      }
      
      public function get maxValue() : Number
      {
         return this._maxValue;
      }
      
      public function get price() : String
      {
         return this._price;
      }
      
      public function get imgKey() : String
      {
         return this._imgKey;
      }
      
      public function get textKey() : String
      {
         return this._textKey;
      }
   }
}

