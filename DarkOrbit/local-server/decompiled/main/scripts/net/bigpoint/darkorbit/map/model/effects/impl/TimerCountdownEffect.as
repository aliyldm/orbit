package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class TimerCountdownEffect extends MapObjectEffect
   {
      
      private var _countdownTime:Number = 0;
      
      public function TimerCountdownEffect(param1:MapEntity, param2:Number)
      {
         this._countdownTime = param2;
         super(EffectIDList.TIMER_COUNTDOWN,param1,PERSISTANT);
      }
      
      public function get countdownTime() : Number
      {
         return this._countdownTime;
      }
   }
}

