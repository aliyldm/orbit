package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model.vo
{
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class EternalBlacklightPlaceVO
   {
      
      public const changed:ISignal = new Signal();
      
      private var _playerRewards:Vector.<RewardContentModule>;
      
      private var _max:int;
      
      private var _min:int;
      
      public function EternalBlacklightPlaceVO()
      {
         super();
      }
      
      public static function sort(param1:EternalBlacklightPlaceVO, param2:EternalBlacklightPlaceVO) : int
      {
         return param1.min - param2.min;
      }
      
      public function set playerRewards(param1:Vector.<RewardContentModule>) : void
      {
         this._playerRewards = param1;
         this.changed.dispatch();
      }
      
      public function get playerRewards() : Vector.<RewardContentModule>
      {
         return this._playerRewards;
      }
      
      public function set min(param1:int) : void
      {
         this._min = param1;
      }
      
      public function set max(param1:int) : void
      {
         this._max = param1;
      }
      
      public function get max() : int
      {
         return this._max;
      }
      
      public function get min() : int
      {
         return this._min;
      }
   }
}

