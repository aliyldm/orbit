package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class CollectorBeamEffect extends MapObjectEffect
   {
      
      private var _countdownDuration:Number = 1;
      
      private var _useCountdownVisual:Boolean;
      
      public function CollectorBeamEffect(param1:Ship, param2:Number, param3:Boolean)
      {
         super(EffectIDList.COLLECTOR_BEAM,param1,TIME_OUT);
         timeOutTime = Math.max(1000,param2 * 1000);
         this._countdownDuration = param2;
         this._useCountdownVisual = param3;
      }
      
      public function get countdownDuration() : Number
      {
         return this._countdownDuration;
      }
      
      public function set countdownDuration(param1:Number) : void
      {
         this._countdownDuration = param1;
      }
      
      public function get useCountdownVisual() : Boolean
      {
         return this._useCountdownVisual;
      }
   }
}

