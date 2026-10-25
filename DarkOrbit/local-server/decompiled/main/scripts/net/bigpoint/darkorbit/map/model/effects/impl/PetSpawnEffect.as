package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class PetSpawnEffect extends MapObjectEffect
   {
      
      public function PetSpawnEffect(param1:MapEntity)
      {
         super(EffectIDList.PET_SPAWN,param1,NOT_PERSISTANT,null,InGameCatalog.SOUND_ID_PET_ACTIVATION);
      }
   }
}

