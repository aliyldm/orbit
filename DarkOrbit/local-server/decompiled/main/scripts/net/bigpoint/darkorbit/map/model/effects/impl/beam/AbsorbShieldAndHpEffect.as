package net.bigpoint.darkorbit.map.model.effects.impl.beam
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class AbsorbShieldAndHpEffect extends BeamEffect
   {
      
      public function AbsorbShieldAndHpEffect(param1:int, param2:MapEntity, param3:MapEntity)
      {
         super(EffectIDList.ABSORB_SHIELD_AND_HP_EFFECT,param2,param3,param1,4278255360);
      }
   }
}

