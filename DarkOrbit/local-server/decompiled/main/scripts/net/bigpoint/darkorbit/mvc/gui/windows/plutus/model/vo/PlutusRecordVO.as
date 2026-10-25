package net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.vo
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PlutusRecordVO
   {
      
      public const changed:ISignal = new Signal();
      
      private var _timeInSeconds:int;
      
      private var _score:int;
      
      public function PlutusRecordVO()
      {
         super();
      }
      
      public static function sort(param1:PlutusRecordVO, param2:PlutusRecordVO) : int
      {
         return param2.score - param1.score;
      }
      
      public function get timeInSeconds() : int
      {
         return this._timeInSeconds;
      }
      
      public function set timeInSeconds(param1:int) : void
      {
         this._timeInSeconds = param1;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function set score(param1:int) : void
      {
         this._score = param1;
      }
   }
}

