package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class GhostNPCEffect extends MapObjectEffect
   {
      
      public function GhostNPCEffect(param1:Ship)
      {
         super(EffectIDList.GHOST_NPC_EFFECT,param1,PERSISTANT);
      }
   }
}

