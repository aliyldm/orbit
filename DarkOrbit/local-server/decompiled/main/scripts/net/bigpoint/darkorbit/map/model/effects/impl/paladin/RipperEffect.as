package net.bigpoint.darkorbit.map.model.effects.impl.paladin
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class RipperEffect extends MapObjectEffect
   {
      
      public function RipperEffect(param1:MapEntity)
      {
         super(EffectIDList.RIPPER,param1,TIME_OUT,new EffectPattern(EffectIDList.RIPPER,"ripperEffect"));
         this.timeOutTime = 3000;
      }
   }
}

