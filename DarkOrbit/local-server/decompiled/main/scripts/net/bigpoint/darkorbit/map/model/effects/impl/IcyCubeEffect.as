package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.AbstractShipGlowEffect;
   
   public class IcyCubeEffect extends AbstractShipGlowEffect
   {
      
      public function IcyCubeEffect(param1:MapEntity)
      {
         super(EffectIDList.ICY_CUBE_EFFECT,param1);
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

