package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class ModuleInstallEffect extends MapObjectEffect
   {
      
      public function ModuleInstallEffect(param1:MapEntity)
      {
         super(EffectIDList.MODULE_INSTALL_EFFECT,param1);
      }
   }
}

