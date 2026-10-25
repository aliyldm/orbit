package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SphereShieldEffect extends MapObjectEffect
   {
      
      private const _percentageSignal:Signal = new Signal(uint);
      
      public const radius:uint = 700;
      
      public const OUTER_RING_COLOR:Number = 3709911;
      
      public const OUTER_RING_ALPHA:Number = 0.2;
      
      public const INNER_PERCENTAGE_RING_COLOR:Number = 3709911;
      
      public const INNER_PERCENTAGE_RING_ALPHA:Number = 0.8;
      
      public function SphereShieldEffect(param1:MapEntity, param2:int)
      {
         super(EffectIDList.SPHERE_SHIELD_EFFECT,param1,param2,new EffectPattern(EffectIDList.SPHERE_SHIELD_EFFECT,"shield0"));
      }
      
      public function update(param1:uint) : void
      {
         this._percentageSignal.dispatch(param1);
      }
      
      public function get percentageSignal() : ISignal
      {
         return this._percentageSignal;
      }
   }
}

