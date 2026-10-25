package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class BerserkEffect extends MapObjectEffect
   {
      
      public function BerserkEffect(param1:MapEntity)
      {
         super(EffectIDList.BERSERK,param1);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return false;
      }
   }
}

