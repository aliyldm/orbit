package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   
   public class VoltageLinkEffect extends AbstractBoltEffect
   {
      
      public function VoltageLinkEffect(param1:MapEntity, param2:Array)
      {
         super(EffectIDList.VOLTAGE_LINK_EFFECT,param1,param2,NOT_PERSISTANT);
      }
   }
}

