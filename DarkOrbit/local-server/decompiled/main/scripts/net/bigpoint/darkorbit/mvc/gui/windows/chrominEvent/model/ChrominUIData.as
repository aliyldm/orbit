package net.bigpoint.darkorbit.mvc.gui.windows.chrominEvent.model
{
   import net.bigpoint.darkorbit.com.module.ChrominUpdateCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ChrominUIData
   {
      
      public const changed:ISignal = new Signal();
      
      private var _currentAmt:Number;
      
      private var _maxAmt:Number;
      
      public function ChrominUIData()
      {
         super();
      }
      
      public function get currentAmt() : Number
      {
         return this._currentAmt;
      }
      
      public function get maxAmt() : Number
      {
         return this._maxAmt;
      }
      
      public function updateInfo(param1:ChrominUpdateCommand) : void
      {
         this.updateCurrentValue(param1.currentAmt);
         this.updateMaxValue(param1.maxAmt);
         this.changed.dispatch();
      }
      
      private function updateMaxValue(param1:Number) : void
      {
         this._maxAmt = param1;
      }
      
      private function updateCurrentValue(param1:Number) : void
      {
         this._currentAmt = param1;
      }
   }
}

