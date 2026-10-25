package net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model.vo
{
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PayloadEscortPlaceVO
   {
      
      public const changed:ISignal = new Signal();
      
      private var _permanentPointsRewards:Vector.<RewardContentModule>;
      
      private var _permanentPointsMax:int;
      
      private var _permanentPointsMin:int;
      
      public function PayloadEscortPlaceVO()
      {
         super();
      }
      
      public static function sort(param1:PayloadEscortPlaceVO, param2:PayloadEscortPlaceVO) : int
      {
         return param1._permanentPointsMin - param2._permanentPointsMin;
      }
      
      public function set permanentPointsRewards(param1:Vector.<RewardContentModule>) : void
      {
         this._permanentPointsRewards = param1;
         this.changed.dispatch();
      }
      
      public function set permanentPointsMin(param1:int) : void
      {
         this._permanentPointsMin = param1;
      }
      
      public function set permanentPointsMax(param1:int) : void
      {
         this._permanentPointsMax = param1;
      }
      
      public function get permanentPointsRewards() : Vector.<RewardContentModule>
      {
         return this._permanentPointsRewards;
      }
      
      public function get permanentPointsMin() : int
      {
         return this._permanentPointsMin;
      }
      
      public function get permanentPointsMax() : int
      {
         return this._permanentPointsMax;
      }
   }
}

