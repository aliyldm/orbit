package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class ReversalSelfEffect extends MapObjectEffect
   {
      
      public function ReversalSelfEffect(param1:Ship)
      {
         super(EffectIDList.REVERSAL_SELF_EFFECT,param1,PERSISTANT);
      }
   }
}

