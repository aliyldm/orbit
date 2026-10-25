package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class TechEnergyLeechEffect extends MapObjectEffect
   {
      
      public function TechEnergyLeechEffect(param1:Ship)
      {
         super(EffectIDList.TECH_ENERGY_LEECH_EFFECT,param1,PERSISTANT,new EffectPattern(EffectIDList.TECH_ENERGY_LEECH_EFFECT,"ela0"));
      }
   }
}

