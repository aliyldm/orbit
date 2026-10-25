package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class ReversalEnemyEffect extends MapObjectEffect
   {
      
      public function ReversalEnemyEffect(param1:Ship)
      {
         super(EffectIDList.REVERSAL_ENEMY_EFFECT,param1,PERSISTANT);
      }
   }
}

