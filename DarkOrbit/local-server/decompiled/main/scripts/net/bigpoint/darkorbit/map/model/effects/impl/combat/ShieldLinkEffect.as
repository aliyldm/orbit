package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class ShieldLinkEffect extends AbstractBoltEffect
   {
      
      public function ShieldLinkEffect(param1:MapEntity, param2:int)
      {
         super(EffectIDList.SHIELD_LINK,param1,[param2],PERSISTANT);
      }
   }
}

