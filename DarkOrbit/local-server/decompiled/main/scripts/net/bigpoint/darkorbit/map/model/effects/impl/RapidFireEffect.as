package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class RapidFireEffect extends MapObjectEffect
   {
      
      public function RapidFireEffect(param1:Ship)
      {
         super(EffectIDList.RAPID_FIRE_EFFECT,param1,PERSISTANT);
      }
   }
}

