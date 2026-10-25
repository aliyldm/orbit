package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class MayhemWinnerEffect extends MapObjectEffect
   {
      
      public function MayhemWinnerEffect(param1:Ship)
      {
         super(EffectIDList.MAYHEM_WINNER_EFFECT,param1,PERSISTANT);
      }
   }
}

