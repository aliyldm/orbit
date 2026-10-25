package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class SkullEffect extends MapObjectEffect
   {
      
      public function SkullEffect(param1:MapEntity)
      {
         super(EffectIDList.SKULL,param1,PERSISTANT,null,InGameCatalog.SOUND_ID_PIRATE_RAGE);
      }
   }
}

