package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo
{
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PvpSummerPlaceVO
   {
      
      public const changed:ISignal = new Signal();
      
      private var _repRewards:Vector.<RewardContentModule>;
      
      private var _repPerKillRewards:Vector.<RewardContentModule>;
      
      private var _repMax:int;
      
      private var _repMin:int;
      
      private var _repPerKillMax:int;
      
      private var _repPerKillMin:int;
      
      public function PvpSummerPlaceVO()
      {
         super();
      }
      
      public static function sort(param1:PvpSummerPlaceVO, param2:PvpSummerPlaceVO) : int
      {
         return param1.repMin - param2.repMin;
      }
      
      public function set repRewards(param1:Vector.<RewardContentModule>) : void
      {
         this._repRewards = param1;
         this.changed.dispatch();
      }
      
      public function get repRewards() : Vector.<RewardContentModule>
      {
         return this._repRewards;
      }
      
      public function get repPerKillRewards() : Vector.<RewardContentModule>
      {
         return this._repPerKillRewards;
      }
      
      public function set repPerKillRewards(param1:Vector.<RewardContentModule>) : void
      {
         this._repPerKillRewards = param1;
         this.changed.dispatch();
      }
      
      public function set repMin(param1:int) : void
      {
         this._repMin = param1;
      }
      
      public function set repMax(param1:int) : void
      {
         this._repMax = param1;
      }
      
      public function get repMax() : int
      {
         return this._repMax;
      }
      
      public function get repMin() : int
      {
         return this._repMin;
      }
      
      public function get repPerKillMax() : int
      {
         return this._repPerKillMax;
      }
      
      public function set repPerKillMax(param1:int) : void
      {
         this._repPerKillMax = param1;
      }
      
      public function get repPerKillMin() : int
      {
         return this._repPerKillMin;
      }
      
      public function set repPerKillMin(param1:int) : void
      {
         this._repPerKillMin = param1;
      }
   }
}

