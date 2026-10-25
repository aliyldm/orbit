package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class HPLinkEffect extends AbstractBoltEffect
   {
      
      public function HPLinkEffect(param1:MapEntity, param2:int)
      {
         super(EffectIDList.HP_LINK,param1,[param2],PERSISTANT);
      }
   }
}

