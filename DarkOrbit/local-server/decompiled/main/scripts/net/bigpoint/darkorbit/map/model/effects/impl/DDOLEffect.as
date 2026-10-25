package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class DDOLEffect extends MapObjectEffect
   {
      
      public function DDOLEffect(param1:MapEntity)
      {
         super(EffectIDList.DISTRIBUTED_DENIAL_OF_LASERS,param1,PERSISTANT);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

