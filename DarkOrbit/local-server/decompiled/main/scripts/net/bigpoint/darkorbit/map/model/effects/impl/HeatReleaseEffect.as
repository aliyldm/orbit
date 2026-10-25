package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class HeatReleaseEffect extends MapObjectEffect
   {
      
      public static const MIN_RADIUS:Number = 150;
      
      private var _radius:Number;
      
      public function HeatReleaseEffect(param1:MapEntity, param2:Number = 150, param3:int = 1, param4:EffectPattern = null, param5:int = -1)
      {
         super(EffectIDList.HEAT_RELEASE_EFFECT,param1,param3,param4,param5);
         this._radius = param2 <= MIN_RADIUS ? MIN_RADIUS : param2;
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
   }
}

